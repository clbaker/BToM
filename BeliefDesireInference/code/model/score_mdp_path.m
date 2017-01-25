function [fwd,bwd,smooth] = score_mdp_path(c_ind_seq,w_ind0,Q,beta,s_trans)
% [fwd,bwd,smooth] = score_mdp_path(c_ind_seq,w_ind0,Q,beta,s_trans,s_dim,s_sub)
% 
% Input:
%   -c_ind_seq: 
%   -w_ind0: 
%   -Q: 
%   -beta: 
%   -s_dim: 
%   -s_trans: 
%
% Output:
%


path_len = length(c_ind_seq);

n_action = size(s_trans,4);

fwd = zeros(n_action,path_len-1);
bwd = zeros(n_action,path_len-1);

s_trans2 = s_trans(:,:,w_ind0,:);

policy = mdp_Q_to_policy(squeeze(Q(:,w_ind0,:)),beta,true);


%% forward loop

for ti=1:(path_len-1)
  trans = squeeze(s_trans2(c_ind_seq(ti+1),c_ind_seq(ti),:));
  p_action = policy(c_ind_seq(ti),:);

  if ti==1
    fwd(:,ti) = log(trans) + log(p_action');
  else
    pred = logsumexp(fwd(:,ti-1));
    fwd(:,ti) = log(trans) + log(p_action') + pred;
  end

end % for ti=1:path_len

smooth = fwd+bwd;
