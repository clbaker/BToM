%% truebelief_solve_mdps.m
%
% Notes:
%  -formulation with single absorbing, cost-free "finished" state
%  -uses freudenthal triangulation MDP solver in solve_momdp_cluster.m
%


localdir = pwd;

addpath([localdir '/code/model']);

basedir = [localdir '/data/truebelief'];
if ~exist(basedir,'dir')
  mkdir(basedir);
end

solvedir = [basedir '/solve_mdps'];
if ~exist(solvedir,'dir')
  mkdir(solvedir);
end

% get stimuli
load('data/stimuli.mat','worlds');
n_worlds = length(worlds);

% get model parameters
truebelief_parameters;


%% main loop
for nw=1:n_worlds

  % set up MOMDP
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);

  [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(worlds{nw},action,move_noise);
  n_c_ind = size(is_c_ind_valid,2);
  n_world = length(worlds{nw});
  
  savedir = sprintf('%s/worlds%d',solvedir,nw);
  if ~exist(savedir,'dir')
    mkdir(savedir);
  end
  
  % build and solve mdp;
  for ng=1:n_goal_reward
    s_reward = create_state_reward(worlds{nw},c_sub,is_c_ind_valid,goal_reward(ng,:),action_cost);
    s_reward = permute(reshape(s_reward,[n_world n_c_ind n_action]),[2 1 3]);
    
    Q = zeros(size(s_reward));
    V = zeros(size(s_reward(:,:,1)));
    for wi=1:n_world
      [Q(:,wi,:),V(:,wi),n_iter,err] = mdp_Q_VI([],squeeze(c_trans(:,:,wi,:)),squeeze(s_reward(:,wi,:)),mdp_options);
    end

    save(sprintf('%s/value%03d.mat',savedir,ng),'Q','V');
    
  end % for ng=1:n_goal_reward
    
end
