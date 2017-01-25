function [neighbor_g_ind,b_coord] = barycentric_coord(b_sub,b_to_g)
% [neighbor_g_ind,b_coord] = barycentric_coord(b_sub,b_to_g)
%
% Input:
%   -b_sub:
%   -b_to_g:
%
% Output:
%   -neighbor_g_ind:
%   -b_coord:
%


[b_sub_u,b_ind,u_ind] = unique(b_sub','rows');

[n_b_sub,n_dim] = size(b_sub_u);

g_sub = b_to_g * b_sub_u';

base = fix(single(g_sub)); % CB: protect against numerical error with "single"
d = g_sub - base;

v = zeros(n_dim,n_dim,n_b_sub);
Id = eye(n_dim);
b_coord = zeros(n_dim,n_b_sub);

neighbor_g_ind = zeros(n_dim,n_b_sub);
k = b_to_g(1);

for ni=1:n_b_sub
  [d_sort,d_order] = sort(d(:,ni),'descend');
  
  % compute neighboring vertices
  v(:,1,ni) = base(:,ni);
  for nd=1:(n_dim-1)
    v(:,nd+1,ni) = v(:,nd,ni) + Id(:,d_order(nd));
  end
  neighbor_g_ind(:,ni) = g_sub_to_g_ind(v(:,:,ni),n_dim,k);

  % compute barycentric coordinates
  b_coord(n_dim,ni) = d_sort(n_dim-1);
  for nd=(n_dim-1):-1:2
    b_coord(nd,ni) = d_sort(nd-1) - d_sort(nd);
  end
  
end
b_coord(1,:) = 1 - sum(b_coord(2:end,:));
b_coord = max(b_coord,0); % CB: protect against numerical error

b_coord = b_coord(:,u_ind);
neighbor_g_ind = neighbor_g_ind(:,u_ind);