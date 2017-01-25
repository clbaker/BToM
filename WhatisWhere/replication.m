%Parameters
joint_inference=1;
path=3;
saveoutput=0;
%Load the observer model of the world
run('Policies/p1_matlab_pomdp.m')
p1_POMDP.cs=24;
disp('Configuration Size (cs) set to 24.');
%Load the family of policies
disp('Loading policies...');
run('Policies/p1_matlab_btom.m')
pols{1}=p1_btom;clear p1_btom;
if (joint_inference==1)
	run('Policies/p2_matlab_btom.m')
	pols{2}=p2_btom;clear p2_btom;
	run('Policies/p3_matlab_btom.m')
	pols{3}=p3_btom;clear p3_btom;
	run('Policies/p4_matlab_btom.m')
	pols{4}=p4_btom;clear p4_btom;
	run('Policies/p5_matlab_btom.m')
	pols{5}=p5_btom;clear p5_btom;
	run('Policies/p6_matlab_btom.m')
	pols{6}=p6_btom;clear p6_btom;
	run('Policies/p7_matlab_btom.m')
	pols{7}=p7_btom;clear p7_btom;
	run('Policies/p8_matlab_btom.m')
	pols{8}=p8_btom;clear p8_btom;
	run('Policies/p9_matlab_btom.m')
	pols{9}=p9_btom;clear p9_btom;
	run('Policies/p10_matlab_btom.m')
	pols{10}=p10_btom;clear p10_btom;
	run('Policies/p11_matlab_btom.m')
	pols{11}=p11_btom;clear p11_btom;
	run('Policies/p12_matlab_btom.m')
	pols{12}=p12_btom;clear p12_btom;
	run('Policies/p13_matlab_btom.m')
	pols{13}=p13_btom;clear p13_btom;
	run('Policies/p14_matlab_btom.m')
	pols{14}=p14_btom;clear p14_btom;
	run('Policies/p15_matlab_btom.m')
	pols{15}=p15_btom;clear p15_btom;
	run('Policies/p16_matlab_btom.m')
	pols{16}=p16_btom;clear p16_btom;
	run('Policies/p17_matlab_btom.m')
	pols{17}=p17_btom;clear p17_btom;
	run('Policies/p18_matlab_btom.m')
	pols{18}=p18_btom;clear p18_btom;
	run('Policies/p19_matlab_btom.m')
	pols{19}=p19_btom;clear p19_btom;
	run('Policies/p20_matlab_btom.m')
	pols{20}=p20_btom;clear p20_btom;
	run('Policies/p21_matlab_btom.m')
	pols{21}=p21_btom;clear p21_btom;
	run('Policies/p22_matlab_btom.m')
	pols{22}=p22_btom;clear p22_btom;
end

disp('Building belief space');
if (joint_inference==1)
	bp=false_belief_set();
else
	bp = ones(1,24)/24;
end
bpb=ones(1,size(bp,1))/size(bp,1);
prior=ones(1,p1_POMDP.cs)/p1_POMDP.cs;
o=observer(prior,bp,bpb,p1_POMDP,pols,10);
%clean up
clear('bp','bpb','prior');
o=o.start_observing(19,6);
%Place here all possible paths from 1 to 19.
switch path
	case 1
		disp('Running path 1...');
		o.action_array=[6 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 -1 -1 -1 -1 -1 -1 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o1s.mat','o');
		end
	case 2
		disp('Running path 2...');
		o.action_array=[6 2 2 -1 -1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 5 6 -1 -1 -1 -1 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o2s.mat','o');
		end
	case 3
		disp('Running path 3...');
		o.action_array=[6 1 1 1 -1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 -1 -1 -1 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o3s.mat','o');
		end
	case 4
		disp('Running path 4...');
		o.action_array=[6 2 2 1 1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 5 6 5 4 -1 -1 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o4s.mat','o');
		end
	case 5
		disp('Running path 5...');
		o.action_array=[6 2 2 1 1 1 1 1 2 2 2 -1 -1 -1];
		o.location_array=[19 4 5 6 5 4 3 2 1 2 3 4 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o5s.mat','o');
		end
	case 6
		disp('Running path 6...');
		o.action_array=[6 1 1 1 2 2 2 -1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 2 3 4 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o6s.mat','o');
		end
	case 7
		disp('Running path 7...');
		o.action_array=[6 2 2 1 1 1 1 1 -1 -1 -1];
		o.location_array=[19 4 5 6 5 4 3 2 1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o7s.mat','o');
		end
	case 8
		disp('Running path 8...');
		o.action_array=[6 1 1 1 2 2 2 2 2 -1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 2 3 4 5 6 -1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o8s.mat','o');
		end
	case 9
		disp('Running path 9...');
		o.action_array=[6 1 1 1 2 2 2 2 2 1 1 1 1 1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 2 3 4 5 6 5 4 3 2 1 -1 -1];
		o=o.observe_action(4);
		if (saveoutput)
			save('o9s.mat','o');
		end
	case 10
		disp('Running path 10...');
		o.action_array=[6 -1 -1 -1];
		o.location_array=[19 4 -1 -1];
		o=o.observe_action(2);
		if (saveoutput)
			save('o10s.mat','o');
		end
	case 11
		disp('Running path 11...');
		o.action_array=[6 -1 -1 -1];
		o.location_array=[19 4 -1 -1];
		o=o.observe_action(1);
		if (saveoutput)
			save('o11s.mat','o');
		end
	case 12
		disp('Running path 12...');
		o.action_array=[6 2 2 -1 -1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 5 6 -1 -1 -1 -1 -1 -1 -1];
		o=o.observe_action(1);
		if (saveoutput)
			save('o12s.mat','o');
		end
	case 13
		disp('Running path 13...');
		o.action_array=[6 1 1 1 -1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 -1 -1 -1 -1 -1 -1];
		o=o.observe_action(2);
		if (saveoutput)
			save('o13s.mat','o');
		end
	case 14
		disp('Running path 14...');
		o.action_array=[6 2 2 1 1 -1 -1 -1 -1 -1 -1];
		o.location_array=[19 4 5 6 5 4 -1 -1 -1 -1 -1];
		o=o.observe_action(1);
		if (saveoutput)
			save('o14s.mat','o');
		end
	case 15
		disp('Running path 15...');
		o.action_array=[6 1 1 1 2 2 2 -1 -1 -1 -1];
		o.location_array=[19 4 3 2 1 2 3 4 -1 -1 -1];
		o=o.observe_action(2);
		if (saveoutput)
			save('o15s.mat','o');
		end
	case 16
		disp('Running path 16...');
		o.action_array=[6 2 2 1 1 1 1 1 2 2 -1 -1 -1];
		o.location_array=[19 4 5 6 5 4 3 2 1 2 3 -1 -1];
		o=o.observe_action(2);
		if (saveoutput)
			save('o16s.mat','o');
		end
end
