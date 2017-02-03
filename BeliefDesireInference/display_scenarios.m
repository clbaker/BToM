% display_scenarios.m
% load and display stimuli from all conditions, 
% grouping according to group_conds.m


load('data/stimuli.mat');

cond_groups = group_conds(true);
n_cond_groups = length(cond_groups);


f_pose = [25 500 2500 1000];

disp_options = [];
disp_options.goal_text = {'K','L','M'};
n_goal = length(disp_options.goal_text);
disp_options.goal_type = ones(1,n_goal);
disp_options.goal_sz = num2cell(repmat(8,1,n_goal));
disp_options.goal_color = mat2cell(repmat([0 0 0],1,n_goal),1,repmat(3,n_goal,1));

disp_options.agent_type = 1;
disp_options.agent_text = '.';
disp_options.agent_sz = 4;
disp_options.agent_color = [0 0 0];
%   disp_options.agent_trail = 2;
%   disp_options.agent_trail_sz = 8;
disp_options.agent_trail = 3;
disp_options.agent_trail_sz = .1;
disp_options.agent_trail_color = [0 0 0];

disp_options.view_opt = 1;
disp_options.box_on = 1;
disp_options.animate = false;

h = figure(1);
disp_options.f_num = h;

set(h,'menubar','figure','position',f_pose,'name','Grouped Conditions','numbertitle','on');


for gi=1:n_cond_groups

  n_conds = length(cond_groups{gi});
  
  for ci=1:n_conds
    nc = cond_groups{gi}(ci);
  
    if nc<=54 % complete paths
      % remove special "finished" state at end of path
      disp_path_ind = scenario{nc}.path(1:(end-1));
    else
      disp_path_ind = scenario{nc}.path;
    end
    disp_path_sub = ind2subv(scenario{nc}.world{1}.graph_sz',disp_path_ind)';
    hold off;
    
    n_col = max(cellfun('length',cond_groups));
    subplot(n_cond_groups,n_col,((gi-1)*n_col)+ci);
    
    world_ind = scenario{nc}.condition(2);
    path_anim(scenario{nc}.world{world_ind},disp_path_sub,zeros(2,length(disp_path_ind)-1),disp_options);
    
    title(sprintf('%d',nc));
    
  end % for nc=1:n_conds

end % for nc=1:n_cond_groups
