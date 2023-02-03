########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\MyFiles\MyFiles\PhD Research\MRI Serious\BrainJamz\RSA_Data_Jan23
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
       export)






########################### BetaImages Between Condition HPC ##########################
data_Corr      = read.csv("RSA_BlockBased_Song.csv",sep = ",",header=TRUE,strip.white=TRUE)
sDat = data_Corr
sDat = sDat[sDat$Mask=="HPC",]
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$group %in% c("Replication","Extension"),]

sDat$Conditions = factor(sDat$Conditions, levels =  c( "target_reverse","reverse_novel","target_novel"))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions )) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  # facet_wrap(~group)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

########################### BetaImages Between Condition HPC ##########################
data_Corr      = read.csv("RSA_BlockBased_Word.csv",sep = ",",header=TRUE,strip.white=TRUE)
sDat = data_Corr
sDat = sDat[sDat$Mask=="HPC",]
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_Known", "target_Unknown", "Known_Unknown"),] #, "target_baseline"


sDat$Conditions = factor(sDat$Conditions, levels =  c("target_Known", "target_Unknown", "target_baseline", "Known_Unknown"),
                                          labels =c("Target_Known", "Target_Unknown", "Target_Baseline", "Known_Unknown"))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions )) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

