function [reward] = create_state_reward(world,c_sub,is_c_ind_valid,goal_reward,cost)
% [reward] = create_state_reward(world,c_sub,is_c_ind_valid,goal_reward,cost)
%
% Create goal-based reward function for world state with goal-achieved ("finished") bit.
% Set up "finished" transition function for each world.
%
% Input:
%   -world: 
%   -c_sub: 
%   -is_c_ind_valid: 
%   -goal_reward: utility of each goal 
%   -cost: cost of taking "move-action" 
%
% Output:
%   -reward:
%   -s_sub (state_sub): [coord_ind,world_ind]
%   -s_dim (state_dim): [n_c_sub,n_world]
%


[n_world,n_c_ind] = size(is_c_ind_valid);
n_c_sub = size(c_sub,2);
n_action = length(cost);

% n_goal_ind: here to preserve compatibility with more complex model with
% explicit goal-seeking and exploration. multiple rows in goal_reward will
% allow different goal_object reward values for different goals.
[n_goal_ind,n_goal_obj] = size(goal_reward);

s_dim = [n_world,n_c_ind];
n_s_ind = prod(s_dim);
s_ind = 1:n_s_ind;
s_sub = ind2subv(s_dim,s_ind)';

% setup:
% if you take EAT action in a particular coord and world 
%   if there's a truck there
%     you get reward and Finish
%   if there's not a truck there
%     no reward and you don't Finish

wcg_reward = zeros([n_world,n_c_ind,n_goal_ind]);

for wi=1:n_world
  for go=1:n_goal_obj
    if ~isempty(world{wi}.goal_pose{go})
      goal_obj_c_ind = find(all(repmat(world{wi}.goal_pose{go},1,n_c_sub) == c_sub,1) & is_c_ind_valid(wi,1:n_c_sub));
      if ~isempty(goal_obj_c_ind)

          for gi=1:n_goal_ind
            wcg_reward(wi,goal_obj_c_ind,gi) = wcg_reward(wi,goal_obj_c_ind,gi) + goal_reward(gi,go);
          end

      end % if ~isempty(goal_obj_c_ind)
    end % if ~isempty(world{wi}.goal_pose{go})

  end % for go=1:n_goal_obj
end % for wi=1:n_world

reward = zeros(n_s_ind,n_action);
reward = repmat(-cost(:)',n_s_ind,1);

% last action is the "finish" action
reward(:,end) = reward(:,end) + wcg_reward(:);

