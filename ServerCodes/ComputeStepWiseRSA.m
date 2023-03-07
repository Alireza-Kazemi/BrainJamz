function similarityScores = ComputeStepWiseRSA(ts,Step)
% Compute Correlation between activation pattern in two timepoints.
% within Blocks
% timeSeries is cell variable that includes voxel-wise timecourse activities
% for different blocks with voxels as rows and timepoints as columns

%% Compute Correlations within Blocks

% Zscores data per voxel (within timecourse/voxels)
tsdat = zscore(ts,0,2); 
% tsdat = ts{blockIdx};
% Remove zero/constant voxels
voxels = max(tsdat,[],2)-min(tsdat,[],2);
tsdat = tsdat(voxels>0,:);

similarityScores = diag(squareform(1-pdist(tsdat','correlation')),Step);



