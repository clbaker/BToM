function newbelief = updatebelief(belief, observation, states, action, pomdp)
	% Update belief distribution using Bayes
	%
	%Intuitive read: Under belief belief, state state, I took action action and got observation observation from pomdp. Now I have belief newbelief
	%
	% Arguments:
	% belief[vector]		prior belief.
	% observation[integer]	observation number from MOMDP.
  % state[integer]		state number from MOMDP.
	% action[integer]		action number from MOMDP.
	% pomdp[struct]			pomdp structure. See observer class for specifications.
	newbelief=belief.*squeeze(pomdp.O(observation,states(2),:).*pomdp.T(states(2),states(1),:,action))';
	if(sum(newbelief)>0)
		newbelief=newbelief/sum(newbelief);
	end
end
