function [Q,V,n_iter,err] = mdp_Q_VI(V,trans,reward,options)
% [Q,V,n_iter,err] = mdp_Q_VI(V,trans,reward,options)
%
% run value iteration on an MDP
%
% Input: 
%  -V: [] or size(n_state,1)
%  -trans: size(n_state,n_state,n_move_action)
%    -trans(i,j,k) = p(s'=i|s=j,a=k)
%  -reward: size(n_state,1), the reward for each state.
%  -options [optional]: struct
%    .stochastic_value:
%    .beta: "inverse temperature"
%    .discount: gamma parameter in VI
%    .max_iter: maximum value iteration steps
%    .err_tol: convergence criterion
%    .sptrans:
%    .trans_ind:
%
% Output:
%  -Q: size(n_state,n_action);
%  -V: size(n_state,1)
%  -n_iter: number of iterations


% TODO
% -move_action vs. goal_action
% -use goal_trans to update V

[n_state,n_action] = size(reward);

if isempty(V)
  V = zeros(n_state,1);
elseif ~all(size(V)==[n_state,1])
  error('mdp_Q_VI2() - V')
end
Q = zeros(n_state,n_action);

stochastic_value = options.stochastic_value;
beta = options.beta;
discount = options.discount;
max_iter = options.max_iter;
err_tol = options.err_tol;
sptrans = options.sptrans;
verbose = options.verbose;

err = zeros(1,max_iter);


for n_iter=1:max_iter
  if sptrans
    Q = discount*squeeze(sum(V(options.trans_ind).*trans,1)) + reward;
    
  else
    state_valid = ~(isnan(V));
    for na=1:n_action
      EV = squeeze(trans(state_valid,:,na))'*V(state_valid);
      Q(:,na) = discount * EV + reward(:,na);
      
    end

  end
  
  policy = mdp_Q_to_policy(Q,beta,stochastic_value);
 
  V_new = mdp_Q_policy_to_V(Q,policy);
  
  err(n_iter) = max(abs(V - V_new));
  converge =  err(n_iter) < err_tol;

  V = V_new;

  if verbose
    fprintf('mdp_Q_VI2() -- iter %d/%d completed\n',n_iter,max_iter);
  end

  if converge
    break;
  end

end % for n_iter=1:max_iter

err = err(1:n_iter);
