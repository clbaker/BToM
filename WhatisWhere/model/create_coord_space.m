function [c_sub,is_c_ind_valid] = create_coord_space(world)
% [c_sub,is_c_ind_valid] = create_coord_space(world)

graph_sz = world.graph_sz;
n_c_ind = prod(graph_sz);
c_sub = double(ind2subv(graph_sz,1:n_c_ind)');

is_c_ind_valid = true(1,n_c_ind);
obst_sub = get_obst_sub(world.obst_pose,world.obst_sz);
obst_ind = sub2indv(graph_sz,obst_sub);
is_c_ind_valid(obst_ind) = false;

