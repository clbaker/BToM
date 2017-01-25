function [b_sub,b_to_g,g_to_b] = create_belief_space(n_world,n_grid)
% [b_sub,b_to_g,g_to_b] = create_belief_space(n_world,n_grid)
%
% Input:
%   n_world: number of possible worlds (vertices on simplex)
%   n_grid: each edge of the belief simplex has n_grid+1 points
%
% Output:
%   b_sub:
%   b_to_g:
%   g_to_b:
%
% Data types:
%   b_sub (belief_sub): 
%   b_ind (belief_ind): 
%   g_sub (grid_sub): regular grid simplex, allows efficient computation of
%     neighbor vertices and barycentric coordinates
%   g_ind (grid_ind): 
%


%% compute b_sub, b_to_g, g_to_b
if n_grid>0
    [g_sub,g_ind] = regular_simplex(n_world,n_grid);
    g_to_b = zeros(1,(n_grid+1)^n_world,'uint32');
    g_to_b(g_ind) = 1:length(g_ind);

    [b_sub,b_to_g] = belief_simplex(g_sub,n_grid);

else
    b_sub = [1;1;1]/3;
    g_to_b = ones(n_world)/9;
    b_to_g = ones(n_world);
end