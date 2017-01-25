%% btom_results.m
%


localdir = pwd;

addpath([localdir '/code/model']);

basedir = [localdir '/data/btom'];
scoredir = [basedir '/score_scenarios'];

% get stimuli
load('data/stimuli.mat');
n_scenario = length(scenario);

% get model parameters
btom_parameters;


%% load data and compute joint posterior, joint marginal over beliefs and rewards

belief_sub = cell(1,n_scenario);
smooth_joint_post = cell(1,n_scenario);
belief_marg = cell(1,n_scenario);
reward_marg = cell(1,n_scenario);

for ns=1:n_scenario

  % LOAD SCORES
  
  loaddir = sprintf('%s/scenario%02d',scoredir,ns);

  nw = scenario{ns}.condition(1); % set of possible worlds for this condition (according to agent)
  path_len = length(scenario{ns}.path);
  n_worlds = length(worlds{nw});
  
  goal_reward = create_goal_reward(worlds{nw},n_reward_grid);
  n_goal_reward = size(goal_reward,1);
  n_goal_obj = size(goal_reward,2);
  G = double(ind2subv(repmat(n_reward_grid,1,n_goal_obj),1:(n_reward_grid^n_goal_obj)));
  
  b_sub_unique = cell(n_goal_reward,path_len);
  fwd          = cell(n_goal_reward,path_len);
  smooth       = cell(n_goal_reward,path_len);

  for ng=1:n_goal_reward
    score = load(sprintf('%s/score%03d.mat',loaddir,ng));
    b_sub_unique(ng,:) = score.b_sub_unique;
    fwd(ng,:) = score.fwd;
    smooth(ng,:) = score.smooth;
  end
  
  % COMPUTE JOINT POSTERIOR OVER BELIEFS, REWARDS

  belief_sub{ns} = cell(1,path_len);
  belief_ind_all = cell(1,path_len);

  % always Ts=t, ts=1
  smooth_joint_score = cell(1,path_len);
  smooth_joint_post{ns} = cell(1,path_len);

  for t=1:path_len

    b_sub_cell = b_sub_unique(:,t)';
    b_sub_all = cell2mat(b_sub_cell);

    [belief_sub{ns}{t},foo,belief_ind_all{t}] = unique(round(b_precision*b_sub_all')/b_precision,'rows');

    smooth_joint_score{t} = cell(1,t);
    smooth_joint_post{ns}{t} = cell(1,t);

    %for tau=1:t
    for tau=[1 t] % just do initial, final joint marginals

      b_sub_smooth_cell = cell(1,n_goal_reward);

      % sum over g, f
      for nr=1:n_goal_reward
        b_sub_smooth_cell{nr} = smooth{nr,t}{tau};
      end

      b_sub_smooth_all = cell2mat(b_sub_smooth_cell);
      n_b_sub_smooth_all = length(b_sub_smooth_all);
      n_b_sub_smooth_reward = cellfun('length',b_sub_smooth_cell);
      b_sub_reward_smooth_ind = [0 cumsum(n_b_sub_smooth_reward)];
      joint_smooth_reward_ind = zeros(1,n_b_sub_smooth_all);
      n_smooth_belief_sub = size(belief_sub{ns}{tau},1);

      for nr=1:n_goal_reward
        joint_smooth_reward_ind(1,(b_sub_reward_smooth_ind(nr)+1):b_sub_reward_smooth_ind(nr+1)) = nr;
      end

      smooth_joint_score{t}{tau} = -inf(n_goal_reward,n_smooth_belief_sub);
      for nb=1:n_smooth_belief_sub
        reward_belief_score_ind = find(belief_ind_all{tau}==nb);
        smooth_joint_score{t}{tau}(joint_smooth_reward_ind(reward_belief_score_ind),nb) = b_sub_smooth_all(reward_belief_score_ind);
      end

      smooth_joint_post{ns}{t}{tau} = smooth_joint_score{t}{tau} - logsumexp(smooth_joint_score{t}{tau}(:));

    end % for tau=1:t

  end % for t=1:path_len

  % COMPUTE MARGINAL INFERENCES
  
  belief_marg{ns} = zeros(n_worlds,path_len);    
  reward_marg{ns} = zeros(n_goal_obj,path_len);
  
  for t=1:path_len
 
    % various marginal distributions computed from model predictions used below
    
    smooth_joint_post_marg = exp(smooth_joint_post{ns}{t}{1});
    fwd_joint_post_marg = exp(smooth_joint_post{ns}{t}{t});
    
    smooth_belief_post_marg = sum(smooth_joint_post_marg,1);
    reward_post_marg = sum(fwd_joint_post_marg,2);
    
    belief_marg{ns}(:,t) = (smooth_belief_post_marg*belief_sub{ns}{1})';
    reward_marg{ns}(:,t) = G' * reward_post_marg;
    
  end % for t=1:path_len
      
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
