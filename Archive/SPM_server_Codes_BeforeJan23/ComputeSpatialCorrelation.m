function [averageCorrROI,averageVariation] = ComputeSpatialCorrelation(tsDat1,tsDat2)
% wnSize = 10;
% wnD = [1,10]; %Window star scan
averageCorrROI = NaN(1,16);
averageVariation = [];
normalizationMethod  = 'range';
if(~exist('tsDat2','var'))
    blockNum1 = length(tsDat1);
    %% single scan to block
    for scanIdx = 1:15
        corrScans = [];
        for bIdx1=1:(blockNum1-1)
            for bIdx2=(bIdx1+1):blockNum1
                if(scanIdx>size(tsDat1{bIdx1},2) || scanIdx>size(tsDat1{bIdx2},2))
                    continue;
                end
                A = normalize(tsDat1{bIdx1}(:,1:scanIdx),1,normalizationMethod);
                A = mean(A,2);
                B = normalize(tsDat1{bIdx2}(:,1:scanIdx),1,normalizationMethod);
                B = mean(B,2);
                C = 1-pdist([A,B]','correlation');
                corrScans = cat(1,corrScans,C);
            end
        end
        averageCorrROI(scanIdx) = mean(corrScans);
    end
    for bIdx1=1:(blockNum1-1)
        for bIdx2=(bIdx1+1):blockNum1
            A = normalize(tsDat1{bIdx1},1,normalizationMethod);
            A = mean(A,2);
            B = normalize(tsDat1{bIdx2},1,normalizationMethod);
            B = mean(B,2);
            C = 1-pdist([A,B]','correlation');
            corrScans = cat(1,corrScans,C);
        end
    end
    averageCorrROI(16) = mean(corrScans);
    %% Within Block Variation of Voxelwise activations
    meanVariation = zeros(1,blockNum1);
    for bIdx1=1:blockNum1
        A = normalize(tsDat1{bIdx1},1,normalizationMethod);
        A = mean(std(A,[],2));
        meanVariation(bIdx1) = A;
    end
    averageVariation = mean(meanVariation);
else  
    blockNum1 = length(tsDat1);
    blockNum2 = length(tsDat2);    
    %% single scan to block
%     for scanIdx = 1:15
%         corrScans = [];
%         for bIdx1=1:blockNum1
%             for bIdx2=1:blockNum2
%                 if(scanIdx>size(tsDat1{bIdx1},2) || scanIdx>size(tsDat2{bIdx2},2))
%                     continue;
%                 end
%                 A = normalize(tsDat1{bIdx1}(:,1:scanIdx),1,normalizationMethod);
%                 A = mean(A,2);
%                 B = normalize(tsDat2{bIdx2}(:,1:scanIdx),1,normalizationMethod);
%                 B = mean(B,2);
%                 C = 1-pdist([A,B]','correlation');
%                 corrScans = cat(1,corrScans,C);
%             end
%         end
%         averageCorrROI(scanIdx) = mean(corrScans);
%     end
%     for bIdx1=1:blockNum1
%         for bIdx2=1:blockNum2
%             A = normalize(tsDat1{bIdx1},1,normalizationMethod);
%             A = mean(A,2);
%             B = normalize(tsDat2{bIdx2},1,normalizationMethod);
%             B = mean(B,2);
%             C = 1-pdist([A,B]','correlation');
%             corrScans = cat(1,corrScans,C);
%         end
%     end

% ------ New Jan 2023
    corrScans = [];
    for bIdx1=1:blockNum1
        for bIdx2=1:blockNum2
            A = tsDat1{bIdx1};
            A = mean(A,2,'omitnan');
            B = tsDat2{bIdx2};
            B = mean(B,2,'omitnan');
            idx = ~(isnan(A) | isnan(B));
            A = A(idx);
            B = B(idx);
            C = 1-pdist([A,B]','correlation');
            corrScans = cat(1,corrScans,C);
        end
    end
    averageCorrROI(16) = mean(corrScans);
end
end