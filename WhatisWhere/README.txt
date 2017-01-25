The POMDP gridworld has 18 locations

1  2  3  4  5  6
7  8  9  10 11 12
13 14 15 16 17 18

Out of which states, 8, 9, 11, 14, 15, and 17 are locations that are physically impossible to reach (spaces between hallways). Including these states makes the code more readable.

The hallway formed by states 4-10-16 moves downwards while in the experimental stimuli it goes upwards. It doesn't make a difference.

POMDP states have the following notation:

p[x] determines the position of the agent in the map.
a[x][y] determines the position of cart a (in x). Since carts can only be instates 13, 16, or 18. x only marks the last digit (3, 6, or 8). y determines if the cart is open (e) of closed (f) (marked as e or f because we were originally referring to the carts being empty or full).

So then, state p6a6fb3f indicates:

X X X X X a
X     X   X
B     A   C

where a is the position of the agent. and carts A and B are closed.

States are ordered in the following way:

1  - a6eb3e
2  - a6eb3f
3  - a6fb3e
4  - a6fb3f
5  - a6eb8e
6  - a6eb8f
7  - a6fb8e
8  - a6fb8f
9  - a3eb6e
10 - a3eb6f
11 - a3fb6e
12 - a3fb6f
13 - a3eb8e
14 - a3eb8f
15 - a3fb8e
16 - a3fb8f
17 - a8eb6e
18 - a8eb6f
19 - a8fb6e
20 - a8fb6f
21 - a8eb3e
22 - a8eb3f
23 - a8fb3e
24 - a8fb3f

This is the order in which beliefs are stored in the observer class (o.belief, o.belief_prior, and o.newbelief).

To transform this into a vector like the ones storing human subject responses you can use observer.marginalizeOverPosition()

To replicate the data from CogSci2012 open replication.m and set the first three variables
joint_inference % Set to 1 to do join observation-prior belief inference. to 0 to only infer observations
path % Path number
saveoutput % Save the output?

To run the model on a different path:

1. Load POMDP and policies (found in replication.m)
	If you want joint belief-observation inference load all 22 policies. If you are only interested in observation inference only load the first policy (p1_btom).
2. load the agent's possible beliefs. If you're doing joint belief-observation inference load them using
	bp=false_belief_set(),
	otherwise, just make one variable
	bp=ones(1,24)/24;
3. Set a prior of the observer's beliefs on the agent's beliefs
	bpb=ones(1,size(bp,1))/size(bp,1);
4. create an observer
	o=observer(prior,bp,bpb,p1_POMDP,pols,10);
5. Initialize the observer as being in limbo (state 19) and choosing to enter the world (action 6)
	o=o.start_observing(19,6);
6. Set up the path the agent has already taken. Actions are:
	1 - Move left.
	2 - Move right.
	3 - Move up.
	4 - Move down.
	5 - Eat.
	6 - Enter world.
	o.action_array=[6 2 2 1 1 1 1 1 -1 -1 -1];
	-1 are placeholders. Give the array enough space so it can continue computing if necessary (i.e., throw a bunch of -1's at the end)
7. Set up the locations it's been moving towards (using the map above).
	o.location_array=[19 4 5 6 5 4 3 2 1 -1 -1];
8. Now have the observer watch the last chosen action and it will infer the state of the world.
	o=o.observe_action(4);

To run the model on your own world:

1. Build a .POMDP file using Tony's POMDP file format ( http://cs.brown.edu/research/ai/pomdp/examples/pomdp-file-spec.html )
2. For each point in your prior belief simplex (i.e., the observer's belief about the agent's prior belief about the world), use a different .POMDP file that changes in the starting state belief distribution.
3. Generate all matlab structures using Policies/perl_scripts/build_matlab_pomdp.pl
4. Generate optimal policies for each POMDP through appl.
5. Generate optimal policy matlab structures using Policies/perl_scripts/build_matlab_policy.pl
6. Follow the "Run the model on a different path" instructions changing the food track planning files for yours.