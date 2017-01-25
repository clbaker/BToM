function [B,B_to_G,G_to_B] = belief_simplex(G,k)
% [B,B_to_G,G_to_B] = belief_simplex(G,k)
% lovejoy regular grid -> belief simplex construction
%
% Input:
%   G: points on regular simplex returned by regular_simplex
%   k: grid size
%
% Output:

dim = size(G,1);
B_to_G = triu(zeros(dim)+k);
G_to_B = inv(B_to_G);

B = G_to_B * double(G);