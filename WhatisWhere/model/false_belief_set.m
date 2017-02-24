function dist = false_belief_set()
	% Build space of possible prior the acting agent could have.
	%
	% Essentially, some points on a simplex that make sense
	% in the context of the space (beliefs that are biased on some carts being in some locations or states).
	%
	%build the set as if only those states existed
	dist=ones(22,24)/100;
	%uniform uncertainty
	dist(1,:)=ones(1,24)/24;
	%State description of partial information beliefs
	a3e=[9 10 13 14];
	a3f=[11 12 15 16];
	a6e=[1 2 5 6];
	a6f=[3 4 7 8];
	a8e=[17 18 21 22];
	a8f=[19 20 23 24];
	b3e=[1 3 21 23];
	b3f=[2 4 22 24];
	b6e=[9 11 17 19];
	b6f=[10 12 18 20];
	b8e=[5 7 13 15];
	b8f=[6 8 14 16];
	c3=[5 6 7 8 17 18 19 20];
	c6=[13 14 15 16 21 22 23 24];
	c8=[1 2 3 4 9 10 11 12];
	%pack up in the distribution
	%specific belief
	dist(2,a3e)=dist(2,a3e)+0.19;
	dist(3,a3f)=dist(3,a3f)+0.19;
	dist(4,a6e)=dist(4,a6e)+0.19;
	dist(5,a6f)=dist(5,a6f)+0.19;
	dist(6,a8e)=dist(6,a8e)+0.19;
	dist(7,a8f)=dist(7,a8f)+0.19;
	dist(8,b3e)=dist(8,b3e)+0.19;
	dist(9,b3f)=dist(9,b3f)+0.19;
	dist(10,b6e)=dist(10,b6e)+0.19;
	dist(11,b6f)=dist(11,b6f)+0.19;
	dist(12,b8e)=dist(12,b8e)+0.19;
	dist(13,b8f)=dist(13,b8f)+0.19;
	%general belief
	dist(14,c3)=dist(14,c3)+0.095;
	dist(15,c6)=dist(15,c6)+0.095;
	dist(16,c8)=dist(16,c8)+0.095;
	dist(17,[a3e a3f])=dist(17,[a3e a3f])+0.095;
	dist(18,[a6e a6f])=dist(18,[a6e a6f])+0.095;
	dist(19,[a8e a8f])=dist(19,[a8e a8f])+0.095;
	dist(20,[b3e b3f])=dist(20,[b3e b3f])+0.095;
	dist(21,[b6e b6f])=dist(21,[b6e b6f])+0.095;
	dist(22,[b8e b8f])=dist(22,[b8e b8f])+0.095;
	%clean up
	clear('a3e','a3f','a6e','a6f','a8e','a8f','b3e','b3f','b6e','b6f','b8e','b8f');
end
