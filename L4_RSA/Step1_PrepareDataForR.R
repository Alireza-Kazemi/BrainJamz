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


########################### Prepare Song BlockBased Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockBased_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("reverse_target", "novel_target", "novel_reverse",
                                          "baseline_target", "baseline_reverse", "baseline_novel"),
                              labels = c("target_reverse", "target_novel", "reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))
write.csv(data_Corr,"Song_BlockBased_ForR.csv", row.names = F)


########################### Prepare Song EventRelated Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_EventRelated_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "reverse", "novel", "baseline", 
                                          "reverse_target", "novel_target","novel_reverse",
                                          "baseline_target", "baseline_reverse", "baseline_novel"),
                              labels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Song_EventRelated_ForR.csv", row.names = F)

########################### Prepare Word BlockBased Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockBased_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("known_target", "unknown_target", "known_unknown",
                                          "baseline_target", "baseline_known", "baseline_unknown"),
                              labels = c("target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))
write.csv(data_Corr,"Word_BlockBased_ForR.csv", row.names = F)


########################### Prepare Word EventRelated Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_EventRelated_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "known", "unknown", "baseline", 
                                          "known_target", "unknown_target", "known_unknown",
                                          "baseline_target", "baseline_known", "baseline_unknown"),
                              labels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Word_EventRelated_ForR.csv", row.names = F)

########################### Prepare Song BlockEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockEvent_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "reverse", "novel", "baseline", 
                                          "reverse_target", "novel_target","novel_reverse",
                                          "baseline_target", "baseline_reverse", "baseline_novel"),
                              labels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Song_BlockEvent_ForR.csv", row.names = F)

########################### Prepare Word BlockEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_BlockEvent_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "known", "unknown", "baseline", 
                                          "known_target", "unknown_target", "known_unknown",
                                          "baseline_target", "baseline_known", "baseline_unknown"),
                              labels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Word_BlockEvent_ForR.csv", row.names = F)

########################### Prepare Song MicroEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_MicroEvent_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)

data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "reverse", "novel", "baseline", 
                                          "reverse_target", "novel_target","novel_reverse",
                                          "baseline_target", "baseline_reverse", "baseline_novel",
                                          "target_reverse", "target_novel","reverse_novel",
                                          "target_baseline", "reverse_baseline", "novel_baseline"),
                              labels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline",
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Song_MicroEvent_ForR.csv", row.names = F)


########################### Prepare Word MicroEvent Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_MicroEvent_Word.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

A = as.data.frame(strsplit(unique(data_Corr$Conditions),"_"))
A = transpose(A)
names(A) = c("Cond1","T1","Cond2","T2")
A$Conditions = paste(A$Cond1,A$T1,A$Cond2,A$T2,sep="_")

data_Corr = merge(data_Corr, A, by = "Conditions", all.x = T)
data_Corr$SimilarityCond = ifelse(data_Corr$Cond1 == data_Corr$Cond2, "Within","Between")
data_Corr$Conditions = case_when(data_Corr$SimilarityCond == "Within" ~ data_Corr$Cond1,
                                 data_Corr$SimilarityCond == "Between"~ paste(data_Corr$Cond1,data_Corr$Cond2,sep = "_"))
unique(data_Corr$Conditions)


data_Corr$Conditions = factor(data_Corr$Conditions, 
                              levels =  c("target", "known", "unknown", "baseline", 
                                          "known_target", "unknown_target", "unknown_known",
                                          "baseline_target", "baseline_known", "baseline_unknown",
                                          "target_known", "target_unknown", "known_unknown",
                                          "target_baseline", "known_baseline", "unknown_baseline"),
                              labels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline",
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))

data_Corr$timeCond = abs(as.numeric(data_Corr$T1) - as.numeric(data_Corr$T2))
data_Corr$timeCond = factor(data_Corr$timeCond,
                            levels = sort(unique(data_Corr$timeCond)))

write.csv(data_Corr,"Word_MicroEvent_ForR.csv", row.names = F)

########################### Prepare Song PermMicroEvents Data and Save #################
data_Corr      = read.csv(paste(RD,"RSA_PermMicroEvents_Song.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack      = read.csv(paste(RD,"TrackTable.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
songTrack$Subj = songTrack$ID
data_Corr = merge(data_Corr,songTrack[,c("Subj","songGroup")],by = "Subj")

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
                              levels =  c("target", "reverse", "novel", "baseline", 
                                          "reverse_target", "novel_target","novel_reverse",
                                          "baseline_target", "baseline_reverse", "baseline_novel",
                                          "target_reverse", "target_novel","reverse_novel",
                                          "target_baseline", "reverse_baseline", "novel_baseline"),
                              labels = c("target", "reverse", "novel", "baseline", 
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline",
                                         "target_reverse", "target_novel","reverse_novel",
                                         "target_baseline", "reverse_baseline", "novel_baseline"))


write.csv(data_Corr,"Song_PermMicroEvents_ForR.csv", row.names = F)


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
                              levels =  c("target", "known", "unknown", "baseline", 
                                          "known_target", "unknown_target", "unknown_known",
                                          "baseline_target", "baseline_known", "baseline_unknown",
                                          "target_known", "target_unknown", "known_unknown",
                                          "target_baseline", "known_baseline", "unknown_baseline"),
                              labels = c("target", "known", "unknown", "baseline", 
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline",
                                         "target_known", "target_unknown", "known_unknown",
                                         "target_baseline", "known_baseline", "unknown_baseline"))


write.csv(data_Corr,"Word_PermMicroEvents_ForR.csv", row.names = F)
