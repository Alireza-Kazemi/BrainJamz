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

resultNames = 'TimeSeriesInterp';
%% Load Masks
MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 

%% TimeSeries for Songs
SessName = 'Song';
load([rootResultPath,Sep,resultNames,'_',SessName,'.mat']);

TimeSeries_VoxelWiseTimeCourseAnalysis_Feb23
disp('############################')

%% TimeSeries for Words
SessName = 'Word';
load([rootResultPath,Sep,resultNames,'_',SessName,'.mat']);

TimeSeries_VoxelWiseTimeCourseAnalysis_Feb23
disp('############################')

