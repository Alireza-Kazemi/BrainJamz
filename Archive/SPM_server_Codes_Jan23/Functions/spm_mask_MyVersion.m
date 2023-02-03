function maskedVol = spm_mask_MyVersion(V1, V2, thresh)
% Mask images  Based on spm_mask function
% FORMAT spm_mask(P1, P2, thresh)
% P1     - matrix of input image filenames from which
%          to compute the mask.
% P2     - matrix of input image filenames on which
%          to apply the mask.
% thresh - optional threshold(s) for defining the mask.
% The masked images are prepended with the prefix `m'.





%-Parameters & Arguments
%--------------------------------------------------------------------------


% Directly I am passing the volumes from the spm matrix
% V1 = spm_vol(P1);
% V2 = spm_vol(P2);



M   = V2.mat;
dim = V2.dim(1:3);

maskedVol = zeros(dim(1),dim(2),dim(3));
mask = false(dim(1),dim(2),dim(3));
%-Compute masked images
%--------------------------------------------------------------------------


for j=1:dim(3)
    msk = true(dim(1:2));
    Mi  = spm_matrix([0 0 j]);

    % Load slice j from all images

    M1  = M\V1.mat\Mi;

    img = spm_slice_vol(V1,M1,dim(1:2),[0 NaN]);
    
    msk = msk & isfinite(img);
    
    if ~spm_type(V1.dt(1),'nanrep')
        msk = msk & (img ~= 0);
    end

    msk = msk & (img >= thresh);
    mask(:,:,j) = msk;
    % Write the images
    M1        = M\V2.mat\Mi;
    img       = spm_slice_vol(V2,M1,dim(1:2),[1 0]);
    img(~msk) = NaN;
    maskedVol(:,:,j) = img;

end
% maskedVol = maskedVol(mask);
