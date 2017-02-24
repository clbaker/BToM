function obsmat = build_config_obsmat(pomdp)
	% Build array of possible observations that can happen in state i, independent of location
	%
	% Returns a list where vector i contains an array with observations that can occur in state i.
	%
	% ARGUMENTS:
	% pomdp[struct]		pomdp structure
	%
	% This function is not essential but it optimizes sparse pomdp structures.
	obsmat=zeros(pomdp.cs,length(pomdp.O(1,1,:)));
 	pl=floor(length(pomdp.T(1,1,:))/pomdp.cs);
	for i=1:pomdp.cs,
		%get submatrix of rows indicating same configuration but different physical location, add them up and get all the places where an observation has chance greater than zero, then replace those values for 1 in the obsmat
		obsmat(i,find(sum(pomdp.O(1,((0:(pl-1))*pomdp.cs)+i,:))))=1;
	end
end
