% %% CreateMasks
% clear;
% clc;
% close all;
% 
% load AtlasRegions.mat
% directoryname = uigetdir('D:\Projects\BrainJamz\DataFiles\L2_Masks');
% 
% 
% %% Show the Mask
% Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
% BW = bwmorph3(sign(Brain),'majority');
% BW = bwmorph3(BW,'fill');
% BW = bwmorph3(BW,'remove');
% BWxy = imerode(BW,ones(2,2,1));
% BWxz = imerode(BW,ones(2,1,2));
% BWyz = imerode(BW,ones(1,2,2));
% 
% [fileName1, pathName] = uigetfile(string(directoryname)+"\*.*");
% Mask1 = niftiread([pathName,fileName1]);
% [fileName2, pathName] = uigetfile(string(directoryname)+"\*.*");
% Mask2 = niftiread([pathName,fileName2]);
% 
% Show3dMasks(BWxy+BWxz+BWyz,'k+',.1);
% hold on
% Show3dMasks(Mask1);
% Show3dMasks(Mask2);
% axis off
% set(gcf,'Color',[1,1,1])
% legend(cat(1,"brain",string(fileName1(1:end-4)),string(fileName2(1:end-4))),'Interpreter','None');
% view(47,13)
% 
% 
% 

%% Show Masks
clear;
clc;
close all;

files = uigetfile('D:\Projects\BrainJamz\DataFiles\L2_Masks\*.*','MultiSelect', 'on');
directoryname = 'D:\Projects\BrainJamz\DataFiles\L2_Masks\';
for i=1:length(files)
    Masks.(files{i}(1:end-4)) = niftiread(string(directoryname)+string(files{i}));
end
names = fields(Masks);

directoryname = uigetdir('D:\Projects\BrainJamz\DataFiles\L2_Masks');
Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
BW = bwmorph3(sign(Brain),'majority');
BW = bwmorph3(BW,'fill');
BW = bwmorph3(BW,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));
Show3dMasks(BWxy+BWxz+BWyz,'k+',.1);
% Show3dMasks(Brain,'ko',0.1);

hold on
for maskIdx = 1:length(names)
    Show3dMasks(Masks.(names{maskIdx}));
end
legend(cat(1,"brain",names),'interpreter','none');
axis off
set(gcf,'Color',[1,1,1])
view(47,13)

%% CreateMasks
clear;
clc;
close all;



% Masks.MTL = [37,38,39,40,41,42];
Masks.Amyg = [41,42]; % Without HPC
Masks.MTL = [39,40]; % Without HPC
Masks.HPC_L = 37;
Masks.HPC_R = 38;


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
Masks.aMTL = Masks.MTL;
Masks.aMTL(:,1:105,:) = false;
Masks.aMTL_L = Masks.aMTL;
Masks.aMTL_L(92:end,:,:) = false;
Masks.aMTL_R = Masks.aMTL;
Masks.aMTL_R(1:92,:,:) = false;
Masks = rmfield(Masks,["MTL","aMTL"]);

[fileName1, pathName] = uigetfile(string(directoryname)+"\*.*");
Masks.Auditory_L = niftiread([pathName,fileName1]);
[fileName2, pathName] = uigetfile(string(directoryname)+"\*.*");
Masks.Auditory_R = niftiread([pathName,fileName2]);

names = fields(Masks);

Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
BW = bwmorph3(sign(Brain),'majority');
BW = bwmorph3(BW,'fill');
BW = bwmorph3(BW,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));
Show3dMasks(BWxy+BWxz+BWyz,'k+',.1);
% Show3dMasks(Brain,'ko',0.1);

hold on
for maskIdx = 1:length(names)
    Show3dMasks(Masks.(names{maskIdx}));
end
legend(cat(1,"brain",names),'interpreter','none');
axis off
set(gcf,'Color',[1,1,1])
view(47,13)