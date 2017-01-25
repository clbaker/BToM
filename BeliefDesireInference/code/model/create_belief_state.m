function [s_sub,s_dim,b_sub,b_to_g,g_to_b] = create_belief_state(is_c_ind_valid,n_grid)
% [s_sub,s_dim,b_sub,b_to_g,g_to_b] = create_belief_state(is_c_ind_valid,n_grid)
%
% Input:
%   is_c_ind_valid: size(n_world,n_c_ind)
%   n_grid: each edge of the belief simplex has n_grid+1 points
%
% Output:
%   -s_sub (state_sub): [b_ind c_ind]
%   -s_dim (state_dim): [n_b_sub n_c_ind]
%   -b_sub: size(n_world,n_b_sub)
%   -b_to_g: size(n_world,n_world)
%   -g_to_b:


[n_world,n_c_ind] = size(is_c_ind_valid);

% create belief space
[b_sub,b_to_g,g_to_b] = create_belief_space(n_world,n_grid);
n_b_sub = size(b_sub,2);

% create belief state
s_dim = [n_b_sub n_c_ind];
n_s_ind = prod(s_dim);
s_ind = 1:n_s_ind;
s_sub = ind2subv(s_dim,s_ind)';

