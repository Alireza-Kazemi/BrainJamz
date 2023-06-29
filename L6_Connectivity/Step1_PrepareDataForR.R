########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L6_Connectivity
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


RD = "D:\\Projects\\BrainJamz\\DataFiles\\L6_Connectivity\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L6_Connectivity\\"



########################### Prepare Word Seed Based Connectivity Data and Save #################
dat      = read.csv(paste(RD,"TimeSeries_SeedbasedConn_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(dat$Condition)
dat$Condition = factor(dat$Condition, 
                              levels = c("Known", "Puppet","Object", "Unknown","baseline"),
                              labels = c("known", "puppet","object", "novel","baseline"))
dat$Seed = factor(dat$Seed, levels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                                       "PAuditory_L", "PAuditory_R", "aMPFCSphere"), 
                        labels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                                   "Auditory_L", "Auditory_R", "aMPFC_L"))
dat$Target = factor(dat$Target, levels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                                       "PAuditory_L", "PAuditory_R", "aMPFCSphere"), 
                  labels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                             "Auditory_L", "Auditory_R", "aMPFC_L"))

unique(dat$Condition)
write.csv(dat,paste(RD,"Word_Connectivity_ForR.csv",sep=""), row.names = F)

########################### Prepare Word Seed Based Connectivity Data and Save #################
dat      = read.csv(paste(RD,"TimeSeries_SeedbasedConn_Word_Sig.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(dat$Condition)
dat$Condition = factor(dat$Condition, 
                       levels = c("Known", "Puppet","Object", "Unknown","baseline"),
                       labels = c("known", "puppet","object", "novel","baseline"))
dat$Seed = factor(dat$Seed, levels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                                       "PAuditory_L", "PAuditory_R", "aMPFCSphere"), 
                  labels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                             "Auditory_L", "Auditory_R", "aMPFC_L"))
dat$Target = factor(dat$Target, levels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                                           "PAuditory_L", "PAuditory_R", "aMPFCSphere"), 
                    labels = c("HPC_L", "HPC_R", "aMTL_L", "aMTL_R", 
                               "Auditory_L", "Auditory_R", "aMPFC_L"))

unique(dat$Condition)
write.csv(dat,paste(RD,"Word_Connectivity_Sig_ForR.csv",sep=""), row.names = F)
