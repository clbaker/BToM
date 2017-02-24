% run_btom_train.m

addpath([pwd '/model']);
addpath([pwd '/3rd Party']);

btom_parameters;

%Load the observer model of the world
pomdp.T = pomdpx_state_trans(p_action_fail);
pomdp.O = pomdpx_obs_func(obs_noise);
pomdp.cost = repmat(cost,1,6);
pomdp.disc = discount;

n_world = size(pomdp.T,3);

% different agent belief points (only open carts for training)
bp = false_belief_set_train();
n_bp = size(bp,1);

% observer's prior over agent's prior p(bp|w)
bpb=repmat(1/n_bp,n_bp,n_world); % uniform

if ~exist(resultsdir,'dir')
  mkdir(resultsdir);
end
 
disp('Loading policies...');
pols = cell(1,n_bp);
for bi=1:n_bp
  pols{bi}=parse_policyx(sprintf('%s/%02d-train.policyx',policydir,bi));
end

% observer's prior over worlds (only open carts for training)
prior=zeros(1,n_world);
prior(1:4:24)=1/6;

%% main loop
for beta_score=beta_score_values
    for path=1:3
        o=observer(prior,bp,bpb,pomdp,pols,beta_score,10);
        o=o.start_observing(19,6);
        switch path
            case 1
                disp('Running path 1...');
                o.action_array=[6 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                o=o.observe_action(4);
            case 2
                disp('Running path 2...');
                o.action_array=[6 2 2 -1 -1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 5 6 -1 -1 -1 -1 -1 -1 -1];
                o=o.observe_action(4);
            case 3
                disp('Running path 3...');
            %case 7
            %	disp('Running path 7...');
                o.action_array=[6 2 2 1 1 1 1 1 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 3 2 1 -1 -1];
                o=o.observe_action(4);
        end % switch path
        save(sprintf('%s/o%d-train-beta%1.2f.mat',resultsdir,path,beta_score),'o');
    end % for path=1:3
end % for beta_score=beta_score_values
