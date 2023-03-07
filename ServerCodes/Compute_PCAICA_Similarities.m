function similarityScores = Compute_PCAICA_Similarities(ts)
% Compute Correlation between voxel-wise timecourse activities. This is
% similar to connectivity measurement. Results are Computed between and
% within Blocks
% timeSeries is cell variable that includes voxel-wise timecourse activities
% for different blocks with voxels as rows and timepoints as columns

%% Compute Correlations within Blocks
similarityScores = zeros(1,length(ts));

%% Compute Correlations Between Blocks
for condIdx2 = condIdx1:length(conditionNames)
    for blockIdx1 = 1:(length(ts)-1)
        for blockIdx2 = (blockIdx1+1):length(ts)
            tsdat1 = ts{blockIdx1};
            tsdat2 = ts{blockIdx2};
            tsdat1 = zscore(tsdat1,0,1);
            tsdat2 = zscore(tsdat2,0,1);
            corrVal = corr(tsdat1(:,1:19)',tsdat2(:,1:19)');
        end
    end
end
