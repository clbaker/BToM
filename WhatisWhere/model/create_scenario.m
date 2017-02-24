function scenario = create_scenario()
% scenario = create_scenario()

scenario = [];
scenario.graph_sz   = [6;3];
scenario.obst_pose  = [2 5; 2 2];
scenario.obst_sz    = [2 1; 2 2];
gp1 = [1; 3];
gp2 = [4; 3];
gp3 = [6; 3];

scenario.goal_space = [gp1 gp2 gp3];
scenario.goal_pose{1} = {gp2,gp1,gp3}; % BAC
scenario.goal_pose{2} = {gp2,gp3,gp1}; % CAB
scenario.goal_pose{3} = {gp1,gp2,gp3}; % ABC
scenario.goal_pose{4} = {gp1,gp3,gp2}; % ACB
scenario.goal_pose{5} = {gp3,gp2,gp1}; % CBA
scenario.goal_pose{6} = {gp3,gp1,gp2}; % BCA
scenario.goal_open{1} = [true,true,true];
scenario.goal_open{2} = [true,false,true]; % B closed
scenario.goal_open{3} = [false,true,true]; % A closed
scenario.goal_open{4} = [false,false,true]; % A and B closed

