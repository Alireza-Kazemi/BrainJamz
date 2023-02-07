%% Time Series Extraction from SPM.mat Jan2023 Version

includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];



% %% Test
% resultFolderNameTag = 'FirstLevel_';
% SPMFileName = 'SPM.mat';
% maskingthreshold = 0.5;
% 
% 
% for sID = 1:length(IDs)
%     disp([num2str(sID),'/',num2str(length(IDs)),' Beta Image ',DesignName,'_',SessName,' for Subject: ', IDs{sID}])
%     if(includeSubj(sID)==0)
%         disp([num2str(sID),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{sID}])
%         continue;
%     end
% 
%     load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
%     conditionNames = {SPM.Sess.U(:).name};
%     designMat = SPM.xX.X;
%     % TimeSeries Voxel-wise values
%     for maskIdx=1:length(MaskNames)
%         Y = [];
%         for scanIdx =  1:size(designMat,1) %startScan(blockIdx):finalScan(blockIdx)
%             scan = SPM.xY.VY(scanIdx);
%             Masked = spm_mask_MyVersion(mask{maskIdx}, scan, maskingthreshold);
%             Y = cat(2,Y,Masked);
%         end
%         a=0;
%     end
% end
% X = designMat;
% Y = Y';
% Betas = zeros(86,size(Y,2));
% for i = 1:size(Y,2)
%     Betas(:,i) = mvregress(X,Y(:,i));
% end
% 
% Betas = zeros(4,size(Y,2));
% for i = 1:size(Y,2)
%     Betas(:,i) = mvregress(X(:,1:4),ones(255,1));
% end


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