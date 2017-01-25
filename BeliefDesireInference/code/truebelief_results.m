%% truebelief_results.m
%


localdir = pwd;

basedir = [localdir '/data/truebelief'];
scoredir = [basedir '/score_scenarios'];

% get stimuli
load('data/stimuli.mat');
n_scenario = length(scenario);

% get model parameters
truebelief_parameters;


%% load data and compute marginals over beliefs and rewards

reward_post = cell(1,n_scenario);
belief_marg = cell(1,n_scenario);
reward_marg = cell(1,n_scenario);

for ns=1:n_scenario

  % LOAD SCORES
  
  loaddir = sprintf('%s/scenario%02d',scoredir,ns);

  nw = scenario{ns}.condition(1); % set of possible worlds for this condition (according to agent)
  wi = scenario{ns}.condition(2); % actual world for this condition (known to truebelief observer but not agent)
  path_len = length(scenario{ns}.path);
  n_worlds = length(worlds{nw});
  
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);
  n_goal_obj = size(goal_reward,2);
  G = double(ind2subv(repmat(n_reward_grid,1,n_goal_obj),1:(n_reward_grid^n_goal_obj)));

  fwd = zeros(n_goal_reward,path_len);

  for ng=1:n_goal_reward
    score = load(sprintf('%s/score%03d.mat',loaddir,ng));
    fwd(ng,:) = [0 logsumexp(score.fwd,1)];
  end
  
  % COMPUTE POSTERIOR AND MARGINAL OVER REWARDS

  reward_post{ns} = zeros(n_goal_reward,path_len);
  reward_marg{ns} = zeros(n_goal_obj,path_len);

  for t=1:path_len
    reward_post{ns}(:,t) = exp(fwd(:,t) - logsumexp(fwd(:,t)));
    reward_marg{ns}(:,t) = G' * reward_post{ns}(:,t);
  end % for t=1:path_len
  
  % COMPUTE MARGINALS OVER BELIEFS

  belief_marg{ns} = zeros(n_worlds,path_len);
  belief_marg{ns}(wi,:) = 1;
  
end % for ns=1:n_scenario


%% model inferences

% individual scenarios

desire_model = zeros(3,n_scenario);
belief_model = zeros(3,n_scenario);

for ns=1:n_scenario
  desire_model(:,ns) = reward_marg{ns}(:,end);
  belief_model(:,ns) = belief_marg{ns}(:,end);
end

% grouped scenarios

group_inds = group_conds(false);
n_group = length(group_inds);

desire_model_group = zeros(n_goal_obj,n_group);
belief_model_group = zeros(n_worlds,n_group);
desire_model_group_se = zeros(n_goal_obj,n_group);
belief_model_group_se = zeros(n_worlds,n_group);
for ng=1:n_group
  desire_model_group(:,ng) = mean(desire_model(:,group_inds{ng}),2);
  belief_model_group(:,ng) = mean(belief_model(:,group_inds{ng}),2);
  desire_model_group_se(:,ng) = std(desire_model(:,group_inds{ng})') / length(group_inds{ng});
  belief_model_group_se(:,ng) = std(belief_model(:,group_inds{ng})') / length(group_inds{ng});
end
