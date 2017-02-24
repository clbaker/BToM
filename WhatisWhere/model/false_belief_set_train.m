function dist = false_belief_set_train()
	% Build space of possible prior the acting agent could have during training.
	%
	% It is similar to false_belief_set but only considers cases where all carts are open.
	% in this case we only need the first 10 distributions.
	%
	% Essentially, some points on a simplex that make sense
	% in the context of the space (beliefs that are biased on some carts being in some locations or states).
	%
	%build the set as if only those states existed
	dist=zeros(10,24);
	dist(:,[1 5 9 13 17 21])=0.05;
	%uniform uncertainty
	dist(1,:)=zeros(1,24);
	 dist(1,[1 5 9 13 17 21])=1/6;
	%State description of partial information beliefs
	a3e=[9 13];
	a6e=[1 5];
	a8e=[17 21];
	b3e=[1 21];
	b6e=[9 17];
	b8e=[5 13];
	c3=[5 17];
	c6=[13 21];
	c8=[1 9];
	%pack up in the distribution
	%specific belief
	dist(2,a3e)=dist(2,a3e)+0.35;
	dist(3,a6e)=dist(3,a6e)+0.35;
	dist(4,a8e)=dist(4,a8e)+0.35;
	dist(5,b3e)=dist(5,b3e)+0.35;
	dist(6,b6e)=dist(6,b6e)+0.35;
	dist(7,b8e)=dist(7,b8e)+0.35;
	%general belief
	dist(8,c3)=dist(8,c3)+0.35;
	dist(9,c6)=dist(9,c6)+0.35;
	dist(10,c8)=dist(10,c8)+0.35;
	%clean up
	clear('a3e','a6e','a8e','b3e','b6e','b8e');
end
