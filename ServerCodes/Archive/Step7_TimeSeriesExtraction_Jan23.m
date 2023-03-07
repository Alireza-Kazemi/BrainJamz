% VoxelWise TimeSeries Extraction

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
IDs = Info.IDs;
Dir = Info.Dir;

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');

ResultsName = 'TimeSeries';
%% Load Masks
MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 
% MaskNames = { 'HPC'}; 
MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');

mask = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    mask{maskID} = spm_vol(readPath);
end

%% TimeSeries for Songs
DesignName = 'BlockBased';
SessName = 'Song';
TimeSeries_Extraction_Jan23;
clear  TimeSeries
disp('############################')

%% TimeSeries for Words
DesignName = 'BlockBased';
SessName = 'Word';
TimeSeries_Extraction_Jan23;
clear  TimeSeries
disp('############################')

