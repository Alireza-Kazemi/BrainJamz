
%% Load Masks
maskMatrix = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    maskMatrix{maskID} = spm_read_vols(spm_vol(readPath));
end


%% TimeSeries
resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';

for sID = 1:length(IDs)
    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
    conditionNames = {SPM.Sess.U(:).name};
    designMat = SPM.xX.X(:,1:length(conditionNames));
    designMat = sign(designMat);
    designMat(designMat<0)=0;
%     designMat = cat(1,zeros(1,length(conditionNames)),diff(designMat));
    designMat = diff(cat(1,designMat,zeros(1,length(conditionNames))));
    for conditionIdx = 1:length(conditionNames)
        conditionNames{conditionIdx} = SPM.Sess.U(conditionIdx).name{:};
        % Timeseries Scan Index
        startScan = find(designMat(:,conditionIdx)>0);
        finalScan = find(designMat(:,conditionIdx)<0);
        timeSeries.(['S',IDs{sID}]).ScanIndex.(conditionNames{conditionIdx}) = cat(2,startScan,finalScan);
        % TimeSeries Voxel-wise values
        for maskIdx=1:length(MaskNames)
            voxels = find(maskMatrix{maskIdx});
            timeSeriesPerBlock = cell(1,length(startScan));
            for blockIdx=1:length(startScan)
                timeSeriesTemp=[];
                for scanIdx = startScan(blockIdx):finalScan(blockIdx)
                    scan = SPM.xY.VY(scanIdx).private.dat;
                    timeSeriesTemp = cat(2,timeSeriesTemp,scan(voxels));
                end
                timeSeriesPerBlock{blockIdx} = timeSeriesTemp;
            end
            timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx}) = timeSeriesPerBlock;
        end
    end
end

% %% TimeSeries Voxel-wise values
%     for scanIdx = 1:SPM.nscan
%         scan = SPM.xY.VY(scanIdx).private.dat;
%         for conditionIdx = 1:length(conditionNames)
%             if(designMat(scanIdx,conditionIdx))
%                 timeSeries.(['S',IDs{sID}]).(conditionNames{conditionIdx}) = ...
%                     cat(1,timeSeries.(['S',IDs{sID}]).(conditionNames{conditionIdx}),scan);
%             end
%         end        
%     end

design = SPM.xX.X;
A = SPM.Sess.U;
B = full(A(1).u);
plot(1.5/46:1.5/46:length(B)/46*1.5,B)
hold on;plot((1:length(design(:,1)))*1.5,design(:,1))
plot((1:length(design(:,2)))*1.5,design(:,2))