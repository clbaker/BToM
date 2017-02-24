%returns a matrix with size(location) columns where each row is an observation history
function obs_hist = build_mobs_hist(l,obsmat)
	% Get possible observations the agent could have had given its path.
	%
	% This function requires classcomb function. It is provided along with the code and can be obtained at http://www.mathworks.com/matlabcentral/fileexchange/10064
	%
	% ARGUMENTS:
	% l[vector]			location the agent has been in.
	% obsmat[matrix]	matrix indicating the possible observations an agent can have in each location (e.g., nothing when you're on a hallway).
	n_obs=size(obsmat,1);
  n_world=size(obsmat,3);
  hist=zeros(n_world,length(l));
  for nw=1:n_world
		hist(nw,:)=(rem(find(obsmat(:,l,nw))-1,6)+1)';
  end
  obs_hist=unique(hist,'rows');
end