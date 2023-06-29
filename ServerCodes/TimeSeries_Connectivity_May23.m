%% Time Series Analysis

includeSubj = Info.(['include',SessName]);


%% Seed-Based Connectivity
datTable = [];
for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' Seed Based Connectivity ','_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    Subj = [];
    Seed = [];
    Condition = [];
    Target = [];
    CorrRmF2S = [];
    CorrAllS = [];
    CorrSeeds = [];
    CorrRmF2S_Sig = [];
    CorrAllS_Sig = [];
    CorrSeeds_Sig = [];
    conditionNames = fields(timeSeries.(['S',IDs{sID}]).dat.(MaskNames{1}));
    for conditionIdx = 1:length(conditionNames)
        disp("        Condition: " + string(conditionNames{conditionIdx}))
        for maskIdxSeed = 1:length(MaskNames)
            disp("        Seed: " + string(MaskNames{maskIdxSeed}))
            for maskIdxRest = 1:length(MaskNames)
                tsSeed = timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdxSeed}).(conditionNames{conditionIdx});
                tsRest = timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdxRest}).(conditionNames{conditionIdx});
                SeedStr = string(MaskNames{maskIdxSeed});
                [averageCorrROI, averageCorrROI_Sig] = SeedBasedCorrelations(tsSeed,tsRest);
                Subj = cat(1,Subj,['S',IDs{sID}]);
                Condition = cat(1,Condition,string(conditionNames{conditionIdx}));
                Seed = cat(1,Seed,SeedStr);
                Target = cat(1,Target,string(MaskNames{maskIdxRest}));
                CorrRmF2S = cat(1,CorrRmF2S,averageCorrROI(1));
                CorrAllS = cat(1,CorrAllS,averageCorrROI(2));
                CorrSeeds = cat(1,CorrSeeds,averageCorrROI(3));
                CorrRmF2S_Sig = cat(1,CorrRmF2S_Sig,averageCorrROI_Sig(1));
                CorrAllS_Sig = cat(1,CorrAllS_Sig,averageCorrROI_Sig(2));
                CorrSeeds_Sig = cat(1,CorrSeeds_Sig,averageCorrROI_Sig(3));
            end
        end
    end
    datTable = cat(1,datTable,table(Subj,Condition,Seed,Target,...
                        CorrRmF2S,CorrAllS,CorrSeeds, ...
                        CorrRmF2S_Sig,CorrAllS_Sig,CorrSeeds_Sig));
end

%% Save Output in CSV format

writetable(datTable,[rootResultPath,Sep,'TimeSeries_SeedbasedConn_',SessName,'.csv']);
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_SeedbasedConn_',SessName,'.csv'])

