function Show3dMasks(ROI,Par,transparency)

if(~exist('Par','var'))
    Par = '.';
end
if(~exist('transparency','var'))
    transparency = 1;
end
[yL,xL,zL] = size(ROI);

[x,y,z] = meshgrid(1:xL,1:yL,1:zL);

Inds = find(ROI);

x = x(Inds);
y = y(Inds);
z = z(Inds);
scatter3(x,y,z,Par,'MarkerEdgeAlpha',transparency,'MarkerFaceAlpha',transparency)
axis equal
end




