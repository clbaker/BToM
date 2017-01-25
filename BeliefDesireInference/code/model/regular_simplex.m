function [G_sub,G_ind] = regular_simplex(dim,k)
% [G_sub,G_ind] = regular_simplex(dim,k)
% lovejoy regular grid simplex construction
%
% Input:
%   dim: number of dimensions
%   k: grid size -- each edge of the simplex has k+1 points
%
% Output:
%

G = ind2subv(repmat(k+1,1,(dim-1)),1:((k+1)^(dim-1)))'; % generate all points on the hypercube

G_sub = [repmat(k,1,size(G,2)); G-1];
G_ind_valid = find(all(diff(G_sub)<=0,1)); % lower tri constraint
G_sub = G_sub(:,G_ind_valid);
G_ind = g_sub_to_g_ind(G_sub,dim,k);

