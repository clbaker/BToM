function [results] = score_momdp_path_cluster(params)
% [results] = score_momdp_path_cluster(params)
%


warning off;


%% unpack params

paths = params.paths;
s_dim = params.s_dim;
w_trans = params.w_trans;
c_trans = params.c_trans;
obs_dist = params.obs_dist;
action_cost = params.action_cost;

if isfield(params,'save_matfile')
  save_matfile = params.save_matfile;
else
  save_matfile = true;
end

%n_world = size(w_trans,1);
%n_belief_grid = params.n_belief_grid;
%b_sub_space = params.b_sub_space;
%b_sub = create_belief_space1(n_world,n_belief_grid);
%b_sub0 = (b_sub*(1-b_sub_space) + (b_sub_space/n_world));
%b_sub0_prior = zeros(1,size(b_sub0,2));

b_sub0 = params.b_sub0;
b_sub0_prior = params.b_sub0_prior;

b_precision = params.b_precision;

b_sub_to_g_sub = params.b_sub_to_g_sub;
g_ind_to_b_ind = params.g_ind_to_b_ind;

beta_score = params.beta_score;
n_beta_score = length(beta_score);

cond_sub = params.cond_sub;
n_cond = size(cond_sub,2);


value = load(sprintf('%s/value-obs%d-cost%d/value%03d.mat',params.basedir,obs_dist.ind,action_cost.ind,params.goal_reward_ind),'Q','V');

save_dir = [params.basedir sprintf('/expt2_score_momdp_path1_%s',params.score_t_str)];
if save_matfile && exist(save_dir) ~= 7
  mkdir(save_dir);
end

%results = cell(1,n_cond);

for bi=1:n_beta_score

  if save_matfile
    score_dir = [save_dir sprintf('/obs%d-cost%d-beta%d',obs_dist.ind,action_cost.ind,bi)];
    mkdir(score_dir);
  end

  for ni=1:n_cond
    world_ind = cond_sub(1,ni);
    path_ind = cond_sub(2,ni);

    % score conditions
    [b_sub_unique,b_ind,fwd,bwd,filter,smooth,trans_unique,o_ind,a_ind] ...
      = score_momdp_path1(paths{path_ind},world_ind,b_sub0,b_sub0_prior,value.Q,value.V,beta_score(bi), ...
          s_dim,w_trans,c_trans,obs_dist.dist,b_sub_to_g_sub,g_ind_to_b_ind,b_precision);

    if save_matfile
      save(sprintf('%s/cond%03d-reward%03d.mat',score_dir,ni,params.goal_reward_ind), ...
        'b_sub_unique','trans_unique','fwd','smooth','b_sub0_prior','b_ind','o_ind','a_ind');
    end

    %results{ni}.bwd = bwd;
    %results{ni}.filter = filter;
    %results{ni}.trans = trans;
    %results{ni}.o_ind = o_ind;
    %results{ni}.a_ind = a_ind;

  end
end

results.b_sub0 = b_sub0;

