function [V,policy] = mdp_Q_policy_to_V1(Q,policy)
% [Q] = Q_policy_to_V1(Q,policy)
%

dims = ndims(Q);
sz = size(Q);
Q(isnan(Q)) = 0;
% policy at invalid poses is NaN
V = sum(Q.*policy,dims);

