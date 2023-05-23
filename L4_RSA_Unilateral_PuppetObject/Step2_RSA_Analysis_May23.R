########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L4_RSA_Unilateral_PuppetObject
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

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObject\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObject\\"

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

########################### LoadData #################
#-------------- WordData
data_Corr      = read.csv(paste(RD,"Word_BlockBased_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordBB = data_Corr

data_Corr      = read.csv(paste(RD,"Word_BlockEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$blockCond = factor(data_Corr$blockCond,
                            levels = sort(unique(data_Corr$blockCond)))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordBE = data_Corr


data_Corr      = read.csv(paste(RD,"Word_MicroEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr = data_Corr[data_Corr$Time1==data_Corr$Time2,]
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordME = data_Corr


data_Corr      = read.csv(paste(RD,"Word_PermMicroEvents_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr = data_Corr[data_Corr$Perm1 == data_Corr$Perm2,]
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordPME = data_Corr


data_Corr      = read.csv(paste(RD,"Word_PermMEBSD_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr = data_Corr[data_Corr$Perm1 == data_Corr$Perm2,]
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordPMEBSD = data_Corr

########################### Word BlockBased Between Conditions All Masks ##########################
sDat = WordBB
unique(sDat$Conditions)
head(sDat)
# sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),N=n(), CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


sDat$ZscoredValue = FisherZ(sDat$CorrVal)

Mask = "aMPFCSphere"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


Mask = "aMTL"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "Auditory"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

########################### Word BlockEvent Within Condition All Masks ##########################
sDat = WordBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known", "puppet", "object", "novel"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))


ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


sDat$ZscoredValue = FisherZ(sDat$CorrVal)

Group = "Replication"
Mask = "HPC"
cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Group = "Replication"
Mask = "aMPFCSphere"
cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

########################### Word BlockEvent Between Condition All Masks ##########################
sDat = WordBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


sDat$ZscoredValue = FisherZ(sDat$CorrVal)


Group = "Replication"
Mask = "HPC"
cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Group = "Replication"
Mask = "aMPFCSphere"
cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


########################### Word MicroEvents Between Condition All Masks ##########################
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


########################### Word MicroEvents Between Conditions Temporal Change All Masks ##########################
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Time = sDat$Time1
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,Time),N=n(),CorrVal = mean(CorrVal,na.rm = T)))


ggplot(sDat,aes(x=Time,y=CorrVal,colour=Conditions)) +
  geom_line(stat="summary",fun="mean",position=position_dodge(width = 0.5),linewidth = 2) +
  # stat_summary(fun.data = "mean_se", geom="errorbar",position = position_dodge(width = 0.5), alpha = 0.5, linewidth=1)+
  facet_grid(Hemisphere~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Time),N=n(),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Time,y=CorrVal,colour=Conditions)) +
  geom_line(stat="summary",fun="mean",position=position_dodge(width = 0.5),linewidth = 2) +
  # stat_summary(fun.data = "mean_se", geom="errorbar",position = position_dodge(width = 0.5), alpha = 0.5, linewidth=1)+
  facet_wrap(~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())



########################### Word PermMicroEvents Between Condition All Masks ##########################
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))


ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


########################### Word PermMeBSD Within Condition All Masks ##########################
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known", "puppet", "object", "novel"),]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
unique(sDat$blockCond)
sDat = sDat[sDat$blockCond %in% c("1_2","2_3"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = WordCond)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Hemisphere~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

sDat$ZscoredValue = FisherZ(sDat$CorrVal)
Mask = "HPC"
Hem = "Left"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target" & sDat$Hemisphere == Hem
cond2 = sDat$Mask == Mask & sDat$Conditions == "known" & sDat$Hemisphere == Hem
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "known" & sDat$Hemisphere == Hem
cond2 = sDat$Mask == Mask & sDat$Conditions == "unknown" & sDat$Hemisphere == Hem
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

#-----------Collapse conditions
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known", "puppet", "object", "novel"),]
sDat$Conditions = factor(sDat$Conditions, levels=c("known", "puppet", "object", "novel"),
                                          labels = c("known","learned","learned","novel"))
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))



########################### Word PermMeBSD Within only Both words Condition All Masks ##########################
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known", "puppet", "object", "novel"),]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
unique(sDat$blockCond)
sDat = sDat[sDat$WordCond=="Both",]
# sDat = sDat[sDat$blockCond %in% c("1_2","2_3"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

sDat$ZscoredValue = FisherZ(sDat$CorrVal)
Mask = "HPC"
Hem = "Left"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target" & sDat$Hemisphere == Hem
cond2 = sDat$Mask == Mask & sDat$Conditions == "known" & sDat$Hemisphere == Hem
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "known" & sDat$Hemisphere == Hem
cond2 = sDat$Mask == Mask & sDat$Conditions == "unknown" & sDat$Hemisphere == Hem
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

#-----------Collapse conditions
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known", "puppet", "object", "novel"),]
sDat$Conditions = factor(sDat$Conditions, levels=c("known", "puppet", "object", "novel"),
                         labels = c("known","learned","learned","novel"))
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))



########################### Word PermMeBSD Between Condition All Masks ##########################
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
unique(sDat$blockCond)
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,WordCond,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = WordCond)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Hemisphere~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))




#-----------Collapse WordConds
sDat = WordPMEBSD
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
unique(sDat$blockCond)
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)

ggplot(sDat,aes(x=Hemisphere, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


########################### Word across Methods May 2023 ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordME = sDat
datWordME$Method = unique("Micro-Event")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPME = sDat
datWordPME$Method = unique("PermME")

sDat = WordPMEBSD
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPMEBSD = sDat
datWordPMEBSD$Method = unique("PermMEBSD")

sDat = rbind(datWordBB,datWordBE,datWordME,datWordPME,datWordPMEBSD)

sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Micro-Event","PermME","PermMEBSD"))
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                                           labels = c("known_puppet", "known_object","puppet_object",
                                                      "known_novel", "puppet_novel", "object_novel"))


ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Mask~Method)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")



########################### Word across Methods May 2023 ReScaled ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordME = sDat
datWordME$Method = unique("Micro-Event")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordPME = sDat
datWordPME$Method = unique("PermME")

sDat = WordPMEBSD
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat = sDat[sDat$WordCond == "Both",]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordPMEBSD = sDat
datWordPMEBSD$Method = unique("PermMEBSD")

# sDat = rbind(datWordBB,datWordBE,datWordME,datWordPME,datWordPMEBSD)
sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMEBSD)

sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Micro-Event","PermME","PermMEBSD"))
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_puppet", "known_object","puppet_object",
                                    "known_novel", "puppet_novel", "object_novel"))


ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Mask~Method)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")




########################### Word across Methods Collapsed Conditions May 2023 ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,Time1),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordME = sDat
datWordME$Method = unique("Micro-Event")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPME = sDat
datWordPME$Method = unique("PermME")

sDat = WordPMEBSD
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))

sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond,WordCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPMEBSD = sDat
datWordPMEBSD$Method = unique("PermMEBSD")

sDat = rbind(datWordBB,datWordBE,datWordME,datWordPME,datWordPMEBSD)

sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Micro-Event","PermME","PermMEBSD"))
sDat$Conditions = factor(sDat$Conditions, levels = c("known_learned","learned",
                                                     "known_novel", "learned_novel"))


ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Mask~Method)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")


########################### Word across Methods Collapsed Conditions ReScaled May 2023 ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,Time1),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordME = sDat
datWordME$Method = unique("Micro-Event")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordPME = sDat
datWordPME$Method = unique("PermME")

sDat = WordPMEBSD
sDat = sDat[sDat$Conditions %in% c("known_puppet", "known_object","puppet_object", 
                                   "known_novel", "puppet_novel", "object_novel"),]
sDat$Conditions = factor(sDat$Conditions, levels = c("known_puppet", "known_object","puppet_object", 
                                                     "known_novel", "puppet_novel", "object_novel"),
                         labels = c("known_learned", "known_learned","learned",
                                    "known_novel", "learned_novel", "learned_novel"))

sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond,WordCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
sDat$CorrVal = (sDat$CorrVal-min(sDat$CorrVal,na.rm=T))/(max(sDat$CorrVal,na.rm=T)-min(sDat$CorrVal,na.rm=T))
datWordPMEBSD = sDat
datWordPMEBSD$Method = unique("PermMEBSD")

sDat = rbind(datWordBB,datWordBE,datWordME,datWordPME,datWordPMEBSD)

sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Micro-Event","PermME","PermMEBSD"))
sDat$Conditions = factor(sDat$Conditions, levels = c("known_learned","learned",
                                                     "known_novel", "learned_novel"))


ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Mask~Method)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")


