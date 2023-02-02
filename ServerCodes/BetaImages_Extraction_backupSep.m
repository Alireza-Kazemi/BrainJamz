%% I haven't editted it it is simply a copy of the timeseries now
%% Load Masks
maskMatrix = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    maskMatrix{maskID} = spm_read_vols(spm_vol(readPath));
end


%% BetaImages
resultFolderNameTag = 'FirstLevel_';
SPMFileName = 'SPM.mat';

for sID = 1:length(IDs)
    load([ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,'SPM.mat']);
    conditionNames = {SPM.Sess.U(:).name};
    betaNames = {SPM.Vbeta(:).descrip};
    for conditionIdx = 1:length(conditionNames)
        conditionNames(conditionIdx) = conditionNames{conditionIdx};
        for maskIdx=1:length(MaskNames)
            voxels = find(maskMatrix{maskIdx});
            blockIdx = [];
            betaImg = [];
            for betaImgIdx = 1:length(betaNames)
                if(contains(betaNames{betaImgIdx},conditionNames{conditionIdx}))
                    scan = SPM.Vbeta(betaImgIdx).private.dat;
                    scan.fname = [ResultPath,Sep,resultFolderNameTag,IDs{sID},Sep,scan.fname];
                    betaImg = cat(2,betaImg,scan(voxels));
                    blockIdx = cat(1,blockIdx,betaImgIdx);
                end
            end
            betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx}).Beta = betaImg;
            betaImage.(['S',IDs{sID}]).(MaskNames{maskIdx}).(conditionNames{conditionIdx}).Block = blockIdx;
         end
     end
end




% 
% 
% design = SPM.xX.X;
% A = SPM.Sess.U;
% B = full(A(1).u);
% plot(1.5/46:1.5/46:length(B)/46*1.5,B)
% hold on;plot((1:length(design(:,1)))*1.5,design(:,1))
% plot((1:length(design(:,2)))*1.5,design(:,2))