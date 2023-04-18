########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\SRCD\
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

RD = "D:\\Projects\\BrainJamz\\DataFiles\\SRCD\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\SRCD\\"



######################################################### Univariate Contrasts ----
dat = read.csv(paste(RD,"NewData.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

dat = dat[,c("ID","obj_char_L_hip_m", "Contrast_Known_LHPC","obj_char_L_antPHG_m","Contrast_Known_aMTL")]
names(dat) = c("ID","HPC_Target>Unknown", "HPC_Known>Unknown","aMTL_Target>Unknown", "aMTL_Known>Unknown")
dat = reshape2::melt(dat, id.vars = "ID",measure.vars = c("HPC_Target>Unknown", "HPC_Known>Unknown","aMTL_Target>Unknown", "aMTL_Known>Unknown"), 
                     variable.name = "Contrast", value.name = "Activation" )
dat$Mask = case_when(grepl("HPC_",dat$Contrast)~"HPC",
                     grepl("aMTL_",dat$Contrast)~"aMTL")
dat$Contrast = gsub("HPC_","",dat$Contrast)
dat$Contrast = gsub("aMTL_","",dat$Contrast)
unique(dat$Contrast)
dat$Mask = factor(dat$Mask, levels = c("HPC","aMTL"))
dat$Contrast = factor(dat$Contrast, levels = c("Target>Unknown","Known>Unknown"),
                      labels = c("Target > Unknown","Known > Unknown"))

ggplot(dat,aes(x = Contrast , y = Activation, fill = Contrast)) +
  # geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = Contrast))+
  # geom_boxplot(outlier.colour="black",outlier.shape=8,
  #              size=.5,fill = NA,aes(colour = condition))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge",linewidth=2,
               aes(colour = Contrast))+
  theme_bw(base_family = "serif")+
  # theme(strip.text.x = element_text(size=16, face="bold"))+
  # theme(strip.text.y = element_text(size=16, face="bold"))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  # theme(legend.text = element_text(size = 16))+
  # theme(axis.title.y = element_text(size = 18))+
  # theme(axis.title.x = element_text(size = 18))+
  theme(text = element_text(size=14))+
  facet_wrap(~Mask)
graph2ppt(file=paste(WD,"Figure1.pptx",sep = ""),width = 9, height = 4)
######################################################### Univariate Contrasts ----
dat = read.csv(paste(RD,"NewData.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)

dat = dat[,c("ID","obj_char_L_hip_m", "Known_L_whole_M","obj_char_L_antPHG_m","Known_L_antPHG_M")]
names(dat) = c("ID","HPC_Target>Unknown", "HPC_Known>Unknown","aMTL_Target>Unknown", "aMTL_Known>Unknown")
dat = reshape2::melt(dat, id.vars = "ID",measure.vars = c("HPC_Target>Unknown", "HPC_Known>Unknown","aMTL_Target>Unknown", "aMTL_Known>Unknown"), 
                     variable.name = "Contrast", value.name = "Activation" )
dat$Mask = case_when(grepl("HPC_",dat$Contrast)~"HPC",
                     grepl("aMTL_",dat$Contrast)~"aMTL")
dat$Contrast = gsub("HPC_","",dat$Contrast)
dat$Contrast = gsub("aMTL_","",dat$Contrast)
unique(dat$Contrast)
dat$Mask = factor(dat$Mask, levels = c("HPC","aMTL"))
dat$Contrast = factor(dat$Contrast, levels = c("Target>Unknown","Known>Unknown"),
                      labels = c("Target > Unknown","Known > Unknown"))

ggplot(dat,aes(x = Contrast , y = Activation, fill = Contrast)) +
  # geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = Contrast))+
  # geom_boxplot(outlier.colour="black",outlier.shape=8,
  #              size=.5,fill = NA,aes(colour = condition))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge",linewidth=2,
               aes(colour = Contrast))+
  theme_bw(base_family = "serif")+
  # theme(strip.text.x = element_text(size=16, face="bold"))+
  # theme(strip.text.y = element_text(size=16, face="bold"))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  # theme(legend.text = element_text(size = 16))+
  # theme(axis.title.y = element_text(size = 18))+
  # theme(axis.title.x = element_text(size = 18))+
  theme(text = element_text(size=14))+
  facet_wrap(~Mask)
graph2ppt(file=paste(WD,"Figure1.pptx",sep = ""),width = 9, height = 4)
######################################################### Selection Rate ----
dat = read.csv(paste(RD,"SelectionRate.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)


dat = reshape2::melt(dat, id.vars = "ID", 
                     variable.name = "Condition", value.name = "value" )

dat$Session = case_when(grepl("S1_",dat$Condition)~"S1",
                        grepl("S2_",dat$Condition)~"S2")

dat$Condition = gsub("S1_","",dat$Condition)
dat$Condition = gsub("S2_","",dat$Condition)

dat$Name = case_when(grepl("_o",dat$Condition)~"Object",
                     grepl("_c",dat$Condition)~"Puppet")

dat$Condition = gsub("_o","",dat$Condition)
dat$Condition = gsub("_c","",dat$Condition)

dat = as.data.frame(summarise(group_by(dat,ID,Condition,Session),value = mean(value,na.rm = T)))

dat$Condition = factor(dat$Condition, levels = c("Tar","Non","Dis"),
                       labels = c("Target","NonTarget","Distractor"))

dat = dat[dat$Session == "S2",]
ggplot(dat,aes(x = Condition , y = value, fill = Condition)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  # geom_boxplot(outlier.colour="black",outlier.shape=8,
  #              size=.5,fill = NA,aes(colour = condition))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge",linewidth=1)+
  theme_bw(base_family = "serif")+
  # theme(strip.text.x = element_text(size=16, face="bold"))+
  # theme(strip.text.y = element_text(size=16, face="bold"))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  # theme(legend.text = element_text(size = 16))+
  # theme(axis.title.y = element_text(size = 18))+
  # theme(axis.title.x = element_text(size = 18))+
  theme(text = element_text(size=14))+
  facet_wrap(~Session)
graph2ppt(file=paste(WD,"Figure2.pptx",sep = ""),width = 9, height = 6)
