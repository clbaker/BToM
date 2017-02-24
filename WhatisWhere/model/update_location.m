function newl = update_location(a,l)
	% Return the location of an agent taking action a in location l, if it were to succeed.
	%
	% Arguments
	% a[integer]	Number of action as specified by the POMDP.
	% l[integer]	Number of position on grid (see README.txt)
	%
	% Note that this function depends on the grid's size.
	switch a
		case 1
			shift=-1;
		case 2
			shift=+1;
		case 3
			shift=-6;
		case 4
			shift=+6;
		%for POMDPs that have a "Start" action (such as fh family)
		case 6
			shift=4;l=0;
		%fixies because fh family is mislabeled.
		otherwise
			shift=0;
	end
	newl=l+shift;
end
