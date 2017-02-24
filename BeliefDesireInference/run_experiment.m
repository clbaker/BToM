%% run_experiment.m
%
% Synopsis:
%   -show familiarization stimuli
%     -familiarization slides: see expt_familiarization.m, expt_familiarization.fig
%   -present stimuli from data/stimuli.mat in random order with random names and collect belief & desire inferences
%     -expt_show_cond.m displays each trial
%       -belief/desire inference slide: see expt_bel_pref_inf.m, expt_bel_pref_inf.fig
%
% Experimental variables:
%   -truck_order_ind: familiarization+expt, scalar values in 1-6
%   -ex_name_ind: familiarization, scalar values in 1-2
%   -ex_color: familiarization, scalar values in 1:n_color
%   -cond_order: expt, length=n_cond
%   -color_ind: expt, length=n_cond
%   -name_ind: expt, length=n_cond
%   -sex_ind: expt, length=n_cond


addpath([pwd '/code']);
addpath([pwd '/code/model']);
addpath([pwd '/code/visilibity']);

max_time = 60 * 85; % 85 minutes


%% setup main experiment

% load stimuli and conditions
load('data/stimuli.mat');
n_cond = length(scenario);
n_complete_paths = 54;

truck_names = {'Korean','Lebanese','Mexican'};
n_truck_names = length(truck_names);

n_color = 10;
truck_sz = [.91;.59];
agent_sz = truck_sz;

agent_img = cell(2,n_color);
for ni=1:n_color
  [agent_img{1,ni}.img,agent_img{1,ni}.map,agent_img{1,ni}.alpha] = imread(sprintf('data/img/agent%d.png',ni));
  [agent_img{2,ni}.img,agent_img{2,ni}.map,agent_img{2,ni}.alpha] = imread(sprintf('data/img/agent%d_eat.png',ni));
  
end

truck_img = cell(1,n_truck_names);
[truck_img{1}.img,truck_img{1}.map,truck_img{1}.alpha] = imread('data/img/truck_k.png');
[truck_img{2}.img,truck_img{2}.map,truck_img{2}.alpha] = imread('data/img/truck_l.png');
[truck_img{3}.img,truck_img{3}.map,truck_img{3}.alpha] = imread('data/img/truck_m.png');


% subject data structures

pref_inf = cell(1,n_cond);
bel_inf = cell(1,n_cond);
cond_time = zeros(3,n_cond);

% save subjects' raw data just in case!
pref_click = cell(1,n_cond);
bel_click = cell(1,n_cond);


% figure for animations

close all;

fnum = 1;
h_fig = figure(fnum);
clf;
set(h_fig,'menubar','none','position',[830 367 661 501],'name','Instructions','numbertitle','off','renderer','opengl');


% randomize exptl variables

% start expt with at least 4 "complete" paths
complete_paths_rand = randperm(n_complete_paths);
intro_cond_order = complete_paths_rand(1:4);

remaining_conds = [complete_paths_rand(5:end) (n_complete_paths+1):n_cond];
n_remaining_conds = length(remaining_conds);
remaining_cord_order = randperm(n_remaining_conds);

%cond_order = randperm(n_cond);
cond_order = [intro_cond_order remaining_conds(remaining_cord_order)];

% randomize order of truck names
truck_perms = perms(1:n_truck_names);
truck_order_ind = ceil(size(truck_perms,1).*rand(1,n_cond));
truck_order = truck_perms(truck_order_ind,:);

% randomize agent color across all conditions
color_ind = ceil(n_color.*rand(1,n_cond));

% randomize name and sex order across all conditions
[fmnames] = names();
[sex_ind,name_ind] = ind2sub([6 26],randperm(n_cond));

% randomize stimulus reflection
reflection = [false,false; false,true; true,false; true,true];
reflect_ind = ceil(4.*rand(1,n_cond));
reflect = reflection(reflect_ind,:);


% randomize familiarization variables

ex_truck_order = truck_perms(ceil(size(truck_perms,1)*rand),:);

ex_color = ceil(n_color*rand);

ex_names = {'Harold','he','his','him'; ...
            'Harriet','she','her','her'};

n_ex_names = size(ex_names,1);
ex_name_ind = ceil(n_ex_names.*rand);


%% run familiarization interface

pause;

% start timer at this point
tic;

expt_familiarization(ex_names(ex_name_ind,:),truck_names(ex_truck_order),agent_img(:,ex_color),truck_img(ex_truck_order),h_fig);
fam_time = toc;


%% run main experiment

close(h_fig);
h_fig=figure;
set(h_fig,'menubar','none','position',[175 2 1500 501],'numbertitle','off','renderer','opengl','doublebuffer','on');


side = 1; % select which side to display belief/desire

for nc=1:n_cond
  
  ci = cond_order(nc);

  pronouns = fmnames{sex_ind(ci)}(name_ind(ci),:);
    
  [pref_inf{ci},bel_inf{ci},cond_time(:,ci),pref_click{ci},bel_click{ci}] ...
      = expt_show_scenario(scenario{ci},h_fig,pronouns,side,truck_names, ...
        ex_truck_order,truck_order(ci,:),reflect(ci,:), ...
        agent_img(:,color_ind(ci)),truck_img(truck_order(ci,:)), ...
        agent_sz,truck_sz);

  if nc==45
    expt_intermission;
  end
  
  % end experiment if time goes over
  if sum(cond_time(3,:)) > max_time
    break;
  end

end % for nc=1:n_cond
  
t = fix(clock);
t_str = sprintf('%04g-%02g-%02g-%02g-%02g',t(1),t(2),t(3),t(4),t(5));

expt_ending;

save(sprintf('data/data_%s.mat',t_str));
