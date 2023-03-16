% Go to Folder that has brodmann 22, 41 and 42 areas
% can be downloaded from http://www.talairach.org/nii/gzip/
% good resource: https://nipy.org/nibabel/coordinate_systems.html

B41 = niftiread("Cell_Brodmann_area_41.nii");
B42 = niftiread("Cell_Brodmann_area_42.nii");
B22 = niftiread("Cell_Brodmann_area_22.nii");

B41Info = niftiinfo("Cell_Brodmann_area_41.nii");

auditory = B41+B42+B22;

% Find the Talairach coordinates
[x,y,z] = ind2sub(size(auditory),find(auditory));
talairachCoords = B41Info.Transform.T'*[x,y,z,ones(size(z))]';
talairachCoords = talairachCoords(1:3,:);
% Convert Talairach coordinates to MNI
mniCoords = tal2mni(talairachCoords);

% Find corresponding indices in the UNC MNI mapped files
directoryname = uigetdir('D:\Projects\BrainJamz\DataFiles\L2_Masks');
Atlas = double(niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz"));
AtlasInfo = niftiinfo(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
affineT = AtlasInfo.Transform.T';

matrixIdx = affineT^-1 * [mniCoords;ones(1,size(mniCoords,2))];
matrixIdx = round(matrixIdx);
% Create the mask
Mask = zeros(size(Atlas));
Mask(sub2ind(size(Mask),matrixIdx(1,:),matrixIdx(2,:),matrixIdx(3,:))) = 1;
Mask = bwmorph3(Mask,'fill');
% find the intersection between UNC Heschl and Superior temporal gyrus with
% this mask (coded as 79:82)
inds = false(size(Atlas));
for codesROI = 79:82 %UNC Heschl and Superior temporal gyrus
    inds = inds|(Atlas==codesROI);
end

Mask = logical(Mask);
Mask = inds & Mask;

AuditoryLeft = Mask;
AuditoryLeft(1:91,:,:)=false;
AuditoryRight = Mask;
AuditoryRight(92:end,:,:)=false;
AuditoryRight = single(AuditoryRight);
AuditoryLeft = single(AuditoryLeft);
%% Display the Mask
Brain = niftiread(string(directoryname)+"\"+"infant-2yr-aal.nii.gz");
BW = bwmorph3(sign(Brain),'majority');
BW = bwmorph3(BW,'fill');
BW = bwmorph3(BW,'remove');
BWxy = imerode(BW,ones(2,2,1));
BWxz = imerode(BW,ones(2,1,2));
BWyz = imerode(BW,ones(1,2,2));
Show3dMasks(BWxy+BWxz+BWyz,'k+',.1);
hold on
Show3dMasks(AuditoryLeft);
Show3dMasks(AuditoryRight);
xlabel('x')
ylabel('y')
legend("Brain","Left","Right")

%% savefiles
niftiwrite(AuditoryLeft,string(directoryname)+"\PAuditory_L.nii", AtlasInfo);
niftiwrite(AuditoryRight,string(directoryname)+"\PAuditory_R.nii", AtlasInfo);

