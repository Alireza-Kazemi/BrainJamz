%% Resize Desired Masks to native Space of functional Data:
Loc = "/media/data/SIPAlireza/Jamz/MasksSep/";
names = ["aMTL.nii","HPC.nii","aMPFSphere.nii"];
Brain = niftiread(Loc+"babybrain.nii");
Brain = imresize3(Brain, [79,95,79]);
BW = bwmorph3(Brain,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));

figure
Show3dMasks(BWxy+BWxz,'k.');
hold on
for i=1:length(names)
    Mask = niftiread(Loc+names(i));
%     MsskInfo = niftiinfo(names(i)); No header is being added
    Mask = imresize3(Mask, [79,95,79]);
    Show3dMasks(Mask);
%     niftiwrite(Mask,"Final_"+names(i));
end

Mask = niftiread(Loc+names(3));

Loc = "/media/data/SIPAlireza/Jamz/ResultsSep/Collapsed/FirstLevel_242/";
Info = niftiinfo(Loc+"RPV.nii");
Image = niftiread(Loc+"RPV.nii");
% Show3dMasks(Image);
T = imtool3D(Image);
T.setMask(Mask);


Loc = "/media/data/SIPAlireza/Jamz/PreprocessSep/092/Highres_raw/";
Info = niftiinfo(Loc+"ws092-0002-00001-000256-01.img");
Image = niftiread(Loc+"ws092-0002-00001-000256-01.hdr");
T = imtool3D(Image);
T.setMask(Mask);


