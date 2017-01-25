function [obs_dist,obs,isovist_polygon,vis_area,epsilon] = create_obs_dist(world,c_sub,is_c_ind_valid,obs_noise)
% [obs_dist,obs,isovist_polygon,vis_area,epsilon] = create_obs_dist(world,c_sub,is_c_ind_valid,obs_noise)
%
% Input:
%   -world:
%   -c_sub:
%   -is_c_ind_valid:
%   -obs_noise:
%
% Output:
%   -obs_dist: size(n_obs,n_c_sub,n_world)
%   -obs: size(n_obs,n_world)
%   -isovist_polygon: cell(n_world,n_c_sub)
%   -vis_area: size(n_c_sub,n_c_sub,n_world)
%   -epsilon: tolerance value passed into visibility_polygon()
%


n_world = length(world);
n_c_sub = size(c_sub,2);
n_c_ind = size(is_c_ind_valid,2);

epsilon = 0.000000001;
snap_dist = 0.0;

% compute:
%   1. isovist_polygon: area of space visible from each coord in each world
%      isovist_polygon{w,nc}: isovist from coordinate nc in world w
%   2. objects: object (goal,obst,empty) identity in each coord in each world
%   3. vis_area: proportion of each coord visible from each coordinate in each world
isovist_polygon = cell(n_world,n_c_sub);
objects = zeros(n_world,n_c_sub);
% vis_area = zeros(n_c_sub,n_c_sub,n_world);

for w=1:n_world
  isovist_polygon(w,is_c_ind_valid(w,1:n_c_sub)) = isovist(world{w},c_sub(:,is_c_ind_valid(w,1:n_c_sub)),epsilon,snap_dist);

  objects(w,~is_c_ind_valid(w,1:n_c_sub)) = -1;
  for ng=1:length(world{w}.goal_pose)
    if ~isempty(world{w}.goal_pose{ng})
      %objects(w,sub2indv(world{w}.graph_sz,world{w}.goal_pose{ng})) = ng;
      objects(w,all(bsxfun(@eq,c_sub,world{w}.goal_pose{ng}),1)) = ng;
    end
  end
  
end % for w=1:n_world


% DISTINCT_OBJECTS: set of possible percepts at each c_sub across worlds
distinct_objects = cell(1,n_c_sub);
for c=1:n_c_sub
  distinct_objects{c} = unique(objects(:,c));
end
n_distinct_objects = cellfun('length',distinct_objects);

% OBS_DIFF_IND: c_inds where observations produce different percepts
obs_diff_ind = find(n_distinct_objects>1);
n_obs_diff_ind = length(obs_diff_ind);

% OBS_DET: enumeration of possible object identities seen from obs_diff_inds
obs_det = unique(objects(:,obs_diff_ind),'rows');

% different combinations of observation failures at obs_diff_inds
obs_fail = ind2subv(repmat(2,1,n_obs_diff_ind),1:(2^n_obs_diff_ind))==2;
% observation symbol corresponding to obs_fail
obs_fail_val = max(obs_det(:)+1);


obs = obs_det;
for ni=2:size(obs_fail,1)
  new_obs = obs_det;
  new_obs(:,obs_fail(ni,:)) = obs_fail_val;
  obs = [obs; unique(new_obs,'rows')];
end

n_obs = size(obs,1);


% VIS_AREA: amount of each obs_diff_ind visible from each c_sub in each
% world
vis_area = zeros(n_obs_diff_ind,n_c_sub,n_world);

for w=1:n_world

  for c1=1:n_c_sub
    if is_c_ind_valid(w,c1)
      
      for n2=1:n_obs_diff_ind
        c2 = obs_diff_ind(n2);
        
        c_polygon = [c_sub(:,c2)'+[0 0]; ...
          c_sub(:,c2)'+[0 1]; ...
          c_sub(:,c2)'+[1 1]; ...
          c_sub(:,c2)'+[1 0]];
        [c_polygon_vis_area_x,c_polygon_vis_area_y] ...
          = polybool('&',isovist_polygon{w,c1}(:,1),isovist_polygon{w,c1}(:,2),c_polygon(:,1),c_polygon(:,2));
        
        vis_area(n2,c1,w) = polyarea(c_polygon_vis_area_x,c_polygon_vis_area_y);
        
      end

    end
  end
  
end


% OBS_DIST: p(o|c,w) = obs_dist(o,c,w)
obs_dist = zeros(n_obs,n_c_ind,n_world);

for c=1:n_c_sub
  for w=1:n_world
    for o=1:size(obs_fail,1)
      obs_no = objects(w,obs_diff_ind);
      obs_no(obs_fail(o,:)) = obs_fail_val;
      
      obs_ind = all(bsxfun(@eq,obs,obs_no),2);
      obs_prob = [1-((1-obs_noise).*vis_area(obs_fail(o,:),c,w)); (1-obs_noise).*vis_area(~obs_fail(o,:),c,w)];
      
      obs_dist(obs_ind,c,w) = obs_dist(obs_ind,c,w) + prod(obs_prob);

    end
  end
end

obs_dist(n_obs,(n_c_sub+1):n_c_ind,:) = 1;

% normalize
obs_dist = obs_dist ./ repmat(sum(obs_dist,1),[n_obs 1 1]);
