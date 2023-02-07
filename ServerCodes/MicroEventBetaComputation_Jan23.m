%% MicroEvent BlockBased based on EventRelated Design from SPM.mat Jan2023 Version
% This is a very customized routine to compute betas manually instead of
% changing design files and use spm first level analysis.
includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];



%% Compute betas for MicroEvents
resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';
maskingthreshold = 0.5;


for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' Beta Compute ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end

    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
    % Extract microEvents names
    microEventNames = strings(length(SPM.Sess.U),1);
    for microIdx = 1:length(SPM.Sess.U)
       microEventNames(microIdx) = string(SPM.Sess.U(microIdx).name);
    end
    
    designMat = SPM.xX.X;
    % TimeSeries Voxel-wise values
    for maskIdx=1:length(MaskNames)
        % Run a sample to get the size
        scanIdx = 1;
        scan = SPM.xY.VY(scanIdx);
        Masked = spm_mask_MyVersion(mask{maskIdx}, scan, maskingthreshold);
        allVolumes = zeros(length(Masked),size(designMat,1));
        % Extract all Volumes from preprocessed images
        for scanIdx =  1:size(designMat,1) 
            scan = SPM.xY.VY(scanIdx);
            Masked = spm_mask_MyVersion(mask{maskIdx}, scan, maskingthreshold);
            allVolumes(:,scanIdx) = Masked;
        end
        for microIdx=1:20

    end
end
X = designMat;
allVolumes = allVolumes';
Betas = zeros(86,size(allVolumes,2));
for i = 1:size(allVolumes,2)
    Betas(:,i) = mvregress(X,allVolumes(:,i));
end

Betas = zeros(4,size(allVolumes,2));
for i = 1:size(allVolumes,2)
    Betas(:,i) = mvregress(X(:,1:4),ones(255,1));
end


%% TimeSeries
resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';
maskingthreshold = 0.5;

for sID = 1:length(IDs)
    disp([num2str(sID),'/',num2str(length(IDs)),' TimeSeries ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
    if(includeSubj(sID)==0)
        disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
        continue;
    end

    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
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
                timeSeriesTemp=[];
                for scanIdx = startScan(blockIdx):finalScan(blockIdx)
                    scan = SPM.xY.VY(scanIdx);
                    Masked = spm_mask_MyVersion(mask{maskIdx}, scan, maskingthreshold);
                    timeSeriesTemp = cat(2,timeSeriesTemp,Masked);
                end
                timeSeriesPerBlock{blockIdx} = timeSeriesTemp;
            end
            timeSeries.(['S',IDs{sID}]).Dat.(MaskNames{maskIdx}).(conditionNames{conditionIdx}) = timeSeriesPerBlock;
        end
    end
end
%% Save Time Series Data

save([rootResultPath,Sep,'TimeSeries_',SessName,'.mat'],'timeSeries','-v7.3');
disp(['Results Saved ---> ',rootResultPath,Sep,'TimeSeries_',SessName,'.mat'])