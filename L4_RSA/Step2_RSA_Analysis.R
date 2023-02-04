########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L4_RSA
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


RD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA\\"


########################### LoadData #################
data_Corr      = read.csv(paste(RD,"Song_BlockBased_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target_reverse", "target_novel", "reverse_novel",
                                          "target_baseline", "reverse_baseline", "novel_baseline"))

SongBB = data_Corr

data_Corr      = read.csv(paste(RD,"Song_EventRelated_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))

data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
SongER = data_Corr



data_Corr      = read.csv(paste(RD,"Word_BlockBased_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
WordBB = data_Corr


data_Corr      = read.csv(paste(RD,"Word_EventRelated_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
WordER = data_Corr


########################### Demographics ##########################
trackDat  = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

songDat = trackDat[trackDat$includeSong==1,]
as.data.frame(summarise(group_by(songDat,songGroup),N = n(),VolNum_Average = mean(songVols) , 
                        M_age = round(mean(ageFrac),2),SD_age = round(sd(ageFrac),2)))

wordDat = trackDat[trackDat$includeWord==1,]
as.data.frame(summarise(group_by(wordDat),N = n(),VolNum_Average = mean(wordVols) , 
                        M_age = round(mean(ageFrac),2),SD_age = round(sd(ageFrac),2)))

########################### Song BlockBased Similarity to Baseline All Masks ##########################
sDat = SongBB
unique(sDat$Conditions)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(songGroup~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

########################### Word BlockBased Similarity to Baseline All Masks ##########################
sDat = WordBB
unique(sDat$Conditions)

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

########################### Song BlockBased All Masks ##########################
sDat = SongBB
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(songGroup~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


sDat$ZscoredValue = FisherZ(sDat$CorrVal)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "reverse_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


########################### Word BlockBased All Masks ##########################
sDat = WordBB
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]

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




########################### Song EventRelated Within Condition All Masks ##########################
sDat = SongER
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target", "reverse", "novel", "baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$CorrVal = abs(sDat$CorrVal);
# sDat = sDat[sDat$timeCond==4 & sDat$T2<21,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(songGroup~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


########################### Song EventRelated Between Condition All Masks ##########################
sDat = SongER
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse", "target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$CorrVal = abs(sDat$CorrVal);
sDat$timeCond = as.numeric(sDat$timeCond)
# sDat = sDat[sDat$timeCond<5 ,]
sDat = sDat[sDat$T1==5 ,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(songGroup~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))

########################### Word EventRelated Within Condition All Masks ##########################
sDat = WordER
unique(sDat$Conditions)
# sDat = sDat[sDat$Mask=="HPC",]
sDat = sDat[sDat$Conditions %in% c("target", "known", "unknown", "baseline"),]
sDat$CorrVal = abs(sDat$CorrVal);
# sDat = sDat[sDat$timeCond==4 & sDat$T2<21,]

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

########################### Word EventRelated Between Condition All Masks ##########################
sDat = WordER
unique(sDat$Conditions)
# sDat = sDat[sDat$Mask=="HPC",]
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$CorrVal = abs(sDat$CorrVal);
# sDat = sDat[sDat$timeCond==4 & sDat$T2<21,]

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

Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


Mask = "aMPFCSphere"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


########################### Song EventRelated Within Condition All Masks ##########################
sDat = SongER
unique(sDat$Conditions)
sDat = sDat[sDat$Mask=="HPC",]
sDat = sDat[sDat$Conditions %in% c("target", "reverse", "novel", "baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$CorrVal = abs(sDat$CorrVal);
sDat = sDat[sDat$T1==7,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=timeCond, y=CorrVal, fill = Conditions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(songGroup~Mask)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  theme(strip.text.y = element_text(size=16, face="bold"))+
  labs(x="",y="Pearson's Correlation Coefficient", size=16)+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(legend.text = element_text(size = 16))+
  theme(axis.title.y = element_text(size = 18))


########################### Word EventRelated Within Condition All Masks ##########################
sDat = WordER
unique(sDat$Conditions)
sDat = sDat[sDat$Mask=="HPC",]
sDat = sDat[sDat$Conditions %in% c("target", "known", "unknown", "baseline"),]
sDat$CorrVal = abs(sDat$CorrVal);
sDat = sDat[sDat$T1==6,]

ggplot(sDat,aes(x=T2, y=CorrVal, fill = Conditions)) + 
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
