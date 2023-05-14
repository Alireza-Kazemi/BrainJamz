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
    datTemp$Run = unique(runStr)
    datAll = rbind(datAll,datTemp)
    next
  }
  
  conditions = sub(paste(subj,"_",sep = ""),"",tFiles)
  conditions = sub(".txt","",conditions)
  conditions[conditions=="Kword"] = "Known"
  conditions[conditions=="Wunknown"] = "Unknown"
  conditions[conditions=="Ctarget"] = "Puppet"
  conditions[conditions=="Otarget"] = "Object"
  for (condInd in (1:length(tFiles))){
    if(conditions[condInd] %in% c("baseline")){
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
  
  Text = print("%=====================================================",quote = F)
  write(Text, DesignFile, append = T)
  Filename = paste("S",subj,"_",runStr,sep = "")
  Text = print(paste("save(\'",Filename,"\',\'names\',\'onsets\',\'durations\')",sep = ""),quote = F)
  write(Text, DesignFile, append = T)
} 
