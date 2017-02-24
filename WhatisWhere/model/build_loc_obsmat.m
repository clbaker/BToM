function obsmat = build_loc_obsmat(pomdp)
	% Build array of possible observation the agent can have in each location
	%
	% ARGUMENTS:
	% pomdp[struct]		pomdp structure
	%
	% OUTPUT:
	% list where vector i contains an array with the observation that can occur in location i.
	% This function is not essential but it optimizes sparse pomdp structures (So you can skip all observations that will have probability 0).
	pl=floor(length(pomdp.T(1,1,:))/pomdp.cs);
	obsmat=zeros(pl,length(pomdp.O(1,1,:)));
	for i=1:pl,
 		obsmat(i,find(sum(pomdp.O(1,[((i-1)*pomdp.cs+1):i*pomdp.cs],:))))=1;
	end
end
