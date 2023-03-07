close all
clear

N=1000;
X1 = 10*rand(N,1)+2;
X2 = ((10+rand(N,1)-0.5).*X1+20*(rand(N,1)-.5))/10;


Y = cat(2,X1,X2);

Y = zscore(Y,0,1);

theta = pi/6;
R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
Ynew = Y*R/2;

theta = 2*pi/6;
R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
Ynew1 = Y*R/3;

theta = pi/2;
R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
Ynew2 = Y*R/4;

Y = cat(1,Y,Ynew,Ynew1,Ynew2);

% scatter(Y(:,1),Y(:,2))
% hold on 
% scatter(Ynew(:,1),Ynew(:,2))
% axis equal

%% PCA
% theta = pi/4-pi/8;
% R = [cos(theta),-sin(theta);sin(theta),cos(theta)];

[coeff,yPCA,latent] = pca(Y);%,'NumComponents',3);
% yPCA = Ynew*coeff;
% 
%% ICA 
Mdl = rica(yPCA,2);
yICA = transform(Mdl,yPCA);


%% plot
subplot 221
scatter(Y(:,1),Y(:,2))
axis equal
legend("Y");

subplot 222
scatter(yPCA(:,1),yPCA(:,2));
axis equal
legend("PCA");

subplot 223
scatter(yICA(:,1),yICA(:,2));
axis equal
legend("ICA");

subplot 224
scatter(Y(:,1),Y(:,2))
hold on
scatter(yPCA(:,1),yPCA(:,2));
scatter(yICA(:,1),yICA(:,2));
axis equal
legend("ICA");
legend("Y","PCA","ICA");

%% plot
figure

subplot 221
plot(Y(:,1))
hold on
plot(Y(:,2))
legend("Y1","Y2");

subplot 222
plot(yPCA(:,1))
hold on
plot(yPCA(:,2))
legend("Y1pca","Y2pca");

subplot 223
plot(yICA(:,1))
hold on
plot(yICA(:,2))
legend("Y1ICA","Y2ICA");
