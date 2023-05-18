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


RD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObject\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L4_RSA_Unilateral_PuppetObject\\"



########################### Prepare Word BlockBased Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockBased_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("puppet_known", "known_object","puppet_object", 
                                          "known_unknown", "puppet_unknown", "object_unknown"),
                              labels = c("known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))
data_Corr$Hemisphere = case_when(grepl("_L",data_Corr$Mask)~"Left",
                                 grepl("_R",data_Corr$Mask)~"Right")
data_Corr$Mask = gsub("_L","",data_Corr$Mask)
data_Corr$Mask = gsub("_R","",data_Corr$Mask)

write.csv(data_Corr,"Word_BlockBased_ForR.csv", row.names = F)


########################### Prepare Word BlockEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockEvent_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(data_Corr$Conditions)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Block1","Cond2","Block2")
A$Conditions = paste(A$Cond1,A$Block1,A$Cond2,A$Block2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("known", "puppet", "object", "unknown",
                                          "puppet_known", "known_object","puppet_object", 
                                          "known_unknown", "puppet_unknown", "object_unknown"),
                              labels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))

data_Corr$blockCond = abs(as.numeric(data_Corr$Block1) - as.numeric(data_Corr$Block2))
data_Corr$blockCond = factor(data_Corr$blockCond,
                            levels = sort(unique(data_Corr$blockCond)))
data_Corr$Hemisphere = case_when(grepl("_L",data_Corr$Mask)~"Left",
                                 grepl("_R",data_Corr$Mask)~"Right")
data_Corr$Mask = gsub("_L","",data_Corr$Mask)
data_Corr$Mask = gsub("_R","",data_Corr$Mask)
write.csv(data_Corr,"Word_BlockEvent_ForR.csv", row.names = F)

########################### Prepare Word MicroEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_MicroEvent_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Time1","Cond2","Time2")
A$Conditions = paste(A$Cond1,A$Time1,A$Cond2,A$Time2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)


data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("known", "puppet", "object", "unknown",
                                          "puppet_known", "known_object","puppet_object", 
                                          "known_unknown", "puppet_unknown", "object_unknown",
                                          "known_puppet", "object_known","object_puppet", 
                                          "unknown_known", "unknown_puppet", "unknown_object"),
                              labels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))

data_Corr$timeCond = abs(as.numeric(data_Corr$Time1) - as.numeric(data_Corr$Time2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

data_Corr$Hemisphere = case_when(grepl("_L",data_Corr$Mask)~"Left",
                                 grepl("_R",data_Corr$Mask)~"Right")
data_Corr$Mask = gsub("_L","",data_Corr$Mask)
data_Corr$Mask = gsub("_R","",data_Corr$Mask)

write.csv(data_Corr,"Word_MicroEvent_ForR.csv", row.names = F)

########################### Prepare Word PermMicroEvents Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_PermMicroEvents_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Perm1","Cond2","Perm2")
A$Conditions = paste(A$Cond1,A$Perm1,A$Cond2,A$Perm2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("known", "puppet", "object", "unknown",
                                          "puppet_known", "known_object","puppet_object", 
                                          "known_unknown", "puppet_unknown", "object_unknown",
                                          "known_puppet", "object_known","object_puppet", 
                                          "unknown_known", "unknown_puppet", "unknown_object"),
                              labels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))

data_Corr$Hemisphere = case_when(grepl("_L",data_Corr$Mask)~"Left",
                                 grepl("_R",data_Corr$Mask)~"Right")
data_Corr$Mask = gsub("_L","",data_Corr$Mask)
data_Corr$Mask = gsub("_R","",data_Corr$Mask)

write.csv(data_Corr,"Word_PermMicroEvents_ForR.csv", row.names = F)



########################### Prepare Word PermME Both/Same/Diff Blocks Data and Save #################
fileName = "RSA_PermMEBoth_Word.csv"
data_Corr      = read.csv(paste(RD,fileName,sep=""),sep = ",",header=TRUE,strip.white=TRUE)
A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Block1","Perm1","Cond2","Block2","Perm2")
A$Conditions = paste(A$Cond1,A$Block1,A$Perm1,A$Cond2,A$Block2,A$Perm2,sep="_")
data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr = data_Corr[data_Corr$Perm1==data_Corr$Perm2,]
data_Corr$WordCond = unique("Both")
datBoth = data_Corr

fileName = "RSA_PermMESame_Word.csv"
data_Corr      = read.csv(paste(RD,fileName,sep=""),sep = ",",header=TRUE,strip.white=TRUE)
A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Block1","Perm1","Cond2","Block2","Perm2")
A$Conditions = paste(A$Cond1,A$Block1,A$Perm1,A$Cond2,A$Block2,A$Perm2,sep="_")
data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr = data_Corr[data_Corr$Perm1==data_Corr$Perm2,]
data_Corr$WordCond = unique("Same")
datSame = data_Corr

fileName = "RSA_PermMEDiff_Word.csv"
data_Corr      = read.csv(paste(RD,fileName,sep=""),sep = ",",header=TRUE,strip.white=TRUE)
A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","Block1","Perm1","Cond2","Block2","Perm2")
A$Conditions = paste(A$Cond1,A$Block1,A$Perm1,A$Cond2,A$Block2,A$Perm2,sep="_")
data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr = data_Corr[data_Corr$Perm1==data_Corr$Perm2,]
data_Corr$WordCond = unique("Diff")
datDiff = data_Corr

data_Corr = rbind(datBoth,datSame,datDiff)

data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("known", "puppet", "object", "unknown",
                                          "puppet_known", "known_object","puppet_object", 
                                          "known_unknown", "puppet_unknown", "object_unknown",
                                          "known_puppet", "object_known","object_puppet", 
                                          "unknown_known", "unknown_puppet", "unknown_object"),
                              labels = c("known", "puppet", "object", "novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel",
                                         "known_puppet", "known_object","puppet_object", 
                                         "known_novel", "puppet_novel", "object_novel"))

data_Corr$Hemisphere = case_when(grepl("_L",data_Corr$Mask)~"Left",
                                 grepl("_R",data_Corr$Mask)~"Right")
data_Corr$Mask = gsub("_L","",data_Corr$Mask)
data_Corr$Mask = gsub("_R","",data_Corr$Mask)
write.csv(data_Corr,"Word_PermMEBSD_ForR.csv", row.names = F)
