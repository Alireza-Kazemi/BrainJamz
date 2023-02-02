Info = niftiinfo("wraf076-0007-00334-000334-01.hdr");
Image = niftiread("wraf076-0007-00334-000334-01.img");
ImgT = imwarp(Image,Info.Transform);

Info = niftiinfo("ws076-0002-00001-000256-01.hdr");
Image = niftiread("ws076-0002-00001-000256-01.img");
ImgT = imwarp(Image,Info.Transform);

Info = niftiinfo("s076-0002-00001-000256-01.hdr");
Image = niftiread("s076-0002-00001-000256-01.img");
ImgT = imwarp(Image,Info.Transform);


Rinfo = niftiinfo("example_func2standard.nii.gz");
ImageEx = niftiread("example_func2standard.nii.gz");
ImgnewReg = imwarp(Image,Rinfo.Transform);


MaskS = niftiread("TPM.nii");
size(MaskS)


MR = niftiread("rinfant-2yr-avgseg.nii");
MRInfo = niftiinfo("rinfant-2yr-avgseg.nii");
ImgT = imwarp(MR,MRInfo.Transform);

M0 = niftiread("infant-2yr-avgseg.nii");
M0Info = niftiinfo("infant-2yr-avgseg.nii");
ImgT = imwarp(MR,M0Info.Transform);


MaskS = niftiread("L_anterior_hip_unc.nii");
FuncS = niftiread("example_func2highres.nii.gz");