function newbelief = updatebelief(belief, observation, action, pomdp)
	% Update belief distribution using Bayes
	%
	%Intuitive read: Under belief belief, I took action action and got observation observation from pomdp. Now I have belief newbelief
	%
	% Arguments:
	% belief[vector]		prior belief.
	% observation[integer]	observation number from POMDP.
	% action[integer]		action number from POMDP.
	% pomdp[struct]			pomdp structure. See observer class for specifications.
	newbelief=zeros(length(belief),1);
	for i=1:length(belief),
		%loop through states
		for loopstate=1:length(belief),
			term=pomdp.O(action,i,observation)*pomdp.T(action,loopstate,i)*belief(loopstate);
			newbelief(i)=newbelief(i)+term;
		end
	end
	%unless you were reasoning about an impossible scenario (in which the posterior becomes zero), the belief is normalized.
	if(sum(newbelief)>0),
		newbelief=newbelief/sum(newbelief);
	end
end
