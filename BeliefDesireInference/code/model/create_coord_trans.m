function [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(world,action,p_action_fail)
% [c_trans,c_sub,is_c_ind_valid] = create_coord_trans(world,action,p_action_fail)
%
% Create deterministic coordinate transition matrix with absorbing end state.
%
% Input:
%   world:
%   action:
%   p_action_fail:
%
% Output:
%   c_trans: size(n_c_ind,n_c_sub,n_action,n_world). c_trans(cj,ci,a,w) = p(cj|ci,a,w).
%   c_sub:
%   is_c_ind_valid:
%


n_action = size(action,2);

[c_sub,is_c_ind_valid] = create_coord_space(world);
n_c_sub = size(c_sub,2);
[n_world,n_c_ind] = size(is_c_ind_valid);

c_trans = zeros(n_c_ind,n_c_ind,n_world,n_action);

for nw=1:n_world
  graph_sz = world{nw}.graph_sz;
  c_sub_valid = find(is_c_ind_valid(nw,1:n_c_sub));
  n_c_sub_valid = length(c_sub_valid);
  
  c_sub_invalid = find(~is_c_ind_valid(nw,1:n_c_sub));
  
  in_bounds = repmat(graph_sz(:),1,n_c_sub_valid);

  is_goal_ind = false(1,n_c_sub);
  for nc=1:n_c_sub
    is_goal_ind(nc) = any(all(bsxfun(@eq,cell2mat(world{nw}.goal_pose),c_sub(:,nc))));
  end

  for na=1:(n_action-1)
    % moves from invalid c_subs
    c_trans(:,c_sub_invalid,nw,na) = nan;

    move_sub = c_sub(:,c_sub_valid) + repmat(action(:,na),1,n_c_sub_valid);
    move_in_bounds = find(all(move_sub <= in_bounds,1) & all(move_sub > 0,1));
    move_ind = sub2indv(graph_sz,move_sub(:,move_in_bounds));
    move_valid = is_c_ind_valid(nw,move_ind);
    n_move_valid = sum(move_valid);

    % valid moves
    c_trans_sub = zeros(4,n_move_valid);
    c_trans_sub([1 2],:) = [move_ind(move_valid); c_sub_valid(move_in_bounds(move_valid))];
    c_trans_sub(3,:) = nw;
    c_trans_sub(4,:) = na;

    % valid moves succeed
    c_trans(sub2indv(size(c_trans),c_trans_sub)) = 1-p_action_fail;

    % valid moves fail
    c_trans_sub(1,:) = c_trans_sub(2,:);
    c_trans_ind = sub2indv(size(c_trans),c_trans_sub);
    c_trans(c_trans_ind) = c_trans(c_trans_ind) + p_action_fail;

    % invalid moves
    % includes:
    %   -moves out of bounds or into obstacles,
    %   -transitions from Finished to other coords.
    
    c_trans_stay = is_c_ind_valid(nw,1:n_c_sub);
    c_trans_stay(c_sub_valid(move_in_bounds(move_valid))) = false;
    c_trans_stay_ind = find(c_trans_stay);
    n_c_trans_stay_ind = length(c_trans_stay_ind);

    c_trans_sub = zeros(4,n_c_trans_stay_ind);
    c_trans_sub([1 2],:) = repmat(c_trans_stay_ind,[2 1]);
    c_trans_sub(3,:) = nw;
    c_trans_sub(4,:) = na;
    c_trans(sub2indv(size(c_trans),c_trans_sub)) = 1;
    
  end % for na=1:(n_action-1)

  c_trans(end,end,nw,:) = 1;
  c_trans(end,[is_goal_ind true],nw,n_action) = 1;
  c_trans(~is_goal_ind,~is_goal_ind,nw,n_action) = eye(sum(~is_goal_ind));

end % for nw=1:n_world



function [obst_sub] = get_obst_sub(obst_pose,obst_sz)
% [obst_sub] = get_obst_sub(obst_pose,obst_sz)

n_obst = size(obst_pose,2);
if n_obst > 0
  n_ind  = obst_sz(1,:)*obst_sz(2,:)';
  obst_sub = zeros(2,n_ind);
  ind = 1;
  for oi=1:n_obst
    for xi=0:(obst_sz(1,oi)-1)
      for yi=0:(obst_sz(2,oi)-1)
        obst_sub(:,ind) = obst_pose(:,oi) + [xi yi]';
        ind = ind+1;
      end
    end
  end
else
  obst_sub = zeros(2,0);
end
