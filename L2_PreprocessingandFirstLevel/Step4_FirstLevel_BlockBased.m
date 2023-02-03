% First Level Analysis BlockBased
% Developed by Alireza Kazemi 2023
% kazemi@ucdavis.edu 
%
clear;
clc;
if (ispc)
    Sep = '\';
else
    Sep = '/';
end
SessionNum=1;



%% Load Information data
load ParticipantsInfoJan23.mat


%% First Level Analysis BlockBased
FormatPrep = 'wra';% a for Slicetime, r for realignment, w for normalization, s for smoothing
DesignName = 'BlockBased';
DD = '/media/data/SIPAlireza/';
DesignPath = uigetdir(DD,'Please choose the folder of Design .mat files');
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');
IDs = Info.IDs;
Dir = Info.Dir;

% -------------------------------------> Songs
includeSubj = Info.includeSong;
SessName = 'Song';
designFileNameTag = ['_',SessName];
SessFoldeName = [SessName,'_raw'];
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];
mkdir(ResultPath)

disp('################################################')
disp('################################################')
disp('################################################')
disp('################################################')
oldPWD = pwd;
RunFirstLevelBatch;
cd(oldPWD)

% -------------------------------------> Wrods
includeSubj = Info.includeWord;
SessName = 'Word';
designFileNameTag = ['_',SessName];
SessFoldeName = [SessName,'_raw'];
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];
mkdir(ResultPath)

disp('################################################')
disp('################################################')
disp('################################################')
disp('################################################')
oldPWD = pwd;
RunFirstLevelBatch;
cd(oldPWD)