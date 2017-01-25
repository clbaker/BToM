function [isovists,env] = isovist1(world,c_sub,epsilon,snap_dist)
% [isovists,env] = isovist1(world,c_sub,epsilon,snap_dist)
%
% Input:
%
% Output:
%   isovists{i} is a star-shaped polygon in clockwise order
%


%Robustness constant
if ~exist('epsilon','var')
  epsilon = 0.000000001;
end

%Snap distance (distance within which an observer location will be snapped to the
%boundary before the visibility polygon is computed)
if ~exist('snap_dist','var')
  snap_dist = 0.05;
end

n_c_sub = size(c_sub,2);
c_sub_offset = [0.5 0.5];

graph_pose = [1.0 1.0];
graph_sz = world.graph_sz(:)';
obst_pose = world.obst_pose;
obst_sz = world.obst_sz;

n_obst = size(obst_pose,2);

isovists = cell(1,n_c_sub);
env = cell(1,n_obst+1);

% outer boundary x-y coords (listed counterclockwise)
env{1} = zeros(4,2);
env{1}(1,:) = graph_pose;
env{1}(2,:) = graph_pose+[graph_sz(1) 0.0];
env{1}(3,:) = graph_pose+graph_sz;
env{1}(4,:) = graph_pose+[0.0 graph_sz(2)];

% "hole" x-y coords (listed clockwise)
for no=1:n_obst
  env{no+1} = zeros(4,2);
  env{no+1}(1,:) = obst_pose(:,no)'+epsilon;
  env{no+1}(2,:) = obst_pose(:,no)'+[epsilon obst_sz(2,no)-epsilon];
  env{no+1}(3,:) = obst_pose(:,no)'+obst_sz(:,no)'-epsilon;
  env{no+1}(4,:) = obst_pose(:,no)'+[obst_sz(1,no)-epsilon epsilon];

  % OLD: caused a heinous bug because it didn't ensure that non-overlapping
  % obstacles didn't intersect along the edges
  %env{no+1}(env{no+1}==repmat(graph_pose,4,1))=env{no+1}(env{no+1}==repmat(graph_pose,4,1))+epsilon;
  %env{no+1}(env{no+1}==repmat(graph_sz,4,1))=env{no+1}(env{no+1}==repmat(graph_sz,4,1))-epsilon;
end

for nc=1:n_c_sub
  iso_tmp = visibility_polygon(c_sub(:,nc)'+c_sub_offset, env, epsilon, snap_dist);
  [iso_cw_x,iso_cw_y] = poly2cw(iso_tmp(:,1),iso_tmp(:,2));
  isovists{nc} = [iso_cw_x iso_cw_y];
end
