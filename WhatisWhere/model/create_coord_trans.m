function [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(world,action,p_action_fail)
%[c_trans,c_sub,is_c_ind_valid] = create_coord_trans(world,action,p_action_fail)
% Create coordinate transition matrix.

n_action = size(action,2);

[c_sub,is_c_ind_valid] = create_coord_space(world);

n_c_ind = length(is_c_ind_valid);

c_trans = zeros(n_c_ind,n_c_ind,n_action);

graph_sz = world.graph_sz;
c_ind_valid = find(is_c_ind_valid);
n_c_ind_valid = length(c_ind_valid);
  
in_bounds = repmat(graph_sz(:),1,n_c_ind_valid);
  
for na=1:n_action
  move_sub = c_sub(:,c_ind_valid) + repmat(action(:,na),1,n_c_ind_valid);
  move_in_bounds = find(all(move_sub <= in_bounds,1) & all(move_sub > 0,1));
  move_ind = sub2indv(graph_sz,move_sub(:,move_in_bounds));
  move_valid = is_c_ind_valid(move_ind);
  n_move_valid = sum(move_valid);
  
  % valid moves
  c_trans(sub2indv(size(c_trans),...
    [move_ind(move_valid); c_ind_valid(move_in_bounds(move_valid)); repmat(na,[1 n_move_valid])])) = 1-p_action_fail;
  c_trans(sub2indv(size(c_trans),...
    [c_ind_valid(move_in_bounds(move_valid)); c_ind_valid(move_in_bounds(move_valid)); repmat(na,[1 n_move_valid])])) = p_action_fail;
  
  % moves from invalid states
  c_trans(:,~is_c_ind_valid,na) = nan;
  
  % normalize valid moves
  c_trans_sum = sum(c_trans(:,:,na));
  c_trans(:,c_trans_sum>0,na) = c_trans(:,c_trans_sum>0,na) ./ repmat(c_trans_sum(c_trans_sum>0),n_c_ind,1);
  
  % failed moves
  c_trans_stay_ind = find(c_trans_sum==0);
  c_trans(sub2indv(size(c_trans), ...
    [c_trans_stay_ind; c_trans_stay_ind; repmat(na,[1 length(c_trans_stay_ind)])])) = 1;
  
end

