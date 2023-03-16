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
# p_load(psych,plyr,psych,MCMCpack)

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

data_Corr      = read.csv(paste(RD,"Song_BlockEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
SongBE = data_Corr

data_Corr      = read.csv(paste(RD,"Song_MicroEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(data_Corr$Conditions)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
SongME = data_Corr

data_Corr      = read.csv(paste(RD,"Song_PermMicroEvents_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
SongPME = data_Corr

#-------------- WordData
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

data_Corr      = read.csv(paste(RD,"Word_BlockEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
WordBE = data_Corr

data_Corr      = read.csv(paste(RD,"Word_MicroEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
WordME = data_Corr

data_Corr      = read.csv(paste(RD,"Word_PermMicroEvents_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
WordPME = data_Corr

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



############################################################################## BlockEvent ----
########################### Song BlockEvent Within Condition All Masks ##########################
sDat = SongBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

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

########################### Word BlockEvent Within Condition All Masks ##########################
sDat = WordBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]

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

########################### Song BlockEvent Between Condition All Masks ##########################
sDat = SongBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

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


sDat$ZscoredValue = FisherZ(sDat$CorrVal)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "target_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "aMPFCSphere" & sDat$Conditions == "reverse_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


cond1 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_reverse"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup=="Extension" & sDat$Mask == "HPC" & sDat$Conditions == "target_novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)


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
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]

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


############################################################################## Micro Event ----
########################### Song MicroEvent Within Condition All Masks ##########################
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
# sDat$CorrVal = abs(sDat$CorrVal)
# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
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

#---------- Testing
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$timeCond = as.numeric(sDat$timeCond)
# sDat = sDat[sDat$timeCond==5,]
sDat = sDat[sDat$T1>5 & sDat$timeCond<7,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

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


sDat$ZscoredValue = FisherZ(sDat$CorrVal)

Group = "Replication"
Mask = "HPC"
cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "novel"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "reverse_novel"
cond2 = sDat$songGroup==Group & sDat$Mask == Mask & sDat$Conditions == "target_reverse"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

#---------- HRF Effect
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=timeCond, y=CorrVal, fill = Conditions)) + 
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

########################### Word MicroEvent Within Condition All Masks ##########################
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]

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
cond1 = sDat$Mask == Mask & sDat$Conditions == "target"
cond2 = sDat$Mask == Mask & sDat$Conditions == "known"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target"
cond2 = sDat$Mask == Mask & sDat$Conditions == "baseline"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "known"
cond2 = sDat$Mask == Mask & sDat$Conditions == "unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "baseline"
cond2 = sDat$Mask == Mask & sDat$Conditions == "unknown"
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

#---------- Testing
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]

sDat$timeCond = as.numeric(sDat$timeCond)
sDat = sDat[sDat$timeCond==5,]
sDat = sDat[sDat$T1>5 & sDat$timeCond<8,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
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


#---------- HRF Effect
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]
sDat = sDat[sDat$T1==10,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,timeCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=timeCond, y=CorrVal, fill = Conditions)) + 
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



########################### Song MicroEvent Between Condition All Masks ##########################
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
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


#---------- Testing
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$timeCond = as.numeric(sDat$timeCond)
# sDat = sDat[sDat$timeCond==5,]
sDat = sDat[sDat$T1>0 & sDat$timeCond<7,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

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


#---------- HRF Effect
sDat = SongME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

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

########################### Word MicroEvent Between Condition All Masks ##########################
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]

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

#---------- Testing
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]

sDat$timeCond = as.numeric(sDat$timeCond)
# sDat = sDat[sDat$timeCond==3,]
sDat = sDat[sDat$T1>0 & sDat$timeCond<8,]

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,timeCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=timeCond, y=CorrVal, fill = Conditions)) + 
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


#---------- HRF Effect
sDat = WordME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
# sDat = sDat[sDat$T1==10,]

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,timeCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=timeCond, y=CorrVal, fill = Conditions)) + 
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



############################################################################## Perm Micro Event ----
########################### Song PermMicroEvents Within Condition All Masks ##########################
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

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


#---------- Perm Effect
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=PermCond, y=CorrVal, fill = Conditions)) + 
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

########################### Word PermMicroEvents Within Condition All Masks ##########################
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
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



#---------- Perm Effect
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")

sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=PermCond, y=CorrVal, fill = Conditions)) + 
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



########################### Song PermMicroEvents Between Condition All Masks ##########################
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
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


# testing across groups
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,timeCond),CorrVal = mean(CorrVal,na.rm = T)))
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
#---------- HRF Effect
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=PermCond, y=CorrVal, fill = Conditions)) + 
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

########################### Word PermMicroEvents Between Condition All Masks ##########################
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond),CorrVal = mean(CorrVal,na.rm = T)))

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



#---------- HRF Effect
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = sDat[sDat$Mask=="HPC",]

ggplot(sDat,aes(x=PermCond, y=CorrVal, fill = Conditions)) + 
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


############################################################################## test ----
########################### Song EventRelated test ##########################
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


########################### Word EventRelated test ##########################
sDat = WordER
unique(sDat$Conditions)
sDat = sDat[sDat$Mask=="HPC",]
sDat = sDat[sDat$Conditions %in% c("target", "known", "unknown", "baseline",
                                   "target_known", "target_unknown", "known_unknown"),]
sDat$CorrVal = abs(sDat$CorrVal);
sDat = sDat[sDat$timeCond==2,]

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


####################################### Correlations with Behavior Song Permutation -----------
sDat = SongPME
unique(sDat$Conditions)
# sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[!(sDat$Conditions %in% c("target","reverse","novel","baseline")),]

# sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Mask=="HPC",]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions, value.var="CorrVal")

data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))

datTime      = read.csv(paste(RD,"Behavioral_Time.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
datSpace      = read.csv(paste(RD,"Behavioral_Space.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)

trialB = "Merge234"#"trial2"#
datTime = datTime[,c("subjID",trialB)]
names(datTime) = c("Subj","Time")
datSpace = datSpace[,c("subjID",trialB)]
names(datSpace) = c("Subj","Space")

corrMatDat = merge(datTime,datSpace,by = "Subj")
corrMatDat = merge(corrMatDat,data_Corr,by = "Subj")

corrMatDat = corrMatDat[,-1]
pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)


####################################### Correlations with Behavior Song Block Event-----------
sDat = SongBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[!(sDat$Conditions %in% c("target","reverse","novel","baseline")),]

# sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions, value.var="CorrVal")

data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))

datTime      = read.csv(paste(RD,"Behavioral_Time.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
datSpace      = read.csv(paste(RD,"Behavioral_Space.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)

trialB = "Merge234"#"trial2"#
datTime = datTime[,c("subjID",trialB)]
names(datTime) = c("Subj","Time")
datSpace = datSpace[,c("subjID",trialB)]
names(datSpace) = c("Subj","Space")

corrMatDat = merge(datTime,datSpace,by = "Subj")
corrMatDat = merge(corrMatDat,data_Corr,by = "Subj")

corrMatDat = corrMatDat[,-1]
pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)

####################################### Correlations with Behavior Word Permutation-----------
sDat = WordBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]
sDat = sDat[!(sDat$Conditions %in% c("target","known","unknown","baseline")),]

# sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions, value.var="CorrVal")

data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))

datWord      = read.csv(paste(RD,"Behavioral_MacWord.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
names(datWord) = c("Subj","MacWord")

corrMatDat = merge(datWord,data_Corr,by = "Subj")

corrMatDat = corrMatDat[,-1]
pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)

####################################### Correlations with Behavior Word Permutation-----------
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","known","unknown","baseline"),]
sDat = sDat[!(sDat$Conditions %in% c("target","known","unknown","baseline")),]

# sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions, value.var="CorrVal")

data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))

datVocab      = read.csv(paste(RD,"Behavioral_MacWord.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
names(datVocab) = c("Subj","MacVocab")

corrMatDat = merge(datVocab,data_Corr,by = "Subj")

corrMatDat = corrMatDat[,-1]
pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)


####################################### Correlations with Behavior Data save-----------
sDat = SongPME
unique(sDat$Conditions)
# sDat = sDat[(sDat$Conditions %in% c("target_baseline","reverse_baseline","novel_baseline")),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Mask,Conditions),CorrVal = mean(CorrVal,na.rm = T)))
sDat$C1 = unique("S")
sDat$CorrVal = FisherZ(sDat$CorrVal)
data_Corr = sDat
data_Corr = reshape2::dcast(data_Corr,Subj ~ C1+Mask+Conditions, value.var="CorrVal")
data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))
datSong = data_Corr



sDat = WordPME
unique(sDat$Conditions)
# sDat = sDat[sDat$Conditions %in% c("target_baseline","known_baseline","unknown_baseline"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Mask,Conditions),CorrVal = mean(CorrVal,na.rm = T)))
sDat$C1 = unique("W")
sDat$CorrVal = FisherZ(sDat$CorrVal)
data_Corr = sDat
data_Corr = reshape2::dcast(data_Corr,Subj ~ C1+Mask+Conditions, value.var="CorrVal")
data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))
datWord = data_Corr

datTime      = read.csv(paste(RD,"Behavioral_Time.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
datSpace      = read.csv(paste(RD,"Behavioral_Space.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
trialB = "Merge234"#"trial2"#
datTime = datTime[,c("subjID","Age","Age_split",trialB)]
names(datTime) = c("Subj","age","ageSplit","Time")
datSpace = datSpace[,c("subjID",trialB)]
names(datSpace) = c("Subj","Space")
datVocab      = read.csv(paste(RD,"Behavioral_MacWord.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
names(datVocab) = c("Subj","MacWord")
datOther      = read.csv(paste(RD,"Behavioral_Other.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
names(datOther) = c("Subj","Average","AfterDelay","Initial_Learning")

dat = merge(datTime,datSpace, by = "Subj", all = T)
dat = merge(dat,datVocab, by = "Subj", all = T)
dat = merge(dat,datOther, by = "Subj", all = T)
dat = merge(dat,datSong, by = "Subj", all = T)
dat = merge(dat,datWord, by = "Subj", all = T)

write.csv(dat, file = "DataforJamovi.csv", row.names = F)
