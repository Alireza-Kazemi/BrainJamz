%% Beta Image Extraction from SPM.mat Jan2023 Version

includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];
%% Extract BetaImages

resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';
maskingthreshold = 0.5;

for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' Beta Image ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end

    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
    conditionNames = {SPM.Sess.U(:).name};
    betaNames = {SPM.Vbeta(:).descrip};
    for conditionIdx = 1:length(conditionNames)
        conditionNames(conditionIdx) = conditionNames{conditionIdx};
        for maskIdx=1:length(MaskNames)
            betaImg = [];
            for betaImgIdx = 1:length(betaNames)
                if(contains(betaNames{betaImgIdx},conditionNames{conditionIdx}))
                    scan = SPM.Vbeta(betaImgIdx);
                    scan.fname = [ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,scan.fname];
                    Masked = spm_mask_MyVersion(mask{maskIdx}, scan, maskingthreshold);
                    betaImg = cat(2,betaImg,Masked);
                end
            end
            betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(lower(conditionNames{conditionIdx})).Beta = betaImg;
         end
     end
end

%% Save Beta Images

save([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat'],'betaImage','-v7.3');
disp(['Results Saved ---> ',rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat'])