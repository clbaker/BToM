%% nocost_parameters.m
%


% [stay, west, east, south, north, eat]
action = [0 -1  1  0  0  0; ...
          0  0  0 -1  1  0];
n_action = size(action,2);

n_reward_grid = 7;
n_belief_grid = 6;
b_sub_space = 0.075;
b_precision = 2^16;

view_border = [0.01 0.01];

% parameters for planning (fixed)
mdp_options.stochastic_value = false;
mdp_options.stochastic_policy = false;
mdp_options.beta = inf;
mdp_options.discount = 1;
mdp_options.max_iter = 50;
mdp_options.err_tol = 0.0;
mdp_options.sptrans = true;
mdp_options.verbose = false;

visilibity = false;

move_noise = 0.0;
obs_noise = 0;
move_cost = 0;
action_cost = [0 repmat(move_cost,1,n_action-1)];
%beta_score = 2.5;
