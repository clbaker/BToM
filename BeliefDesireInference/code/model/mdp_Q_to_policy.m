function [policy] = mdp_Q_to_policy1(Q,beta,stochastic_policy)
% [policy] = mdp_Q_to_policy1(Q,beta,stochastic_policy)
%

if ~exist('stochastic_policy')
  stochastic_policy = 1;
end

dims = ndims(Q);
sz = size(Q);

if stochastic_policy
  policy = exp(beta*(Q-repmat(max(Q,[],dims),[ones(1,dims-1) sz(dims)])));
  policy(isnan(policy)) = 0;

else
  policy = zeros(size(Q));
  max_Q = max(Q,[],dims);
  policy = (Q == repmat(max_Q,[ones(1,dims-1) sz(dims)]));
end

% 0.0 / 0.0 here gets NaN, which is what we want
policy = policy ./ repmat(sum(policy,dims),[ones(1,dims-1) sz(dims)]);

