function [reward,f_trans,s_sub,s_dim] = create_state_reward(world,c_sub,is_c_ind_valid,goal_reward,cost)
% [reward,f_trans,s_sub,s_dim] = create_state_reward(world,c_sub,is_c_ind_valid,goal_reward,cost)
% Create goal-based reward function for world state with goal-achieved ("finished") bit.
% Set up "finished" transition function for each world.

n_world = length(world);
n_c_sub = size(c_sub,2);
n_action = length(cost);

% n_goal_ind: here to preserve compatibility with more complex model with
% explicit goal-seeking and exploration. multiple rows in goal_reward will
% allow different goal_object reward values for different goals.
[n_goal_ind,n_goal_obj] = size(goal_reward);

% n_f_ind: number of "finished" states
% can either make this a binary feature of the state, i.e. "any goal achieved",
% to capture the notion that you can only eat lunch once, OR could also make
% this a binary string with length = n_endgoal. this would allow rewards from
% each goal one time.
n_f_ind = 2;

s_dim = [n_c_sub,n_goal_ind,n_f_ind,n_world];
n_s_ind = prod(s_dim);
s_ind = 1:n_s_ind;
s_sub = ind2subv(s_dim,s_ind)';

% setup:
% if you take EAT action in a particular coord and world 
%   if there's a truck there
%     you get reward and Finish
%   if there's not a truck there
%     no reward and you don't Finish

cgw_reward = zeros([n_c_sub,n_goal_ind,n_world]);
fcw_trans = zeros([n_c_sub,n_world]);

for wi=1:n_world
  for go=1:n_goal_obj

    if ~isempty(world{wi}.goal_pose{go})
      goal_obj_c_ind = find(all(repmat(world{wi}.goal_pose{go},1,n_c_sub) == c_sub,1) & is_c_ind_valid(wi,:));

      if ~isempty(goal_obj_c_ind)
        fcw_trans(goal_obj_c_ind,wi) = 1;

          cgw_reward(goal_obj_c_ind,:,wi) = cgw_reward(goal_obj_c_ind,:,wi) + goal_reward(:,go);

      end % if ~isempty(goal_obj_c_ind)
    end % if ~isempty(world{wi}.goal_pose{go})

  end % for go=1:n_goal_obj
end % for wi=1:n_world

finished = s_sub(3,:) == 2;
not_finished = ~finished;

reward = zeros(n_s_ind,n_action);
reward(not_finished,:) = repmat(reshape(-cost,[1 1 n_action]),[sum(not_finished) 1]);

% last action is the "finish" action
reward(not_finished,end) = reward(not_finished,end) + cgw_reward(:);

f_trans = zeros([n_f_ind,n_s_ind,n_action]);
f_trans(2,finished,:) = 1;
f_trans(2,not_finished,end) = reshape(repmat(fcw_trans,[n_goal_ind 1]),1,n_c_sub*n_goal_ind*n_world);
f_trans(1,:) = 1 - f_trans(2,:);

