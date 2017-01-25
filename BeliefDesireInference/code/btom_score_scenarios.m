%% btom_score_scenarios.m
%


localdir = pwd;

addpath([localdir '/code/model']);
addpath([localdir '/code/visilibity']);

basedir = [localdir '/data/btom'];
solvedir = [basedir '/solve_momdps'];
scoredir = [basedir '/score_scenarios'];
if ~exist(scoredir,'dir')
  mkdir(scoredir);
end

% get stimuli
load('data/stimuli.mat');
n_scenario = length(scenario);

% get model parameters
btom_parameters;

if visilibity
  obs_dist = cell(1,n_worlds);
else
  load('code/visilibity/observation_distribution.mat');
end


%% main loop
for ns=1:n_scenario

  nw = scenario{ns}.condition(1); % set of possible worlds for this condition (according to agent)
  n_world = length(worlds{nw});
  wi = scenario{ns}.condition(2); % actual world for this condition (known to btom observer but not agent)

  loaddir = sprintf('%s/worlds%d',solvedir,nw);

  % set up MOMDP
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);

  [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(worlds{nw},action,move_noise);

  if visilibity
    obs_dist{nw} = create_obs_dist(worlds{nw},c_sub,is_c_ind_valid,obs_noise);
  end
  
  w_trans = eye(n_world);

  [s_sub,s_dim,b_sub,b_sub_to_g_sub,g_ind_to_b_ind] = create_belief_state(is_c_ind_valid,n_belief_grid);

  [s_trans,s_trans_ind] ...
    = create_belief_state_sptrans(s_dim,s_sub,w_trans,c_trans,obs_dist{nw},b_sub,b_sub_to_g_sub,g_ind_to_b_ind);

  mdp_options.trans_ind = s_trans_ind;

  b_sub0 = (b_sub*(1-b_sub_space) + (b_sub_space/n_world));
  b_sub0_prior = zeros(1,size(b_sub0,2));
  
  for ng=1:n_goal_reward
    
    value = load(sprintf('%s/value%03d.mat',loaddir,ng),'Q','V');

    savedir = sprintf('%s/scenario%02d',scoredir,ns);
    if ~exist(savedir,'dir')
      mkdir(savedir);
    end

    [b_sub_unique,b_ind,fwd,bwd,filter,smooth,trans_unique,o_ind,a_ind] ...
      = score_momdp_path(scenario{ns}.path,wi,b_sub0,b_sub0_prior,value.Q,value.V,beta_score, ...
        s_dim,w_trans,c_trans,obs_dist{nw},b_sub_to_g_sub,g_ind_to_b_ind,b_precision);

    save(sprintf('%s/score%03d.mat',savedir,ng),'b_sub_unique','fwd','smooth');

  end % for ng=1:n_goal_reward

end % for ns=1:n_scenarios
