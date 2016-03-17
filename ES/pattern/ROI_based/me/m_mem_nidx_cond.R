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
roi_name <- c('LVVC','LPHG')
r.itemInfo <- matrix(data=NA, nr=length(roi_name), nc=9)
for (i in 1:length(roi_name)){
#i=1
## read data
#get data for each trial
item_file <- paste(basedir,"/ROI_based_RSM/ref_space/me/data/",roi_name[i],".mat",sep="")
t <- readMat(item_file)
item_data <- as.data.frame(t$all)
#item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c('subid','wid','ev','lag','ev_lag','mem','nmem','act1','act2','act','ps'); 
item_data$subid <- as.factor(item_data$subid)
item_data$wid <- as.factor(item_data$wid)
item_data$ev <- as.factor(item_data$ev)
item_data$lag <- as.factor(item_data$lag)
item_data$ev_lag <- as.factor(item_data$ev_lag)
item_data$mem <- as.factor(item_data$mem)
titem_data <- subset(item_data,mem!=0)
data <- titem_data
data$ps <- scale(titem_data$ps)

cdata <- subset(data,ev==1)
yx <- glmer(mem~lag+ps+(1|subid),data=cdata,family='binomial')
mx <- lmer(ps~lag+(1|subid),REML=FALSE,data=cdata)
ym <- glmer(mem~ps+(1|subid),data=cdata,family='binomial')
apath <- fixef(mx)["lag2"]
bpath <- fixef(yx)["ps"]
sea <- sqrt(vcov(mx)["lag2","lag2"])
seb <- sqrt(vcov(yx)["ps","ps"])
library(lavaan)
library(RMediation)
medci(mu.x=apath,mu.y=bpath,se.x=sea,se.y=seb,rho=0,alpha=0.1,type='all')
list(apath,bpath,sea,seb)

mdata <- subset(data,lag==2)
yx <- glmer(mem~ev+ps+(1|subid),data=mdata,family='binomial')
mx <- lmer(ps~ev+(1|subid),REML=FALSE,data=mdata)
ym <- glmer(mem~ps+(1|subid),data=mdata,family='binomial')
apath <- fixef(mx)["ev2"]
bpath <- fixef(yx)["ps"]
sea <- sqrt(vcov(mx)["ev2","ev2"])
seb <- sqrt(vcov(yx)["ps","ps"])
library(lavaan)
library(RMediation)
medci(mu.x=apath,mu.y=bpath,se.x=sea,se.y=seb,rho=0,alpha=0.1,type='all')
list(apath,bpath,sea,seb)
}
