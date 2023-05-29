% VoxelWise TimeSeries Analysis

clear;
clc;
if (ispc)
    Sep = '\';
else
    Sep = '/';
end

%% Load Information data
load ParticipantsInfoJan23.mat
IDs = Info.IDs;
Dir = Info.Dir;

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');

resultNames = 'TimeSeries_NoInterp';
%% Load Masks
MaskNames = { 'HPC_L',...
              'HPC_R',...
              'aMTL_L',...
              'aMTL_R',...
              'PAuditory_L',...
              'PAuditory_R',...
              'aMPFCSphere'}; 

%% TimeSeries for Words
SessName = 'Word';
load([rootResultPath,Sep,resultNames,'_',SessName,'.mat']);

TimeSeries_Connectivity_May23;
disp('############################')

