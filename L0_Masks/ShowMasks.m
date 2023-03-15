%% CreateMasks
clear;
clc;
close all;

load AtlasRegions.mat
directoryname = uigetdir('D:\Projects\BrainJamz\DataFiles\L2_Masks');


%% Show the Mask
Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
BW = bwmorph3(sign(Brain),'majority');
BW = bwmorph3(BW,'fill');
BW = bwmorph3(BW,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));

[fileName, pathName] = uigetfile(string(directoryname)+"\*.*");
Mask = niftiread([pathName,fileName]);


Show3dMasks(BWxy+BWxz+BWyz,'k+',.2);
hold on
Show3dMasks(Mask);
axis off
set(gcf,'Color',[1,1,1])
legend(cat(1,"brain",string(fileName(1:end-4))));
