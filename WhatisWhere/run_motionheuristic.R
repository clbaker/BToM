# run_motionheuristic.R

rm(list = ls(all = TRUE)) 

# load all libraries
library(ggplot2)
library(reshape2)
library(plyr)
library(lme4)
library(nnet)
library(reshape2)
library(R.matlab)

setwd("~/Research/src/BToM/WhatisWhere")
RawData<-read.csv("Data/carts-mean.csv",header=T)
folds<-readMat("Data/bscv_folds.mat")

# Re-sort conditions
completes<-c(1,3,11,5,7,15,6,14,16)+3
incompletes<-c(4,10,2,12,8,13,9)+3
RealOrder<-c(1,2,3,completes,incompletes)

RawData<-RawData[RealOrder,]
RawData$path<-rep(1:19)
#1 is left, 2 is middle, 3 is right, 0 is incomplete.
Destination<-c(2,3,1,2,3,1,2,2,2,1,3,1,0,0,0,0,0,0,0)

PathLen<-c(1,3,8,1,3,4,5,11,7,8,9,14,1,1,3,4,5,7,10)
LeftChange<- c(-1,-3,-2+6,-1,-3, 4,-3+2,-6+5, 3-4,-2+6, 3-6, 9-5,  -1, 1,-2+1, 3-1,-2+3, 3-4,-5+5)
TopChange<-  c( 1,-3,-6+2, 1,-3,-4,-2+3,-5+6,-3+4,-6+2,-6+3,-9+5,  -1,-1,-2+1,-3+1,-3+2,-4+3,-5+5)
RightChange<-c(-1, 3, 2-6,-1, 3,-4, 2-3, 5-6,-4+3, 2-6,-3+6,-3+5-6, 1,-1, 2-1,-3+1, 2-3,-3+4,+2-5+3)

AvChangeLeft<-LeftChange/PathLen
AvChangeRight<-RightChange/PathLen
AvChangeTop<-TopChange/PathLen

RawData$AvChangeLeft<-AvChangeLeft
RawData$AvChangeRight<-AvChangeRight
RawData$AvChangeTop<-AvChangeTop

names(RawData)[1:6]<-c("cab","bac","cba","abc","bca","acb")

RegressionData<-melt(RawData,id=c("path","AvChangeLeft","AvChangeRight","AvChangeTop"))

RegressionData$A<-rep(0,dim(RegressionData)[1]) # Going towards A
RegressionData$B<-rep(0,dim(RegressionData)[1]) # Going towards B
RegressionData$C<-rep(0,dim(RegressionData)[1]) # Going towards C
  
# in cab, and bac. A is AvChangeTop
RegressionData[which(RegressionData$variable=="cab" | RegressionData$variable=="bac"),]$A=RegressionData[which(RegressionData$variable=="cab" | RegressionData$variable=="bac"),]$AvChangeTop
# in abc, and acb. A is AvChangeLeft
RegressionData[which(RegressionData$variable=="abc" | RegressionData$variable=="acb"),]$A=RegressionData[which(RegressionData$variable=="abc" | RegressionData$variable=="acb"),]$AvChangeLeft
# in cba and bca. A is AvChange Right
RegressionData[which(RegressionData$variable=="cba" | RegressionData$variable=="bca"),]$A=RegressionData[which(RegressionData$variable=="cba" | RegressionData$variable=="bca"),]$AvChangeRight

# in abc, and cba. B is AvChangeTop
RegressionData[which(RegressionData$variable=="abc" | RegressionData$variable=="cba"),]$B=RegressionData[which(RegressionData$variable=="cba" | RegressionData$variable=="abc"),]$AvChangeTop
# in bac, and bca. B is AvChangeLeft
RegressionData[which(RegressionData$variable=="bac" | RegressionData$variable=="bca"),]$B=RegressionData[which(RegressionData$variable=="bca" | RegressionData$variable=="bac"),]$AvChangeLeft
# in cab and cba. B is AvChange Right
RegressionData[which(RegressionData$variable=="cab" | RegressionData$variable=="acb"),]$B=RegressionData[which(RegressionData$variable=="cab" | RegressionData$variable=="acb"),]$AvChangeRight

# in acb, and bca. C is AvChangeTop
RegressionData[which(RegressionData$variable=="acb" | RegressionData$variable=="bca"),]$C=RegressionData[which(RegressionData$variable=="acb" | RegressionData$variable=="bca"),]$AvChangeTop
# in cba, and cab. C is AvChangeLeft
RegressionData[which(RegressionData$variable=="cba" | RegressionData$variable=="cab"),]$C=RegressionData[which(RegressionData$variable=="cab" | RegressionData$variable=="cba"),]$AvChangeLeft
# in abc and bac. C is AvChange Right
RegressionData[which(RegressionData$variable=="abc" | RegressionData$variable=="bac"),]$C=RegressionData[which(RegressionData$variable=="abc" | RegressionData$variable=="bac"),]$AvChangeRight

# Different intercepts
RegressionData$abc<-rep(0,dim(RegressionData)[1])
RegressionData$acb<-rep(0,dim(RegressionData)[1])
RegressionData$bca<-rep(0,dim(RegressionData)[1])
RegressionData$bac<-rep(0,dim(RegressionData)[1])
RegressionData$cba<-rep(0,dim(RegressionData)[1])
RegressionData$cab<-rep(0,dim(RegressionData)[1])

RegressionData[which(RegressionData$variable=="abc"),]$abc=rep(1,19)
RegressionData[which(RegressionData$variable=="acb"),]$acb=rep(1,19)
RegressionData[which(RegressionData$variable=="bac"),]$bac=rep(1,19)
RegressionData[which(RegressionData$variable=="bca"),]$bca=rep(1,19)
RegressionData[which(RegressionData$variable=="cab"),]$cab=rep(1,19)
RegressionData[which(RegressionData$variable=="cba"),]$cba=rep(1,19)

value.mat <- matrix(RegressionData$value,ncol=6)
RegressionData$value.norm <- as.vector(sweep(value.mat, 1, rowSums(value.mat), FUN="/"))

fit<-lm(value ~ A + B + C + abc + acb + bca + bac + cba + cab, data=RegressionData)

worldInf <- matrix(fit$fitted.values,ncol=6)
worldInf.norm <- sweep(worldInf, 1, rowSums(worldInf), FUN="/")
#fit<-lm(value ~ A + B + C, data=RegressionData)
cor.test(as.vector(worldInf.norm),RegressionData$value.norm) # 0.3384451 (0.1647876 0.4917509)

# Bootstrap them
#set.seed(593847)
samples=100000
bootres<-NULL
Cut<-13 # 2/3 of data.
for (i in 1:samples){
  #trainset<-sample(1:19,Cut)
  trainset<-folds$train.folds[i,]
  Train<-subset(RegressionData,(path %in% trainset))
  Test<-subset(RegressionData,!(path %in% trainset))
  #Bfit<-lm(value ~ A + B + C + abc + acb + bca + bac + cba + cab, data=Train)
  #Bfit<-lm(value ~ A + B + C + abc + acb + bca + bac + cba, data=Train)
  Bfit<-lm(value.norm ~ A + B + C + abc + acb + bca + bac + cba, data=Train)
  Bpred<-matrix(predict.lm(Bfit,Test),ncol=6);
  Bpred.norm<-sweep(Bpred, 1, rowSums(Bpred), FUN="/")
  bootres[i]<-cor(as.vector(Bpred.norm),Test$value.norm)
}

mean(bootres) #0.1198264 (0.1172252 0.1224277)
t.test(bootres)$conf.int # Use only to look at 95% CI


bootressort<-sort(bootres)
bootressort[round(c(.025*samples,.5*samples,.975*samples))]

writeMat("Data/MotionHeuristic/results.mat",results=worldInf.norm)
writeMat("Data/MotionHeuristic/results_bscv.mat",r_bscv=bootres)
