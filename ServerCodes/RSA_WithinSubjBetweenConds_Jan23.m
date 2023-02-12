%----> Compute RSA within Subj between Conditions Spatial Correlations


%% Compute RSA
datTable = [];

for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' RSA ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    for maskIdx = 1:length(MaskNames)
        Subj = [];
        Conditions = [];
        Mask = [];
        CorrVal = [];
        conditionNames = fieldnames(betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}));
        for conditionIdx1 = 1:(length(conditionNames)-1)
            for conditionIdx2 = (conditionIdx1+1):length(conditionNames)
                biDat1 = betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx1}).Beta(:,1);
                biDat2 = betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx2}).Beta(:,1);
                condStr = string(conditionNames{conditionIdx1})+"_"+string(conditionNames{conditionIdx2});
                idx = ~(isnan(biDat1) | isnan(biDat2));
                biDat1 = biDat1(idx);
                biDat2 = biDat2(idx);
                CorrROI = 1-pdist([biDat1,biDat2]','correlation');
                Subj = cat(1,Subj,string(['S',IDs{sID}]));
                Conditions = cat(1,Conditions,condStr);
                Mask = cat(1,Mask,string(MaskNames{maskIdx}));
                CorrVal = cat(1,CorrVal,CorrROI);
            end
        end
        datTable = cat(1,datTable,table(Subj,Conditions,Mask,CorrVal));
    end
end

%% Save Output in CSV format

writetable(datTable,[rootResultPath,Sep,'RSA_',DesignName,'_',SessName,'.csv']);
disp(['Results Saved ---> ',rootResultPath,Sep,'RSA_',DesignName,'_',SessName,'.csv'])