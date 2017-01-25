%returns a matrix with size(location) columns where each row is an observation history
function obs_hist = build_obs_hist(l,obsmat)
	% Get possible observations the agent could have had given it's path.
	%
	% This function requires classcomb function. It is provided along with the code and can be obtained at http://www.mathworks.com/matlabcentral/fileexchange/10064
	%
	% ARGUMENTS:
	% l[vector]			location the agent has been in.
	% obsmat[matrix]	matrix indicating the possible observations an agent can have in each location (e.g., nothing when you're on a hallway).
	l2=unique(l);
	for i=1:length(l2),
		hist{i}=find(obsmat(l2(i),:));
	end
	simple_obs_hist=allcomb(hist{:});
	for i=1:length(simple_obs_hist),
		for j=1:length(l),
			%CAREFUL: THIS CODE ONLY IMPROVES THE FOODHALL POMDP. BREAKS ALL OTHERS.
			%reduce code for observations with physical shift
			switch l(j)
				case 7
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+18;
				case 13
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+36;
				case 10
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+18;
				case 16
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+36;
				case 12
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+18;
				case 18
					obs_hist(i,j)=simple_obs_hist(i,find(l2==1,1))+36;
				otherwise
					obs_hist(i,j)=simple_obs_hist(i,find(l2==l(j),1));
			end
			%Use this line only when working on another POMDP
			%obs_hist(i,j)=simple_obs_hist(i,find(l2==l(j),1));
		end
	end
end