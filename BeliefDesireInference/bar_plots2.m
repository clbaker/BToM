% bar_plots2.m
% Plot individual-trial mean judgments for all scenarios against btom.
% Fig 1 shows environment configuration 3; fig 2 shows configurations 1 & 2.
% Desire results are shown in odd subplots, and belief results are shown 
% in even subplots.


btom=load('data/btom_results_complete.mat');
people=load('data/human_data.mat');

btom.beta_ind = 5;

fig_s9_conditions = ...
    [ 5 10 15 ...
     55 63 71 59 67 75 ...
      1  6 11  8 13 40 ...
      2  7 12  4  9 14 ...
     18 21 24 ...
     56 64 72 60 68 76 ...
     16 19 22 17 20 23];
 
 fig_s10_conditions = ...
    [42 45 48 27 30 33 ...
     57 65 73 61 69 77 ...
     40 43 46 25 28 31 ...
     41 44 47 26 29 32 ...
     50 52 54 35 37 39 ...
     58 66 74 62 70 78 ...
     49 51 53 34 36 38];

fig_s9_subplots = ...
     [ 1  2  3 ...
       7  8  9 10 11 12 ...
      13 14 15 16 17 18 ...
      19 20 21 22 23 24 ...
      25 26 27 ...
      31 32 33 34 35 36 ...
      37 38 39 40 41 42];
  
fig_s10_subplots = 1:42;

bar_width = .6;

desire_people = people.des_inf_mean;
belief_people = people.bel_inf_mean_norm;
desire_people_se = people.des_inf_se;
belief_people_se = people.bel_inf_se;

desire_model = btom.desire_model(:,:,btom.beta_ind);
belief_model = btom.belief_model(:,:,btom.beta_ind);

% Fig S9
figure;
for ni=1:length(fig_s9_conditions)
  ci = fig_s9_conditions(ni);
  
  % Desires
  subplot(7,12,fig_s9_subplots(ni)*2-1);
  b=bar([desire_model(:,ci)'; desire_people(:,ci)']'-1,bar_width);
  hold on;
  errorbar(1.147:3.147,desire_people(:,ci)-1,desire_people_se(:,ci),desire_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
  axis([.25 3.75 0 6]);
  set(gca,'xtick',[1 2 3]);
  set(gca,'xticklabel',{'K','L','M'});
  set(gca,'ytick',0:6);
  set(gca,'yticklabel',{'1','2','3','4','5','6','7'});
  
  % Beliefs
  subplot(7,12,fig_s9_subplots(ni)*2);
  b=bar([belief_model(:,ci)'; belief_people(:,ci)']',bar_width);
  hold on;
  errorbar(1.147:3.147,belief_people(:,ci),belief_people_se(:,ci),belief_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
  axis([.25 3.75 0 1]);  
  set(gca,'xtick',[1 2 3]);
  set(gca,'xticklabel',{'L','M','N'});
  
end


% Fig S10
figure;
for ni=1:length(fig_s10_conditions)
  ci = fig_s10_conditions(ni);
  
  % Desires
  subplot(7,12,fig_s10_subplots(ni)*2-1);
  b=bar([desire_model(:,ci)'; desire_people(:,ci)']'-1,bar_width);
  hold on;
  errorbar(1.147:3.147,desire_people(:,ci)-1,desire_people_se(:,ci),desire_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
  axis([.25 3.75 0 6]);
  set(gca,'xtick',[1 2 3]);
  set(gca,'xticklabel',{'K','L','M'});
  set(gca,'ytick',0:6);
  set(gca,'yticklabel',{'1','2','3','4','5','6','7'});
  
  % Beliefs
  subplot(7,12,fig_s10_subplots(ni)*2);
  b=bar([belief_model(:,ci)'; belief_people(:,ci)']',bar_width);
  hold on;
  errorbar(1.147:3.147,belief_people(:,ci),belief_people_se(:,ci),belief_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
  axis([.25 3.75 0 1]);  
  set(gca,'xtick',[1 2 3]);
  set(gca,'xticklabel',{'L','M','N'});
  
end
