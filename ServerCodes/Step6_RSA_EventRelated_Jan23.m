% RSA Analysis
clear;
clc;
close all;

%% Load Information data
load ParticipantsInfoJan23.mat
IDs = Info.IDs;

MaskNames = {'HPC'}; 


%% RSA for Song EventRelated
DesignName = 'EventRelated';
SessName = 'Song';
includeSubj = Info.(['include',SessName]);
load(['BetaImages',DesignName,'_',SessName,'.mat']);



%% RSA for Word EventRelated within Subj between Conditions
DesignName = 'EventRelated';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
load(['BetaImages',DesignName,'_',SessName,'.mat']);

conditionNames = {'target',...1
	              'Known',...3
	              'Unknown',...4
                  'baseline'}; %..5


%----> Compute RSA Between Subj Within Conditions Spatial Correlations
Subj = [];
Conditions = [];
Mask = [];
CorrVal = [];
for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' Data for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    for maskIdx = 1:length(MaskNames)
        for conditionIdx1 = 1:(length(conditionNames)-1)
            for conditionIdx2 = (conditionIdx1+1):length(conditionNames)
                biDat1 = betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx1}).Beta(:,1);
                biDat2 = betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx2}).Beta(:,1);
                condStr = string(conditionNames{conditionIdx1})+"_"+string(conditionNames{conditionIdx2});
                idx = ~(isnan(biDat1) | isnan(biDat1));
                biDat1 = biDat1(idx);
                biDat2 = biDat2(idx);
                CorrROI = 1-pdist([biDat1,biDat2]','correlation');
                Subj = cat(1,Subj,['S',IDs{sID}]);
                Conditions = cat(1,Conditions,condStr);
                Mask = cat(1,Mask,string(MaskNames{maskIdx}));
                CorrVal = cat(1,CorrVal,CorrROI);
            end
        end
    end
end
datTable = table(Subj,Conditions,Mask,CorrVal);
writetable(datTable,['RSA_',DesignName,'_',SessName,'.csv']);