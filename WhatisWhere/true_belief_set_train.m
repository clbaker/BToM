function dist = true_belief_set()
	% Build space of possible priors the acting agent could have.
	%
	%build the set as if only those states existed
	dist=zeros(6,24);
	% a6b3c8
	dist(1,1)=1;
	% a6b8c3
	dist(2,5)=1;
	% a3b6c8
	dist(3,9)=1;
	% a3b8c6
	dist(4,13)=1;
	% a8b6c3
	dist(5,17)=1;
	% a8b3c6
	dist(6,21)=1;
end
