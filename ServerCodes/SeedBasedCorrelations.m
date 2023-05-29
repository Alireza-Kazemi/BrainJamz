function averageCorrROI = SeedBasedCorrelations(tsSeed,tsRest)
% wnSize = 10;
% wnD = [1,10]; %Window star scan
blockNum1 = length(tsSeed);
%% First 3 scans are removed
corrVoxels = []; 
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1}(:,4:end);
    A = mean(A);
    B = tsRest{bIdx1}(:,4:end);
    for voxelIdx = 1:size(B,1)
        C = corr(A',B(voxelIdx,:)');
        corrVoxels = cat(1,corrVoxels,diag(C)');
    end
end
averageCorrROI(1) = mean(corrVoxels);
%% All scans
corrVoxels = []; 
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1};
    A = mean(A);
    B = tsRest{bIdx1};
    for voxelIdx = 1:size(B,1)
        C = corr(A',B(voxelIdx,:)');
        corrVoxels = cat(1,corrVoxels,diag(C)');
    end
end
averageCorrROI(2) = mean(corrVoxels);

%SeedtoSeed
corrVoxels = []; 
for bIdx1=1:blockNum1
    if(size(tsSeed{bIdx1},2)<5 || size(tsRest{bIdx1},2)<5)
        continue;
    end
    A = tsSeed{bIdx1};
    A = mean(A);
    B = tsRest{bIdx1};
    B = mean(B);
    C = corr(A',B');
    corrVoxels = cat(1,corrVoxels,diag(C)');
end
averageCorrROI(3) = mean(corrVoxels);

end