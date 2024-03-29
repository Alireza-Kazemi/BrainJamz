function [averageCorrROI, averageCorrROI_Sig]= SeedBasedCorrelations(tsSeed,tsRest)
% wnSize = 10;
% wnD = [1,10]; %Window star scan
blockNum1 = length(tsSeed);
%% First 3 scans are removed
corrVoxels = [];
pValues = [];
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1}(:,4:end);
    A = mean(A);
    B = tsRest{bIdx1}(:,4:end);
    for voxelIdx = 1:size(B,1)
        [C, p] = corr(A',B(voxelIdx,:)','Type','Pearson');
        corrVoxels = cat(1,corrVoxels,diag(C)');
        pValues = cat(1,pValues,diag(p)');
    end
end
averageCorrROI(1) = mean(corrVoxels);
averageCorrROI_Sig(1) = mean(corrVoxels(pValues<0.05));
%% All scans
corrVoxels = [];
pValues = [];
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1};
    A = mean(A);
    B = tsRest{bIdx1};
    for voxelIdx = 1:size(B,1)
        [C, p] = corr(A',B(voxelIdx,:)','Type','Pearson');
        corrVoxels = cat(1,corrVoxels,diag(C)');
        pValues = cat(1,pValues,diag(p)');
    end
end
averageCorrROI(2) = mean(corrVoxels);
averageCorrROI_Sig(2) = mean(corrVoxels(pValues<0.05));

%SeedtoSeed
corrVoxels = []; 
pValues = [];
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1};
    A = mean(A);
    B = tsRest{bIdx1};
    B = mean(B);
    [C, p] = corr(A',B','Type','Pearson');
    corrVoxels = cat(1,corrVoxels,diag(C)');
    pValues = cat(1,pValues,diag(p)');
end
averageCorrROI(3) = mean(corrVoxels);
averageCorrROI_Sig(3) = mean(corrVoxels(pValues<0.05));
end