function [scenario,path,options] = expt2_familiarization_scenario1(names,agent_img,goal_img,h_fig)
% [scenario,path,options] = expt2_familiarization_scenario1(names,agent_img,goal_img,h_fig)
%
% generate familiarization stimulus and display options
%


n_scenario = 3;
scenario = cell(1,n_scenario);
scenario{1}.graph_sz = [5;5];
scenario{1}.obst_pose = [2;3];
scenario{1}.obst_sz = [3;1];
scenario{1}.goal_space = [[3;1] [3;5]];
scenario{1}.goal_pose = {[3;1],[3;5],[]};
scenario{2}.graph_sz = [5;5];
scenario{2}.obst_pose = [2;3];
scenario{2}.obst_sz = [3;1];
scenario{2}.goal_space = [[3;1] [3;5]];
scenario{2}.goal_pose = {[3;1],[],[3;5]};
scenario{3}.graph_sz = [5;5];
scenario{3}.obst_pose = [2;3];
scenario{3}.obst_sz = [3;1];
scenario{3}.goal_space = [[3;1] [3;5]];
scenario{3}.goal_pose = {[3;1],[],[]};

scenario{4}.graph_sz = [5;5];
scenario{4}.obst_pose = [2;3];
scenario{4}.obst_sz = [3;1];
scenario{4}.goal_space = [[3;1] [3;5]];
scenario{4}.goal_pose = {[],[],[3;5]};

path = [8 9 10 15 20];

n_goal = length(names);

truck_sz = [.91; .59];
agent_sz = truck_sz;

options = [];
options.agent_type = 3;

options.agent_img = agent_img;

options.agent_sz = agent_sz;
options.agent_color = [];
options.agent_trail = 3;
options.agent_trail_sz = 5;
options.agent_trail_color = [0 0 0];
options.goal_type = repmat(3,1,n_goal);

options.goal_img = goal_img;

options.goal_sz = mat2cell(repmat(truck_sz,1,n_goal),2,ones(1,n_goal));
options.goal_color = mat2cell(repmat([0 0 0],1,n_goal),1,repmat(3,n_goal,1));

options.view_opt = 1;
options.box_on = 1;
options.animate = false;
options.speed = 10;
options.delay = 0;
options.special_delay = false;
options.f_num = h_fig;
options.isovist = false;

options.clear_frame = true;

% options.click_advance = true;
