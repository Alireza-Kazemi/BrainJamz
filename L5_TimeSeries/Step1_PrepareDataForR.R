########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L5_TimeSeries
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


RD = "D:\\Projects\\BrainJamz\\DataFiles\\L5_TimeSeries\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L5_TimeSeries\\"


########################### Prepare Song IntervoxelSimilarities Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_InterVoxelSim_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Song_InterVoxelSim_ForR.csv",sep=""), row.names = F)

########################### Prepare Song IntervoxelSimilarities FLHalf #################
data_Corr      = read.csv(paste(RD,"TimeSeries_InterVoxelSim_Song_FLHalf.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Song_InterVoxelSimFLHalf_ForR.csv",sep=""), row.names = F)

########################### Prepare Song StepWiseRSA Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_StepWiseRSA_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Song_StepWiseRSA_ForR.csv",sep=""), row.names = F)

########################### Prepare Song AverageTimeSeries Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_AverageTimeSeries_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Song_AverageTimeSeries_ForR.csv",sep=""), row.names = F)


########################### Prepare Word IntervoxelSimilarities Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_InterVoxelSim_Word_FLHalf.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "Known", "Unknown","baseline"),
                              labels = c("target", "known", "unknown","baseline"))
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Word_InterVoxelSimFLHalf_ForR.csv",sep=""), row.names = F)

########################### Prepare Word IntervoxelSimilarities FLHalf #################
data_Corr      = read.csv(paste(RD,"TimeSeries_InterVoxelSim_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "Known", "Unknown","baseline"),
                              labels = c("target", "known", "unknown","baseline"))
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Word_InterVoxelSim_ForR.csv",sep=""), row.names = F)

########################### Prepare Word StepWiseRSA Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_StepWiseRSA_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "Known", "Unknown","baseline"),
                              labels = c("target", "known", "unknown","baseline"))
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Word_StepWiseRSA_ForR.csv",sep=""), row.names = F)

########################### Prepare Word AverageTimeSeries Data and Save #################
data_Corr      = read.csv(paste(RD,"TimeSeries_AverageTimeSeries_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels = c("target", "Known", "Unknown","baseline"),
                              labels = c("target", "known", "unknown","baseline"))
unique(data_Corr$Conditions)

write.csv(data_Corr,paste(RD,"Word_AverageTimeSeries_ForR.csv",sep=""), row.names = F)


