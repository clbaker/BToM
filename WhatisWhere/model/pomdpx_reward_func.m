function [reward]=pomdpx_reward_func(goal_reward)
% [reward]=pomdpx_reward_func(goal_reward)

scenario = create_scenario;
n_world = length(scenario.goal_pose)*length(scenario.goal_open);

% create state space
action = [-1  1  0   0  0  0; ...
           0  0 -1   1  0  0];
p_action_fail=0;
[c_trans,c_sub,is_c_ind_valid] = create_coord_trans(scenario,action,p_action_fail);
n_coord = size(c_sub,2);
n_state = n_coord+3;

cash_ind = n_state-1;

reward = zeros(n_state,n_world);

worlds = {'a6eb3e','a6eb3f','a6fb3e','a6fb3f','a6eb8e','a6eb8f','a6fb8e','a6fb8f','a3eb6e','a3eb6f','a3fb6e','a3fb6f','a3eb8e','a3eb8f','a3fb8e','a3fb8f','a8eb6e','a8eb6f','a8fb6e','a8fb6f','a8eb3e','a8eb3f','a8fb3e','a8fb3f'};
a3_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a3')),worlds,'uniformoutput',false)));
a6_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a6')),worlds,'uniformoutput',false)));
a8_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a8')),worlds,'uniformoutput',false)));

b3_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b3')),worlds,'uniformoutput',false)));
b6_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b6')),worlds,'uniformoutput',false)));
b8_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b8')),worlds,'uniformoutput',false)));

c3_ind = ~any([a3_ind; b3_ind]);
c6_ind = ~any([a6_ind; b6_ind]);
c8_ind = ~any([a8_ind; b8_ind]);

g3 = 13;
g6 = 16;
g8 = 18;

reward(g3,a3_ind) = goal_reward(1);
reward(g3,b3_ind) = goal_reward(2);
reward(g3,c3_ind) = goal_reward(3);

reward(g6,a6_ind) = goal_reward(1);
reward(g6,b6_ind) = goal_reward(2);
reward(g6,c6_ind) = goal_reward(3);

reward(g8,a8_ind) = goal_reward(1);
reward(g8,b8_ind) = goal_reward(2);
reward(g8,c8_ind) = goal_reward(3);



return;

fid=fopen('rewardfunc-symm.pomdpx','w');

% RewardFunc:
fprintf(fid,'\t<Func>\n');
fprintf(fid,'\t\t<Var>reward</Var>\n');
fprintf(fid,'\t\t<Parent>world0 state1 state0</Parent>\n');
fprintf(fid,'\t\t<Parameter type="TBL">\n');

for s0=1:n_state
  fprintf(fid,'\t\t\t<Entry>\n');
  fprintf(fid,'\t\t\t\t<Instance>- s%d s%d</Instance>\n',cash_ind-1,s0-1);
  fprintf(fid,'\t\t\t\t<ValueTable>');
  for w0=1:n_world
    fprintf(fid,' %f',reward(s0,w0));
  end
  fprintf(fid,'\n\t\t\t\t</ValueTable>\n');
  fprintf(fid,'\t\t\t</Entry>\n');      
end

fprintf(fid,'\t\t</Parameter>\n');
fprintf(fid,'\t</Func>\n');

if fid~=1
  fclose(fid);
end

