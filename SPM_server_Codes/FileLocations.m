function [Scans,mvRegs] = FileLocations(Dir,format)

% FileLocations
%
% This function returns the location of images
%
% Developed by Alireza Kazemi 2019
% kazemi@ucdavis.edu 

if (ispc)
    Sep = '\';
else
    Sep = '/';
end

if (~exist('format','var'))
    format='';
end

% %% Song
% InnerPath = [Dir,Sep,IDs{Sid},Sep,'Song_raw',Sep];
% Filestmp = dir([InnerPath,'*.img']);
% Inds = regexp({Filestmp.name},['^',format,'.*\.img'],'match');
% Inds = vertcat(Inds{:});
% Filestmp = Inds;%{Filestmp.name}';
% for Find = 1:length(Filestmp)
%     Filestmp{Find} = [InnerPath,Filestmp{Find},',1'];
% end
% Scans = Filestmp;
% %% Movement Regressors
% InnerPath = [Dir,Sep,IDs{Sid},Sep,'Song_raw',Sep];
% Filestmp = dir([InnerPath,'*.txt']);
% 
% Filestmp = {[InnerPath,Filestmp.name]};
% 
% mvRegs = Filestmp;
%% Preprocessed Data
Filestmp = dir([Dir,'*.img']);
Inds = regexp({Filestmp.name},['^',format,'.*\.img'],'match');
Inds = vertcat(Inds{:});
Filestmp = Inds;%{Filestmp.name}';
for Find = 1:length(Filestmp)
    Filestmp{Find} = [Dir,Filestmp{Find},',1'];
end
Scans = Filestmp;
%% Movement Regressors
Filestmp = dir([Dir,'*.txt']);
Filestmp = {[Dir,Filestmp.name]};
mvRegs = Filestmp;

    