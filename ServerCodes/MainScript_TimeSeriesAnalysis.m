% Time Series Correlation Computation
clear;
clc;
close all;

load TimeSeriesDat.mat
load ParticipantsInfo_Removed.mat

IDs = Info.IDs;

MaskNames = { 'HPC',...
              'Right_HPC',...
              'Left_HPC'}; 
          
designName = 'Collapsed'; %'Separated'; %

if(strcmp(designName,'Separated'))
    conditionNames = {'baseline',...1
	    'target',...2
	    'nreverse',...3
	    'treverse',...4
	    'novel'}; %..5
else
    conditionNames = {'baseline',...1
	    'target',...2
	    'reverse',...3
	    'novel'}; %..4
end          
%% Similarity Parameters


%% Compute Within Subject Within Condition Spatial Correlations
Subj = [];
Conditions = [];
Mask = [];
ScanNum = [];
CorrVals = [];
variations = [];
for sID = 1:length(IDs)
    for conditionIdx = 1:length(conditionNames)
        for maskIdx = 1:length(MaskNames)
            tsDat = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            [averageCorrROI, averageVariation]= ComputeSpatialCorrelation(tsDat);
            Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),16,1));
            Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),16,1));
            Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),16,1));
            ScanNum  = cat(1,ScanNum,(1:16)');
%             variations = cat(1,variations,repmat(averageVariation,16,1));
            variations = cat(1,variations,averageVariation);
            CorrVals = cat(1,CorrVals,averageCorrROI');
        end
    end
end
datTable = table(Subj,Conditions,Mask,ScanNum,CorrVals);
writetable(datTable,'SpatialCorrelationsWithinSubj_WithinCond.csv');

%% Compute Within Subject Within Condition Single 10 first TR Spatial Correlations
Subj = [];
Conditions = [];
Mask = [];
ScanNum = [];
CorrVals = [];
for sID = 1:length(IDs)
    for conditionIdx = 1:length(conditionNames)
        for maskIdx = 1:length(MaskNames)
            tsDat = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            averageCorrROI= ComputeSpatialCorrelationSingleTimePoints(tsDat);
            if(isempty(averageCorrROI))
                continue
            end
            Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),10,1));
            Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),10,1));
            Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),10,1));
            ScanNum  = cat(1,ScanNum,(1:10)');
            CorrVals = cat(1,CorrVals,averageCorrROI');
        end
    end
end
datTable = table(Subj,Conditions,Mask,ScanNum,CorrVals);
writetable(datTable,'SpatialCorrelationsSingletimepointsWithinSubj_WithinCond.csv');

%% Compute Within Subject Within Condition random temporal permutations Spatial Correlations
Subj = [];
Conditions = [];
Mask = [];
ScanNum = [];
CorrVals = [];
for sID = 1:length(IDs)
    for conditionIdx = 1:length(conditionNames)
        for maskIdx = 1:length(MaskNames)
            tsDat = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
            averageCorrROI= ComputeSpatialCorrelationRandomPerm(tsDat);
            if(isempty(averageCorrROI))
                continue
            end
            Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),10,1));
            Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),10,1));
            Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),10,1));
            ScanNum  = cat(1,ScanNum,(1:10)');
            CorrVals = cat(1,CorrVals,averageCorrROI');
        end
    end
end
datTable = table(Subj,Conditions,Mask,ScanNum,CorrVals);
writetable(datTable,'SpatialCorrelationsTemporalPermWithinSubj_WithinCond.csv');

%% Compute Within Subj Between Conditions Correlations
Subj = [];
Conditions = [];
Mask = [];
ScanNum = [];
CorrVals = [];
% variations = [];
for sID = 1:length(IDs)
    for maskIdx = 1:length(MaskNames)
        for conditionIdx1 = 1:(length(conditionNames)-1)
            for conditionIdx2 = (conditionIdx1+1):length(conditionNames)
                tsDat1 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx1});
                tsDat2 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx2});
                condStr = string(conditionNames{conditionIdx1})+"_"+string(conditionNames{conditionIdx2});
                averageCorrROI = ComputeSpatialCorrelation(tsDat1,tsDat2);
                Subj = cat(1,Subj,repmat(string(['S',IDs{sID}]),16,1));
                Conditions = cat(1,Conditions,repmat(condStr,16,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),16,1));
                ScanNum  = cat(1,ScanNum,(1:16)');
%                 variations = cat(1,variations,repmat(averageVariation,16,1));
                CorrVals = cat(1,CorrVals,averageCorrROI');
            end
        end
    end
end
datTable = table(Subj,Conditions,Mask,ScanNum,CorrVals);
writetable(datTable,'SpatialCorrelationsWithinSubj_BetweenCondJan23.csv');


%% Compute Between Subj Within Conditions Correlations
Subj = [];
Conditions = [];
Mask = [];
ScanNum = [];
CorrVals = [];
% variations = [];
for sID1 = 1:(length(IDs)-1)
    for sID2 = 2:length(IDs)
        for conditionIdx = 1:length(conditionNames)
            for maskIdx = 1:length(MaskNames)
                tsDat1 = timeSeries.(['S',IDs{sID1}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
                tsDat2 = timeSeries.(['S',IDs{sID2}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
                subjStr = string(['S',IDs{sID1}])+"_"+string(['S',IDs{sID2}]);
                averageCorrROI = ComputeSpatialCorrelation(tsDat1,tsDat2);
                Subj = cat(1,Subj,repmat(subjStr,16,1));
                Conditions = cat(1,Conditions,repmat(string(conditionNames{conditionIdx}),16,1));
                Mask = cat(1,Mask,repmat(string(MaskNames{maskIdx}),16,1));
                ScanNum  = cat(1,ScanNum,(1:16)');
%                 variations = cat(1,variations,repmat(averageVariation,16,1));
                CorrVals = cat(1,CorrVals,averageCorrROI');
            end
        end
    end
end
datTable = table(Subj,Conditions,Mask,ScanNum,CorrVals);
writetable(datTable,'SpatialCorrelationsBetweenSubj_WithinCond.csv');
%% Compute Within Condition Correlations
% Subj = [];
% Conditions = [];
% Mask = [];
% CorrF10S = [];
% CorrL10S = [];
% CorrAllS = [];
% for sID = 1:length(IDs)
%     for conditionIdx = 1:length(conditionNames)
%         for maskIdx = 1:length(MaskNames)
%             tsDat = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
%             averageCorrROI = ComputeCorrelations(tsDat);
%             Subj = cat(1,Subj,['S',IDs{sID}]);
%             Conditions = cat(1,Conditions,string(conditionNames{conditionIdx}));
%             Mask = cat(1,Mask,string(MaskNames{maskIdx}));
%             CorrF10S = cat(1,CorrF10S,averageCorrROI(1));
%             CorrL10S = cat(1,CorrL10S,averageCorrROI(2));
%             CorrAllS = cat(1,CorrAllS,averageCorrROI(3));
%         end
%     end
% end
% datTable = table(Subj,Conditions,Mask,CorrF10S,CorrL10S,CorrAllS);
% writetable(datTable,'WithinConditionCorrelations.csv');
% 
% %% Compute Between Conditions Correlations
% Subj = [];
% Conditions = [];
% Mask = [];
% CorrF10S = [];
% CorrL10S = [];
% CorrAllS = [];
% for sID = 1:length(IDs)
%     for maskIdx = 1:length(MaskNames)
%         for conditionIdx1 = 1:(length(conditionNames)-1)
%             for conditionIdx2 = (conditionIdx1+1):length(conditionNames)
%                 tsDat1 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx1});
%                 tsDat2 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx2});
%                 condStr = string(conditionNames{conditionIdx1})+"_"+string(conditionNames{conditionIdx2});
%                 averageCorrROI = ComputeCorrelations(tsDat1,tsDat2);
%                 Subj = cat(1,Subj,['S',IDs{sID}]);
%                 Conditions = cat(1,Conditions,condStr);
%                 Mask = cat(1,Mask,string(MaskNames{maskIdx}));
%                 CorrF10S = cat(1,CorrF10S,averageCorrROI(1));
%                 CorrL10S = cat(1,CorrL10S,averageCorrROI(2));
%                 CorrAllS = cat(1,CorrAllS,averageCorrROI(3));
%             end
%         end
%     end
% end
% datTable = table(Subj,Conditions,Mask,CorrF10S,CorrL10S,CorrAllS);
% writetable(datTable,'BetweenConditionsCorrelations.csv');
% 
% %% Compute Within Condition Correlations Shuffled
% Subj = [];
% Conditions = [];
% Mask = [];
% CorrF10S = [];
% CorrL10S = [];
% CorrAllS = [];
% for sID = 1:length(IDs)
%     for conditionIdx = 1:length(conditionNames)
%         for maskIdx = 1:length(MaskNames)
%             tsDat = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx});
%             averageCorrROI = ComputeShuffledCorrelations(tsDat);
%             Subj = cat(1,Subj,['S',IDs{sID}]);
%             Conditions = cat(1,Conditions,string(conditionNames{conditionIdx}));
%             Mask = cat(1,Mask,string(MaskNames{maskIdx}));
%             CorrF10S = cat(1,CorrF10S,averageCorrROI(1));
%             CorrL10S = cat(1,CorrL10S,averageCorrROI(2));
%             CorrAllS = cat(1,CorrAllS,averageCorrROI(3));
%         end
%     end
% end
% datTable = table(Subj,Conditions,Mask,CorrF10S,CorrL10S,CorrAllS);
% writetable(datTable,'WithinConditionShuffledCorrelations.csv');
% 
% %% Compute Between Conditions Correlations Shuffled
% Subj = [];
% Conditions = [];
% Mask = [];
% CorrF10S = [];
% CorrL10S = [];
% CorrAllS = [];
% for sID = 1:length(IDs)
%     for maskIdx = 1:length(MaskNames)
%         for conditionIdx1 = 1:(length(conditionNames)-1)
%             for conditionIdx2 = (conditionIdx1+1):length(conditionNames)
%                 tsDat1 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx1});
%                 tsDat2 = timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx2});
%                 condStr = string(conditionNames{conditionIdx1})+"_"+string(conditionNames{conditionIdx2});
%                 averageCorrROI = ComputeShuffledCorrelations(tsDat1,tsDat2);
%                 Subj = cat(1,Subj,['S',IDs{sID}]);
%                 Conditions = cat(1,Conditions,condStr);
%                 Mask = cat(1,Mask,string(MaskNames{maskIdx}));
%                 CorrF10S = cat(1,CorrF10S,averageCorrROI(1));
%                 CorrL10S = cat(1,CorrL10S,averageCorrROI(2));
%                 CorrAllS = cat(1,CorrAllS,averageCorrROI(3));
%             end
%         end
%     end
% end
% datTable = table(Subj,Conditions,Mask,CorrF10S,CorrL10S,CorrAllS);
% writetable(datTable,'BetweenConditionsShuffledCorrelations.csv');