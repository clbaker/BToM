% run_nocost.m

addpath([pwd '/code']);

beta_score_values=0.5:0.5:10;
n_beta_score = length(beta_score_values);
for beta_score=beta_score_values
  nocost_solve_momdps;
  nocost_score_scenarios;
  nocost_results;
  save(sprintf('data/nocost/nocost_results%1.1f.mat',beta_score),...
        'belief_model','desire_model','belief_model_group','desire_model_group');
end

belief_model = zeros(3,78,n_beta_score);
desire_model = zeros(3,78,n_beta_score);
belief_model_group = zeros(3,7,n_beta_score);
desire_model_group = zeros(3,7,n_beta_score);
for bi=1:n_beta_score
  d=load(sprintf('data/nocost/nocost_results%1.1f.mat',beta_score_values(bi)));
  belief_model(:,:,bi) = d.belief_model;
  desire_model(:,:,bi) = d.desire_model;
  belief_model_group(:,:,bi) = d.belief_model_group;
  desire_model_group(:,:,bi) = d.desire_model_group;
end

save('data/nocost/nocost_results_complete.mat', ...
    'belief_model','desire_model','belief_model_group','desire_model_group','beta_score_values');
