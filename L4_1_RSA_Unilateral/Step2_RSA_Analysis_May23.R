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

########################### LoadData #################
data_Corr      = read.csv(paste(RD,"Song_BlockBased_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target_reverse", "target_novel", "reverse_novel",
                                          "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
SongBB = data_Corr


data_Corr      = read.csv(paste(RD,"Song_BlockEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
SongBE = data_Corr


data_Corr      = read.csv(paste(RD,"Song_PermMicroEvents_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
SongPME = data_Corr

data_Corr      = read.csv(paste(RD,"Song_PermMicroEventsS_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
SongPMES = data_Corr

#-------------- WordData
data_Corr      = read.csv(paste(RD,"Word_BlockBased_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordBB = data_Corr

data_Corr      = read.csv(paste(RD,"Word_BlockEvent_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordBE = data_Corr

data_Corr      = read.csv(paste(RD,"Word_PermMicroEvents_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordPME = data_Corr

data_Corr      = read.csv(paste(RD,"Word_PermMicroEventsS_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
data_Corr$Mask = factor(data_Corr$Mask, levels = c("HPC","aMTL","PAuditory","aMPFCSphere"), 
                        labels = c("HPC","aMTL","Auditory","aMPFC"))
data_Corr$Hemisphere[data_Corr$Mask=="aMPFC"] = "Left"
unique(data_Corr$Conditions)
unique(data_Corr$Mask)
WordPMES = data_Corr

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
head(sDat)
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

########################### Word BlockBased Similarity to Baseline All Masks ##########################
sDat = WordBB
unique(sDat$Conditions)
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

head(sDat)
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



########################### Song BlockBased All Masks ##########################
sDat = SongBB
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
head(sDat)
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

########################### Word BlockBased SRCD ##########################
sDat = WordBB
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]
# sDat = sDat[sDat$Hemisphere=="Left",]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)

ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  # geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")
graph2ppt(file=paste(WD,"Figure1.pptx",sep = ""),width = 12, height = 5.5)


sDat$ZscoredValue = FisherZ(sDat$CorrVal)
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


############################################################################## BlockEvent ----
########################### Song BlockEvent Within Condition All Masks ##########################
sDat = SongBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))

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
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))

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

########################### Song BlockEvent Between Condition All Masks ##########################
sDat = SongBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_reverse","target_novel","reverse_novel"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
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
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
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


########################### Word BlockEvent SRCD ##########################
sDat = WordBE
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
# sDat = sDat[sDat$Hemisphere=="Left",]
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)

ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  # geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")
graph2ppt(file=paste(WD,"Figure2.pptx",sep = ""),width = 12, height = 5.5)

sDat$ZscoredValue = FisherZ(sDat$CorrVal)


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


############################################################################## Perm Micro Event ----
########################### Song PermMicroEvents Within Condition All Masks ##########################
sDat = SongPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target","reverse","novel","baseline"),]
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,PermCond,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
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
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,PermCond,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
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
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
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
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))


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





########################### Word PermMicroEvents SRCD ##########################
sDat = WordPME
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)

ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  # geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge", linewidth = 1,
               aes(colour = Conditions))+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  
  facet_wrap(~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")
graph2ppt(file=paste(WD,"Figure4.pptx",sep = ""),width = 12, height = 5.5)

sDat$ZscoredValue = FisherZ(sDat$CorrVal)
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






############################################################################## Perm Micro Event Separated Blocks----
########################### Word PermMicroEvents Between Condition All Masks ##########################
sDat = WordPMES
unique(sDat$Conditions)
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))

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



########################### Word Compare PME and PMES ##########################
sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPME = sDat
datWordPME$Method = unique("Permuted Micro-Event")

sDat = WordPMES
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPMES = sDat
datWordPMES$Method = unique("Permuted Micro-Event Sep")

sDat = rbind(datWordPME,datWordPMES)
# sDat = sDat[sDat$Mask!="Auditory",]
sDat$Method = factor(sDat$Method, levels = c("Permuted Micro-Event","Permuted Micro-Event Sep"))
sDat$Conditions = factor(sDat$Conditions, levels = c("target_known", "known_unknown", "target_unknown"),
                         labels = c("known_target", "known_unknown", "target_unknown"))


ggplot(sDat,aes(x = Conditions , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Method~Mask)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")

########################### Word across Methods May 2023 ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPME = sDat
datWordPME$Method = unique("Permuted Micro-Event")

sDat = WordPMES
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPMES = sDat
datWordPMES$Method = unique("Permuted Micro-Event Sep")

sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMES)
# sDat = sDat[sDat$Mask!="Auditory",]
sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Permuted Micro-Event","Permuted Micro-Event Sep"))
sDat$Conditions = factor(sDat$Conditions, levels = c("target_known", "known_unknown", "target_unknown"),
                         labels = c("known_target", "known_unknown", "target_unknown"))


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

graph2ppt(file=paste(WD,"Figure5.pptx",sep = ""),width = 12, height = 5.5)


sDat$ZscoredValue = FisherZ(sDat$CorrVal)
Method = "Permuted Micro-Event"
Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "aMTL"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "Auditory"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)
########################### Word LearnMEM Dissimialrities across Methods ##########################
sDat = WordBB
sDat$CorrVal = 1-sDat$CorrVal
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat$CorrVal = 1-sDat$CorrVal
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordPME
sDat$CorrVal = 1-sDat$CorrVal
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPME = sDat
datWordPME$Method = unique("Permuted Micro-Event")

sDat = WordPMES
sDat$CorrVal = 1-sDat$CorrVal
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
datWordPMES = sDat
datWordPMES$Method = unique("Permuted Micro-Event Sep")

sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMES)
# sDat = sDat[sDat$Mask!="Auditory",]
sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","Permuted Micro-Event","Permuted Micro-Event Sep"))
sDat$Conditions = factor(sDat$Conditions, levels = c("known_unknown", "target_known",  "target_unknown"),
                         labels = c("known_unknown", "known_target", "target_unknown"))




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
graph2ppt(file=paste(WD,"Figure5.pptx",sep = ""),width = 12, height = 5.5)


sDat$ZscoredValue = FisherZ(sDat$CorrVal)
Method = "Permuted Micro-Event"
Mask = "HPC"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "aMTL"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

Mask = "Auditory"
cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "known_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

cond1 = sDat$Mask == Mask & sDat$Conditions == "target_known" & sDat$Method == Method
cond2 = sDat$Mask == Mask & sDat$Conditions == "target_unknown" & sDat$Method == Method
t.test(sDat$ZscoredValue[cond1],sDat$ZscoredValue[cond2], paired = T)

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

####################################### Correlations with Behavior Word BlockEvent-----------
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
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Mask,Conditions,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat$C1 = unique("S")
sDat$CorrVal = FisherZ(sDat$CorrVal)
head(sDat)
data_Corr = sDat
data_Corr = reshape2::dcast(data_Corr,Subj ~ C1+Mask+Hemisphere+Conditions, value.var="CorrVal")
data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))
datSong = data_Corr



sDat = WordPME
unique(sDat$Conditions)
head(sDat)
sDat = as.data.frame(summarise(group_by(sDat,Subj,Mask,Conditions,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat$C1 = unique("W")
sDat$CorrVal = FisherZ(sDat$CorrVal)
head(sDat)
data_Corr = sDat
data_Corr = reshape2::dcast(data_Corr,Subj ~ C1+Mask+Hemisphere+Conditions, value.var="CorrVal")
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

write.csv(dat, file = paste(WD,"DataforJamovi.csv",sep = ""), row.names = F)
########################### Word Behavior across Methods ##########################
sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordBB = sDat
datWordBB$Method = unique("BB")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordBE = sDat
datWordBE$Method = unique("BE")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordPME = sDat
datWordPME$Method = unique("PME")

sDat = WordPMES
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordPMES = sDat
datWordPMES$Method = unique("PMES")


sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMES)
sDat = sDat[sDat$Mask!="Auditory",]
sDat$Method = factor(sDat$Method, levels = c("BB","BE","PME","PMES"))
head(sDat)
dataWordBiLat = reshape2::dcast(sDat,Subj ~ Mask+Conditions+Method, value.var="CorrVal")
dataWordBiLat$Subj = as.numeric(sub("S","",dataWordBiLat$Subj, ignore.case = T))


sDat = WordBB
sDat = sDat[sDat$Conditions %in% c("target_known","target_unknown","known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask","Hemisphere"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordBB = sDat
datWordBB$Method = unique("BB")

sDat = WordBE
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask","Hemisphere"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordBE = sDat
datWordBE$Method = unique("BE")

sDat = WordPME
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask","Hemisphere"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordPME = sDat
datWordPME$Method = unique("PME")

sDat = WordPMES
sDat = sDat[sDat$Conditions %in% c("target_known", "target_unknown", "known_unknown"),]
sDat$PermCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat = sDat[sDat$Perm1 == sDat$Perm2,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,PermCond),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
sDat = RemoveOutliers(sDat,factorNames = c("Conditions","Mask"), varName = "CorrVal", Criteria = 3)
# sDat$ZscoredValue = FisherZ(sDat$CorrVal)
datWordPMES = sDat
datWordPMES$Method = unique("PMES")


sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMES)
sDat = sDat[sDat$Mask!="Auditory",]
sDat$Method = factor(sDat$Method, levels = c("BB","BE","PME","PMES"))
head(sDat)
dataWordUniiLat = reshape2::dcast(sDat,Subj ~ Mask+Conditions+Method+Hemisphere, value.var="CorrVal")
dataWordUniiLat$Subj = as.numeric(sub("S","",dataWordUniiLat$Subj, ignore.case = T))

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
dat = merge(dat,dataWordBiLat, by = "Subj", all.y = T)
dat = merge(dat,dataWordUniiLat, by = "Subj", all.y = T)

write.csv(dat, file = paste(WD,"ForJamovi_May2023.csv",sep = ""), row.names = F)
