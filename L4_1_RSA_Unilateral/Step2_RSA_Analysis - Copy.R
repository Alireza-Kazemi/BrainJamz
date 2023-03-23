########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L4_1_RSA_Unilateral
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

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_1_RSA_Unilateral\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_1_RSA_Unilateral\\"

########################### Functions -----
RemoveOutliers <- function(dataFrame,factorNames,varName,Criteria=3){
  datTemp = dataFrame[,c(factorNames,varName)]
  Conds = NULL
  for (condName in factorNames){
    Conds = paste(Conds,datTemp[,condName],sep = "_")    
  }
  
  for (condName in unique(Conds)){
    X = datTemp[Conds==condName,varName]
    X[abs((X-mean(X,na.rm = TRUE))/sd(X,na.rm = TRUE))>Criteria]=NA
    dataFrame[Conds==condName,varName] = X
  }
  return(dataFrame)
}

########################### SRCD Correlation Graphs #################
dat      = read.csv(paste(RD,"SRCDForJamovi.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

ggplot()+
  # geom_line(data=d2,aes(x = age, y = M),lwd=1, color= "blue",alpha=0.5)+
  # geom_point(data=d2,aes(x = age, y = M),size=3, color= "blue",alpha=0.5)+
  geom_line(data=dat,aes(age, fit),lwd=1, linetype="dotted", color= "blue")+
  geom_point(data=d1,aes(age, fit),size=2, color= "blue")+
  geom_errorbar(data=d1,aes(x=age, ymin=lower, ymax=upper), color= "blue",width = 0.05,size = .8)+
  theme_bw(base_family = "serif")+
  labs(x="Age",y="Agree", size=16)+
  theme(axis.title.y = element_text(size = 16))+
  theme(axis.title.x = element_text(size = 16))+
  theme(axis.text.x = element_text(size = 16))+
  theme(axis.text.y = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  scale_x_continuous(breaks=c(5,7,9))+
  ylim(0.5,.95)+
  scale_fill_grey()