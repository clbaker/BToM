% run_truebelief.m

addpath([pwd '/model']);
addpath([pwd '/3rd Party']);

truebelief_parameters;

%Load the observer model of the world
pomdp.T = pomdpx_state_trans(p_action_fail);
pomdp.O = pomdpx_obs_func(obs_noise);
pomdp.cost = repmat(cost,1,6);
pomdp.disc = discount;

n_world = size(pomdp.T,3);

% different agent belief points
bp = true_belief_set();
n_bp = size(bp,1);

% observer's prior over agent's prior p(bp|w)
bpb=zeros(n_bp,n_world); % non-uniform
bpb(1,1:4)=1;
bpb(2,5:8)=1;
bpb(3,9:12)=1;
bpb(4,13:16)=1;
bpb(5,17:20)=1;
bpb(6,21:24)=1;

if ~exist(resultsdir,'dir')
  mkdir(resultsdir);
end

disp('Loading policies...');
pols = cell(1,n_bp);
for bi=1:n_bp
  pols{bi}=parse_policyx(sprintf('%s/%02d.policyx',policydir,bi));
end

prior=repmat(1/n_world,1,n_world); % observer's prior over worlds

%% main loop
for beta_score=beta_score_values
    for path=1:16
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
                o.action_array=[6 1 1 1 -1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 -1 -1 -1 -1 -1 -1];
                o=o.observe_action(4);
            case 4
                disp('Running path 4...');
                o.action_array=[6 2 2 1 1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 -1 -1 -1 -1 -1];
                o=o.observe_action(4);
            case 5
                disp('Running path 5...');
                o.action_array=[6 2 2 1 1 1 1 1 2 2 2 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 3 2 1 2 3 4 -1 -1];
                o=o.observe_action(4);
            case 6
                disp('Running path 6...');
                o.action_array=[6 1 1 1 2 2 2 -1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 2 3 4 -1 -1 -1];
                o=o.observe_action(4);
            case 7
                disp('Running path 7...');
                o.action_array=[6 2 2 1 1 1 1 1 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 3 2 1 -1 -1];
                o=o.observe_action(4);
            case 8
                disp('Running path 8...');
                o.action_array=[6 1 1 1 2 2 2 2 2 -1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 2 3 4 5 6 -1 -1 -1];
                o=o.observe_action(4);
            case 9
                disp('Running path 9...');
                o.action_array=[6 1 1 1 2 2 2 2 2 1 1 1 1 1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 2 3 4 5 6 5 4 3 2 1 -1 -1];
                o=o.observe_action(4);
            case 10
                disp('Running path 10...');
                o.action_array=[6 -1 -1 -1];
                o.location_array=[19 4 -1 -1];
                o=o.observe_action(2);
            case 11
                disp('Running path 11...');
                o.action_array=[6 -1 -1 -1];
                o.location_array=[19 4 -1 -1];
                o=o.observe_action(1);
            case 12
                disp('Running path 12...');
                o.action_array=[6 2 2 -1 -1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 5 6 -1 -1 -1 -1 -1 -1 -1];
                o=o.observe_action(1);
            case 13
                disp('Running path 13...');
                o.action_array=[6 1 1 1 -1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 -1 -1 -1 -1 -1 -1];
                o=o.observe_action(2);
            case 14
                disp('Running path 14...');
                o.action_array=[6 2 2 1 1 -1 -1 -1 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 -1 -1 -1 -1 -1];
                o=o.observe_action(1);
            case 15
                disp('Running path 15...');
                o.action_array=[6 1 1 1 2 2 2 -1 -1 -1 -1];
                o.location_array=[19 4 3 2 1 2 3 4 -1 -1 -1];
                o=o.observe_action(2);
            case 16
                disp('Running path 16...');
                o.action_array=[6 2 2 1 1 1 1 1 2 2 -1 -1 -1];
                o.location_array=[19 4 5 6 5 4 3 2 1 2 3 -1 -1];
                o=o.observe_action(2);
        end % switch path
        save(sprintf('%s/o%d-beta%1.2f.mat',resultsdir,path,beta_score),'o');
    end % for path=1:16
end % for beta_score=beta_score_values


%% collect results
results = zeros(6,19,length(beta_score_values));
for bi=1:length(beta_score_values)
    for path=1:3
        load(sprintf('%s/o%d-train-beta%1.2f.mat',resultsdir,path,beta_score_values(bi)),'o');
        results(:,path,bi) = o.marginalizeOverPosition;
    end
    for path=1:16
        load(sprintf('%s/o%d-beta%1.2f.mat',resultsdir,path,beta_score_values(bi)),'o');
        results(:,path+3,bi) = o.marginalizeOverPosition;
    end
end
save(sprintf('%s/results.mat',resultsdir),'results');
