function newbelief = pushconfig(belief, l, pomdp)
	%Push agent's belief into the POMDP subset of states with the right position.
	%
	% Takes the agent's belief over the possible worlds (24 in POMDP), and places it in the right location
	% of the POMDP's belief space (24 states x agent's possible positions).
	% We need this because the agent's location is fully observable, but we didn't use a MOMDP.
	%
	% Arguments
	% belief[vector]	Belief distribution over possible states
	% l[integer]		Agent's location on map
	% pomdp[struct]		POMDP structure.
    newbelief=zeros(1,length(pomdp.prior));
    newbelief(((l-1)*pomdp.cs+1):l*pomdp.cs)=belief;
end
