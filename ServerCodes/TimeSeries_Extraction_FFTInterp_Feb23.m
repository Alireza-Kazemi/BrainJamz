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
        % interpolated timeseries with x10 samples
        timeDat.(MaskNames{maskIdx}).datInterp = interpft(timeSeriesTemp,size(timeSeriesTemp,2)*interpolateBy,2);
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
%             compute indexes in interpolated values
            nVolumes = size(timeDat.(MaskNames{maskIdx}).dat,2);
            t0 = linspace(1,nVolumes*TR,nVolumes);
            tUp = linspace(1,(nVolumes+1)*TR-(TR/interpolateBy),nVolumes*interpolateBy);
%             % Sample Plot
%             VoxelNumPlot = floor(rand()*size(timeSeriesPerBlock{blockIdx},1))+1;
%             figure
%             plot(t0, timeDat.(MaskNames{maskIdx}).dat(VoxelNumPlot,:),'-+');
%             hold on;
%             plot(tUp, timeDat.(MaskNames{maskIdx}).datInterp(VoxelNumPlot,:),'-+');
%             title("Voxel = "+VoxelNumPlot)
            timeSeriesPerBlock = cell(1,length(startScan));
            timeSeriesInterpPerBlock = cell(1,length(startScan));
            for blockIdx=1:length(startScan)
                timeSeriesPerBlock{blockIdx} = timeDat.(MaskNames{maskIdx}).dat(:,startScan(blockIdx):finalScan(blockIdx));
                [~,sUp] = min(abs(tUp - t0(startScan(blockIdx))));
                [~,fUp] = min(abs(tUp - t0(finalScan(blockIdx))));
                timeSeriesInterpPerBlock{blockIdx} = timeDat.(MaskNames{maskIdx}).datInterp(:,sUp:fUp);
                % Sample plot
%                 VoxelNumPlot = floor(rand()*size(timeSeriesPerBlock{blockIdx},1))+1;
%                 figure
%                 plot(t0(startScan(blockIdx):finalScan(blockIdx)), timeSeriesPerBlock{blockIdx}(VoxelNumPlot,:),'-+');
%                 hold on;
%                 plot(tUp(sUp:fUp), timeSeriesInterpPerBlock{blockIdx}(VoxelNumPlot,:),'-+');
%                 title("Voxel = "+VoxelNumPlot)
            end
            timeSeries.(['S',IDs{sID}]).dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx}) = timeSeriesPerBlock;
            timeSeries.(['S',IDs{sID}]).datInterp.(MaskNames{maskIdx}).(conditionNames{conditionIdx}) = timeSeriesInterpPerBlock;
        end
    end
end
%% Save Time Series Data

save([rootResultPath,Sep,'TimeSeriesInterp_',SessName,'.mat'],'timeSeries','-v7.3');
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeriesInterp_',SessName,'.mat'])