########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L7_CombineWidedataframes
setwd(x)
getwd()

library(pacman)
p_load(reshape2,
       ez,
       lme4,
       lmerTest,
       ggplot2,
       grid,
       tidyr,
       plyr,
       dplyr,
       effects,
       gridExtra,
       DescTools,
       Cairo, #alternate image writing package with superior performance.
       corrplot,
       knitr,
       PerformanceAnalytics,
       afex,
       ggpubr,
       readxl,
       officer,
       psych,
       rstatix,
       emmeans,
       standardize,
       performance,stringr,
       export,
       data.table)
# p_load(psych,plyr,psych,MCMCpack)

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L7_CombineWidedataframes\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L7_CombineWidedataframes\\"



########################### LoadData #################
dat    = read.csv(paste(RD,"Word_task_september22.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

data_Corr      = read.csv(paste(RD,"datWide_RSAnoBL.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$ID = as.numeric(gsub("S","",data_Corr$Subj))
data_Corr = data_Corr[,!names(data_Corr)=="Subj"]
dat = merge(dat,data_Corr, by = "ID" , all.x = T)

data_Corr      = read.csv(paste(RD,"datWide_RSAwBL.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$ID = as.numeric(gsub("S","",data_Corr$Subj))
data_Corr = data_Corr[,!names(data_Corr)=="Subj"]
dat = merge(dat,data_Corr, by = "ID", all.x = T)

data_Corr      = read.csv(paste(RD,"datWide_RSAwBLCollapsed.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$ID = as.numeric(gsub("S","",data_Corr$Subj))
data_Corr = data_Corr[,!names(data_Corr)=="Subj"]
dat = merge(dat,data_Corr, by = "ID", all.x = T)

data_Corr      = read.csv(paste(RD,"ConnectivityScores.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$ID = as.numeric(gsub("S","",data_Corr$Subj))
data_Corr = data_Corr[,!names(data_Corr)=="Subj"]
dat = merge(dat,data_Corr, by = "ID", all.x = T)


write.csv(dat, paste(WD,"Word_task_september22_wRSAandConnectivity.csv",sep="") , row.names = F , na = "")
