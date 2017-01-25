function [b_sub_unique,b_ind,fwd,bwd,filter,smooth,trans_unique,o_ind,a_ind] = ...
  score_momdp_path(c_ind_seq,w_ind0,b_sub0,b_sub0_prior,Q,V,beta,s_dim,w_trans,c_trans,obs_dist,b_sub_to_g_sub,g_ind_to_b_ind,b_precision)
% [b_sub_unique,b_ind,fwd,bwd,filter,smooth,trans_unique,o_ind,a_ind,b_sub0_prior] = ...
%   score_momdp_path(c_ind_seq,w_ind0,b_sub0,b_sub0_prior,Q,V,beta,s_dim,w_trans,c_trans,obs_dist,b_sub_to_g_sub,g_ind_to_b_ind,b_precision)
% 
% Input:
%   -c_ind_seq: 
%   -w_ind0: 
%   -b_sub0: 
%   -b_sub0_prior: 
%   -Q: 
%   -V: 
%   -beta: 
%   -s_dim: 
%   -w_trans: 
%   -c_trans: 
%   -obs_dist: 
%   -b_sub_to_g_sub: 
%   -g_ind_to_b_ind: 
%
% Output:
%   -b_sub_unique: 
%   -b_ind: 
%   -fwd: 
%   -bwd: 
%   -filter: 
%   -smooth: 
%   -trans: 
%   -o_ind: 
%   -a_ind: 
%
% Comments:
%   -taken from score_pomdp_path3.m
%


path_len = length(c_ind_seq);

n_world = size(w_trans,1);

[n_b_sub,n_c_sub] = deal(s_dim(1),s_dim(2));

n_action = size(Q,2);

n_obs = size(obs_dist,1);
n_b_sub0 = size(b_sub0,2);


%% return values

%
b_sub_unique = cell(1,path_len);
% index into b_sub_unique, selects number of occurences of each b_sub
% b_ind{t}: b_sub_unique{t} -> b_sub_all{t}
b_ind = cell(1,path_len);

% forward distribution
% fwd{1}: p(b1,c1|s1)
% fwd{t}: p(bt,ct|s1:t)
fwd = cell(1,path_len);

% backward distribution
% bwd{T}: 1
% bwd{t}: p(st+1:T|bt)
bwd = cell(1,path_len);

% filter{t}(bi): observer's joint probability of b_sub_unique{t}(:,bi), given c_ind_seq(1:t)
% filter{t}: p(bt-1,ct-1|s1:t)
filter = cell(1,path_len-1);

% backward distribution
% b_smooth{t}: size(1,n_b_sub_unique{t})
smooth = cell(1,path_len);

% for each timestep, record probability of going from one mental state to another
% sum_[Ot+1,At+1] P(Bt+1,Ot+1,At+1|W,Ct+1,Ct,Bt)
% trans{t}(bj): p(bj|bi)
trans = cell(1,path_len-1);

% CB: needed for Viterbi?
trans_unique = cell(1,path_len-1);

o_ind = cell(1,path_len);
a_ind = cell(1,path_len-1);

% for smoothing
b_prev = cell(1,path_len-1);


%% initialize belief
% update b_sub0 based on all observations from initial location

o_score1 = squeeze(obs_dist(:,c_ind_seq(1),:))';
o_score2 = o_score1(w_ind0,:)';

b_t = cell(1,n_b_sub0);
fwd_t = cell(n_b_sub0,1);
o_t = cell(1,n_b_sub0);

for bi=1:n_b_sub0
 
  b_next = o_score1 .* repmat(b_sub0(:,bi),1,n_obs);
  b_next_sum = sum(b_next,1);
  b_next_ind = find(b_next_sum>0);
  b_next_norm = b_next(:,b_next_ind) ./ repmat(b_next_sum(:,b_next_ind),[n_world 1]);
  n_b_next = length(b_next_ind);

  b_t{bi} = b_next_norm;
  o_t{bi} = b_next_ind;
  
  fwd_t{bi} = b_sub0_prior(bi);

end % for bi=1:n_b_sub0


%% forward loop

for t=1:path_len

  fwd_all = cell2mat(fwd_t);
  b_all = cell2mat(b_t);
  o_all = cell2mat(o_t);

  % detect and eliminate hypotheses with probability 0
  fwd_all_valid_ind = find(any(~isinf(fwd_all(:,:)),2));

  fwd_all_valid = fwd_all(fwd_all_valid_ind);
  b_all_valid = b_all(:,fwd_all_valid_ind);
  o_ind{t} = o_all(fwd_all_valid_ind);

  % use b_precision so b_subs that are very close get combined
  [b_sub_unique_unnormalized,last,b_ind{t}] = unique(round(b_precision*b_all_valid')/b_precision,'rows');

  n_b = size(b_sub_unique_unnormalized,1);
  b_sub_unique{t} = b_sub_unique_unnormalized' ./ repmat(sum(b_sub_unique_unnormalized',1),n_world,1);

  fwd{t} = zeros(1,n_b);
  for bi=1:n_b
    fwd{t}(bi) = logsumexp(fwd_all_valid(b_ind{t}==bi),1);
  end

  if t>1
    b_prev_all = cell2mat(b_prev_t);
    a_all = cell2mat(a_t);
    trans_all = cell2mat(trans_t);

    b_prev{t-1} = b_prev_all(fwd_all_valid_ind);
    a_ind{t-1} = a_all(fwd_all_valid_ind);
    trans{t-1} = trans_all(fwd_all_valid_ind);

    n_b_prev = size(b_sub_unique{t-1},2);
    trans_unique{t-1} = zeros(n_b,n_b_prev);
    for np=1:n_b_prev
      for nt=1:n_b
        trans_unique{t-1}(nt,np) = sum(exp(trans{t-1}((b_prev{t-1}'==np)&(b_ind{t}==nt))),1);
      end
    end

  end

  if t==path_len
    break;
  end

  b_t = cell(1,n_b);
  trans_t = cell(n_b,1);
  fwd_t = cell(n_b,1);
  o_t = cell(1,n_b);
  a_t = cell(1,n_b);

  b_prev_t = cell(1,n_b);

  % variable naming scheme: 1 = "agent"; 2 = "observer"

  c_score1 = squeeze(c_trans(c_ind_seq(t+1),c_ind_seq(t),:,:));
  c_score2 = c_score1(w_ind0,:);
  
  o_score1 = squeeze(obs_dist(:,c_ind_seq(t+1),:));
  o_score2 = o_score1(:,w_ind0);
  
  co_score1 = repmat(o_score1',[1 1 n_action]) .*repmat(reshape(c_score1,[n_world 1 n_action]),[1 n_obs 1]);
  co_score2 = squeeze(co_score1(w_ind0,:,:));
 
  w_pred1 = w_trans*b_sub_unique{t};
  
  filter{t} = zeros(1,n_b);

  for bi=1:n_b

    % agent computes P(Ot+1,Wt+1|bt,Ct+1,Ct,At)
    b_next = co_score1.*repmat(w_pred1(:,bi),[1 n_obs n_action]);
    b_next_sum = sum(b_next,1);
    b_next_ind = find(b_next_sum>0);
    n_b_next = length(b_next_ind);

    if n_b_next
      b_t{bi} = b_next(:,b_next_ind) ./ repmat(b_next_sum(:,b_next_ind),[n_world 1 1]);

      [o_t{bi},a_t{bi}] = ind2sub([n_obs n_action],b_next_ind(:)');
      
      b_prev_t{bi} = repmat(bi,1,n_b_next);

      % trans_t{bi}(i)
      %   = p(belief i, c_ind_seq(t+1), [o,a]| belief bi, c_ind_seq(t))
      %   ... or something
      trans_t{bi} = zeros(n_b_next,1);

      policy_bi = policy_b_sub(b_sub_unique{t}(:,bi),c_ind_seq(t),Q,beta,s_dim,b_sub_to_g_sub,g_ind_to_b_ind);
      filter{t}(bi) = log(policy_bi*c_score2') + fwd{t}(bi);

      % observer computes P(bt+1,Ot+1,At|bt,Ct+1,Ct,Wt+1,Wt)
      b_next_score = co_score2.*repmat(policy_bi,n_obs,1);

      trans_t{bi} = log(b_next_score(b_next_ind));

      fwd_t{bi} = trans_t{bi} + fwd{t}(bi);
      
    end % if n_b_next

  end % for bi=1:n_b

end % for t=1:path_len


%% backward loop

for T=path_len:(-1):1
  
  bwd{T} = cell(1,T);
  smooth{T} = cell(1,T);

  % initialization
  bwd{T}{T} = zeros(size(fwd{T}));
  smooth{T}{T} = fwd{T} + bwd{T}{T};

  for t=(T-1):(-1):1

    n_b = size(b_sub_unique{t},2);
    bwd{T}{t} = zeros(1,n_b);

    for bi=1:n_b
      bi_index = (b_prev{t} == bi);
      if any(bi_index)
          bwd{T}{t}(bi) = logsumexp(m2v(trans{t}(bi_index)) + m2v(bwd{T}{t+1}(b_ind{t+1}(bi_index))));
      else
          bwd{T}{t}(bi) = -inf;
      end
    end

    smooth{T}{t} = fwd{t} + bwd{T}{t};

  end % for t=T:(-1):1

end % for T=path_len:(-1):1



function [policy] = policy_b_sub(b_sub,c_ind,Q,beta,s_dim,b_to_g,g_to_b)

n_action = size(Q,2);

[neighbor_g_ind,lambda] = barycentric_coord(b_sub,b_to_g);

g_ind_valid = neighbor_g_ind>0;
neighbor_g_ind = neighbor_g_ind(g_ind_valid);
lambda = lambda(g_ind_valid);

neighbor_b_ind = g_to_b(neighbor_g_ind);

b_ind_valid = neighbor_b_ind>0;
neighbor_b_ind = neighbor_b_ind(b_ind_valid);
lambda = lambda(b_ind_valid)';

n_neighbor = length(neighbor_b_ind);

if n_neighbor==0
  error('policy_b_sub1() -- probably a numerical error with b_sub');
end

Q_dim = [n_neighbor n_action 1];
Q_sub_inds = ind2subv(Q_dim,1:prod(Q_dim))';
Q_sub = [neighbor_b_ind(Q_sub_inds(1,:)); c_ind(Q_sub_inds(3,:)); Q_sub_inds(2,:)];
Q_ind = sub2indv([s_dim n_action],Q_sub);

Q_neighbors = reshape(Q(Q_ind), [n_neighbor n_action]);

Q_s = lambda*Q_neighbors;

if isinf(beta)
  policy = zeros(size(Q_s));
  policy(Q_s == max(Q_s)) = 1;
else
  policy = exp(beta*(Q_s - max(Q_s)));
end

policy = policy ./ sum(policy);

