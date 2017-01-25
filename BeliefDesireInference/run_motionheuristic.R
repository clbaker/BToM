# motionheuristic.R

# Data Description --------------------------------------------------------

# Subject is subject number
# R's have a range from 1 to 7
# R1 (Rating 1): Korean or Bottom left truck
# R2: Lebanese: Sometimes present on top right
# R3: Mexican is always an absent truck.

# So there are only two worlds in the stimuli: K and L, or K and N(othing), though from the actor's perspective
# there are eight possible worlds. When the agent begins he always sees K, so that reduces the space to KL, KM, or KN

# Scenario ranges from 1 to 3
# Scenario=1 is O-shaped world.
# Scenario=2 Backwards C-shaped world
# Scenario=3 C shape world

# Paths 1-15 are complete, 16-21 are incomplete

# World is either 1 or 3
# One of the three possible worlds: KL, KM, or KN. It's only 1 or 3 because KM never happens in reality.
# World 1 is KL, and world 3 is KN

# R1 in desires asks how much does he like Korean, always on the lower left position.


# Load Data ---------------------------------------------------------------


rm(list = ls(all = TRUE))

# Load all libraries
library(ggplot2)
library(reshape2)
library(plyr)
#library(dplyr)
library(lme4)
library(nnet)
library(reshape2)
library(boot)
library(bootstrap)
library(R.matlab)

# Load Data
setwd("~/Research/src/belief_inf2.0/branches/release")
RawData<-read.csv("data/motionheuristic/RawData.csv",header=T)
Paths<-read.csv("data/motionheuristic/Paths.csv",header=T)
# Paths$Path is the pathnumber that is referenced in the RawData file; 1-15 are complete and 16-21 are incomplete.
# Paths$X and PathInfo$Y are the coordinates it travels

# Load training & testing folds
folds<-readMat("data/bscv_folds.mat")

# 1 means the final destination was lower-left. 2 means final destination was upper-right, and 0 means the final destination is undetermined (incomplete path)
# length(Destination)=78. It's a mapping from the paths subjects saw to the destination, not from path number to destination.
Destination<-c(1,2,1,2,1,1,2,1,2,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,2,1,1,1,1,1,1,1,1,2,1,1,2,1,1,2,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

# 1 means checked on left-side, 2 means checked on right side, 0 means didn't check
# Same as with the destination vector
Check<-c(1,1,2,2,0,1,1,2,2,0,1,1,2,2,0,1,2,0,1,2,0,1,2,0,2,2,0,2,2,0,2,2,0,2,0,2,0,2,0,1,1,0,1,1,0,1,1,0,1,0,1,0,1,0,1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,2,1,1,1,1,2,2,2,2)

# Group trials depending on their overall structure
#check - go back (G2 present)
group1 = c(1,6,11,40,43,46,3,8,13,25,28,31)
#check - stay (G2 present)
group2 = c(2,7,12,41,44,47,4,9,14,26,29,32)
#no check (G2 present)
group3 = c(5,10,15,42,45,48,27,30,33)
#check - go back (G2 absent)
group4 = c(16,19,22,49,51,53,17,20,23,34,36,38)
#no check (G2 absent)
group5 = c(18,21,24,50,52,54,35,37,39)
#check partial (G2 present)
group6 = c(55,63,71,57,65,73,59,67,75,61,69,77)
#check partial (G2 absent)
group7 = c(56,64,72,58,66,74,60,68,76,62,70,78)

conditions<-unique(RawData$Condition)

# General data manipulation -----------------------------------------------
  
# Extract path length of each path
Pathlen<-table(Paths[1])
RawData$PathLen<-as.numeric(Pathlen[RawData$Path])

# Arrange group vectors into data frame
Groups<-data.frame(
  trial<-c(group1,group2,group3,group4,group5,group6,group7),
  groups<-c(rep("G1",length(group1)),rep("G2",length(group2)),rep("G3",length(group3)),rep("G4",length(group4)),rep("G5",length(group5)),rep("G6",length(group6)),rep("G7",length(group7)))
)
names(Groups)<-c("trial","groups")

# Sort and reset rownames
Groups<-Groups[with(Groups, order(trial)),]
rownames(Groups) <- seq(length=nrow(Groups)) 

# Attach group membership to dataset
RawData$Group<-rep(rep(Groups$groups,max(RawData$Subject)),2)

# Mark factor varibles as factors for regression
RawData$Destination<-as.factor(Destination)
RawData$Check<-as.factor(Check)
RawData$Scenario<-as.factor(RawData$Scenario)
RawData$World<-as.factor(RawData$World)
RawData$Path<-as.factor(RawData$Path)

# Transform Scenario variable into markers of which sides of map are open
RawData$OpenLeft=as.numeric(RawData$Scenario!=2)
RawData$OpenRight=as.numeric(RawData$Scenario!=3)

# # Normalize Beliefs
# RawData$FullScore<-RawData$R1+RawData$R2+RawData$R3
# 
# RawData[which(RawData$type=="Belief"),]$R1<-RawData[which(RawData$type=="Belief"),]$R1/RawData[which(RawData$type=="Belief"),]$FullScore
# RawData[which(RawData$type=="Belief"),]$R2<-RawData[which(RawData$type=="Belief"),]$R2/RawData[which(RawData$type=="Belief"),]$FullScore
# RawData[which(RawData$type=="Belief"),]$R3<-RawData[which(RawData$type=="Belief"),]$R3/RawData[which(RawData$type=="Belief"),]$FullScore
# 
# RawData$FullScore<-NULL

# Replace World with a binary variable
RawData$World<-as.numeric(RawData$World)
RawData[which(RawData$World==2),]$World=rep(0,length(RawData[which(RawData$World==2),]$World))

# Distance matrices -------------------------------------------------------

# Load distance matrices
# World 1: O-shaped
d1<-read.csv("data/motionheuristic/DistanceMatrices/d1.csv",na.strings="Inf",header=F)
# Only keep distances from each point to lower-left spot (V1) and upper-right spot (V3)
d1<-d1[,c("V1","V75")]
# World 2: Inverse-C shaped
d2<-read.csv("data/motionheuristic/DistanceMatrices/d2.csv",na.strings="Inf",header=F)
d2<-d2[,c("V1","V75")]
# World 3: C-shaped
d3<-read.csv("data/motionheuristic/DistanceMatrices/d3.csv",na.strings="Inf",header=F)
d3<-d3[,c("V1","V75")]

# Add absolute state number to the path information frame
# State 30 is where he can check the upper spot on the right side (only visible in worlds 1 and 3).
# State 46 is where he can check the upper spot on the left side (only in worlds 1 and 2).
Paths$StateNo<-(Paths$Y-1)*15 + Paths$X

# Feature: Is harold going toward or away from the upper-right cart right after the check position

# Get distances to lower left spot from each state
Paths$LowerDistd1<-d1$V1[Paths$StateNo] # World 1
Paths$LowerDistd2<-d2$V1[Paths$StateNo] # World 2
Paths$LowerDistd3<-d3$V1[Paths$StateNo] # World 3

# Get distances to upper right spot from each state
Paths$UpperDistd1<-d1$V75[Paths$StateNo] # World 1
Paths$UpperDistd2<-d2$V75[Paths$StateNo] # World 2
Paths$UpperDistd3<-d3$V75[Paths$StateNo] # World 3

# Get average distance into a dataframe
AvDists<-data.frame(matrix(NA,nrow=max(Paths$Path),ncol=6))
names(AvDists)<-c("LowerDistd1","LowerDistd2","LowerDistd3","UpperDistd1","UpperDistd2","UpperDistd3")
# Calculate average distance change in each path
for (i in 1:max(Paths$Path)){
  TempData<-subset(Paths,Path==i)
  AvDists$LowerDistd1[i]<-mean(diff(TempData$LowerDistd1))
  AvDists$LowerDistd2[i]<-mean(diff(TempData$LowerDistd2))
  AvDists$LowerDistd3[i]<-mean(diff(TempData$LowerDistd3))
  AvDists$UpperDistd1[i]<-mean(diff(TempData$UpperDistd1))
  AvDists$UpperDistd2[i]<-mean(diff(TempData$UpperDistd2))
  AvDists$UpperDistd3[i]<-mean(diff(TempData$UpperDistd3))
}

# Fix data and add it into RawData

AvDists$Path<-seq(1:21)
AvDists<-melt(AvDists,id=c("Path"))
AvDists$Objective<-rep(c("Lower","Upper"),each=63)
AvDists$Scenario<-rep(rep(c(1,2,3),each=21),2)

RawData$LowerDistChange<-rep(1,dim(RawData)[1])
RawData$UpperDistChange<-rep(1,dim(RawData)[1])

for (i in 1:dim(RawData)[1]){
  CurrPath<-RawData[i,]$Path
  CurrScenario<-RawData[i,]$Scenario
  RawData$LowerDistChange[i]<-subset(AvDists,Objective=="Lower" & Path==CurrPath & Scenario==CurrScenario)$value
  RawData$UpperDistChange[i]<-subset(AvDists,Objective=="Upper" & Path==CurrPath & Scenario==CurrScenario)$value  
}


DirectionCounts<-data.frame(matrix(NA,nrow=max(Paths$Path),ncol=12))
names(DirectionCounts)<-c("TowardsLowerd1","AwayLowerd1","TowardsLowerd2","AwayLowerd2","TowardsLowerd3","AwayLowerd3",
                          "TowardsUpperd1","AwayUpperd1","TowardsUpperd2","AwayUpperd2","TowardsUpperd3","AwayUpperd3")
# Calculate average distance change in each path
for (i in 1:max(Paths$Path)){
  TempData<-subset(Paths,Path==i)
  DirectionCounts$TowardsLowerd1[i]<-length(which(diff(TempData$LowerDistd1)>0))
  DirectionCounts$AwayLowerd1[i]<-length(which(diff(TempData$LowerDistd1)<0))
  DirectionCounts$TowardsLowerd2[i]<-length(which(diff(TempData$LowerDistd2)>0))
  DirectionCounts$AwayLowerd2[i]<-length(which(diff(TempData$LowerDistd2)<0))
  DirectionCounts$TowardsLowerd3[i]<-length(which(diff(TempData$LowerDistd3)>0))
  DirectionCounts$AwayLowerd3[i]<-length(which(diff(TempData$LowerDistd3)<0))
  DirectionCounts$TowardsUpperd1[i]<-length(which(diff(TempData$UpperDistd1)>0))
  DirectionCounts$AwayUpperd1[i]<-length(which(diff(TempData$UpperDistd1)<0))
  DirectionCounts$TowardsUpperd2[i]<-length(which(diff(TempData$UpperDistd2)>0))
  DirectionCounts$AwayUpperd2[i]<-length(which(diff(TempData$UpperDistd2)<0))
  DirectionCounts$TowardsUpperd3[i]<-length(which(diff(TempData$UpperDistd3)>0))
  DirectionCounts$AwayUpperd3[i]<-length(which(diff(TempData$UpperDistd3)<0))
}

DirectionCounts$Path<-seq(1:21)
DirectionCounts<-melt(DirectionCounts,id=c("Path"))
DirectionCounts$Objective<-rep(c("Lower","Upper"),each=126)
DirectionCounts$Scenario<-rep(rep(c(1,2,3),each=42),2)
DirectionCounts$Direction<-rep(c("Towards","Away"),each=21)

RawData$LowerTowardsCount<-rep(1,dim(RawData)[1])
RawData$UpperTowardsCount<-rep(1,dim(RawData)[1])
RawData$LowerAwayCount<-rep(1,dim(RawData)[1])
RawData$UpperAwayCount<-rep(1,dim(RawData)[1])

for (i in 1:dim(RawData)[1]){
  CurrPath<-RawData[i,]$Path
  CurrScenario<-RawData[i,]$Scenario
  RawData$LowerTowardsCount[i]<-subset(DirectionCounts,Objective=="Lower" & Path==CurrPath & Scenario==CurrScenario & Direction=="Towards")$value
  RawData$UpperTowardsCount[i]<-subset(DirectionCounts,Objective=="Upper" & Path==CurrPath & Scenario==CurrScenario & Direction=="Towards")$value
  RawData$LowerAwayCount[i]<-subset(DirectionCounts,Objective=="Lower" & Path==CurrPath & Scenario==CurrScenario & Direction=="Away")$value
  RawData$UpperAwayCount[i]<-subset(DirectionCounts,Objective=="Upper" & Path==CurrPath & Scenario==CurrScenario & Direction=="Away")$value
}

# Build new towards/away data frame ---------------------------------------

SimpleData<-RawData
SimpleData$Scenario<-NULL
SimpleData$Path<-NULL
SimpleData$PathLen<-NULL
SimpleData$Destination<-NULL
SimpleData$Check<-NULL
SimpleData$OpenLeft<-NULL
SimpleData$OpenRight<-NULL
SimpleData$LowerTowardsCount<-NULL
SimpleData$UpperTowardsCount<-NULL
SimpleData$LowerAwayCount<-NULL
SimpleData$UpperAwayCount<-NULL

SimpleData<-melt(SimpleData,id=c("Subject","Condition","type","World","Group","LowerDistChange","UpperDistChange"))
names(SimpleData)[8]<-c("Truck")
names(SimpleData)[9]<-c("Value")

# Get the averages
# Remove trials where subjects answered 0 to everything (NaN in Belief normalization and 0 in Desires)
SimpleData<-SimpleData[-which(SimpleData$Value==0),]
#SimpleData<-SimpleData[-which(is.nan(SimpleData$Value)),]

SimpleData$I<-rep(0,dim(SimpleData)[1]) # Into
SimpleData$O<-rep(0,dim(SimpleData)[1]) # Other


# When World=0 there is nothing on the top spot.

# Desire regression -------------------------------------------------------

DesireData<-subset(SimpleData,type=="Desire")

# Into_R1 (K): approaching lower spot
DesireData[which(DesireData$Truck=="R1"),]$I<-DesireData[which(DesireData$Truck=="R1"),]$LowerDistChange
# Other_R1 (K): approaching upper spot when L is there
DesireData[which(DesireData$Truck=="R1" & DesireData$World==1),]$O<-DesireData[which(DesireData$Truck=="R1" & DesireData$World==1),]$UpperDistChange
## Other_R1 (K): approaching upper spot
#DesireData[which(DesireData$Truck=="R1"),]$O<-DesireData[which(DesireData$Truck=="R1"),]$UpperDistChange

# Into_R2 (L): approaching upper spot when L is there
DesireData[which(DesireData$Truck=="R2" & DesireData$World==1),]$I<-DesireData[which(DesireData$Truck=="R2" & DesireData$World==1),]$UpperDistChange
# Other_R2 (L): approaching lower spot
DesireData[which(DesireData$Truck=="R2"),]$O<-DesireData[which(DesireData$Truck=="R2"),]$LowerDistChange

# Other_R3 (M): approaching lower spot
DesireData[which(DesireData$Truck=="R3"),]$O<-DesireData[which(DesireData$Truck=="R3"),]$LowerDistChange
# Other_R3 (M): approaching upper spot when L is there
DesireData[which(DesireData$Truck=="R3" & DesireData$World==1),]$O<-DesireData[which(DesireData$Truck=="R3" & DesireData$World==1),]$O+DesireData[which(DesireData$Truck=="R3" & DesireData$World==1),]$UpperDistChange
## Into_R3 (M): approaching upper spot when N is there
#DesireData[which(DesireData$Truck=="R3" & DesireData$World==0),]$I<-DesireData[which(DesireData$Truck=="R3" & DesireData$World==0),]$UpperDistChange

DesireAvgData<-ddply(DesireData,c("Condition","Group","Truck","type"),function(df)c(mean(df$Value),mean(df$I),mean(df$O)))
names(DesireAvgData)[5:7]<-c("value","I","O")

DesireAvgData$f3<-rep(0,dim(DesireAvgData)[1]) # Mark if truck is R1
DesireAvgData$f4<-rep(0,dim(DesireAvgData)[1]) # Mark if truck is R2
DesireAvgData$f5<-rep(0,dim(DesireAvgData)[1]) # Mark if truck is R3

DesireAvgData[which(DesireAvgData$Truck=="R1"),]$f3=rep(1,dim(DesireAvgData[which(DesireAvgData$Truck=="R1"),])[1])
DesireAvgData[which(DesireAvgData$Truck=="R2"),]$f4=rep(1,dim(DesireAvgData[which(DesireAvgData$Truck=="R2"),])[1])
DesireAvgData[which(DesireAvgData$Truck=="R3"),]$f5=rep(1,dim(DesireAvgData[which(DesireAvgData$Truck=="R3"),])[1])

DesireAvgDataAll = DesireAvgData

# Remove irrational trials
DesireAvgData<-subset(DesireAvgData,!(Condition %in% c(11,12,22,71,72)));

DesireAvgDataGroup<-ddply(DesireAvgData,c("Group","Truck","type"),function(df)c(mean(df$value),mean(df$I),mean(df$O),mean(df$f3),mean(df$f4),mean(df$f5)));
names(DesireAvgDataGroup)[c(4,5,6,7,8,9)]<-names(DesireAvgData[c(5,6,7,8,9,10)])

DesireFit<-lm(value ~ I + O + f3 + f4, data=DesireAvgData)
cor.test(DesireFit$fitted.values,DesireAvgData$value) # 0.6388838 (0.5531625, 0.7112179)

DesireFitGroup<-lm(value ~ I + O + f3 + f4, data=DesireAvgDataGroup)
cor.test(DesireFitGroup$fitted.values,DesireAvgDataGroup$value) # 0.7696731 (0.5061629, 0.9017474)

DesirePred<-array(predict.lm(DesireFit,DesireAvgDataAll),dim=c(3,78))
DesirePredGroup<-array(predict.lm(DesireFitGroup,DesireAvgDataGroup),dim=c(3,7))


# Belief regression -------------------------------------------------------

BeliefData<-subset(SimpleData,type=="Belief")

# Into_R1 (L): approaching upper spot when L is there
BeliefData[which(BeliefData$Truck=="R1" & BeliefData$World==1),]$I<-BeliefData[which(BeliefData$Truck=="R1" & BeliefData$World==1),]$UpperDistChange
# Other_R1 (L): approaching lower spot
BeliefData[which(BeliefData$Truck=="R1"),]$O<-BeliefData[which(BeliefData$Truck=="R1"),]$LowerDistChange

# Other_R2 (M): approaching lower spot
BeliefData[which(BeliefData$Truck=="R2"),]$O<-BeliefData[which(BeliefData$Truck=="R2"),]$LowerDistChange
# Other_R2 (M): approaching upper spot when L is there
BeliefData[which(BeliefData$Truck=="R2" & BeliefData$World==1),]$O<-BeliefData[which(BeliefData$Truck=="R2" & BeliefData$World==1),]$O+BeliefData[which(BeliefData$Truck=="R2" & BeliefData$World==1),]$UpperDistChange
## Into_R2 (M): approaching upper spot when N is there
#BeliefData[which(BeliefData$Truck=="R2" & BeliefData$World==0),]$I<-BeliefData[which(BeliefData$Truck=="R2" & BeliefData$World==0),]$UpperDistChange

# Into_R3 (N): approaching lower spot
BeliefData[which(BeliefData$Truck=="R3"),]$I<-BeliefData[which(BeliefData$Truck=="R3"),]$LowerDistChange
# Other_R3 (N): approaching upper spot
BeliefData[which(BeliefData$Truck=="R3"),]$O<-BeliefData[which(BeliefData$Truck=="R3"),]$UpperDistChange

BeliefAvgData<-ddply(BeliefData,c("Condition","Group","Truck","type"),function(df)c(mean(df$Value),mean(df$I),mean(df$O)))
names(BeliefAvgData)[5:7]<-c("value","I","O")

BeliefAvgData$f3<-rep(0,dim(BeliefAvgData)[1]) # Mark if truck is R1
BeliefAvgData$f4<-rep(0,dim(BeliefAvgData)[1]) # Mark if truck is R2
BeliefAvgData$f5<-rep(0,dim(BeliefAvgData)[1]) # Mark if truck is R3

BeliefAvgData[which(BeliefAvgData$Truck=="R1"),]$f3=rep(1,dim(BeliefAvgData[which(BeliefAvgData$Truck=="R1"),])[1])
BeliefAvgData[which(BeliefAvgData$Truck=="R2"),]$f4=rep(1,dim(BeliefAvgData[which(BeliefAvgData$Truck=="R2"),])[1])
BeliefAvgData[which(BeliefAvgData$Truck=="R3"),]$f5=rep(1,dim(BeliefAvgData[which(BeliefAvgData$Truck=="R3"),])[1])

# Normalize
BeliefAvgData$value<-BeliefAvgData$value-1;
for (i in conditions)
{
  bsum<-sum(BeliefAvgData$value[BeliefAvgData$Condition==i])
  BeliefAvgData$value[BeliefAvgData$Condition==i]<-BeliefAvgData$value[BeliefAvgData$Condition==i]/bsum
}
  
BeliefAvgDataAll = BeliefAvgData

# Remove irrational trials
BeliefAvgData<-subset(BeliefAvgData,!(Condition %in% c(11,12,22,71,72)));

BeliefAvgDataGroup<-ddply(BeliefAvgData,c("Group","Truck","type"),function(df)c(mean(df$value),mean(df$I),mean(df$O),mean(df$f3),mean(df$f4),mean(df$f5)));
names(BeliefAvgDataGroup)[c(4,5,6,7,8,9)]<-names(BeliefAvgData[c(5,6,7,8,9,10)])

BeliefFit<-lm(value ~ I + O + f3 + f4, data=BeliefAvgData)
cor.test(BeliefFit$fitted.values,BeliefAvgData$value) # 0.7857317 (0.7291072, 0.8316723)

BeliefFitGroup<-lm(value ~ I + O + f3 + f4, data=BeliefAvgDataGroup)
cor.test(BeliefFitGroup$fitted.values,BeliefAvgDataGroup$value) # 0.841894 (0.6444070, 0.9340975)

BeliefPred<-array(predict.lm(BeliefFit,BeliefAvgDataAll),dim=c(3,78))
BeliefPredGroup<-array(predict.lm(BeliefFitGroup,BeliefAvgDataGroup),dim=c(3,7))

# Save predictions
writeMat("data/motionheuristic/motionheuristic_results_complete.mat",belief_model=BeliefPred,desire_model=DesirePred,belief_model_group=BeliefPredGroup,desire_model_group=DesirePredGroup)


# Bootstrap ---------------------------------------------------------------
#   Select random disjoint training and testing subsets of all 78*3 datapoints for both Belief and Desire
#   For the grouped analysis, average the training and testing data by Group and Truck

set.seed(45098)
samples=100000
Desireboot<-NULL
Beliefboot<-NULL
DesirebootGroup<-NULL
BeliefbootGroup<-NULL

conditions<-unique(DesireAvgData$Condition);
unique.groups<-unique(groups)
Cut<-round((4/7)*length(conditions)) # 2/3 of 73 conditions
CutG<-round((4/7)*7) # 2/3 of 7 groups

for (i in 1:samples){
  #trainset<-sample(1:length(conditions),Cut)
  trainset<-folds$train.folds[i,]
  TrainD<-subset(DesireAvgData,(Condition %in% conditions[trainset]))
  TrainB<-subset(BeliefAvgData,(Condition %in% conditions[trainset]))
  TestD<-subset(DesireAvgData,!(Condition %in% conditions[trainset]))
  TestB<-subset(BeliefAvgData,!(Condition %in% conditions[trainset]))
  Dfit<-lm(value ~ I + O + f3 + f4, data=TrainD)
  Bfit<-lm(value ~ I + O + f3 + f4, data=TrainB)
  TestD$predictedValue<-predict.lm(Dfit,TestD)
  TestB$predictedValue<-predict.lm(Bfit,TestB)
  Desireboot[i]<-cor(TestD$predictedValue,TestD$value)
  Beliefboot[i]<-cor(TestB$predictedValue,TestB$value)
  
  #trainsetG<-sample(1:7,CutG)
  trainsetG<-folds$train.folds.g[i,]
  TrainDG<-subset(DesireAvgDataGroup,(Group %in% unique.groups[trainsetG]))
  TrainBG<-subset(BeliefAvgDataGroup,(Group %in% unique.groups[trainsetG]))
  TestDG<-subset(DesireAvgDataGroup,!(Group %in% unique.groups[trainsetG]))
  TestBG<-subset(BeliefAvgDataGroup,!(Group %in% unique.groups[trainsetG]))
  DfitG<-lm(value ~ I + O + f3 + f4, data=TrainDG)
  BfitG<-lm(value ~ I + O + f3 + f4, data=TrainBG)
  TestDG$predictedValue<-predict.lm(DfitG,TestDG)
  TestBG$predictedValue<-predict.lm(BfitG,TestBG)
  DesirebootGroup[i]<-cor(TestDG$predictedValue,TestDG$value)
  BeliefbootGroup[i]<-cor(TestBG$predictedValue,TestBG$value)
  
}


mean(Desireboot)
t.test(Desireboot)$conf.int # Use only to look at 95% CI
mean(Beliefboot)
t.test(Beliefboot)$conf.int

mean(DesirebootGroup)
t.test(DesirebootGroup)$conf.int # Use only to look at 95% CI
mean(BeliefbootGroup)
t.test(BeliefbootGroup)$conf.int


Desirebootsort<-sort(Desireboot)
Beliefbootsort<-sort(Beliefboot)

DesirebootsortGroup<-sort(DesirebootGroup)
BeliefbootsortGroup<-sort(BeliefbootGroup)

Desirebootsort[round(c(.025*samples,.5*samples,.975*samples))]
Beliefbootsort[round(c(.025*samples,.5*samples,.975*samples))]
DesirebootsortGroup[round(c(.025*samples,.5*samples,.975*samples))]
BeliefbootsortGroup[round(c(.025*samples,.5*samples,.975*samples))]

writeMat("data/motionheuristic/motionheuristic_bscv.mat",belief_bscv=Beliefboot,desire_bscv=Desireboot,belief_group_bscv=BeliefbootGroup,desire_group_bscv=DesirebootGroup)
