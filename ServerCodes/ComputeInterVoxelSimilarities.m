function [similarityScores,similarityFHalf,similarityLHalf] = ComputeInterVoxelSimilarities(ts)
% Compute Correlation between voxel-wise timecourse activities. This is
% similar to connectivity measurement. Results are Computed between and
% within Blocks
% timeSeries is cell variable that includes voxel-wise timecourse activities
% for different blocks with voxels as rows and timepoints as columns

%% Compute Correlations within Blocks
similarityScores = zeros(1,length(ts));
similarityFHalf = zeros(1,length(ts));
similarityLHalf = zeros(1,length(ts));
for blockIdx = 1:length(ts)
    % Zscores data per voxel (within timecourse/voxels)
    tsdat = zscore(ts{blockIdx},0,2); 
%     tsdat = ts{blockIdx};
    % Remove zero/constant voxels
    voxels = max(tsdat,[],2)-min(tsdat,[],2);
    tsdat = tsdat(voxels>0,:);
    
%     similarityScores(blockIdx) = mean(1-pdist(tsdat,'correlation'),'omitnan');
    similarityScores(blockIdx) = mean(abs(1-pdist(tsdat,'correlation')),'omitnan');

    L = size(tsdat,2);
    tsFHalf = tsdat(:,1:round(L/2));
    voxels = max(tsFHalf,[],2)-min(tsFHalf,[],2);
    tsFHalf = tsFHalf(voxels>0,:);
    similarityFHalf(blockIdx) = mean(abs(1-pdist(tsFHalf,'correlation')),'omitnan');

    tsLHalf = tsdat(:,(round(L/2)+1):end);
    voxels = max(tsLHalf,[],2)-min(tsLHalf,[],2);
    tsLHalf = tsLHalf(voxels>0,:);
    sc = abs(1-pdist(tsLHalf,'correlation'));
    sc = sc(sc>=0);
    similarityLHalf(blockIdx) = mean(sc,'omitnan');

end
similarityScores = mean(similarityScores,'omitnan');
similarityFHalf = mean(similarityFHalf,'omitnan');
similarityLHalf = mean(similarityLHalf,'omitnan');
% I think between blocks comparison doens't make sense and did not compute
% it at the time.
% %% Compute Correlations Between Blocks
% for condIdx2 = condIdx1:length(conditionNames)
%     for blockIdx1 = 1:(length(ts)-1)
%         for blockIdx2 = (blockIdx1+1):length(ts)
%             tsdat1 = ts{blockIdx1};
%             tsdat2 = ts{blockIdx2};
%             tsdat1 = zscore(tsdat1,0,1);
%             tsdat2 = zscore(tsdat2,0,1);
%             corrVal = corr(tsdat1(:,1:19)',tsdat2(:,1:19)');
%         end
%     end
% end
