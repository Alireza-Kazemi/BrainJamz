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

%% MicroEvent BlockBased based on EventRelated Design Songs
DesignName = 'EventRelated';
SessName = 'Song';
conditionNames = {'baseline', 'novel', 'reverse', 'target'};
MicroEventBetaComputation_Jan23;
clear  TimeSeries
disp('############################')

%% MicroEvent BlockBased based on EventRelated Design Words
DesignName = 'EventRelated';
SessName = 'Word';
conditionNames = {'baseline', 'known', 'unknown', 'target'};
MicroEventBetaComputation_Jan23;
clear  TimeSeries
disp('############################')

