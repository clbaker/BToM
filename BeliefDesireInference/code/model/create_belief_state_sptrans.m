function [s_trans,s_trans_ind] = create_belief_state_sptrans(s_dim,s_sub,w_trans,c_trans,obs_dist,b_sub,b_to_g,g_ind_to_b_ind)
% [s_trans,s_trans_ind] = create_belief_state_sptrans(s_dim,s_sub,w_trans,c_trans,obs_dist,b_sub,b_to_g,g_ind_to_b_ind)
%
% Input:
%   s_dim:
%   w_trans:
%   c_trans:
%   obs_dist:
%   b_sub:
%   b_to_g:
%   g_ind_to_b_ind:
%
% Output:
%   s_trans(i,j,k) = p(s_trans_ind i | from s_ind j given action k)
%     s_trans = size(n_s_trans_ind, n_s_ind, n_action);
%   s_trans_ind(i,j) = next belief state | trans i from s_ind j
%     s_trans_ind = size(n_s_trans_ind, n_s_ind, n_action)
%
% TODO:
%   -currently s_trans_inds is unordered, may contain duplicates, items don't occupy adjacent inds


[n_b_sub,n_c_sub] = deal(s_dim(1),s_dim(2));

n_world = size(w_trans,1);
n_action = size(c_trans,4);
n_obs = size(obs_dist,1);

n_s_ind = size(s_sub,2);

n_w_next = sum(w_trans>0,1);
max_w_next = max(n_w_next(:));

n_c_next = sum(c_trans>0,1);
max_c_next = max(n_c_next(:));

n_obs_next = sum(obs_dist>0,1);
max_obs_next = max(n_obs_next(:));

max_co_ind = n_world*max_w_next*max_c_next*max_obs_next;

% wco_trans represents p(w2,[c2,o]_ind | w1, c1, a)
wco_trans = zeros(n_world,max_co_ind,n_world,n_c_sub,n_action);

% co_trans_ind gives possible [c2,o]_inds given c1, a (for all wi)
co_trans_ind = zeros(max_co_ind,n_c_sub,n_action,'uint32');

% CB: precompute to use below
obs_dist_perm = repmat(permute(obs_dist,[3 2 1]),[1 1 1 n_world]);
w_trans_precomp = repmat(reshape(w_trans,[n_world 1 n_world]),[1 n_c_sub 1]);

n_ca_ind = n_c_sub*n_action;
ca_sub = ind2subv([n_c_sub n_action], 1:n_ca_ind)';

% compute wco_trans, wco_trans_ind: wca -> wco_ind
% TODO: vectorize outer loop?
max_co_ind2 = 0;

for ni=1:n_ca_ind
  [ci,ai] = deal(ca_sub(1,ni),ca_sub(2,ni));
  
  % wc_pred(w2,c2,w1) = p(c2,w2|w1,c1,a)
  wc_pred = repmat(squeeze(c_trans(:,ci,:,ai))',[1 1 n_world]) .* w_trans_precomp;
 
  % wco_pred(w2,c2,o,w1) = p(w2,c2,o|w1,c1,a)
  wco_pred = obs_dist_perm .* repmat(reshape(wc_pred,[n_world n_c_sub 1 n_world]),[1 1 n_obs 1]);
  wco_pred = reshape(wco_pred,[n_world n_c_sub*n_obs n_world]);
  
  co_ind_tmp = find(any(any(wco_pred>0,3),1));
  n_co_ind_tmp = length(co_ind_tmp);
  
  if n_co_ind_tmp
    wco_trans(:,1:n_co_ind_tmp,:,ci,ai) = wco_pred(:,co_ind_tmp,:);
    co_trans_ind(1:n_co_ind_tmp,ci,ai) = co_ind_tmp(:);
    if n_co_ind_tmp>max_co_ind2
      max_co_ind2 = n_co_ind_tmp;
    end
  end

end % for ni=1:n_wca_ind

% compress these to save memory
wco_trans = wco_trans(:,1:max_co_ind2,:,:,:);
co_trans_ind = co_trans_ind(1:max_co_ind2,:,:);


n_bc_ind = n_b_sub*n_c_sub;
max_s_trans_ind = max_obs_next*n_world*max_c_next;
s_trans = zeros(max_s_trans_ind,n_bc_ind,n_action);
s_trans_ind = zeros(max_s_trans_ind,n_bc_ind,n_action,'uint32');

% compute s_trans, s_trans_ind
% TODO: vectorize outer loop?
for bi=1:n_b_sub
  b2 = sum(wco_trans .* repmat(reshape(b_sub(:,bi),[1 1 n_world]),[n_world max_co_ind2 1 n_c_sub n_action]),3);
  
  % b2_valid_sub: [co_ind_next; c_ind_prev; a_ind_prev] for each b2_valid_ind
  b2_valid_ind = find(sum(b2(:,:)>0,1));
  b2_valid_sub = ind2subv([max_co_ind2 n_c_sub n_action],b2_valid_ind)';
  
  b2_valid = b2(:,b2_valid_ind);
  b2_valid_sum = sum(b2_valid,1);
  b2_valid_norm = b2_valid ./ repmat(b2_valid_sum,[n_world 1]);

  % CB: b2_valid_norm_unique? apply barycentric_coord1 to as few b_subs as possible...

  [neighbors,lambda] = barycentric_coord(b2_valid_norm,b_to_g);
  neighbors_valid = neighbors>0 & lambda>0;

  neighbors_valid_ind = find(neighbors_valid);
  n_neighbors_valid_ind = length(neighbors_valid_ind);
  
  % [neighbor_ind; b2_valid_ind]
  neighbors_valid_sub = ind2subv(size(neighbors),neighbors_valid_ind)';
  
  % get previous sa_inds
  ca_valid_ind = sub2indv([n_c_sub n_action],b2_valid_sub([2 3],neighbors_valid_sub(2,:)));
  sa_valid_ind = sub2indv([n_b_sub n_c_sub*n_action],[repmat(bi,[1 n_neighbors_valid_ind]); ca_valid_ind]);

  % get next bc_inds
  
  % get b_inds of all neighbors
  neighbors_valid_b_ind = g_ind_to_b_ind(neighbors(neighbors_valid_ind));

  % get co_inds of all neighbors
  co_valid_ind = co_trans_ind(b2_valid_ind(neighbors_valid_sub(2,:)));
  co_valid_sub = ind2subv([n_c_sub n_obs],double(co_valid_ind))';
  
  % compute bc[o]_inds
  bc_valid_ind = sub2indv([n_b_sub n_c_sub],[neighbors_valid_b_ind; co_valid_sub(1,:)]);
  
  % get indices into first dimension of s_trans_ind
  % these should all be minimal ("left") and consecutive
  ca_valid_ind_diff = find(diff(ca_valid_ind));
  left_inds = zeros(size(ca_valid_ind));
  left_inds([ca_valid_ind_diff end]) = diff([0 ca_valid_ind_diff length(ca_valid_ind)]);
  left_inds = left_inds+(1:length(ca_valid_ind)) - cumsum(left_inds);
  
  s_trans_valid_ind = sub2indv([max_s_trans_ind n_bc_ind*n_action],[left_inds; sa_valid_ind]);
  
  s_trans(s_trans_valid_ind) = b2_valid_sum(neighbors_valid_sub(2,:)) .* lambda(neighbors_valid_ind)';
  s_trans_ind(s_trans_valid_ind) = bc_valid_ind;
  
end % for bi=1:n_b_sub

% HACK to allow indexing value function with s_trans_ind
s_trans_ind(s_trans_ind==0) = 1;
