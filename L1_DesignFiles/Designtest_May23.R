########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
D:\Projects\BrainJamz\DataFiles\L1_DesignFiles
setwd(x)

x = getwd()

library(pacman)
p_load(ggplot2,Hmisc,plyr,dplyr,tibble,tidyr,reshape2)
###################################
datAll = NULL
datPath = paste(x,'T1',sep = "/")
subjects = dir(datPath)

######################### Create Vector files Words -------------------
for (subj in subjects){
  
  # Word-------------------------------------------
  runStr = "Word"
  runPath = runStr
  DesignFile  = paste("S",subj,"_",runStr,".m",sep = "")
  
  textPath = paste(datPath,subj,runPath,sep = "/")
  tFiles = dir(textPath, pattern = paste(subj,".*.txt",sep=""))
  if(length(tFiles)==0){
    datTemp = data.frame(c(NA),c(NA))
    names(datTemp) = c("time","duration")
    datTemp$subjID = unique(subj)
    datTemp$condition = NA
    datTemp$index = 1:nrow(datTemp)
    datTemp$Run = unique(runStr)
    datAll = rbind(datAll,datTemp)
    next
  }
  
  conditions = sub(paste(subj,"_",sep = ""),"",tFiles)
  conditions = sub(".txt","",conditions)
  conditions[conditions=="Kword"] = "Known"
  conditions[conditions=="Wunknown"] = "Unknown"
  indexCond = 1
  for (condInd in (1:length(tFiles))){
    datTemp = read.table(paste(textPath,tFiles[condInd],sep = "/"),header = F)
    names(datTemp) = c("time","duration","code") 
    datTemp = datTemp[,c("time","duration")]
    
    datTemp$subjID = unique(subj)
    datTemp$condition = unique(conditions[condInd])
    datTemp$index = 1:nrow(datTemp)
    datTemp$Run = unique(runStr)
    datAll = rbind(datAll,datTemp)
  }
  
} 

datAll = datAll[datAll$condition %in% c("Ctarget","Otarget"),]
datAll$condition2 = paste(datAll$condition,datAll$index,sep = "") 
head(datAll)
dat = reshape2::dcast(datAll,subjID ~ condition2, value.var="time")


ggplot(datAll,aes(x = index , y = time, fill = condition)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = condition))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")

ggplot(datAll,aes(x = condition2 , y = time, fill = condition2)) +
  geom_bar(stat="summary",fun="mean",position="dodge")+
  geom_jitter(position = position_jitterdodge(jitter.width = NULL,
                                              jitter.height = 0,
                                              dodge.width = .75),shape = 21,fill="grey",aes(colour = condition2))+
  stat_summary(fun.data = "mean_se", geom="errorbar",position="dodge")+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  theme(text = element_text(size=14))+
  scale_fill_brewer(palette="Dark2")+
  scale_color_brewer(palette="Dark2")


ggplot(datAll,aes(x=index,y=time,colour=condition)) +
  geom_line(stat="summary",fun="mean",position=position_dodge(width = 0.5),linewidth = 2) +
  stat_summary(fun.data = "mean_se", geom="errorbar",position = position_dodge(width = 0.5), alpha = 0.5, linewidth=1)+
  theme_bw(base_family = "serif")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

write.csv(datAll,"TimingDataWordSongCollapsed.csv",row.names = F)
######################### Create Vector files Words -------------------
for (subj in subjects){

  # Word-------------------------------------------
  runStr = "Word"
  runPath = runStr
  DesignFile  = paste("S",subj,"_",runStr,".m",sep = "")
  
  textPath = paste(datPath,subj,runPath,sep = "/")
  tFiles = dir(textPath, pattern = paste(subj,".*.txt",sep=""))
  if(length(tFiles)==0){
    datTemp = data.frame(c(NA),c(NA))
    names(datTemp) = c("time","duration")
    datTemp$subjID = unique(subj)
    datTemp$condition = NA
    datTemp$Run = unique(runStr)
    datAll = rbind(datAll,datTemp)
    next
  }
  
  conditions = sub(paste(subj,"_",sep = ""),"",tFiles)
  conditions = sub(".txt","",conditions)
  conditions[conditions=="Kword"] = "Known"
  conditions[conditions=="Wunknown"] = "Unknown"
  for (condInd in (1:length(tFiles))){
    if(conditions[condInd] %in% c("Ctarget","Otarget")){
      next
    }
    datTemp = read.table(paste(textPath,tFiles[condInd],sep = "/"),header = F)
    names(datTemp) = c("time","duration","code") 
    datTemp = datTemp[,c("time","duration")]
    
    datTemp$subjID = unique(subj)
    datTemp$condition = unique(conditions[condInd])
    datTemp$Run = unique(runStr)
    datAll = rbind(datAll,datTemp)
    
    Text = print("%=====================================================",quote = F)
    write(Text, DesignFile, append = T)
    
    Text = print("i=i+1;",quote = F)
    write(Text, DesignFile, append = T)
    
    Text = print(paste("names{i} = \'",conditions[condInd],"\';",sep = ""),quote = F)
    write(Text, DesignFile, append = T)
    
    onsets = datTemp$time
    Text = print(paste("onsets{i} = [",paste(onsets,sep="",collapse = ","),"];",sep = ""),quote = F)
    write(Text, DesignFile, append = T)
    
    durs = datTemp$duration
    Text = print(paste("durations{i} = [",paste(durs,sep="",collapse = ","),"];",sep = ""),quote = F)
    write(Text, DesignFile, append = T)
    
  }
  
  datTemp = NULL
  conditionStr = "target"
  for (condInd in (1:length(tFiles))){
    if(conditions[condInd] %in% c("Ctarget","Otarget")){
      datTemp0 = read.table(paste(textPath,tFiles[condInd],sep = "/"),header = F)
      names(datTemp0) = c("time","duration","code") 
      datTemp0 = datTemp0[,c("time","duration")]
      datTemp = rbind(datTemp,datTemp0)
    }
  }
  datTemp = datTemp[order(datTemp$time),]
  datTemp$subjID = unique(subj)
  datTemp$condition = unique(conditionStr)
  datTemp$Run = unique(runStr)
  datAll = rbind(datAll,datTemp)
    
  Text = print("%=====================================================",quote = F)
  write(Text, DesignFile, append = T)
  
  Text = print("i=i+1;",quote = F)
  write(Text, DesignFile, append = T)
  
  Text = print(paste("names{i} = \'",conditionStr,"\';",sep = ""),quote = F)
  write(Text, DesignFile, append = T)
  
  onsets = datTemp$time
  Text = print(paste("onsets{i} = [",paste(onsets,sep="",collapse = ","),"];",sep = ""),quote = F)
  write(Text, DesignFile, append = T)
  
  durs = datTemp$duration
  Text = print(paste("durations{i} = [",paste(durs,sep="",collapse = ","),"];",sep = ""),quote = F)
  write(Text, DesignFile, append = T)

  
  Text = print("%=====================================================",quote = F)
  write(Text, DesignFile, append = T)
  Filename = paste("S",subj,"_",runStr,sep = "")
  Text = print(paste("save(\'",Filename,"\',\'names\',\'onsets\',\'durations\')",sep = ""),quote = F)
  write(Text, DesignFile, append = T)
} 

write.csv(datAll,"TimingDataWordSongCollapsed.csv",row.names = F)
