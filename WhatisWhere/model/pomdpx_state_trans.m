function [s_trans]=pomdpx_state_trans(p_action_fail)
% [s_trans]=pomdpx_state_trans(p_action_fail)

scenario = create_scenario;
n_world = length(scenario.goal_pose)*length(scenario.goal_open);

% round so columns always add up to 1
num_precision = 10^6;

action = [-1  1  0  0  0  0; ...
           0  0 -1  1  0  0];
n_action = size(action,2);

[c_trans,c_sub,is_c_ind_valid] = create_coord_trans(scenario,action,p_action_fail);

% round c_trans so that columns always add up to 1
c_trans = round(c_trans*num_precision)/num_precision;
c_trans(1,:) = c_trans(1,:) + (1-sum(c_trans(:,:),1));

n_coord = size(c_sub,2);

% fix NaN transitions for APPL
for ci=1:n_coord
  if ~is_c_ind_valid(ci)
    c_trans(:,ci,:) = 0;
    c_trans(ci,ci,:) = 1;
  end
end
%c_trans(isnan(c_trans)) = 0;

% create s_trans
n_state = n_coord+3;
s_trans = zeros(n_state,n_state,n_world,n_action);
for nw=1:n_world
  s_trans(1:n_coord,1:n_coord,nw,:) = c_trans;
end

% transitions to "start", "cash", and "finish" states (this is just additional observable states) to c_trans and calculate transition probabilities
start_ind = n_coord+1;
cash_ind = start_ind+1;
end_ind = cash_ind+1;
s_trans(find(all(bsxfun(@eq,c_sub,[4;1]))),start_ind,:,6) = 1;
s_trans(start_ind,start_ind,:,1:5) = 1;

% transitions to "cash" state
worlds = {'a6eb3e','a6eb3f','a6fb3e','a6fb3f','a6eb8e','a6eb8f','a6fb8e','a6fb8f','a3eb6e','a3eb6f','a3fb6e','a3fb6f','a3eb8e','a3eb8f','a3fb8e','a3fb8f','a8eb6e','a8eb6f','a8fb6e','a8fb6f','a8eb3e','a8eb3f','a8fb3e','a8fb3f'};
a3e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a3e')),worlds,'uniformoutput',false)));
a3f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a3f')),worlds,'uniformoutput',false)));
a6e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a6e')),worlds,'uniformoutput',false)));
a6f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a6f')),worlds,'uniformoutput',false)));
a8e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a8e')),worlds,'uniformoutput',false)));
a8f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'a8f')),worlds,'uniformoutput',false)));

b3e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b3e')),worlds,'uniformoutput',false)));
b3f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b3f')),worlds,'uniformoutput',false)));
b6e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b6e')),worlds,'uniformoutput',false)));
b6f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b6f')),worlds,'uniformoutput',false)));
b8e_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b8e')),worlds,'uniformoutput',false)));
b8f_ind = ~cellfun('isempty',(cellfun(@(x)(strfind(x,'b8f')),worlds,'uniformoutput',false)));

c3_ind = ~any([a3e_ind; a3f_ind; b3e_ind; b3f_ind]);
c6_ind = ~any([a6e_ind; a6f_ind; b6e_ind; b6f_ind]);
c8_ind = ~any([a8e_ind; a8f_ind; b8e_ind; b8f_ind]);

open = [sort([find(a3e_ind) find(b3e_ind) find(c3_ind)]); sort([find(a6e_ind) find(b6e_ind) find(c6_ind)]); sort([find(a8e_ind) find(b8e_ind) find(c8_ind)])];

s_trans(1:n_coord,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,1)))),open(1,:),5) = 0;
s_trans(cash_ind,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,1)))),open(1,:),5) = 1;
s_trans(1:n_coord,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,2)))),open(2,:),5) = 0;
s_trans(cash_ind,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,2)))),open(2,:),5) = 1;
s_trans(1:n_coord,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,3)))),open(3,:),5) = 0;
s_trans(cash_ind,find(all(bsxfun(@eq,c_sub,scenario.goal_space(:,3)))),open(3,:),5) = 1;

s_trans(end_ind,cash_ind,:,:) = 1;
s_trans(end_ind,end_ind,:,:) = 1;



return;

action_label = {'Le','Ri','Up','Do','Ca','St'};

fid=fopen('strans-symm.pomdpx','w');

fprintf(fid,'<StateTransitionFunction>\n');

% StateTrans: world1
fprintf(fid,'\t<CondProb>\n');
fprintf(fid,'\t\t<Var>world1</Var>\n');
fprintf(fid,'\t\t<Parent>world0</Parent>\n');
fprintf(fid,'\t\t<Parameter type="TBL">\n');
fprintf(fid,'\t\t\t<Entry>\n');
fprintf(fid,'\t\t\t\t<Instance>- -</Instance>\n');
fprintf(fid,'\t\t\t\t<ProbTable>identity</ProbTable>\n');
fprintf(fid,'\t\t\t</Entry>\n');
fprintf(fid,'\t\t</Parameter>\n');
fprintf(fid,'\t</CondProb>\n\n');

% StateTrans: state1
fprintf(fid,'\t<CondProb>\n');
fprintf(fid,'\t\t<Var>state1</Var>\n');
fprintf(fid,'\t\t<Parent>action world0 state0</Parent>\n');
fprintf(fid,'\t\t<Parameter type="TBL">\n');

for w0=1:n_world
  for s0=1:n_state
    for na=1:n_action
      fprintf(fid,'\t\t\t<Entry>\n');
      fprintf(fid,'\t\t\t\t<Instance>%s s%d s%d -</Instance>\n',action_label{na},w0-1,s0-1);
      fprintf(fid,'\t\t\t\t<ProbTable>');
      for s1=1:n_state
        fprintf(fid,' %.6f',s_trans(s1,s0,w0,na));
      end
      fprintf(fid,'\n\t\t\t\t</ProbTable>\n');
      fprintf(fid,'\t\t\t</Entry>\n');
    end
  end
end
fprintf(fid,'\t\t</Parameter>\n');
fprintf(fid,'\t</CondProb>\n\n');

fprintf(fid,'</StateTransitionFunction>\n\n');


if fid~=1
  fclose(fid);
end

