function [goal_reward] = create_goal_reward(worlds,n_reward_grid)
% [goal_reward] = create_goal_reward(worlds,n_reward_grid)
%


n_goal_obj = length(worlds{1}.goal_pose); % assuming all possible worlds have same n_goal_obj
G = double(ind2subv(repmat(n_reward_grid,1,n_goal_obj),1:(n_reward_grid^n_goal_obj))-1);
goal_reward = -20+G*20;
