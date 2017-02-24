function [obs_dist]=pomdpx_obs_func(obs_noise)
% [obs_dist]=pomdpx_obs_func(obs_noise)

scenario = create_scenario;
n_world = length(scenario.goal_pose)*length(scenario.goal_open);

% round so columns always add up to 1
num_precision = 10^6;

action = [-1  1  0   0  0  0; ...
           0  0 -1   1  0  0];
p_action_fail=0;
[c_trans,c_sub,is_c_ind_valid] = create_coord_trans(scenario,action,p_action_fail);
n_coord = size(c_sub,2);
n_state = n_coord+3;

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


% numbered observations
ae = 1;
af = 2;
be = 3;
bf = 4;
c = 5;
NULL = 6;

n_obs = 6;

obs_dist = zeros(n_obs,n_state,n_world);
cp3 = [1  7 13];
cp6 = [4 10 16];
cp8 = [6 12 18];

obs_dist(ae,cp3,a3e_ind) = 1-obs_noise;
obs_dist(ae,cp6,a6e_ind) = 1-obs_noise;
obs_dist(ae,cp8,a8e_ind) = 1-obs_noise;
obs_dist(af,cp3,a3f_ind) = 1-obs_noise;
obs_dist(af,cp6,a6f_ind) = 1-obs_noise;
obs_dist(af,cp8,a8f_ind) = 1-obs_noise;

obs_dist(be,cp3,b3e_ind) = 1-obs_noise;
obs_dist(be,cp6,b6e_ind) = 1-obs_noise;
obs_dist(be,cp8,b8e_ind) = 1-obs_noise;
obs_dist(bf,cp3,b3f_ind) = 1-obs_noise;
obs_dist(bf,cp6,b6f_ind) = 1-obs_noise;
obs_dist(bf,cp8,b8f_ind) = 1-obs_noise;

obs_dist(c,cp3,c3_ind) = 1-obs_noise;
obs_dist(c,cp6,c6_ind) = 1-obs_noise;
obs_dist(c,cp8,c8_ind) = 1-obs_noise;

obs_dist(NULL,:,:) = 1-sum(obs_dist);


% round obs_dist so that columns always add up to 1
obs_dist = round(obs_dist*num_precision)/num_precision;
obs_dist(NULL,:) = obs_dist(NULL,:) + (1-sum(obs_dist(:,:),1));



return;

fid=fopen('obsfunc-symm.pomdpx','w');

fprintf(fid,'<ObsFunction>\n');
fprintf(fid,'\t<CondProb>\n');
fprintf(fid,'\t\t<Var>obs</Var>\n');
fprintf(fid,'\t\t<Parent>world1 state1</Parent>\n');
fprintf(fid,'\t\t<Parameter type="TBL">\n');

for w1=1:n_world
  for s1=1:n_state
    fprintf(fid,'\t\t\t<Entry>\n');
    fprintf(fid,'\t\t\t\t<Instance>s%d s%d -</Instance>\n',w1-1,s1-1);
    fprintf(fid,'\t\t\t\t<ProbTable>');
    for no=1:n_obs
      fprintf(fid,' %.6f',obs_dist(no,s1,w1));
    end
    fprintf(fid,'\n\t\t\t\t</ProbTable>\n');
    fprintf(fid,'\t\t\t</Entry>\n');

  end
end

fprintf(fid,'\t\t</Parameter>\n');
fprintf(fid,'\t</CondProb>\n');

fprintf(fid,'</ObsFunction>\n\n');

