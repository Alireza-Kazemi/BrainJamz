function averageCorrROI = ComputeCorrelations(tsDat1,tsDat2)
% wnSize = 10;
% wnD = [1,10]; %Window star scan
if(~exist('tsDat2','var'))
    blockNum1 = length(tsDat1);
    %% First 10 scans
    corrVoxels = []; 
    for bIdx1=1:(blockNum1-1)
        for bIdx2=(bIdx1+1):blockNum1
            A = tsDat1{bIdx1}(:,1:10);
            B = tsDat1{bIdx2}(:,1:10);
            C = corr(A',B');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(1) = mean(mean(corrVoxels));
    %% last 10 scans
    corrVoxels = []; 
    for bIdx1=1:(blockNum1-1)
        for bIdx2=(bIdx1+1):blockNum1
            A = tsDat1{bIdx1}(:,end-9:end);
            B = tsDat1{bIdx2}(:,end-9:end);
            C = corr(A',B');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(2) = mean(mean(corrVoxels));
    %% All scans
    corrVoxels = []; 
    for bIdx1=1:(blockNum1-1)
        for bIdx2=(bIdx1+1):blockNum1
            A = tsDat1{bIdx1};
            B = tsDat1{bIdx2};
            L = min(size(A,2),size(B,2));
            C = corr(A(:,1:L)',B(:,1:L)');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(3) = mean(mean(corrVoxels));   
    
else
    
    blockNum1 = length(tsDat1);
    blockNum2 = length(tsDat2);
    %% First 10 scans
    corrVoxels = []; 
    for bIdx1=1:blockNum1
        for bIdx2=1:blockNum2
            A = tsDat1{bIdx1}(:,1:10);
            B = tsDat2{bIdx2}(:,1:10);
            C = corr(A',B');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(1) = mean(mean(corrVoxels));
    %% last 10 scans
    corrVoxels = []; 
    for bIdx1=1:blockNum1
        for bIdx2=1:blockNum2
            A = tsDat1{bIdx1}(:,end-9:end);
            B = tsDat2{bIdx2}(:,end-9:end);
            C = corr(A',B');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(2) = mean(mean(corrVoxels));
    %% All scans
    corrVoxels = []; 
    for bIdx1=1:blockNum1
        for bIdx2=1:blockNum2
            A = tsDat1{bIdx1};
            B = tsDat2{bIdx2};
            L = min(size(A,2),size(B,2));
            C = corr(A(:,1:L)',B(:,1:L)');
            corrVoxels = cat(1,corrVoxels,diag(C)');
        end
    end
    averageCorrROI(3) = mean(mean(corrVoxels));
end
end