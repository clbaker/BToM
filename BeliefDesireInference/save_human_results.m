% save_human_results.m

%% load raw data

raw_data = {};
raw_data{end+1} = load('data/rawdata/data_2010-05-26-10-53.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-12-00.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-12-11.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-12-43.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-13-39.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-13-50.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-14-37.mat');
raw_data{end+1} = load('data/rawdata/data_2010-05-26-15-06.mat');
% belief-first data
raw_data{end+1} = load('data/rawdata/data_2010-06-01-12-02.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-01-14-08.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-01-14-33.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-01-15-19.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-01-15-24.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-02-13-51.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-02-15-12.mat');
raw_data{end+1} = load('data/rawdata/data_2010-06-02-15-25.mat');


%% extract subject ratings

n_rating = 3;
n_cond = 78;
n_subj = length(raw_data);

bel_data = cell(n_subj,1);
des_data = cell(n_subj,1);

des_inf = zeros(3,78,2);
bel_inf = zeros(3,78,2);

for ni=1:n_subj
  raw_data{ni}.des_inf = raw_data{ni}.pref_inf;
  raw_data{ni}.des_click = raw_data{ni}.pref_click;
  raw_data{ni} = rmfield(raw_data{ni},{'pref_inf','pref_click'});
  
  % take the size of the data from first cond presented
  des_data{ni} = zeros([size(raw_data{ni}.des_inf{raw_data{ni}.cond_order(1)}) n_cond]);
  bel_data{ni} = zeros([size(raw_data{ni}.bel_inf{raw_data{ni}.cond_order(1)}) n_cond]);
  
  for nc=1:n_cond
    if ~isempty(raw_data{ni}.des_inf{nc})
      des_data{ni}(:,:,nc) = raw_data{ni}.des_inf{nc};
    end
    
    if ~isempty(raw_data{ni}.bel_inf{nc})
      bel_data{ni}(:,:,nc) = raw_data{ni}.bel_inf{nc};
    end
    
  end
  
  reward_val = 1:7;
  des_inf(:,:,ni) = squeeze(sum(des_data{ni}.*repmat(reward_val,[size(des_data{ni},1) 1 size(des_data{ni},3)]),2));
  bel_inf(:,:,ni) = squeeze(sum(bel_data{ni}.*repmat(1:size(bel_data{ni},2),[size(bel_data{ni},1) 1 size(bel_data{ni},3)]),2));
  
  if ni<=8
      raw_data{ni}.desire_first = true;
  else
      raw_data{ni}.desire_first = false;
  end
  
end


%% compute mean inferences and standard errors

completed = ~all(bel_inf==0,1);
n_completed = sum(squeeze(completed),2)';

% average desire inferences between subjects
des_inf_mean = bsxfun(@rdivide,sum(des_inf,3),n_completed);

% average belief inferences between subjects
bel_inf_sum = sum(bel_inf,3);
bel_inf_mean = bsxfun(@rdivide,bel_inf_sum,n_completed)-1;

% normalize belief inferences
bel_inf_mean_sum = sum(bel_inf_mean,1);
bel_inf_mean_norm = bsxfun(@rdivide,bel_inf_mean,bel_inf_mean_sum);

% standard errors
des_inf_se = zeros(size(des_inf_mean));
bel_inf_se = zeros(size(bel_inf_mean));
for nc=1:n_cond
  for nr=1:n_rating 
    des_inf_se(nr,nc) = std(des_inf(nr,nc,completed(:,nc,:))) ./ sqrt(n_completed(nc));
    bel_inf_se(nr,nc) = std(bel_inf(nr,nc,completed(:,nc,:))./bel_inf_mean_sum(nc)) ./ sqrt(n_completed(nc));
  end
end


%% compute grouped averages

group_inds = group_conds(false);
n_group = length(group_inds);
des_inf_group_mean = zeros(n_rating,n_group);
bel_inf_group_mean = zeros(n_rating,n_group);
des_inf_group_se = zeros(n_rating,n_group);
bel_inf_group_se = zeros(n_rating,n_group);
for gi=1:n_group
    des_inf_group_mean(:,gi) = mean(des_inf_mean(:,group_inds{gi}),2);
    bel_inf_group_mean(:,gi) = mean(bel_inf_mean_norm(:,group_inds{gi}),2);
    des_inf_group_se(:,gi) = std(des_inf_mean(:,group_inds{gi})') / length(group_inds{gi});
    bel_inf_group_se(:,gi) = std(bel_inf_mean_norm(:,group_inds{gi})') / length(group_inds{gi});
end


%% save results
save('data/human_data.mat','raw_data', ...
    'bel_inf_mean_norm','des_inf_mean', ...
    'bel_inf_group_mean','des_inf_group_mean', ...
    'bel_inf_se','des_inf_se', ...
    'bel_inf_group_se','des_inf_group_se', ...
    'bel_inf','des_inf', ...
    'bel_data','des_data');