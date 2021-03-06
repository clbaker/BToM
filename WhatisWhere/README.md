# BToM: Bayesian Theory of Mind

# Inferring What is Where

## DATA

See:  
Data/carts.csv  
Data/carts-mean.csv  


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

Currently, the POMDPX files are all saved in the repository, but to regenerate or modify them, use:  
&gt;&gt; setup_btom  
&gt;&gt; setup_truebelief  
&gt;&gt; setup_nocost  

The POLICYX files are also saved in the repository. To generate these, you must solve each POMDP using APPL, available at: http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/index.php?n=Main.Download

## ANALYSIS

In Matlab:  
&gt;&gt; bscv_analysis  
->  
Data/BToM/discount0.999900-cost1.0/results/results_bscv.mat  
Data/TrueBelief/discount0.999900-cost1.0/results/results_bscv.mat  
Data/NoCost/discount0.999900-cost0.0/results/results_bscv.mat  
