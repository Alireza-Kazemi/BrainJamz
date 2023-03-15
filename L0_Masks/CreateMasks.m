%% CreateMasks
clear;
clc;
close all;


% Masks.PFC = [3:16,23:26]; 
% Masks.VC = [43,44,45,46,47:54];
% Masks.Parietal = 59:66;
% Masks.MTL = [37,38,39,40,41,42];
Masks.Auditory = 81:82;
% Masks.Auditory_L = 81;
% Masks.Auditory_R = 82;
% Masks.HPC = [37,38];
% Masks.HPC_L = [37,38];
% Masks.HPC_R = [37,38];
% Masks.PHC = [39,40];

load AtlasRegions.mat

directoryname = uigetdir('D:\Projects\BrainJamz\DataFiles\L2_Masks');
Atlas = double(niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz"));
AtlasInfo = niftiinfo(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
names = fields(Masks);

for roiIdx = 1:length(names)
    inds = false(size(Atlas));
    for codesROI = Masks.(names{roiIdx})
        inds = inds|(Atlas==codesROI);
    end
    temp = double(inds);
    temp = sign(temp);
    temp(temp<=0)=0;
    Masks.(names{roiIdx}) = single(temp);
end
% Masks.aMTL = Masks.MTL;
% Masks.aMTL(:,1:115,:) = false;
names = fields(Masks);

Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
BW = bwmorph3(sign(Brain),'majority');
BW = bwmorph3(BW,'fill');
BW = bwmorph3(BW,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));
Show3dMasks(BWxy+BWxz,'k.');
Show3dMasks(Brain,'k.');

hold on
for maskIdx = 1:length(names)
    Show3dMasks(Masks.(names{maskIdx}));
end
legend(cat(1,"brain",names));


for maskIdx = 1:length(names)
    niftiwrite(Masks.(names{maskIdx}),string(directoryname)+"\"+string(names{maskIdx}+".nii"), AtlasInfo);
end


%%  MPFC Sphere
aMPFCSphere = niftiread("Urbain_fixed_MPFC_BinarizedUSE.nii.gz");
aMPFCSphereInfo = niftiinfo("Urbain_fixed_MPFC_BinarizedUSE.nii.gz");
niftiwrite(aMPFCSphere,"aMPFCSphere.nii", aMPFCSphereInfo);