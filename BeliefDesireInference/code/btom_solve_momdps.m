%% btom_solve_momdps.m
%
% Notes:
%  -formulation with single absorbing, cost-free "finished" state
%  -uses freudenthal triangulation MDP solver in solve_momdp_cluster.m
%


localdir = pwd;

addpath([localdir '/code/model']);
addpath([localdir '/code/visilibity']);

basedir = [localdir '/data/btom'];
if ~exist(basedir,'dir')
  mkdir(basedir);
end

solvedir = [basedir '/solve_momdps'];
if ~exist(solvedir,'dir')
  mkdir(solvedir);
end

% get stimuli
load('data/stimuli.mat','worlds');
n_worlds = length(worlds);

% get model parameters
btom_parameters;

if visilibity
  obs_dist = cell(1,n_worlds);
else
  load('code/visilibity/observation_distribution.mat');
end


%% main loop
for nw=1:n_worlds

  % set up MOMDP
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);

  [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(worlds{nw},action,move_noise);

  if visilibity
    obs_dist{nw} = create_obs_dist(worlds{nw},c_sub,is_c_ind_valid,obs_noise);
  end
  
  n_world = length(worlds{nw});
  w_trans = eye(n_world);

  [s_sub,s_dim,b_sub,b_sub_to_g_sub,g_ind_to_b_ind] = create_belief_state(is_c_ind_valid,n_belief_grid);

  [s_trans,s_trans_ind] ...
    = create_belief_state_sptrans(s_dim,s_sub,w_trans,c_trans,obs_dist{nw},b_sub,b_sub_to_g_sub,g_ind_to_b_ind);

  mdp_options.trans_ind = s_trans_ind;

  savedir = sprintf('%s/worlds%d',solvedir,nw);
  if ~exist(savedir,'dir')
    mkdir(savedir);
  end
  
  % build and solve mdp;
  for ng=1:n_goal_reward
    [s_reward] = create_belief_state_reward(worlds{nw},s_sub,s_dim,b_sub,c_sub,is_c_ind_valid,goal_reward(ng,:),action_cost);
    [Q,V,n_iter,err] = mdp_Q_VI([],s_trans,s_reward,mdp_options);

    save(sprintf('%s/value%03d.mat',savedir,ng),'Q','V');
    
  end % for ng=1:n_goal_reward
    
end
