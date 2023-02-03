########################### Initialization ##########################
rm(list=ls(all=TRUE))

x = readline()
C:\Users\kazemi\Documents\MyFiles\MyFiles\PhD Research\MRI Serious\BrainJamz
setwd(x)

x = getwd()

library(pacman)
p_load(ggplot2,Hmisc,plyr,dplyr,tibble,tidyr,reshape2)


######################### Create Vector files Songs -------------------
datAll = NULL
datPath = paste(x,'T1',sep = "/")
subjects = dir(datPath)

# Target Reverse -> TReverse
Replication_IDs =c(76, 93, 95, 97, 98, 123, 124, 132, 133, 134, 141, 151, 153, 154, 156, 157, 158, 165, 177, 190, 195, 220, 221, 223, 226, 228, 230, 232, 234, 235);
# Non-target Reverse -> NReverse 
Extension_IDs = c(155, 166, 169, 192, 199, 206, 208, 209, 210, 216, 218, 219, 233, 239, 240, 242);

for (subj in subjects){
  # Song-------------------------------------------
  runStr = "Song"
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
  conditions[conditions=="nontarget"] = "novel"
  for (condInd in (1:length(tFiles))){
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
    
    # if((as.numeric(subj) %in% Replication_IDs)& conditions[condInd] == "reverse"){
    #   conditions[condInd] = "treverse"
    #   
    #   datTemp$subjID = unique(subj)
    #   datTemp$condition = unique(conditions[condInd])
    #   datTemp$Run = unique(runStr)
    #   datAll = rbind(datAll,datTemp)
    #   
    #   Text = print("%=====================================================",quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   Text = print("i=i+1;",quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   Text = print(paste("names{i} = \'",conditions[condInd],"\';",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   onsets = datTemp$time
    #   Text = print(paste("onsets{i} = [",paste(onsets,sep="",collapse = ","),"];",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   durs = datTemp$duration
    #   Text = print(paste("durations{i} = [",paste(durs,sep="",collapse = ","),"];",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    # }
    # if((as.numeric(subj) %in% Extension_IDs)& conditions[condInd] == "reverse"){
    #   conditions[condInd] = "nreverse"
    #   
    #   datTemp$subjID = unique(subj)
    #   datTemp$condition = unique(conditions[condInd])
    #   datTemp$Run = unique(runStr)
    #   datAll = rbind(datAll,datTemp)
    #   
    #   Text = print("%=====================================================",quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   Text = print("i=i+1;",quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   Text = print(paste("names{i} = \'",conditions[condInd],"\';",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   onsets = datTemp$time
    #   Text = print(paste("onsets{i} = [",paste(onsets,sep="",collapse = ","),"];",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    #   durs = datTemp$duration
    #   Text = print(paste("durations{i} = [",paste(durs,sep="",collapse = ","),"];",sep = ""),quote = F)
    #   write(Text, DesignFile, append = T)
    #   
    # }
    
  }
  
  
  Text = print("%=====================================================",quote = F)
  write(Text, DesignFile, append = T)
  Filename = paste("S",subj,"_",runStr,sep = "")
  Text = print(paste("save(\'",Filename,"\',\'names\',\'onsets\',\'durations\')",sep = ""),quote = F)
  write(Text, DesignFile, append = T)
}

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
