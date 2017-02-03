% scatter_plots.m
% Plot individual trial (figures 1-8) and grouped-trial (figures 9-16) mean
% human judgments against model predictions for desires (odd-numbered
% figures) and beliefs (even-numbered figures) for btom (1,2,9,10),
% truebelief (3,4,11,12), nocost (5,6,13,14) and motionheuristic (7,8,15,16)

btom=load('data/btom_results_complete.mat');
truebelief=load('data/truebelief_results_complete.mat');
nocost=load('data/nocost_results_complete.mat');
motionheuristic=load('data/motionheuristic_results_complete.mat');

people=load('data/human_data.mat');

excl=[11 12 22 71 72];
%excl=[];
incl=setdiff(1:78,excl);

btom.beta_ind = 5;
truebelief.beta_ind = 18;
nocost.beta_ind = 5;

desire_axis = [1 7.5 1 7.5];
belief_axis = [0 1 0 .8];
errorbar_width = 12;
markersize = 40;


%% Individual trial analyses

desire_people = people.des_inf_mean(:,incl);
belief_people = people.bel_inf_mean_norm(:,incl);

% BToM individual

desire_model = btom.desire_model(:,incl,btom.beta_ind);
belief_model = btom.belief_model(:,incl,btom.beta_ind);

figure(1);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
axis(desire_axis);

figure(2);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
axis(belief_axis);

% TrueBelief individual

desire_model = truebelief.desire_model(:,incl,truebelief.beta_ind);
belief_model = truebelief.belief_model(:,incl,truebelief.beta_ind);

figure(3);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
axis(desire_axis);

figure(4);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
axis(belief_axis);

% NoCost individual

desire_model = nocost.desire_model(:,incl,nocost.beta_ind);
belief_model = nocost.belief_model(:,incl,nocost.beta_ind);

figure(5);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
axis(desire_axis);

figure(6);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
axis(belief_axis);

% MotionHeuristic individual

desire_model = motionheuristic.desire_model(:,incl);
belief_model = motionheuristic.belief_model(:,incl);

figure(7);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
axis(desire_axis);

figure(8);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
axis(belief_axis);


%% Grouped trial analysis

desire_people = people.des_inf_group_mean;
belief_people = people.bel_inf_group_mean;
desire_people_sd = people.des_inf_group_sd;
belief_people_sd = people.bel_inf_group_sd;

% BToM grouped

desire_model = btom.desire_model_group(:,:,btom.beta_ind);
belief_model = btom.belief_model_group(:,:,btom.beta_ind);

figure(9);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(desire_model(:),desire_people(:),desire_people_sd(:),desire_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(desire_axis);

figure(10);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(belief_model(:),belief_people(:),belief_people_sd(:),belief_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(belief_axis);

% TrueBelief individual

desire_model = truebelief.desire_model_group(:,:,truebelief.beta_ind);
belief_model = truebelief.belief_model_group(:,:,truebelief.beta_ind);

figure(11);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(desire_model(:),desire_people(:),desire_people_sd(:),desire_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(desire_axis);

figure(12);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(belief_model(:),belief_people(:),belief_people_sd(:),belief_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(belief_axis);

% NoCost individual

desire_model = nocost.desire_model_group(:,:,nocost.beta_ind);
belief_model = nocost.belief_model_group(:,:,nocost.beta_ind);

figure(13);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(desire_model(:),desire_people(:),desire_people_sd(:),desire_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(desire_axis);

figure(14);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(belief_model(:),belief_people(:),belief_people_sd(:),belief_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(belief_axis);

% MotionHeuristic individual

desire_model = motionheuristic.desire_model_group;
belief_model = motionheuristic.belief_model_group;

figure(15);
plot(desire_model(:),desire_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(desire_model(:),desire_people(:),desire_people_sd(:),desire_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(desire_axis);

figure(16);
plot(belief_model(:),belief_people(:),'k.','markersize',markersize);
hold on;
h=errorbar(belief_model(:),belief_people(:),belief_people_sd(:),belief_people_sd(:), ...
    'linestyle','none','color',[0 0 0],'linewidth',1,'markersize',markersize);
h.CapSize = errorbar_width;
axis(belief_axis);
