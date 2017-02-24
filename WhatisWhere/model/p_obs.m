function p = p_obs(o,l,c,pomdp)
	% Return probability of observations o given an agent's path.
	%
	% This function calculates the probability of an observation history
	% given the configuration of the environment and a history of locations
	%
	% Arguments:
	%
	% o[vector]		vector of observations the agent could have seen.
	% l[vector]		vector of locations the agent has been in.
	% c[integer]	number of possible worlds.
	% pomdp[struct]	POMDP structure
	p=prod(pomdp.O(sub2indv(size(pomdp.O),[o; l; repmat(c,1,length(o))])));
end
