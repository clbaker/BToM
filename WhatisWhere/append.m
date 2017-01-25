%This function transforms a MOMDP state description to the POMDP state description
%it receives believed configuration c, physical location l, and the amount of possible configurations.
%The POMDP description state space is a vector appending l1*c l2*c .... So all that needs to be done is shift physical location by the size of configurations and then moves to the given configuration
function state = append(c,l,csize)
	% Transform MOMDP description to POMDP state
	%
	% Takes a description that separates the fully observabe agent's location l
	% and the believed configuration of the food carts, and transforms it into its unique POMDP state.
	%
	% ARGUMENTS:
	% c[integer]	believed configuration.
	% l[integer]	physical location over grid (see README.txt for map).
	% csize			number of possible configurations.
	state = ((l-1)*csize)+c;
end
