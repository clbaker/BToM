% bar_plots1.m
% Plot individual-trial mean human judgments for example scenarios from 
% each of 7 trial-types against btom (fig 1), truebelief (fig 2), nocost 
% (fig 3) and motionheuristic (fig 4). Desire results are shown in odd 
% subplots, and belief results are shown in even subplots.

btom=load('data/btom_results_complete.mat');
truebelief=load('data/truebelief_results_complete.mat');
nocost=load('data/nocost_results_complete.mat');
motionheuristic=load('data/motionheuristic_results_complete.mat');

people=load('data/human_data.mat');

btom.beta_ind = 5;
truebelief.beta_ind = 18;
nocost.beta_ind = 5;

conditions = [48 73 46 47 54 74 53];
     
bar_width = .8;

desire_people = people.des_inf_mean;
belief_people = people.bel_inf_mean_norm;
desire_people_se = people.des_inf_se;
belief_people_se = people.bel_inf_se;

desire_model={};
belief_model={};
desire_model{1} = btom.desire_model(:,:,btom.beta_ind);
belief_model{1} = btom.belief_model(:,:,btom.beta_ind);
desire_model{2} = truebelief.desire_model(:,:,truebelief.beta_ind);
belief_model{2} = truebelief.belief_model(:,:,truebelief.beta_ind);
desire_model{3} = nocost.desire_model(:,:,nocost.beta_ind);
belief_model{3} = nocost.belief_model(:,:,nocost.beta_ind);
desire_model{4} = motionheuristic.desire_model;
belief_model{4} = motionheuristic.belief_model;

for m=1:4
    figure;
    for ni=1:length(conditions)
      ci = conditions(ni);

      % Desires
      subplot(2,8,ni*2-1);
      b=bar([desire_model{m}(:,ci)'; desire_people(:,ci)']'-1,bar_width);
      hold on;
      errorbar(1.147:3.147,desire_people(:,ci)-1,desire_people_se(:,ci),desire_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
      axis([.25 3.75 0 6]);
      set(gca,'xtick',[1 2 3]);
      set(gca,'xticklabel',{'K','L','M'});
      set(gca,'ytick',0:6);
      set(gca,'yticklabel',{'1','2','3','4','5','6','7'});

      % Beliefs
      subplot(2,8,ni*2);
      b=bar([belief_model{m}(:,ci)'; belief_people(:,ci)']',bar_width);
      hold on;
      errorbar(1.147:3.147,belief_people(:,ci),belief_people_se(:,ci),belief_people_se(:,ci),'linestyle','none','color',[0 0 0],'linewidth',1);
      axis([.25 3.75 0 1]);  
      set(gca,'xtick',[1 2 3]);
      set(gca,'xticklabel',{'L','M','N'});

    end
end

