%% Time Series Extraction from SPM.mat Jan2023 Version

includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];


%% TimeSeries
resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';
maskingthreshold = 0.5;
interpolateBy = 3;
TR = 1.5; %seconds
timeSeries = [];

for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' TimeSeries ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end

    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
    

    % Extract timeseries (VoxelWise Activities) data perMask
    timeDat = [];
    for maskIdx=1:length(MaskNames)
        [~,maskingIdx] = spm_mask_MyVersion(mask{maskIdx}, SPM.xY.VY(1), maskingthreshold);
        timeSeriesTemp = zeros(sum(maskingIdx,'all'),length(SPM.xY.VY));
        for volIdx = 1:length(SPM.xY.VY)
            Masked = spm_read_vols(SPM.xY.VY(volIdx));
            Masked = Masked(maskingIdx);
            timeSeriesTemp(:,volIdx) = Masked;
        end
        timeDat.(MaskNames{maskIdx}).dat = timeSeriesTemp;

    end

    conditionNames = {SPM.Sess.U(:).name};
    designMat = SPM.xX.X(:,1:length(conditionNames));
    designMat = sign(designMat);
    designMat(designMat<0)=0;
    designMat = diff(cat(1,designMat,zeros(1,length(conditionNames))));
    for conditionIdx = 1:length(conditionNames)
        conditionNames{conditionIdx} = SPM.Sess.U(conditionIdx).name{:};
        % Timeseries Scan Index
        startScan = find(designMat(:,conditionIdx)>0);
        finalScan = find(designMat(:,conditionIdx)<0);
        timeSeries.(['S',IDs{sID}]).ScanIndex.(conditionNames{conditionIdx}) = cat(2,startScan,finalScan);
        % TimeSeries Voxel-wise values
        for maskIdx=1:length(MaskNames)
            timeSeriesPerBlock = cell(1,length(startScan));
            for blockIdx=1:length(startScan)
                timeSeriesPerBlock{blockIdx} = timeDat.(MaskNames{maskIdx}).dat(:,startScan(blockIdx):finalScan(blockIdx));
            end
            timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx}) = timeSeriesPerBlock;
        end
    end
end
%% Save Time Series Data

save([rootResultPath,Sep,'TimeSeries_NoInterp_',SessName,'.mat'],'timeSeries','-v7.3');
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_NoInterp_',SessName,'.mat'])