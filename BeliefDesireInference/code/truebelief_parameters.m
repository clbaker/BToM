%% truebelief_parameters.m
%


% [stay, west, east, south, north, eat]
action = [0 -1  1  0  0  0; ...
          0  0  0 -1  1  0];
n_action = size(action,2);

n_reward_grid = 7;

% parameters for planning (fixed)
mdp_options.stochastic_value = false;
mdp_options.stochastic_policy = false;
mdp_options.beta = inf;
mdp_options.discount = .99;
mdp_options.max_iter = 50;
mdp_options.err_tol = 0.0;
mdp_options.sptrans = false;
mdp_options.verbose = false;

move_noise = 0.0;
move_cost = 1;
action_cost = [0 repmat(move_cost,1,n_action-1)];
%beta_score = 9.0;
