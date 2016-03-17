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
r.itemInfo <- matrix(data=NA, nr=length(roi_name), nc=9)
for (i in 1:length(roi_name)){
#i=1
## read data
#get data for each trial
item_file <- paste(basedir,"/ROI_based_RSM/ref_space/me/data/",roi_name[i],".mat",sep="")
t <- readMat(item_file)
item_data <- as.data.frame(t$all)
#item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c('subid','wid','ev','lag','ev_lag','mem','nmem',
'act1','act2','act','ps'); 
item_data$subid <- as.factor(item_data$subid)
item_data$wid <- as.factor(item_data$wid)
item_data$ev <- as.factor(item_data$ev)
item_data$lag <- as.factor(item_data$lag)
item_data$ev_lag <- as.factor(item_data$ev_lag)
item_data$mem <- as.factor(item_data$mem)
titem_data <- subset(item_data,mem!=0)

act.null <- glmer(mem~ps+(act+ps|subid)+(act+ps|wid),data=titem_data,family='binomial')
act <- glmer(mem~act+ps+(act+ps|subid)+(act+ps|wid),data=titem_data,family='binomial')
mainEffect.lag <- anova(act,act.null)
r.itemInfo[i,1]=mainEffect.lag[2,6]
r.itemInfo[i,2]=mainEffect.lag[2,7]
r.itemInfo[i,3]=mainEffect.lag[2,8]
r.itemInfo[i,4]=fixef(act)[2];

ps.null <- glmer(mem~act+(ps+act|subid)+(ps+act|wid),data=titem_data,family='binomial')
ps <- glmer(mem~ps+act+(ps+act|subid)+(ps+act|wid),data=titem_data,family='binomial')
mainEffect.lag <- anova(ps,ps.null)
r.itemInfo[i,6]=mainEffect.lag[2,6]
r.itemInfo[i,7]=mainEffect.lag[2,7]
r.itemInfo[i,8]=mainEffect.lag[2,8]
r.itemInfo[i,9]=fixef(ps)[2];
}
write.matrix(r.itemInfo,file=paste("mem_nidx_unique.txt",sep=""),sep="\t")
#write.matrix(r.itemInfo,file=paste("mem_nidx_",roi_name[i],".txt",sep=""),sep="\t")
