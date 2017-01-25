There are in total 22 belief points from the simplex. The i-th simplex point has four files:

i.POMDP is the map specification. This file is the same for all 22 belief points except in the start distribution (line 14), which represents the agent's prior belief.

pi_matlab_pomdp.m will load the i-th POMDP into a MATLAB struct. It needs manual specification of configuration size. Configuration Size is the amount of configurations the environment can have (in paper (3*2)*(2*2)=24).

pi.policy contains the POMDP planning policy approximated by the APPL solver.

pi_matlab_btom.m will load the i-th POMDP alpha-values into a MATLAB struct.

pi_matlab_btom.m was built from pi.policy using the build_matlab_policy.pl script found in the perl_scripts folder.
pi_matlab_pomdp.m was build from i.POMDP using the build_matlab_pomdp.pl script found in the perl_scripts folder.

The prior beliefs in the simplex points are as follows (with some examples on how to read them):
1  - uniform
"Simplex point 1 has a uniform distribution over all possible cart configurations"
2  - Bias: A->W(+)
"Simplex point 2 is biased to believe that Cart A is in the West location and is open"
3  - Bias: A->W(-)
"Simplex point 3 is biased to believe that Cart A is in the West location and is closed"
4  - Bias: A->N(+)
5  - Bias: A->N(-)
6  - Bias: A->E(+)
7  - Bias: A->E(-)
8  - Bias: B->W(+)
9  - Bias: B->W(-)
10 - Bias: B->N(+)
11 - Bias: B->N(-)
12 - Bias: B->E(+)
13 - Bias: B->E(-)
14 - Bias: C->W
15 - Bias: C->N
"Simplex point 15 is biased to believe that cart C is in the North position (always open)"
16 - Bias: C->E
17 - Bias: A->W(?)
"Simplex point 17 is biased to believe that Cart A is in the West location. It can be open or closed."
18 - Bias: A->N(?)
19 - Bias: A->E(?)
20 - Bias: B->W(?)
21 - Bias: B->N(?)
22 - Bias: B->E(?)