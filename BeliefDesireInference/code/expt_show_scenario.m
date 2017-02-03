function [pref_inf,bel_inf,cond_time,pref_click,bel_click] = expt_show_scenario(scenario,h_fig,pronouns,side, ...
  truck_names,truck_name_order,truck_img_order,reflect,agent_img,truck_img,agent_sz,truck_sz)
% [pref_inf,bel_inf,cond_time,pref_click,bel_click] = expt_show_scenario(scenario,h_fig,pronouns,side,
%   truck_names,truck_name_order,truck_img_order,reflect,agent_img,truck_img,agent_sz,truck_sz)


tic;

path = scenario.path;
world_ind = scenario.world_ind;
world = scenario.world;

% if function is called with only 1 argument, use default values for other variables

if ~exist('h_fig','var')
  h_fig = figure;
end

if ~exist('pronouns','var')
  pronouns = {'Harold','he','his','him'};
end

if ~exist('truck_names','var')
  truck_names = {'Korean','Lebanese','Mexican'};
end

if ~exist('truck_name_order','var')
  truck_name_order = [1 2 3];
end

if ~exist('truck_img_order','var')
  truck_img_order = [1 2 3];
end

if ~exist('reflect','var')
  reflect = [0 0];
end

if ~exist('agent_img','var')
  agent_img = cell(2,1);
  [agent_img{1}.img,agent_img{1}.map,agent_img{1}.alpha] = imread('stimuli/img/agent1.png');
  [agent_img{2}.img,agent_img{2}.map,agent_img{2}.alpha] = imread('stimuli/img/agent1_eat.png');
end

if ~exist('truck_img','var')
  truck_img = cell(1,3);
  [truck_img{1}.img,truck_img{1}.map,truck_img{1}.alpha] = imread('stimuli/img/truck_k.png');
  [truck_img{2}.img,truck_img{2}.map,truck_img{2}.alpha] = imread('stimuli/img/truck_l.png');
  [truck_img{3}.img,truck_img{3}.map,truck_img{3}.alpha] = imread('stimuli/img/truck_m.png');
end

if ~exist('agent_sz','var');
  agent_sz = [.91;.59];
end

if ~exist('truck_sz','var');
  truck_sz = agent_sz;
end


% stage 1: display stimulus

disp_options = [];

disp_options.agent_type = 3;

disp_options.agent_img = agent_img;
disp_options.agent_sz = agent_sz;
disp_options.agent_color = [];
disp_options.agent_trail = 3;
disp_options.agent_trail_sz = 2;
disp_options.agent_trail_color = [0 0 0];

n_goal = length(world{world_ind}.goal_pose);

disp_options.goal_img = truck_img;

disp_options.goal_type = repmat(3,1,n_goal);
disp_options.goal_sz = mat2cell(repmat(truck_sz,1,n_goal),2,ones(1,n_goal));
disp_options.goal_color = mat2cell(repmat([0 0 0],1,n_goal),1,repmat(3,n_goal,1));

disp_options.view_opt = 1;
disp_options.box_on = 1;
disp_options.animate = true;
disp_options.speed = 10;
disp_options.delay = 0;
disp_options.special_delay = false;

disp_options.isovist = true;
disp_options.click_advance = true;

disp_options.clear_frame = true;
disp_options.save_frame = false;


disp_options.f_num = h_fig; % figure from familiarization stage
if pronouns{1}(end) == 's'
  set(h_fig,'name',sprintf('%s'' Lunchtime',pronouns{1}));
else
  set(h_fig,'name',sprintf('%s''s Lunchtime',pronouns{1}));
end

[world_xform,disp_path_ind] = reflect_scenario(world,path,reflect(1),reflect(2));

disp_path_sub = ind2subv(world_xform{world_ind}.graph_sz',disp_path_ind)';

actions = [];

cond_time = zeros(1,3);
cond_time(1) = toc;

hold off;
path_anim(world_xform{world_ind},disp_path_sub,actions,disp_options);

cond_time(2) = toc;

% stage 2: ask questions

if nargout
  if side==1
    [pref_inf,bel_inf,pref_click,bel_click] = expt_bel_des_inf1(pronouns(:),truck_names,truck_name_order,truck_img_order,world_xform{world_ind},{disp_path_sub},disp_options);
  else
    [pref_inf,bel_inf,pref_click,bel_click] = expt_bel_des_inf2(pronouns(:),truck_names,truck_name_order,truck_img_order,world_xform{world_ind},{disp_path_sub},disp_options);
  end
end


cond_time(3) = toc;
