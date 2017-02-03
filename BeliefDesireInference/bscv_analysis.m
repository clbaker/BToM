% bscv_analysis.m
%


load('data/human_data.mat');
model{1} = load('data/btom_results_complete.mat');
model{2} = load('data/nocost_results_complete.mat');
model{3} = load('data/truebelief_results_complete.mat');

model_name = {'btom','nocost','truebelief'};

bscv = load('data/bscv_folds.mat');
n_folds = size(bscv.train_folds,1);
train_sz = 3*size(bscv.train_folds,2);
train_sz_g = 3*size(bscv.train_folds_g,2);

excl=[11 12 22 71 72];
incl=setdiff(1:78,excl);

for mi=1:length(model)
  n_param = length(model{mi}.beta_score_values);
  
  b_train = zeros(n_folds,n_param);
  d_train = zeros(n_folds,n_param);
  b_train_g = zeros(n_folds,n_param);
  d_train_g = zeros(n_folds,n_param);
  bd_fit = zeros(n_folds,1);
  belief_bscv = zeros(n_folds,1);
  desire_bscv = zeros(n_folds,1);
  belief_group_bscv = zeros(n_folds,1);
  desire_group_bscv = zeros(n_folds,1);
  for ni=1:n_folds
    train_fold = incl(bscv.train_folds(ni,:));
    test_fold = incl(bscv.test_folds(ni,:));
    train_fold_g = incl(bscv.train_folds_g(ni,:));
    test_fold_g = incl(bscv.test_folds_g(ni,:));
  
    b_train(ni,:) = fcorr(reshape(model{mi}.belief_model(:,train_fold,:),train_sz,n_param), ...
        m2v(bel_inf_mean_norm(:,train_fold)));
    d_train(ni,:) = fcorr(reshape(model{mi}.desire_model(:,train_fold,:),train_sz,n_param), ...
        m2v(des_inf_mean(:,train_fold)));
    b_train_g(ni,:) = fcorr(reshape(model{mi}.belief_model_group(:,train_fold_g,:),train_sz_g,n_param), ...
        m2v(bel_inf_group_mean(:,train_fold_g)));
    d_train_g(ni,:) = fcorr(reshape(model{mi}.desire_model_group(:,train_fold_g,:),train_sz_g,n_param), ...
        m2v(des_inf_group_mean(:,train_fold_g)));
    
    [val,bd_fit(ni)] = max(b_train(ni,:)+d_train(ni,:));
    
    belief_bscv(ni) = fcorr(m2v(model{mi}.belief_model(:,test_fold,bd_fit(ni))), ...
          m2v(bel_inf_mean_norm(:,test_fold)));
    desire_bscv(ni) = fcorr(m2v(model{mi}.desire_model(:,test_fold,bd_fit(ni))), ...
          m2v(des_inf_mean(:,test_fold)));
    belief_group_bscv(ni) = fcorr(m2v(model{mi}.belief_model_group(:,test_fold_g,bd_fit(ni))), ...
          m2v(bel_inf_group_mean(:,test_fold_g)));
    desire_group_bscv(ni) = fcorr(m2v(model{mi}.desire_model_group(:,test_fold_g,bd_fit(ni))), ...
          m2v(des_inf_group_mean(:,test_fold_g)));
  end
  
  save(sprintf('data/%s_bscv.mat',model_name{mi}),'belief_bscv','desire_bscv','belief_group_bscv','desire_group_bscv');
end


%% analyze BSCV results

btom = load('data/btom_bscv.mat');
nocost = load('data/nocost_bscv.mat');
truebelief = load('data/truebelief_bscv.mat');
motionheuristic = load('data/motionheuristic_bscv.mat');

n_folds = length(btom.belief_bscv);
pctiles = round([0.025 0.5 0.975]*n_folds);

btom.belief_bscv_sort = sort(btom.belief_bscv);
btom.desire_bscv_sort = sort(btom.desire_bscv);
btom.belief_group_bscv_sort = sort(btom.belief_group_bscv);
btom.desire_group_bscv_sort = sort(btom.desire_group_bscv);

fprintf('r BTOM BELIEF 50 (2.5, 97.5) %%iles: %1.2f (%1.2f, %1.2f)\n', ...
  btom.belief_bscv_sort(pctiles(2)),btom.belief_bscv_sort(pctiles(1)),btom.belief_bscv_sort(pctiles(3)));
fprintf('r BTOM DESIRE 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  btom.desire_bscv_sort(pctiles(2)),btom.desire_bscv_sort(pctiles(1)),btom.desire_bscv_sort(pctiles(3)));
fprintf('r BTOM BELIEF GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  btom.belief_group_bscv_sort(pctiles(2)),btom.belief_group_bscv_sort(pctiles(1)),btom.belief_group_bscv_sort(pctiles(3)));
fprintf('r BTOM DESIRE GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  btom.desire_group_bscv_sort(pctiles(2)),btom.desire_group_bscv_sort(pctiles(1)),btom.desire_group_bscv_sort(pctiles(3)));


truebelief.belief_bscv_sort = sort(truebelief.belief_bscv);
truebelief.desire_bscv_sort = sort(truebelief.desire_bscv);
truebelief.belief_group_bscv_sort = sort(truebelief.belief_group_bscv);
truebelief.desire_group_bscv_sort = sort(truebelief.desire_group_bscv);

fprintf('r TRUEBELIEF BELIEF 50 (2.5, 97.5) %%iles: %1.3f (%1.2f, %1.2f)\n', ...
  truebelief.belief_bscv_sort(pctiles(2)),truebelief.belief_bscv_sort(pctiles(1)),truebelief.belief_bscv_sort(pctiles(3)));
fprintf('r TRUEBELIEF DESIRE 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  truebelief.desire_bscv_sort(pctiles(2)),truebelief.desire_bscv_sort(pctiles(1)),truebelief.desire_bscv_sort(pctiles(3)));
fprintf('r TRUEBELIEF BELIEF GROUP 50 (2.5, 97.5) %%iles %1.3f (%1.2f, %1.2f)\n', ...
  truebelief.belief_group_bscv_sort(pctiles(2)),truebelief.belief_group_bscv_sort(pctiles(1)),truebelief.belief_group_bscv_sort(pctiles(3)));
fprintf('r TRUEBELIEF DESIRE GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  truebelief.desire_group_bscv_sort(pctiles(2)),truebelief.desire_group_bscv_sort(pctiles(1)),truebelief.desire_group_bscv_sort(pctiles(3)));


nocost.belief_bscv_sort = sort(nocost.belief_bscv);
nocost.desire_bscv_sort = sort(nocost.desire_bscv);
nocost.belief_group_bscv_sort = sort(nocost.belief_group_bscv);
nocost.desire_group_bscv_sort = sort(nocost.desire_group_bscv);

fprintf('r NOCOST BELIEF 50 (2.5, 97.5) %%iles: %1.2f (%1.3f, %1.2f)\n', ...
  nocost.belief_bscv_sort(pctiles(2)),nocost.belief_bscv_sort(pctiles(1)),nocost.belief_bscv_sort(pctiles(3)));
fprintf('r NOCOST DESIRE 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  nocost.desire_bscv_sort(pctiles(2)),nocost.desire_bscv_sort(pctiles(1)),nocost.desire_bscv_sort(pctiles(3)));
fprintf('r NOCOST BELIEF GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.3f, %1.2f)\n', ...
  nocost.belief_group_bscv_sort(pctiles(2)),nocost.belief_group_bscv_sort(pctiles(1)),nocost.belief_group_bscv_sort(pctiles(3)));
fprintf('r NOCOST DESIRE GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  nocost.desire_group_bscv_sort(pctiles(2)),nocost.desire_group_bscv_sort(pctiles(1)),nocost.desire_group_bscv_sort(pctiles(3)));


motionheuristic.belief_bscv_sort = sort(motionheuristic.belief_bscv);
motionheuristic.desire_bscv_sort = sort(motionheuristic.desire_bscv);
motionheuristic.belief_group_bscv_sort = sort(motionheuristic.belief_group_bscv);
motionheuristic.desire_group_bscv_sort = sort(motionheuristic.desire_group_bscv);

fprintf('r MOTIONHEURISTIC BELIEF 50 (2.5, 97.5) %%iles: %1.2f (%1.2f, %1.2f)\n', ...
  motionheuristic.belief_bscv_sort(pctiles(2)),motionheuristic.belief_bscv_sort(pctiles(1)),motionheuristic.belief_bscv_sort(pctiles(3)));
fprintf('r MOTIONHEURISTIC DESIRE 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  motionheuristic.desire_bscv_sort(pctiles(2)),motionheuristic.desire_bscv_sort(pctiles(1)),motionheuristic.desire_bscv_sort(pctiles(3)));
fprintf('r MOTIONHEURISTIC BELIEF GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.2f, %1.2f)\n', ...
  motionheuristic.belief_group_bscv_sort(pctiles(2)),motionheuristic.belief_group_bscv_sort(pctiles(1)),motionheuristic.belief_group_bscv_sort(pctiles(3)));
fprintf('r MOTIONHEURISTIC DESIRE GROUP 50 (2.5, 97.5) %%iles %1.2f (%1.3f, %1.2f)\n', ...
  motionheuristic.desire_group_bscv_sort(pctiles(2)),motionheuristic.desire_group_bscv_sort(pctiles(1)),motionheuristic.desire_group_bscv_sort(pctiles(3)));


fprintf('P(R_BTOM <= R_TRUEBELIEF) [Belief,Desire,BeliefGroup,DesireGroup]\n');
[mean(btom.belief_bscv <= truebelief.belief_bscv); ...
 mean(btom.desire_bscv <= truebelief.desire_bscv); ...
 mean(btom.belief_group_bscv <= truebelief.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= truebelief.desire_group_bscv)]'


fprintf('P(R_BTOM <= R_NOCOST) [Belief,Desire,BeliefGroup,DesireGroup]\n');
[mean(btom.belief_bscv <= nocost.belief_bscv); ...
 mean(btom.desire_bscv <= nocost.desire_bscv); ...
 mean(btom.belief_group_bscv <= nocost.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= nocost.desire_group_bscv)]'


fprintf('P(R_BTOM <= R_MOTIONHEURISTIC) [Belief,Desire,BeliefGroup,DesireGroup]\n');
[mean(btom.belief_bscv <= motionheuristic.belief_bscv); ...
 mean(btom.desire_bscv <= motionheuristic.desire_bscv); ...
 mean(btom.belief_group_bscv <= motionheuristic.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= motionheuristic.desire_group_bscv)]'

