function [c_sub,is_c_ind_valid] = create_coord_space(world)
% [c_sub,is_c_ind_valid] = create_coord_space(world)
%
% Create deterministic coordinate transition matrix.
%
% Input:
%   world:
%
% Output:
%   c_sub:
%   is_c_ind_valid:
%


n_world = length(world);

%% compute c_sub, is_c_ind_valid
% CB: assuming all worlds have same graph_sz as world{1}
graph_sz = world{1}.graph_sz;
n_c_sub = prod(graph_sz);
c_sub = double(ind2subv(graph_sz,1:n_c_sub)');

n_c_ind = n_c_sub+1;
is_c_ind_valid = true(n_world,n_c_ind);
for nw=1:n_world
  obst_pose = world{nw}.obst_pose;
  obst_sz = world{nw}.obst_sz;
  obst_sub = get_obst_sub(obst_pose,obst_sz);
  obst_ind = sub2indv(graph_sz,obst_sub);
  is_c_ind_valid(nw,obst_ind) = false;
end


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
