# BToM: Bayesian Theory of Mind

# Belief-Desire Inference

## DATA

In Matlab:  
&gt;&gt; save_human_results  
->  
data/human_data.mat


## EXPERIMENT & STIMULI

To run the experiment, you need the Visilibity package (http://www.visilibity.org). Compile the source code and put it in the code/visilibity/ directory. In Matlab, enter:  
&gt;&gt; run_experiment

All stimulus scenarios are stored in: stimuli.mat. They can be visualized in Matlab using:  
&gt;&gt; display_scenarios


## MODEL PREDICTIONS

To run the full model, you need the Visilibity package (http://www.visilibity.org). Compile the source code and put it in the code/visilibity/ directory. The default setting doesn't use Visilibity; rather the model loads the saved observation distributions from code/visilibity/observation_distribution.mat.

In Matlab:  
&gt;&gt; run_btom  
->  
data/btom_results/btom_results_complete.mat

&gt;&gt; run_truebelief  
->  
data/truebelief_results/truebelief_results_complete.mat

&gt;&gt; run_nocost  
->  
data/nocost_results/nocost_results_complete.mat

Results for beta_score = 0.5:0.5:10 are in:  
data/btom_results.mat  
data/truebelief_results.mat  
data/nocost_results.mat

In R:  
&gt; run_motionheuristic  
->  
data/motionheuristic_results_complete.mat  
data/motionheuristic_bscv.mat


## ANALYSIS

In Matlab:  
&gt;&gt; bscv_analysis   
->  
btom_bscv.mat  
truebelief_bscv.mat  
nocost_bscv.mat  

&gt;&gt; correlation_analysis.m



