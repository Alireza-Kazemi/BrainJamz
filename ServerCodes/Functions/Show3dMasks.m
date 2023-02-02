function Show3dMasks(ROI,Par)

if(~exist('Par','var'))
    Par = '.';
end
[yL,xL,zL] = size(ROI);

[x,y,z] = meshgrid(1:xL,1:yL,1:zL);

Inds = find(ROI);

x = x(Inds);
y = y(Inds);
z = z(Inds);
scatter3(x,y,z,Par)
axis equal
end




