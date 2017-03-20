% bscv_analysis.m


folds = load('Data/bscv_folds.mat');
raw_human_data = csvread('Data/carts-mean.csv',1,0);

completes = [1,3,11,5,7,15,6,14,16]+3;
incompletes = [4,10,2,12,8,13,9]+3;
RealOrder = [1,2,3,completes,incompletes];
human_data = raw_human_data(RealOrder,:);
human_data = bsxfun(@rdivide,human_data,sum(human_data,2));

% BToM
model = {};
model{1} = load('Data/BToM/discount0.999900-cost1.0/results/results.mat');
% TrueBelief
model{2} = load('Data/TrueBelief/discount0.999900-cost1.0/results/results.mat');
% NoCost
model{3} = load('Data/NoCost/discount0.999900-cost0.0/results/results.mat');

% overall correlation
n_model = length(model);
model_corr = cell(1,n_model);

for m=1:n_model
  model_data = permute(model{m}.results,[2 1 3]);
  n_param = size(model_data,3);
  for np=1:n_param
    model_corr{m}(np) = corr(m2v(model_data(:,:,np)),m2v(human_data));
  end
end

% CV correlation
train_folds=folds.train_folds;
test_folds=folds.test_folds;

n_folds = size(train_folds,1);
train_fold_sz = size(train_folds,2);
test_fold_sz = size(test_folds,2);

cv = cell(1,n_model);

for m=1:n_model
  model_data = permute(model{m}.results,[2 1 3]);
  n_param = size(model_data,3);
  
  cv{m}.model_data = zeros(6,test_fold_sz,n_folds);
  cv{m}.human_data = zeros(6,test_fold_sz,n_folds);
  cv{m}.model_corr_train = zeros(n_folds,n_param);
  cv{m}.model_corr_test = zeros(n_folds,1);
  cv{m}.model_max_corr = zeros(n_folds,1);
  cv{m}.model_max_ind = zeros(n_folds,1);
  
  for ni=1:n_folds
    % fit to this fold
    for np=1:n_param
      cv{m}.model_corr_train(ni,np)=corr(m2v(model_data(train_folds(ni,:),:,np)),m2v(human_data(train_folds(ni,:),:)));
    end
    [cv{m}.model_max_corr(ni),cv{m}.model_max_ind(ni)]=max(cv{m}.model_corr_train(ni,:));
    cv{m}.model_data(:,:,ni) = model_data(test_folds(ni,:),:,cv{m}.model_max_ind(ni));
    cv{m}.human_data(:,:,ni) = human_data(test_folds(ni,:),:);
    cv{m}.model_corr_test(ni) = corr(m2v(cv{m}.model_data(:,:,ni)),m2v(cv{m}.human_data(:,:,ni)));
  end
end

r_bscv = cv{1}.model_corr_test;
save('Data/BToM/discount0.999900-cost1.0/results/results_bscv.mat','r_bscv');
r_bscv = cv{2}.model_corr_test;
save('Data/TrueBelief/discount0.999900-cost1.0/results/results_bscv.mat','r_bscv');
r_bscv = cv{3}.model_corr_test;
save('Data/NoCost/discount0.999900-cost0.0/results/results_bscv.mat','r_bscv');

