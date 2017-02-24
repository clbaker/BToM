% truebelief_parameters.m

beta_score_values=0.25:0.25:5;
discount = 0.9999;
cost = 1;
p_action_fail = 0.0;
obs_noise = 0.0;
goal_reward = [300 100 5];
action = [-1  1  0  0  0  0; ...
           0  0 -1  1  0  0];
action_label = {'Le','Ri','Up','Do','Ca','St'};
basedir = sprintf('%s/Data/TrueBelief/discount%1.6f-cost%1.1f',pwd,discount,cost);
policydir = sprintf('%s/policies',basedir);
resultsdir = sprintf('%s/results',basedir);
