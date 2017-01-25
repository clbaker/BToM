function p = p_act(a,o,belief,btom,pomdp,index)
	% Calculate probability of an action sequence given the state of the world and a history of observations.
	%
	% Note: a and o must have the same length (meaning you don't have the latest observation)
	% The BToM structure should be built using the build_matlab_policy.pl perl policy that is provided with this code
	%
	% ARGUMENTS:
	% a[vector]			vector of actions the agent has taken
	% o[vector]			vector of observation the agent has received
	% belief[vector]	agent's belief that is being considered
	% btom[struct]		optimal policies (as alpha vectors)
	% pomdp[struct]		pomdp structure
	% index[integer]	marker of which optimal policy file to use (depending on which belief is being considered.)
	p=1;
	%for each observation...
	for ol = 2:length(o)
		%took action a(ol-1) and got observation o(ol)
		belief=updatebelief(belief,o(ol),a(ol-1),pomdp);
		policyvals=btom{index}.vectors*belief;
		%vector of all possible actions
		action=btom{index}.actions(find(policyvals == max(policyvals)))+1;
		action=unique(action);
		%disp('expected action:');
		%disp(action);
		%check is action was one of the possible ones
		if ~any(action == a(ol)),
			p=0;
			ol=length(o)+1;
		else
			p=p*(1/length(action));
		end
	end
end
