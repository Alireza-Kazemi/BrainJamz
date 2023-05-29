########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L4_RSA_Unilateral_PuppetObjectBaseline
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

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObjectBaseline\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObjectBaseline\\"
identifier_str = "RSAwBL"


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



########################### Word across Methods May 2023 ##########################
sDat = WordBB
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
datWordBB = sDat
datWordBB$Method = unique("Block-Based")

sDat = WordBE
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
datWordBE = sDat
datWordBE$Method = unique("Block-Event")

sDat = WordME
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
datWordME = sDat
datWordME$Method = unique("Micro-Event")

sDat = WordPME
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
datWordPME = sDat
datWordPME$Method = unique("PermME")

sDat = WordPMEBSD
sDat = sDat[sDat$WordCond == "Both",]
sDat$permCond = paste(sDat$Perm1,sDat$Perm2,sep = "_")
sDat$blockCond = paste(sDat$Block1,sDat$Block2,sep = "_")
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond,blockCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere,permCond),N=n(),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Hemisphere),CorrVal = mean(CorrVal,na.rm = T)))
datWordPMEBSD = sDat
datWordPMEBSD$Method = unique("PermMEBSD")

sDat = rbind(datWordBB,datWordBE,datWordPME,datWordPMEBSD)


sDat$Method = factor(sDat$Method, levels = c("Block-Based","Block-Event","PermME","PermMEBSD"),
                                  labels = c("BB","BE","PME","PMEx"))

sDat$Hemisphere = ifelse(sDat$Hemisphere=="Left","L","R")
sDat$Identifier = identifier_str
head(sDat)

ggplot(sDat,aes(x = Hemisphere , y = CorrVal, fill = Conditions)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_jitter(position = position_jitterdodge(jitter.width = NULL,
  #                                             jitter.height = 0,
  #                                             dodge.width = .75),shape = 21,fill="grey",aes(colour = Conditions))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_grid(Mask~Method)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))

datWide = reshape2::dcast(sDat,Subj~Identifier+Method+Mask+Hemisphere+Conditions,value.var = "CorrVal")


write.csv(datWide,paste(WD,"datWide_",identifier_str,".csv",sep=""), row.names = F)
