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
# p_load(psych,plyr,psych,MCMCpack)

RD = "D:\\Projects\\BrainJamz\\DataFiles\\L6_Connectivity\\"
WD = "D:\\Projects\\BrainJamz\\DataFiles\\L6_Connectivity\\"


# library(HMLET)
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
dat      = read.csv(paste(RD,"Word_Connectivity_Sig_ForR.csv",sep=""),sep = ",",header=TRUE,strip.white=TRUE)
dat$Condition = factor(dat$Condition, 
                              levels = c("known", "puppet","object", "novel","baseline"))
head(dat)
dat_conn = dat


sDat = dat_conn

df = sDat[,c("Seed","Target")]
sDat$Regions = apply(df, 1, function(row) {
                              sorted_row <- sort(row)
                              paste(sorted_row, collapse = "-")
                            })

sDat$Hemisphere = case_when( (grepl("_L",sDat$Seed) & grepl("_L",sDat$Target)) ~ "Left",
                             (grepl("_R",sDat$Seed) & grepl("_R",sDat$Target)) ~ "Right",
                             (grepl("_L",sDat$Seed) & grepl("_R",sDat$Target)) ~ "Cross",
                             (grepl("_R",sDat$Seed) & grepl("_L",sDat$Target)) ~ "Cross")


sDat$Regions[sDat$Seed == sDat$Target] = sDat$Seed[sDat$Seed == sDat$Target]
sDat$Regions = gsub("_L","",sDat$Regions)
sDat$Regions = gsub("_R","",sDat$Regions)

sDat = sDat[sDat$Seed != sDat$Target,]
sDat = as.data.frame(summarise(group_by(sDat,Subj,Condition,Regions,Hemisphere),
                               N=n(),
                               CorrAllS = mean(CorrAllS,na.rm=T),
                               CorrAllS_Sig = mean(CorrAllS_Sig,na.rm=T)))

sDat = sDat[sDat$Hemisphere == "Left",]

unique(sDat$Regions)
head(sDat)

ggplot(sDat,aes(x=Hemisphere, y = CorrAllS_Sig, fill = Regions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Condition)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

ggplot(sDat,aes(x=Regions, y = CorrAllS_Sig, fill =Condition )) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

SaveDat = reshape2::dcast(sDat,Subj~Condition+Regions+Hemisphere,value.var = "CorrAllS_Sig")
write.csv(SaveDat,"ConnectivityScores")

ggplot(sDat,aes(x=Regions, y=CorrSeeds, fill =Condition )) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

ggplot(sDat,aes(x=Hemisphere, y=CorrSeeds, fill = Regions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Condition)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

sDat = as.data.frame(summarise(group_by(sDat,Subj,Condition,Regions),
                               N=n(),
                               CorrAllS = mean(CorrAllS,na.rm=T),
                               CorrRmF2S = mean(CorrRmF2S,na.rm=T),
                               CorrSeeds = mean(CorrSeeds,na.rm=T)))

unique(sDat$Regions)
head(sDat)

ggplot(sDat,aes(x=Regions, y=CorrAllS, fill = Regions)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Condition)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())



datL18s = sDat[,c("Subj", "Condition", "Seed", "Target", "CorrRmF2S")]
names(datL18s) = c("Subj", "Condition", "Seed", "Target", "value")
dat20s = sDat[,c("Subj", "Condition", "Seed", "Target", "CorrAllS")]
names(dat20s) = c("Subj", "Condition", "Seed", "Target", "value")
datSeed = sDat[,c("Subj", "Condition", "Seed", "Target", "CorrSeeds")]
names(datSeed) = c("Subj", "Condition", "Seed", "Target", "value")

########################### Plot All together ----------
sDat = dat_conn
sDat = reshape2::melt(sDat, id.vars = c("Subj","Condition","Seed","Target"), variable.name = "Window")

sDat$Condition = factor(sDat$Condition, levels =  c("known", "puppet","object", "novel","baseline"))

sDat = sDat[sDat$Window == "CorrRmF2S",]
# sDat = sDat[sDat$Window == "CorrAllS",]

ggplot(sDat,aes(x=Seed, y=value, fill = Target)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Condition)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  scale_fill_brewer(palette = "Oranges", direction = -1)

########################### Plot Collapse Connectivities ----------


sDat = reshape2::melt(sDat, id.vars = c("Subj","Condition","Seed","Target"), variable.name = "Window")



sDat$Condition = factor(sDat$Condition, levels =  c("known", "puppet","object", "novel","baseline"))

sDat = sDat[sDat$Window == "CorrRmF2S",]
# sDat = sDat[sDat$Window == "CorrAllS",]

ggplot(sDat,aes(x=Seed, y=value, fill = Target)) + 
  geom_bar(stat="summary",fun="mean",position="dodge")+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  facet_wrap(~Condition)+
  theme_bw(base_family = "serif")+
  theme(strip.text.x = element_text(size=16, face="bold"))+
  labs(x="Source",y="Connectivity Score", size=16)+
  theme(axis.title.y = element_text(size = 18))+
  theme(axis.text.x = element_text(size = 16))+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  scale_fill_brewer(palette = "Oranges", direction = -1)

########################### Export Wide Format ----------
