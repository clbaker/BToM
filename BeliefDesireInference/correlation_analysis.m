% correlation_analysis.m


btom=load('data/btom_results_complete.mat');
truebelief=load('data/truebelief_results_complete.mat');
nocost=load('data/nocost_results_complete.mat');
motionheuristic=load('data/motionheuristic_results_complete.mat');

people=load('data/human_data.mat');

excl=[11 12 22 71 72];
%excl=[];
incl=setdiff(1:78,excl);
imap(incl) = 1:length(incl);

% beta=2.5
btom.beta_ind = 5;
truebelief.beta_ind = 18;
nocost.beta_ind = 5;


% Display individual and group correlations for each model

btom.r_belief = corr(m2v(btom.belief_model(:,incl,btom.beta_ind)),m2v(people.bel_inf_mean_norm(:,incl)));
btom.r_desire = corr(m2v(btom.desire_model(:,incl,btom.beta_ind)),m2v(people.des_inf_mean(:,incl)));
btom.r_belief_g = corr(m2v(btom.belief_model_group(:,:,btom.beta_ind)),m2v(people.bel_inf_group_mean(:)));
btom.r_desire_g = corr(m2v(btom.desire_model_group(:,:,btom.beta_ind)),m2v(people.des_inf_group_mean(:)));
fprintf('BToM:\n\tr_belief: %1.2f\n\tr_desire: %1.2f\n\tr_belief_group: %1.2f\n\tr_desire_group: %1.2f\n', ...
  btom.r_belief,btom.r_desire,btom.r_belief_g,btom.r_desire_g);

truebelief.r_belief = corr(m2v(truebelief.belief_model(:,incl,truebelief.beta_ind)),m2v(people.bel_inf_mean_norm(:,incl)));
truebelief.r_desire = corr(m2v(truebelief.desire_model(:,incl,truebelief.beta_ind)),m2v(people.des_inf_mean(:,incl)));
truebelief.r_belief_g = corr(m2v(truebelief.belief_model_group(:,:,truebelief.beta_ind)),m2v(people.bel_inf_group_mean(:)));
truebelief.r_desire_g = corr(m2v(truebelief.desire_model_group(:,:,truebelief.beta_ind)),m2v(people.des_inf_group_mean(:)));
fprintf('TrueBelief:\n\tr_belief: %1.3f\n\tr_desire: %1.2f\n\tr_belief_group: %1.3f\n\tr_desire_group: %1.2f\n', ...
  truebelief.r_belief,truebelief.r_desire,truebelief.r_belief_g,truebelief.r_desire_g);

nocost.r_belief = corr(m2v(nocost.belief_model(:,incl,nocost.beta_ind)),m2v(people.bel_inf_mean_norm(:,incl)));
nocost.r_desire = corr(m2v(nocost.desire_model(:,incl,nocost.beta_ind)),m2v(people.des_inf_mean(:,incl)));
nocost.r_belief_g = corr(m2v(nocost.belief_model_group(:,:,nocost.beta_ind)),m2v(people.bel_inf_group_mean(:)));
nocost.r_desire_g = corr(m2v(nocost.desire_model_group(:,:,nocost.beta_ind)),m2v(people.des_inf_group_mean(:)));
fprintf('NoCost:\n\tr_belief: %1.2f\n\tr_desire: %1.2f\n\tr_belief_group: %1.2f\n\tr_desire_group: %1.2f\n', ...
  nocost.r_belief,nocost.r_desire,nocost.r_belief_g,nocost.r_desire_g);

motionheuristic.r_belief = corr(m2v(motionheuristic.belief_model(:,incl)),m2v(people.bel_inf_mean_norm(:,incl)));
motionheuristic.r_desire = corr(m2v(motionheuristic.desire_model(:,incl)),m2v(people.des_inf_mean(:,incl)));
motionheuristic.r_belief_g = corr(m2v(motionheuristic.belief_model_group),m2v(people.bel_inf_group_mean(:)));
motionheuristic.r_desire_g = corr(m2v(motionheuristic.desire_model_group),m2v(people.des_inf_group_mean(:)));
fprintf('MotionHeuristic:\n\tr_belief: %1.2f\n\tr_desire: %1.2f\n\tr_belief_group: %1.2f\n\tr_desire_group: %1.2f\n', ...
  motionheuristic.r_belief,motionheuristic.r_desire,motionheuristic.r_belief_g,motionheuristic.r_desire_g);


%% Analysis of BToM partial correlations

desire_model = btom.desire_model(:,incl,btom.beta_ind);
belief_model = btom.belief_model(:,incl,btom.beta_ind);
desire_model_group = btom.desire_model_group(:,:,btom.beta_ind);
belief_model_group = btom.belief_model_group(:,:,btom.beta_ind);

desire_people = people.des_inf_mean(:,incl);
belief_people = people.bel_inf_mean_norm(:,incl);
desire_people_group = people.des_inf_group_mean;
belief_people_group = people.bel_inf_group_mean;

% Regressors based on grouped scenarios
desire_model_group_reg = zeros(3,length(incl));
belief_model_group_reg = zeros(3,length(incl));
desire_people_group_reg = zeros(3,length(incl));
belief_people_group_reg = zeros(3,length(incl));

group_inds = group_conds(false);
n_group_inds = length(group_inds);

for ni=1:n_group_inds
  desire_model_group_reg(:,imap(group_inds{ni})) = repmat(desire_model_group(:,ni),1,length(group_inds{ni}));
  belief_model_group_reg(:,imap(group_inds{ni})) = repmat(belief_model_group(:,ni),1,length(group_inds{ni}));
  desire_people_group_reg(:,imap(group_inds{ni})) = repmat(desire_people_group(:,ni),1,length(group_inds{ni}));
  belief_people_group_reg(:,imap(group_inds{ni})) = repmat(belief_people_group(:,ni),1,length(group_inds{ni}));
end


dmz = zscore(desire_model(:));
[db,dbint,dresid] = regress(dmz,[m2v(desire_model_group_reg) ones(numel(desire_model_group_reg),1)]);
bmz = zscore(belief_model(:));
[bb,bbint,bresid] = regress(bmz,[m2v(belief_model_group_reg) ones(numel(belief_model_group_reg),1)]);

fprintf('\n[T]he BToM model showed three times greater variance within scenario\ntypes for beliefs than for desires:\n');
[h,p,ci,stats]=vartest2(bresid,dresid,'tail','right');
fprintf('var(b)=%1.2f; var(d)=%1.2f; F=%1.2f; (95%% CI %1.2f, %1.2f)\n', ...
    var(bresid), var(dresid), stats.fstat, ci(1), ci(2));


fprintf('\nBToM predictions averaged within scenario types showed a high correlation\nwith human desire judgments:\n');
[rd,pd,rdlo,rdhi] = corrcoef(desire_people(:),desire_model_group_reg(:));
fprintf('r = %1.2f (95%% CI %1.2f, %1.2f)\n',rd(2),rdlo(2),rdhi(2));

fprintf('\nBToM predictions at the individual scenario level showed no partial\ncorrelation with human judgments after controlling for scenario type:\n');
rdg_check = partialcorr(m2v(desire_people),m2v(desire_model),m2v(desire_model_group_reg));
[dmgb,dmgbint,dmgresid] = regress(desire_model(:),[desire_model_group_reg(:) ones(219,1)]);
[dpgb,dpgbint,dpgresid] = regress(desire_people(:),[desire_model_group_reg(:) ones(219,1)]);
[rdg,pdg,rdglo,rdghi] = corrcoef(dmgresid,dpgresid);
fprintf('r = %1.2f (95%% CI %1.2f, %1.2f)\n',rdg(2),rdglo(2),rdghi(2));

% BToM predictions averaged within scenario types showed a high correlation
% with human desire judgments after controlling for individual-scenario
% predictions
rdi_check = partialcorr(m2v(desire_people),m2v(desire_model_group_reg),m2v(desire_model));
[dgib,dgibint,dgiresid] = regress(desire_model_group_reg(:),[desire_model(:) ones(219,1)]);
[dpib,dpibint,dpiresid] = regress(desire_people(:),[desire_model(:) ones(219,1)]);
[rdi,pdi,rdilo,rdihi] = corrcoef(dgiresid,dpiresid);


fprintf('\nBToM predictions averaged within scenario types, combined with individual\nscenario BToM predictions, explain 75 percent of the variance in human belief judgments:\n');
[bgb,bgbint,bgresid] = regress(belief_people(:),[belief_model(:) belief_model_group_reg(:) ones(219,1)]);
[rgb,pgb,rgblo,rgbhi] = corrcoef(belief_people(:),[belief_model(:) belief_model_group_reg(:) ones(219,1)]*bgb);
fprintf('r = %1.2f (95%% CI %1.2f, %1.2f)\n',rgb(2),rgblo(2),rgbhi(2));


fprintf('\n[Individual-scenario predictions] yielded significant partial correlations\nwith human belief judgments when controlling for [type-averaged predictions]:\n');
rbg_check = partialcorr(m2v(belief_people),m2v(belief_model),m2v(group_belief_model));
[bmgb,bmgbint,bmgresid] = regress(belief_model(:),[belief_model_group_reg(:) ones(219,1)]);
[bpgb,bpgbint,bpgresid] = regress(belief_people(:),[belief_model_group_reg(:) ones(219,1)]);
[rbg,pbg,rbglo,rbghi] = corrcoef(bmgresid,bpgresid);
fprintf('r = %1.2f (95%% CI %1.2f, %1.2f)\n',rbg(2),rbglo(2),rbghi(2));


fprintf('\n[Type-averaged predictions] yielded significant partial correlations\nwith human belief judgments when controlling for [individual-scenario predictions]:\n');
rbi_check = partialcorr(m2v(belief_people),m2v(group_belief_model),m2v(belief_model));
[bgib,bgibint,bgiresid] = regress(belief_model_group_reg(:),[belief_model(:) ones(219,1)]);
[bpib,bpibint,bpiresid] = regress(belief_people(:),[belief_model(:) ones(219,1)]);
[rbi,pbi,rbilo,rbihi] = corrcoef(bgiresid,bpiresid);
fprintf('r = %1.2f (95%% CI %1.2f, %1.2f)\n',rbi(2),rbilo(2),rbihi(2));
