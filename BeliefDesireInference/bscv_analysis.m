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
  
    b_train(ni,:) = fc(reshape(model{mi}.belief_model(:,train_fold,:),train_sz,n_param), ...
        m2v(bel_inf_mean_norm(:,train_fold)));
    d_train(ni,:) = fc(reshape(model{mi}.desire_model(:,train_fold,:),train_sz,n_param), ...
        m2v(des_inf_mean(:,train_fold)));
    b_train_g(ni,:) = fc(reshape(model{mi}.belief_model_group(:,train_fold_g,:),train_sz_g,n_param), ...
        m2v(bel_inf_group_mean(:,train_fold_g)));
    d_train_g(ni,:) = fc(reshape(model{mi}.desire_model_group(:,train_fold_g,:),train_sz_g,n_param), ...
        m2v(des_inf_group_mean(:,train_fold_g)));
    
    [val,bd_fit(ni)] = max(b_train(ni,:)+d_train(ni,:));
    
    belief_bscv(ni) = fc(m2v(model{mi}.belief_model(:,test_fold,bd_fit(ni))), ...
          m2v(bel_inf_mean_norm(:,test_fold)));
    desire_bscv(ni) = fc(m2v(model{mi}.desire_model(:,test_fold,bd_fit(ni))), ...
          m2v(des_inf_mean(:,test_fold)));
    belief_group_bscv(ni) = fc(m2v(model{mi}.belief_model_group(:,test_fold_g,bd_fit(ni))), ...
          m2v(bel_inf_group_mean(:,test_fold_g)));
    desire_group_bscv(ni) = fc(m2v(model{mi}.desire_model_group(:,test_fold_g,bd_fit(ni))), ...
          m2v(des_inf_group_mean(:,test_fold_g)));
  end
  
  save(sprintf('data/%s_bscv.mat',model_name{mi}),'belief_bscv','desire_bscv','belief_group_bscv','desire_group_bscv');
end


%% analyze BSCV results

btom = load('data/btom_bscv.mat');
nocost = load('data/nocost_bscv.mat');
truebelief = load('data/truebelief_bscv.mat');
motionheuristic = load('data/motionheuristic_bscv.mat');

pctiles = round([0.025 0.5 0.975]*n_folds);

btom.belief_bscv_sort = sort(btom.belief_bscv);
btom.desire_bscv_sort = sort(btom.desire_bscv);
btom.belief_group_bscv_sort = sort(btom.belief_group_bscv);
btom.desire_group_bscv_sort = sort(btom.desire_group_bscv);

fprintf('BTOM BELIEF 2.5, 50, 97.5 %%iles-----------------------------\n');
btom.belief_bscv_sort(pctiles)'
fprintf('BTOM DESIRE 2.5, 50, 97.5 %%iles-----------------------------\n');
btom.desire_bscv_sort(pctiles)'
fprintf('BTOM BELIEF GROUP 2.5, 50, 97.5 %%iles-----------------------\n');
btom.belief_group_bscv_sort(pctiles)'
fprintf('BTOM DESIRE GROUP 2.5, 50, 97.5 %%iles-----------------------\n');
btom.desire_group_bscv_sort(pctiles)'


truebelief.belief_bscv_sort = sort(truebelief.belief_bscv);
truebelief.desire_bscv_sort = sort(truebelief.desire_bscv);
truebelief.belief_group_bscv_sort = sort(truebelief.belief_group_bscv);
truebelief.desire_group_bscv_sort = sort(truebelief.desire_group_bscv);

fprintf('TRUEBELIEF BELIEF 2.5, 50, 97.5 %%iles-----------------------\n');
truebelief.belief_bscv_sort(pctiles)'
fprintf('TRUEBELIEF DESIRE 2.5, 50, 97.5 %%iles-----------------------\n');
truebelief.desire_bscv_sort(pctiles)'
fprintf('TRUEBELIEF BELIEF GROUP 2.5, 50, 97.5 %%iles-----------------\n');
truebelief.belief_group_bscv_sort(pctiles)'
fprintf('TRUEBELIEF DESIRE GROUP 2.5, 50, 97.5 %%iles-----------------\n');
truebelief.desire_group_bscv_sort(pctiles)'


nocost.belief_bscv_sort = sort(nocost.belief_bscv);
nocost.desire_bscv_sort = sort(nocost.desire_bscv);
nocost.belief_group_bscv_sort = sort(nocost.belief_group_bscv);
nocost.desire_group_bscv_sort = sort(nocost.desire_group_bscv);

fprintf('NOCOST BELIEF 2.5, 50, 97.5 %%iles---------------------------\n');
nocost.belief_bscv_sort(pctiles)'
fprintf('NOCOST DESIRE 2.5, 50, 97.5 %%iles---------------------------\n');
nocost.desire_bscv_sort(pctiles)'
fprintf('NOCOST BELIEF GROUP 2.5, 50, 97.5 %%iles---------------------\n');
nocost.belief_group_bscv_sort(pctiles)'
fprintf('NOCOST DESIRE GROUP 2.5, 50, 97.5 %%iles---------------------\n');
nocost.desire_group_bscv_sort(pctiles)'


motionheuristic.belief_bscv_sort = sort(motionheuristic.belief_bscv);
motionheuristic.desire_bscv_sort = sort(motionheuristic.desire_bscv);
motionheuristic.belief_group_bscv_sort = sort(motionheuristic.belief_group_bscv);
motionheuristic.desire_group_bscv_sort = sort(motionheuristic.desire_group_bscv);

fprintf('MOTIONHEURISTIC BELIEF 2.5, 50, 97.5 %%iles------------------\n');
motionheuristic.belief_bscv_sort(pctiles)'
fprintf('MOTIONHEURISTIC DESIRE 2.5, 50, 97.5 %%iles------------------\n');
motionheuristic.desire_bscv_sort(pctiles)'
fprintf('MOTIONHEURISTIC BELIEF GROUP 2.5, 50, 97.5 %%iles------------\n');
motionheuristic.belief_group_bscv_sort(pctiles)'
fprintf('MOTIONHEURISTIC DESIRE GROUP 2.5, 50, 97.5 %%iles------------\n');
motionheuristic.desire_group_bscv_sort(pctiles)'


fprintf('P(R_BTOM < R_TRUEBELIEF)-------------------------------------\n');
[mean(btom.belief_bscv <= truebelief.belief_bscv); ...
 mean(btom.desire_bscv <= truebelief.desire_bscv); ...
 mean(btom.belief_group_bscv <= truebelief.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= truebelief.desire_group_bscv)]'


fprintf('P(R_BTOM < R_NOCOST)-----------------------------------------\n');
[mean(btom.belief_bscv <= nocost.belief_bscv); ...
 mean(btom.desire_bscv <= nocost.desire_bscv); ...
 mean(btom.belief_group_bscv <= nocost.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= nocost.desire_group_bscv)]'


fprintf('P(R_BTOM < R_MOTIONHEURISTIC)--------------------------------\n');
[mean(btom.belief_bscv <= motionheuristic.belief_bscv); ...
 mean(btom.desire_bscv <= motionheuristic.desire_bscv); ...
 mean(btom.belief_group_bscv <= motionheuristic.belief_group_bscv); ...
 mean(btom.desire_group_bscv <= motionheuristic.desire_group_bscv)]'

