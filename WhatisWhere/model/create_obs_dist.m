function [obs_dist,obs,isovist_polygon,vis_area,epsilon] = create_obs_dist(world,c_sub,is_c_ind_valid,obs_noise)
%[obs_dist,obs,isovist_polygon,vis_area,epsilon] = create_obs_dist(world,c_sub,is_c_ind_valid,obs_noise)

n_goal_pose = length(world.goal_pose);
n_goal_open = length(world.goal_open);

n_world = n_goal_pose*n_goal_open;
world_sub = ind2subv([n_goal_pose n_goal_open],1:n_world)';

n_c_sub = size(c_sub,2);

epsilon = 0.000000001;
snap_dist = 0.0;

% compute:
%   1. objects: object (goal,obst,empty) identity in each coord in each world
%      objects: n_goal_object+1 for obstacles, sign is negative for "closed" goals
%   2. isovist_polygon: area of space visible from each coord in each world
%      isovist_polygon{nw,nc}: isovist from coordinate nc in world nw
%   3. vis_area: proportion of each coord visible from each coordinate in each world

objects = zeros(n_c_sub,n_world);
for nw=1:n_world
  n_goal_object = length(world.goal_pose{world_sub(1,nw)});
  objects(~is_c_ind_valid,nw) = n_goal_object+1;
  for ng=1:n_goal_object
    if ~isempty(world.goal_pose{world_sub(1,nw)}{ng})
      if world.goal_open{world_sub(2,nw)}(ng)
        objects(sub2indv(world.graph_sz,world.goal_pose{world_sub(1,nw)}{ng}),nw) = ng;
      else
        objects(sub2indv(world.graph_sz,world.goal_pose{world_sub(1,nw)}{ng}),nw) = -ng;
      end
    end
  end
end

isovist_polygon = cell(n_world,n_c_sub);
vis_area = zeros(n_c_sub,n_c_sub,n_world);
for nw=1:n_world
  isovist_polygon(nw,is_c_ind_valid) = isovist(world,c_sub(:,is_c_ind_valid),epsilon,snap_dist);

  for c1=1:n_c_sub
    if is_c_ind_valid(c1)
      for c2=1:n_c_sub
        if is_c_ind_valid(c2)
          c_polygon = [c_sub(:,c2)'-[0.5 0.5]; ...
                       c_sub(:,c2)'+[-0.5 0.5]; ...
                       c_sub(:,c2)'+[0.5 0.5]; ...
                       c_sub(:,c2)'+[0.5 -0.5]];
          [c_polygon_vis_area_x,c_polygon_vis_area_y] ...
            = polybool('&',isovist_polygon{nw,c1}(:,1),isovist_polygon{nw,c1}(:,2),c_polygon(:,1),c_polygon(:,2));

          vis_area(c2,c1,nw) = polyarea(c_polygon_vis_area_x,c_polygon_vis_area_y);

        end
      end
    end
  end

end % for nw=1:n_world

vis_obj = zeros(n_c_sub,n_c_sub,n_world);
tmp = repmat(reshape(objects,[n_c_sub 1 n_world]),[1 n_c_sub 1]);
vis_obj(vis_area>eps) = tmp(vis_area>eps);

[obs,foo,obs_ind] = unique(vis_obj(:,:)','rows');
n_obs = size(obs,1);

obs_dist = zeros(n_obs,n_c_sub,n_world);

for ni=1:length(obs_ind)
  obs_dist(obs_ind(ni),ni) = (1-obs_noise)*prod(vis_area(obs(obs_ind(ni),:)>0,ni));
  obs_dist(all(obs==0,2),ni) = obs_dist(all(obs==0,2),ni) + obs_noise;
end

% normalize
obs_dist = obs_dist ./ repmat(sum(obs_dist,1),[n_obs 1 1]);

