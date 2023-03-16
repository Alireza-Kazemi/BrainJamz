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

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L5_TimeSeries\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L5_TimeSeries\\"


library(HMLET)
########################### Functions ----
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
data_Corr      = read.csv(paste(RD,"Song_StepWiseRSA_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "reverse", "novel","baseline"))

Song_StepWiseRSA = data_Corr


data_Corr      = read.csv(paste(RD,"Song_InterVoxelSim_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel","baseline"))

Song_InterVoxelSim = data_Corr

data_Corr      = read.csv(paste(RD,"Song_InterVoxelSimFLHalf_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel","baseline"))

Song_InterVoxelSimFLHalf = data_Corr

data_Corr      = read.csv(paste(RD,"Song_AverageTimeSeries_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "reverse", "novel","baseline"))

Song_AverageTimeSeries = data_Corr
#----- Word Data
data_Corr      = read.csv(paste(RD,"Word_StepWiseRSA_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "known", "unknown","baseline"))

Word_StepWiseRSA = data_Corr


data_Corr      = read.csv(paste(RD,"Word_InterVoxelSim_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown","baseline"))

Word_InterVoxelSim = data_Corr

data_Corr      = read.csv(paste(RD,"Word_InterVoxelSimFLHalf_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown","baseline"))

Word_InterVoxelSimFLHalf = data_Corr

data_Corr      = read.csv(paste(RD,"Word_AverageTimeSeries_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "known", "unknown","baseline"))

Word_AverageTimeSeries = data_Corr


########################### Song StepWiseRSA ##########################
sDat = Song_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
# Interpolated version is not good because of the temporal correlation
# graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex", 
#                                           condition = "Conditions", timepoint = "timePoints",
#                                           gazeInAOI = "CorrVal",testName = "Mask")
# graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex", 
#                                           condition = "Conditions", timepoint = "timePoints",
#                                           gazeInAOI = "CorrVal",testName = "Mask")
# PlotTemporalGazeTrends_HMLET(graphDatTR)
# PlotTemporalGazeTrends_HMLET(graphDatInterp)

sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                          condition = "Conditions", timepoint = "timePoints",
                                          gazeInAOI = "CorrVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                          condition = "Conditions", timepoint = "timePoints",
                                          gazeInAOI = "CorrVal",testName = "songGroup")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)

sDat = sDat[sDat$timePoints>5 & sDat$timePoints<15,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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

########################### Word StepWiseRSA ##########################
sDat = Word_StepWiseRSA
unique(sDat$Conditions)
names(sDat)

# Interpolated version is not good because of the temporal correlation

# graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex", 
#                                           condition = "Conditions", timepoint = "timePoints",
#                                           gazeInAOI = "CorrVal",testName = "Mask")
# graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex", 
#                                           condition = "Conditions", timepoint = "timePoints",
#                                           gazeInAOI = "CorrVal",testName = "Mask")
# PlotTemporalGazeTrends_HMLET(graphDatTR)
# PlotTemporalGazeTrends_HMLET(graphDatInterp)

sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = sDat[sDat$timePoints>5 & sDat$timePoints<15,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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

########################### Song InterVoxelSim ##########################
sDat = Song_InterVoxelSim
unique(sDat$Conditions)
names(sDat)

sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Interpolated, y=CorrVal, fill = Conditions)) + 
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

########################### Song InterVoxelSim FLHALF ##########################
sDat = Song_InterVoxelSimFLHalf
unique(sDat$Conditions)
names(sDat)

sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]

# sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat,aes(x=Timepoints, y=CorrVal, fill = Conditions)) + 
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


########################### Word InterVoxelSim ##########################
sDat = Word_InterVoxelSim
unique(sDat$Conditions)
names(sDat)


ggplot(sDat,aes(x=Interpolated, y=CorrVal, fill = Conditions)) + 
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


########################### Word FLHALF ##########################
sDat = Word_InterVoxelSimFLHalf
unique(sDat$Conditions)
names(sDat)


ggplot(sDat,aes(x=Interpolated, y=CorrVal, fill = Conditions)) + 
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



########################### Song StepWiseRSA Difference to baseline ##########################
sDat = Song_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]


sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "songGroup")
P = PlotTemporalGazeTrends_HMLET(graphDatTR,showDataPointNumbers = F)
plot(P)
P + ylab("Similarity")

PlotTemporalGazeTrends_HMLET(graphDatInterp,showDataPointNumbers = F)


sDat = Song_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+songGroup+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "CorrVal")

sDat$Target_Novel_Baseline = (sDat$target-sDat$novel)/(sDat$target-sDat$baseline)
sDat$Reverse_Novel_Baseline = (sDat$reverse-sDat$novel)/(sDat$reverse-sDat$baseline)
sDat = sDat[,!(names(sDat)%in%c("target","reverse","novel","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","songGroup","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "CorrVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","songGroup","Mask","blockIndex","Interpolated","Conditions"),varName = "CorrVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "songGroup")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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



sDat = Song_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+songGroup+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "CorrVal")

sDat$Target_Baseline = (sDat$target)/(sDat$novel+sDat$reverse+sDat$target+sDat$baseline)
sDat$Reverse_Baseline = sDat$reverse/(sDat$novel+sDat$reverse+sDat$target+sDat$baseline)
sDat$Novel_Baseline = sDat$novel/(sDat$novel+sDat$reverse+sDat$target+sDat$baseline)
sDat = sDat[,!(names(sDat)%in%c("target","reverse","novel","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","songGroup","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "CorrVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","songGroup","Mask","blockIndex","Interpolated","Conditions"),varName = "CorrVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "songGroup")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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

########################### Word StepWiseRSA Difference to baseline ##########################
sDat = Word_StepWiseRSA
unique(sDat$Conditions)
names(sDat)


sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "Mask")
P = PlotTemporalGazeTrends_HMLET(graphDatTR,showDataPointNumbers = F)
plot(P)
P + ylab("Similarity")
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = Word_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "CorrVal")

sDat$Target_unknown_Baseline = (sDat$target-sDat$unknown+1)/(sDat$target-sDat$baseline+1)
sDat$known_unknown_Baseline = (sDat$known-sDat$unknown+1)/(sDat$known-sDat$baseline+1)
sDat = sDat[,!(names(sDat)%in%c("target","known","unknown","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "CorrVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","Mask","blockIndex","Interpolated","Conditions"),varName = "CorrVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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



sDat = Word_StepWiseRSA
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "CorrVal")

sDat$Target_Baseline = sDat$target-sDat$baseline
sDat$known_Baseline = sDat$known-sDat$baseline
sDat$unknown_Baseline = sDat$unknown-sDat$baseline
sDat = sDat[,!(names(sDat)%in%c("target","known","unknown","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "CorrVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","Mask","blockIndex","Interpolated","Conditions"),varName = "CorrVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "CorrVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "CorrVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated,blockIndex),CorrVal = mean(CorrVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated),CorrVal = mean(CorrVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=CorrVal, fill = Conditions)) + 
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
########################### Song Average TimeSeries Difference to baseline ##########################
sDat = Song_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]


sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "songGroup")
P = PlotTemporalGazeTrends_HMLET(graphDatTR,showDataPointNumbers = F)
plot(P)
P + ylab("Bold Signal")
P = PlotTemporalGazeTrends_HMLET(graphDatInterp,showDataPointNumbers = F)
plot(P)
P + ylab("Bold Signal")

sDat = Song_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+songGroup+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "BoldVal")

sDat$Target_Novel_Baseline = (sDat$target-sDat$novel)/(sDat$target-sDat$baseline)
sDat$Reverse_Novel_Baseline = (sDat$reverse-sDat$novel)/(sDat$reverse-sDat$baseline)
sDat = sDat[,!(names(sDat)%in%c("target","reverse","novel","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","songGroup","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "BoldVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","songGroup","Mask","blockIndex","Interpolated","Conditions"),varName = "BoldVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "songGroup")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated,blockIndex),BoldVal = mean(BoldVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),BoldVal = mean(BoldVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=BoldVal, fill = Conditions)) + 
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



sDat = Song_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$songGroup %in% c("Replication","Extension"),]
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+songGroup+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "BoldVal")

sDat$Target_Baseline = sDat$target-sDat$baseline
sDat$Reverse_Baseline = sDat$reverse-sDat$baseline
sDat$Novel_Baseline = sDat$novel-sDat$baseline
sDat = sDat[,!(names(sDat)%in%c("target","reverse","novel","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","songGroup","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "BoldVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","songGroup","Mask","blockIndex","Interpolated","Conditions"),varName = "BoldVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "songGroup")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "songGroup")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated,blockIndex),BoldVal = mean(BoldVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,songGroup,Interpolated),BoldVal = mean(BoldVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=BoldVal, fill = Conditions)) + 
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

########################### Word Average TimeSeries Difference to baseline ##########################
sDat = Word_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)


sDat = sDat[sDat$Mask=="HPC",]
graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
P = PlotTemporalGazeTrends_HMLET(graphDatInterp,showDataPointNumbers = F)
plot(P)
P + ylab("Bold Signal")


sDat = Word_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "BoldVal")

sDat$Target_unknown_Baseline = (sDat$target-sDat$unknown+1)/(sDat$target-sDat$baseline+1)
sDat$known_unknown_Baseline = (sDat$known-sDat$unknown+1)/(sDat$known-sDat$baseline+1)
sDat = sDat[,!(names(sDat)%in%c("target","known","unknown","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "BoldVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","Mask","blockIndex","Interpolated","Conditions"),varName = "BoldVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated,blockIndex),BoldVal = mean(BoldVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated),BoldVal = mean(BoldVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=BoldVal, fill = Conditions)) + 
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



sDat = Word_AverageTimeSeries
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
sDat = reshape2::dcast(sDat,Subj+Mask+blockIndex+Interpolated+timePoints~Conditions, value.var = "BoldVal")

sDat$Target_Baseline = sDat$target-sDat$baseline
sDat$known_Baseline = sDat$known-sDat$baseline
sDat$unknown_Baseline = sDat$unknown-sDat$baseline
sDat = sDat[,!(names(sDat)%in%c("target","known","unknown","baseline"))]
sDat = reshape2::melt(sDat,id.vars = c("Subj","Mask","blockIndex","Interpolated","timePoints"), 
                      variable.name = "Conditions", value.name = "BoldVal")
names(sDat)
sDat = RemoveOutliers(sDat,factorNames =c("Subj","Mask","blockIndex","Interpolated","Conditions"),varName = "BoldVal")

graphDatTR = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==0,],ID = "Subj", trial = "blockIndex",
                                           condition = "Conditions", timepoint = "timePoints",
                                           gazeInAOI = "BoldVal",testName = "Mask")
graphDatInterp = PermutationTestDataPrep_HMLET(sDat[sDat$Interpolated==1,],ID = "Subj", trial = "blockIndex",
                                               condition = "Conditions", timepoint = "timePoints",
                                               gazeInAOI = "BoldVal",testName = "Mask")
PlotTemporalGazeTrends_HMLET(graphDatTR)
PlotTemporalGazeTrends_HMLET(graphDatInterp)


sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated,blockIndex),BoldVal = mean(BoldVal,na.rm = T)))
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,Mask,Interpolated),BoldVal = mean(BoldVal,na.rm = T)))

ggplot(sDat[sDat$Interpolated==0,],aes(x=Conditions, y=BoldVal, fill = Conditions)) + 
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

####################################### Correlations with Behavior time Song Block Event-----------
sDat = Song_StepWiseRSA
sDat = sDat[sDat$Interpolated==0,]
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
SelectCond = "baseline" ; # "target", "reverse" , "novel" , "baseline"
sDat = sDat[sDat$Conditions %in% SelectCond,] 
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,timePoints),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions+timePoints, value.var="CorrVal")

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
corrMatDat = corrMatDat[complete.cases(corrMatDat),]
corrMatDat = corrMatDat[,-1]
# pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)
Cors = cor(corrMatDat,method = "pearson")
X = Cors[1,]
X = X[c(-1,-2)]
mean(X)
plot(X,type = "l",ylab = SelectCond, xlab = "Time")

####################################### Correlations with Behavior Space Song Block Event-----------
sDat = Song_StepWiseRSA
sDat = sDat[sDat$Interpolated==0,]
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
SelectCond = "target" ; # "target", "reverse" , "novel" , "baseline"
sDat = sDat[sDat$Conditions %in% SelectCond,] 
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,timePoints),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions+timePoints, value.var="CorrVal")

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
corrMatDat = corrMatDat[complete.cases(corrMatDat),]
corrMatDat = corrMatDat[,-1]
# pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)
Cors = cor(corrMatDat,method = "pearson")
R = corr.p(Cors,n=43)

X = R$p[1,]
X = Cors[2,]

X = X[c(-1,-2)]
mean(X)
plot(X,type = "l",ylab = SelectCond, xlab = "Time")
####################################### Correlations with Behavior Word Permutation-----------
sDat = Word_StepWiseRSA
sDat = sDat[sDat$Interpolated==0,]
unique(sDat$Conditions)
names(sDat)
sDat = sDat[sDat$Mask=="HPC",]
SelectCond = "target" ; # "target", "known" , "unknown" , "baseline"
sDat = sDat[sDat$Conditions %in% SelectCond,] 
sDat = as.data.frame(summarise(group_by(sDat,Subj,Conditions,timePoints),CorrVal = mean(CorrVal,na.rm = T)))

data_Corr = sDat

data_Corr = reshape2::dcast(data_Corr,Subj ~ Conditions+timePoints, value.var="CorrVal")

data_Corr$Subj = as.numeric(sub("S","",data_Corr$Subj, ignore.case = T))

datWord      = read.csv(paste(RD,"Behavioral_MacWord.csv",sep = ""),sep = ",",header=TRUE,strip.white=TRUE)
names(datWord) = c("Subj","MacWord")

corrMatDat = merge(datWord,data_Corr,by = "Subj")
corrMatDat = corrMatDat[complete.cases(corrMatDat),]
corrMatDat = corrMatDat[,-1]
# pairs.panels(corrMatDat, scale=FALSE,cex.cor=2,stars=TRUE,cex.labels=2)
Cors = cor(corrMatDat,method = "pearson")
X = Cors[1,]
X = X[c(-1)]
mean(X)
plot(X,type = "l",ylab = SelectCond, xlab = "Time")
