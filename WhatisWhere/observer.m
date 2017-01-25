  classdef observer
	% Ideal bayesian observer.
	%
	% To work it needs to know how the environment works (the pomdp struct) and how to act
	% rationally (computed offline and stored in btom struct).
	%
	% pomdp and btom should be built using provided perl scripts.
	properties
		pomdp
		btom
		action_array
		location_array
		belief
		belief_prior
		prior_belief_prior
		newbelief
		obsmat
		% pomdp[struct]					POMDP structure. Generate this using build_matlab_pomdp.pl
		% btom[struct]					optimal policies. Generate this using build_matlab_policy.pl
		% action_array[vector]			array where actions are stored.
		% location_array[vector]		array where locations are stored.
		% belief[vector]				Prior over states the world can have (food cart configurations)
		% belief_prior[vector]			Prior over the possible prior beliefs the observed agent can have.
		% prior_belief_prior[vector]	Prior over belief_prior.
		%								That is, each element is the prior belief of the observer
		%								that the acting agents thas the described prior distribution.
		% newbelief[vector]				posterior belief about the world. Here is where results are stored!
		% obsmat[matrix]				see build_loc_obsmat function.				
	end
	methods
		function obj=observer(prior,bp,pbp,pomdp,btom,limit)
			% Build a new observer
			%
			% Prior is over configuration size (how many worlds are there, independent of the agent), as if it were a MOMDP.
			% switch to a POMDP representation (where each state marks world configuration + agent location) is done through append function
			%
			% limit is for memory preallocation and not really necessary.
			%
			% belief_prior is a matrix with pomdp.cs columns. Each row determines a belief distribution.
			%
			obj.belief=prior;
			obj.belief_prior=bp;
			obj.prior_belief_prior=pbp;
			obj.pomdp=pomdp;
			obj.btom=btom;
			obj.action_array=ones(1,limit)*-1;
			obj.location_array=ones(1,limit)*-1;
			obj.obsmat=build_loc_obsmat(pomdp);
			obj.newbelief=zeros(size(obj.belief_prior,1),length(obj.belief));
		end		
		function obj=start_observing(obj,l,a)
			% Store starting position and action.
			%
			% Additionally stores location at time 2 (the first state from which it obtains an observation).
			obj.location_array(1)=l;
			obj.action_array(1)=a;
			obj.location_array(2)=update_location(a,l);
		end
		function obj=observe_action(obj,a)
			% Compute belief about the world, given an agent's action.

			disp('Reasoning about observation paths. This may take some time...');

			%reset belief
			%each row matches the belief distribution described in the same row of the belief_prior matrix

			obj.newbelief=zeros(size(obj.belief_prior,1),length(obj.belief));

			%store action and new location

			obj.action_array(find(obj.action_array==-1,1))=a;
			index=find(obj.location_array==-1,1);
			obj.location_array(index)=update_location(a,obj.location_array(index-1));

           	%get subsets or locations and actions which will be used

			sublarray=obj.location_array(1:find(obj.location_array==-1,1)-2);
			subaarray=obj.action_array(1:find(obj.action_array==-1,1)-1);
			obs_hist=build_obs_hist(sublarray,obj.obsmat);

			%disp('Observation Histories:');
			%disp(obs_hist);

			%Bayesian inference.
			for beliefdist=1:size(obj.belief_prior,1),
				for state=1:length(obj.belief),
					for obs_path=1:length(obs_hist),
						pact=p_act(subaarray,obs_hist(obs_path,:),pushconfig(obj.belief_prior(beliefdist,:),sublarray(1),obj.pomdp),obj.btom,obj.pomdp,beliefdist);
						pobs=p_obs(obs_hist(obs_path,:),sublarray,state,obj.pomdp);
						obj.newbelief(beliefdist,state)=obj.newbelief(beliefdist,state)+pact*pobs*obj.belief(state)*obj.prior_belief_prior(beliefdist);
					end
				end
			end
			if(sum(sum(obj.newbelief))>0),
				obj.newbelief=obj.newbelief/sum(sum(obj.newbelief));
			end
		end
		function judgment=marginalizeOverPosition(obj)
			% Transforms posterior (self.newbelief) into beliefs about configurations.
			%
			%The order is the same as presented in the Cogsci2012 plot.
			tempjudg=sum(obj.newbelief);
			judgment=zeros(1,6);
			%A is on top and B on right (a6b8)
			judgment(1)=sum(tempjudg([5:8]));
			%A is on top and B on left (a6b3)
			judgment(2)=sum(tempjudg([1:4]));
			%B is on top and A on right (a8b6)
			judgment(3)=sum(tempjudg([17:20]));
			%B is on top and A on left (a3b6)
			judgment(4)=sum(tempjudg([9:12]));
			%B on left and A on right (a8b3)
			judgment(5)=sum(tempjudg([21:24]));
			%B on right and A on left (a3b8)
			judgment(6)=sum(tempjudg([13:16]));
	end
end
