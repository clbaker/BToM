%% truebelief_score_scenarios.m
%


localdir = pwd;

addpath([localdir '/code/model']);

basedir = [localdir '/data/truebelief'];
solvedir = [basedir '/solve_mdps'];
scoredir = [basedir '/score_scenarios'];
if ~exist(scoredir,'dir')
  mkdir(scoredir);
end

% get stimuli
load('data/stimuli.mat');
n_scenario = length(scenario);

% get model parameters
truebelief_parameters;


%% main loop
for ns=1:n_scenario

  nw = scenario{ns}.condition(1); % set of possible worlds for this condition (according to agent)
  n_world = length(worlds{nw});
  wi = scenario{ns}.condition(2); % actual world for this condition (known to truebelief observer but not agent)

  loaddir = sprintf('%s/worlds%d',solvedir,nw);

  % set up MOMDP
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);

  [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(worlds{nw},action,move_noise);

  for ng=1:n_goal_reward
    
    value = load(sprintf('%s/value%03d.mat',loaddir,ng),'Q','V');

    savedir = sprintf('%s/scenario%02d',scoredir,ns);
    if ~exist(savedir,'dir')
      mkdir(savedir);
    end

    [fwd,bwd,smooth] = score_mdp_path(scenario{ns}.path,wi,value.Q,beta_score,c_trans);

    save(sprintf('%s/score%03d.mat',savedir,ng),'fwd','smooth');

  end % for ng=1:n_goal_reward

end % for ns=1:n_scenarios
