# BToM: Bayesian Theory of Mind

# Inferring What is Where

## DATA

See:  
Data/carts.csv  
Data/carts-mean.csv  

## EXPERIMENT & STIMULI



## MODEL PREDICTIONS

In Matlab:  
&gt;&gt; run_btom_train  
&gt;&gt; run_btom  
->  
Data/BToM/discount0.999900-cost1.0/results/results.mat  

&gt;&gt; run_nocost_train  
&gt;&gt; run_nocost  
->  
Data/NoCost/discount0.999900-cost0.0/results/results.mat  

&gt;&gt; run_truebelief_train  
&gt;&gt; run_truebelief  
->  
TrueBelief/discount0.999900-cost1.0/results/results.mat  

In R:  
&gt; run_motionheuristic  
->  
data/motionheuristic_results_complete.mat  
data/motionheuristic_bscv.mat

## ANALYSIS

In Matlab:  
bscv_analysis.m  
->  
btom_bscv.mat  
truebelief_bscv.mat  
nocost_bscv.mat  

correlation_analysis.m  
