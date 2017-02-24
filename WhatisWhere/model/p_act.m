function p = p_act(l,a,o,belief,policy,pomdp,beta)
	% Calculate probability of an action sequence given the state of the world and a history of observations.
	%
	% Note: a and o must have the same length (meaning you don't have the latest observation)
	% The BToM structure should be built using the build_matlab_policy.pl perl policy that is provided with this code
	%
	% ARGUMENTS:
  % l[vector]			vector of states the agent has visited
	% a[vector]			vector of actions the agent has taken
	% o[vector]			vector of observation the agent has received
	% belief[vector]	agent's belief that is being considered
	% btom[struct]		optimal policies (as alpha vectors)
	% pomdp[struct]		pomdp structure
  p=1;
	%for each observation...
	for ol = 1:length(o)
    if ol==1
      belief=belief.*squeeze(pomdp.O(o(ol),l(ol),:))';
    else
      belief=updatebelief(belief,o(ol),l((ol-1):ol),a(ol-1),pomdp);
    end
    Q = zeros(size(pomdp.T,4),1);
    for ai=1:length(Q)
      Q(ai) = lookahead_value(l(ol),belief,ai,policy,pomdp);
    end
    p_action = exp(beta*(Q-max(Q)));
    if sum(p_action)>0
      p_action = p_action./sum(p_action);
    end
    p=p*p_action(a(ol));
	end
end


function Q = lookahead_value(l,belief,a,value,pomdp)
  Q=pomdp.cost(a);
  b_ind = find(belief);
  % integrate over next states and actions
  for bi=1:length(b_ind)
    wi=b_ind(bi);
    l_next = find(pomdp.T(:,l,wi,a));
    for li=1:length(l_next)
      alpha_inds = value.states == (l_next(li)-1);
      o_next = find(pomdp.O(:,l_next(li),wi));
      for oi=1:length(o_next)
        b_next=updatebelief(belief,o_next(oi),[l l_next(li)],a,pomdp);
        b_value = pomdp.disc*max(value.alphas(alpha_inds,:)*b_next');
        Q=Q+b_value*pomdp.T(l_next(li),l,wi,a)*pomdp.O(o_next(oi),l_next(li),wi)*belief(wi);
      end
    end
  end
end
