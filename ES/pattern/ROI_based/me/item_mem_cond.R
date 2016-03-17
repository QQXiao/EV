#!usr/bin/env Rscript
#install.packages("R.matlab")
library(methods)
library(Matrix)
library(MASS)
#library(Rcpp)
library(lme4)
library(R.matlab)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ES")
resultdir <- paste(basedir,"ROI_based_RSM/ref_space/me/results",sep="/")
setwd(resultdir)
roi_name <- c('LVVC','LIFG','LMFG','LPHG','RVVC','RPHG')
r.itemInfo <- matrix(data=NA, nr=5, nc=4)
#for (i in 1:length(roi_name)){
i=1
## read data
#get data for each trial
item_file <- paste(basedir,"/ROI_based_RSM/ref_space/me/data/",roi_name[i],".mat",sep="")
t <- readMat(item_file)
item_data <- as.data.frame(t$all)
#item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c('subid','wid','ev','lag','ev_lag','mem','nmem',
'act1','act2','actmean','rsa'); 
item_data$subid <- as.factor(item_data$subid)
item_data$wid <- as.factor(item_data$wid)
item_data$ev <- as.factor(item_data$ev)
item_data$lag <- as.factor(item_data$lag)
item_data$ev_lag <- as.factor(item_data$ev_lag)
item_data$mem <- as.factor(item_data$mem)
titem_data <- subset(item_data,mem!=0)

cdata <- subset(titem_data,ev==1)
lag.null <- glmer(mem~1+(1|subid)+(1|wid),data=cdata,family='binomial')
lag <- glmer(mem~lag+(1|subid)+(1|wid),data=cdata,family='binomial')
mainEffect.lag <- anova(lag,lag.null)
r.itemInfo[1,1]=mainEffect.lag[2,6]
r.itemInfo[1,2]=mainEffect.lag[2,7]
r.itemInfo[1,3]=mainEffect.lag[2,8]
r.itemInfo[1,4]=fixef(lag)[2];

mdata <- subset(titem_data,lag==1)
mev.null <- glmer(mem~1+(1|subid)+(1|wid),data=mdata,family='binomial')
mev <- glmer(mem~ev+(1|subid)+(1|wid),data=mdata,family='binomial')
mainEffect.mev <- anova(mev,mev.null)
r.itemInfo[2,1]=mainEffect.mev[2,6]
r.itemInfo[2,2]=mainEffect.mev[2,7]
r.itemInfo[2,3]=mainEffect.mev[2,8]
r.itemInfo[2,4]=fixef(mev)[2];

sdata <- subset(titem_data,lag==2)
sev.null <- glmer(mem~1+(1|subid)+(1|wid),data=sdata,family='binomial')
sev <- glmer(mem~ev+(1|subid)+(1|wid),data=sdata,family='binomial')
mainEffect.sev <- anova(sev,sev.null)
r.itemInfo[3,1]=mainEffect.sev[2,6]
r.itemInfo[3,2]=mainEffect.sev[2,7]
r.itemInfo[3,3]=mainEffect.sev[2,8]
r.itemInfo[3,4]=fixef(sev)[2];

lag.null <- glmer(mem~1+(1|subid)+(1|wid),data=titem_data,family='binomial')
lag <- glmer(mem~lag+(1|subid)+(1|wid),data=titem_data,family='binomial')
mainEffect.lag <- anova(lag,lag.null)
r.itemInfo[4,1]=mainEffect.lag[2,6]
r.itemInfo[4,2]=mainEffect.lag[2,7]
r.itemInfo[4,3]=mainEffect.lag[2,8]
r.itemInfo[4,4]=fixef(lag)[2];

mev.null <- glmer(mem~1+(1|subid)+(1|wid),data=titem_data,family='binomial')
mev <- glmer(mem~ev+(1|subid)+(1|wid),data=titem_data,family='binomial')
mainEffect.mev <- anova(mev,mev.null)
r.itemInfo[5,1]=mainEffect.mev[2,6]
r.itemInfo[5,2]=mainEffect.mev[2,7]
r.itemInfo[5,3]=mainEffect.mev[2,8]
r.itemInfo[5,4]=fixef(mev)[2];

write.matrix(r.itemInfo,file=paste("mem_cond.txt",sep=""),sep="\t")
#write.matrix(r.itemInfo,file=paste("mem_cond_",roi_name[i],".txt",sep=""),sep="\t")
