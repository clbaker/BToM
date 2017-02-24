% setup_btom.m
% create .pomdpx files in policydir

addpath([pwd '/model']);
addpath([pwd '/3rd Party']);

btom_parameters;
params.discount = discount;
params.action_reward = -cost;
params.p_action_fail = p_action_fail;
params.obs_noise = obs_noise;
params.goal_reward = goal_reward;
params.action = action;
params.action_label = action_label;

if ~exist(basedir,'dir')
  mkdir(basedir);
end
if ~exist(policydir,'dir')
  mkdir(policydir);
end

train_belief_set = false_belief_set_train;
n_train_belief_set = size(train_belief_set,1);
for bi=1:n_train_belief_set
  params.b_world = train_belief_set(bi,:);
  gen_pomdpx(params,sprintf('%s/%02d-train.pomdpx',policydir,bi));
end

test_belief_set = false_belief_set;
n_test_belief_set = size(test_belief_set,1);
for bi=1:n_test_belief_set
  params.b_world = test_belief_set(bi,:);
  gen_pomdpx(params,sprintf('%s/%02d.pomdpx',policydir,bi));
end
