function [reward] = create_belief_state_reward(world,s_sub,s_dim,b_sub,c_sub,is_c_ind_valid,goal_reward,cost)
% [reward] = create_belief_state_reward(world,s_sub,s_dim,b_sub,c_sub,is_c_ind_valid,goal_reward,cost)
%
% Input:
%   -world: 
%   -b_sub: 
%   -c_sub: 
%   -is_c_ind_valid: 
%   -goal_reward: utility of each goal
%   -cost: cost of taking "move-action"
%
% Output:
%   -reward:
%   -s_sub (state_sub): [belief_ind; coord_ind]
%   -s_dim (state_dim): [n_b_sub; n_c_sub]
%


n_world = length(world);
n_s_ind = prod(s_dim);
[n_b_sub,n_c_sub] = deal(s_dim(1),s_dim(2));
n_action = size(cost,2);

% get fully observable reward function
ws_reward = create_state_reward(world,c_sub,is_c_ind_valid,goal_reward,cost);

% create belief state reward
tmp1 = reshape(repmat(reshape(ws_reward,[n_world 1 n_c_sub,n_action]),[1 n_b_sub 1 1]),[n_world,n_s_ind,n_action]);
tmp2 = repmat(b_sub(:,s_sub(1,:)),[1 1 n_action]);
reward = squeeze(sum(tmp1.*tmp2,1));

