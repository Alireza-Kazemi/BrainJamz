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

head(dat)

corr.test(dat$MacWord,dat$HPC_target_known_BB_Left)
correlation::cor_test(dat, x = "MacWord",y = "HPC_target_known_BB")

ggplot(data=dat,aes(x = MacWord, y = HPC_target_known_BB_Left))+
  geom_point(size=2)+
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth")+
  theme_bw(base_family = "serif")+
  labs(x="Productive Vocabulary Score",y="Target_Known Similarity", size=16)+
  theme(axis.title.y = element_text(size = 16))+
  theme(axis.title.x = element_text(size = 16))+
  theme(axis.text.x = element_text(size = 16))+
  theme(axis.text.y = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())



ggplot(data=dat,aes(x = Initial_Learning, y = HPC_target_known_BE_Left))+
  geom_point(size=2)+
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth")+
  theme_bw(base_family = "serif")+
  labs(x="Memory for Target Words",y="Target_Known Similarity", size=16)+
  theme(axis.title.y = element_text(size = 16))+
  theme(axis.title.x = element_text(size = 16))+
  theme(axis.text.x = element_text(size = 16))+
  theme(axis.text.y = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())


ggplot(data=dat,aes(x = MacWord, y = HPC_target_unknown_PME))+
  geom_point(size=2)+
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth")+
  theme_bw(base_family = "serif")+
  labs(x="Productive Vocabulary Score",y="Target_UnKnown Similarity", size=16)+
  theme(axis.title.y = element_text(size = 16))+
  theme(axis.title.x = element_text(size = 16))+
  theme(axis.text.x = element_text(size = 16))+
  theme(axis.text.y = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

