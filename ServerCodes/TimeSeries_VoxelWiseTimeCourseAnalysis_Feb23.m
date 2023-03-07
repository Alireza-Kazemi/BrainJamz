%% Time Series Analysis

includeSubj = Info.(['include',SessName]);


%% Within Blocks Inter Voxel Similarities
datTable = [];
for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' TimeSeries Analysis ','_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    Subj = [];
    Conditions = [];
    Mask = [];
    Interpolated = [];
    CorrVal = [];
    conditionNames = fields(timeSeries.(['S',IDs{sID}]).dat.(MaskNames{1}));
    for conditionIdx = 1:length(conditionNames)
        for maskIdx=1:length(MaskNames)
            ts = timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            simScore = ComputeInterVoxelSimilarities(ts);
            
            Subj = cat(1,Subj,string(['S',IDs{sID}]));
            Conditions = cat(1,Conditions,string(conditionNames{conditionIdx}));
            Mask = cat(1,Mask,string(MaskNames{maskIdx}));
            Interpolated = cat(1,Interpolated,0);
            CorrVal = cat(1,CorrVal,simScore);


            tsInterp = timeSeries.(['S',IDs{sID}]).datInterp.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            simScoreInterp = ComputeInterVoxelSimilarities(tsInterp);
            
            Subj = cat(1,Subj,string(['S',IDs{sID}]));
            Conditions = cat(1,Conditions,string(conditionNames{conditionIdx}));
            Mask = cat(1,Mask,string(MaskNames{maskIdx}));
            Interpolated = cat(1,Interpolated,1);
            CorrVal = cat(1,CorrVal,simScoreInterp);
        end
    end
    datTable = cat(1,datTable,table(Subj,Conditions,Mask,Interpolated,CorrVal));
end

% Save Output in CSV format

writetable(datTable,[rootResultPath,Sep,'TimeSeries_InterVoxelSim_',SessName,'.csv']);
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_InterVoxelSim_',SessName,'.csv'])

%% Within Blocks Step-Wise Temporal RSA 
datTable = [];
for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' TimeSeries Analysis ','_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    Subj = [];
    Conditions = [];
    Mask = [];
    CorrVal = [];
    CorrValInterp = [];
    timePoints = [];
    Interpolated = [];
    blockIndex = [];
    conditionNames = fields(timeSeries.(['S',IDs{sID}]).dat.(MaskNames{1}));
    for conditionIdx = 1:length(conditionNames)
        for maskIdx=1:length(MaskNames)
            ts = timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            Step = 1; %Every TR which is 1.5s
            for blockIdx = 1:length(ts)
                simScore = ComputeStepWiseRSA(ts{blockIdx},1);
                L = length(simScore);
                Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),L,1));
                Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),L,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),L,1));
                blockIndex = cat(1,blockIndex,repmat(blockIdx,L,1));
                Interpolated = cat(1,Interpolated,false(L,1));
                timePoints = cat(1,timePoints,(1:L)');
                CorrVal = cat(1,CorrVal,simScore);
            end
            
            tsInterp = timeSeries.(['S',IDs{sID}]).datInterp.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            Step = 2; % Every 1 seconds
            for blockIdx = 1:length(tsInterp)
                simScore = ComputeStepWiseRSA(tsInterp{blockIdx},Step);
                L = length(simScore);
                Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),L,1));
                Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),L,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),L,1));
                blockIndex = cat(1,blockIndex,repmat(blockIdx,L,1));
                Interpolated = cat(1,Interpolated,true(L,1));
                timePoints = cat(1,timePoints,(1:L)');
                CorrVal = cat(1,CorrVal,simScore);
            end
        end
    end
    datTable = cat(1,datTable,table(Subj,Conditions,Mask,blockIndex,Interpolated,timePoints,CorrVal));
end
% Save Output in CSV format

writetable(datTable,[rootResultPath,Sep,'TimeSeries_StepWiseRSA_',SessName,'.csv']);
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_StepWiseRSA_',SessName,'.csv'])



%% Within Blocks Average Time Course 
datTable = [];
for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' TimeSeries Analysis ','_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end
    Subj = [];
    Conditions = [];
    Mask = [];
    BoldVal = [];
    timePoints = [];
    Interpolated = [];
    blockIndex = [];
    conditionNames = fields(timeSeries.(['S',IDs{sID}]).dat.(MaskNames{1}));
    for conditionIdx = 1:length(conditionNames)
        for maskIdx=1:length(MaskNames)
            ts = timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            for blockIdx = 1:length(ts)
                simScore = mean(zscore(ts{blockIdx},0,2),'omitnan')';
                L = length(simScore);
                Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),L,1));
                Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),L,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),L,1));
                blockIndex = cat(1,blockIndex,repmat(blockIdx,L,1));
                Interpolated = cat(1,Interpolated,false(L,1));
                timePoints = cat(1,timePoints,(1:L)');
                BoldVal = cat(1,BoldVal,simScore);
            end
            
            tsInterp = timeSeries.(['S',IDs{sID}]).datInterp.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            for blockIdx = 1:length(tsInterp)
                simScore = mean(zscore(tsInterp{blockIdx},0,2),'omitnan')';
                L = length(simScore);
                Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),L,1));
                Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),L,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),L,1));
                blockIndex = cat(1,blockIndex,repmat(blockIdx,L,1));
                Interpolated = cat(1,Interpolated,true(L,1));
                timePoints = cat(1,timePoints,(1:L)');
                BoldVal = cat(1,BoldVal,simScore);
            end
        end
    end
    datTable = cat(1,datTable,table(Subj,Conditions,Mask,blockIndex,Interpolated,timePoints,BoldVal));
end
% Save Output in CSV format

writetable(datTable,[rootResultPath,Sep,'TimeSeries_AverageTimeSeries_',SessName,'.csv']);
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_AverageTimeSeries_',SessName,'.csv'])