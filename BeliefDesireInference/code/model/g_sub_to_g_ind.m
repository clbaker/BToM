function [g_ind] = g_sub_to_g_ind(g_sub,dim,k)
% [g_ind] = g_sub_to_g_ind(g_sub,dim,k)

g_ind = zeros(1,size(g_sub,2));
g_ind_in_range = all(g_sub<=k&g_sub>=0); % ensures that inds will be valid
g_ind(g_ind_in_range) = sub2indv(repmat(k+1,1,dim),g_sub(:,g_ind_in_range)+1);
