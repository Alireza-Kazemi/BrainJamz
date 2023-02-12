%% Load and Append all separate beta images computed in separate first level analysis

betaTemp = [];
for mEIdx = 1:20
    mENameTag = [eventTagName,num2str(mEIdx)];
    DesignName = [DesingNameRoot,mENameTag];
    % Load SPM Data
    load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
    for sID = 1:length(IDs)
        disp([num2str(sID),'/',num2str(length(IDs)),' RSA ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
        if(includeSubj(sID)==0)
            disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
            continue;
        end
        for maskIdx = 1:length(MaskNames)
            conditionNames = fieldnames(betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}));
            for conditionIdx1 = 1:(length(conditionNames)-1)
                betaTemp.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx1}).Beta = ...
                betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx1}).Beta(:,1);
            end
        end
    end
end
betaImage = betaTemp;
clear betaTemp;