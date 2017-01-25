function [scenario_xform,path_inds_xform] = reflect_scenario(scenario,path_inds,reflect_x,reflect_y)
% [scenario_xform,path_inds_xform] = reflect_scenario(scenario,path_inds,reflect_x,reflect_y)
%


n_world = length(scenario);
scenario_xform = cell(1,n_world);

for nw=1:n_world
  scenario_xform{nw}.graph_sz = scenario{nw}.graph_sz;
  
  scenario_xform{nw}.obst_pose = zeros(size(scenario{nw}.obst_pose));
  scenario_xform{nw}.obst_sz = scenario{nw}.obst_sz;
  scenario_xform{nw}.goal_space = zeros(size(scenario{nw}.goal_space));
  scenario_xform{nw}.goal_pose = cell(1,length(scenario{nw}.goal_pose));
  
  if reflect_x
    scenario_xform{nw}.obst_pose(1,:) = scenario{nw}.graph_sz(1)-scenario{nw}.obst_pose(1,:)-scenario{nw}.obst_sz(1,:)+2;
    scenario_xform{nw}.goal_space(1,:) = scenario{nw}.graph_sz(1)-scenario{nw}.goal_space(1,:)+1;
    for ng=1:length(scenario{nw}.goal_pose)
      if ~isempty(scenario{nw}.goal_pose{ng})
        scenario_xform{nw}.goal_pose{ng}(1,:) = scenario{nw}.graph_sz(1)-scenario{nw}.goal_pose{ng}(1)+1;
      end
    end

  else
    scenario_xform{nw}.obst_pose(1,:) = scenario{nw}.obst_pose(1,:);
    scenario_xform{nw}.goal_space(1,:) = scenario{nw}.goal_space(1,:);
    for ng=1:length(scenario{nw}.goal_pose)
      if ~isempty(scenario{nw}.goal_pose{ng})
        scenario_xform{nw}.goal_pose{ng}(1,:) = scenario{nw}.goal_pose{ng}(1);
      end
    end

  end
  
  if reflect_y
    scenario_xform{nw}.obst_pose(2,:) = scenario{nw}.graph_sz(2)-scenario{nw}.obst_pose(2,:)-scenario{nw}.obst_sz(2,:)+2;
    scenario_xform{nw}.goal_space(2,:) = scenario{nw}.graph_sz(2)-scenario{nw}.goal_space(2,:)+1;
    for ng=1:length(scenario{nw}.goal_pose)
      if ~isempty(scenario{nw}.goal_pose{ng})
        scenario_xform{nw}.goal_pose{ng}(2,:) = scenario{nw}.graph_sz(2)-scenario{nw}.goal_pose{ng}(2)+1;
      end
    end

  else
    scenario_xform{nw}.obst_pose(2,:) = scenario{nw}.obst_pose(2,:);
    scenario_xform{nw}.goal_space(2,:) = scenario{nw}.goal_space(2,:);
    for ng=1:length(scenario{nw}.goal_pose)
      if ~isempty(scenario{nw}.goal_pose{ng})
        scenario_xform{nw}.goal_pose{ng}(2,:) = scenario{nw}.goal_pose{ng}(2);
      end
    end

  end
  
end

% CB: assuming all possible worlds have same graph_sz
path_subs = ind2subv(scenario{1}.graph_sz,path_inds)';

path_subs_xform = zeros(size(path_subs));

if reflect_x
  path_subs_xform(1,:) = scenario{nw}.graph_sz(1)-path_subs(1,:)+1;
else
  path_subs_xform(1,:) = path_subs(1,:);
end

if reflect_y
  path_subs_xform(2,:) = scenario{nw}.graph_sz(2)-path_subs(2,:)+1;
else
  path_subs_xform(2,:) = path_subs(2,:);
end

path_inds_xform = sub2indv(scenario{1}.graph_sz,path_subs_xform);