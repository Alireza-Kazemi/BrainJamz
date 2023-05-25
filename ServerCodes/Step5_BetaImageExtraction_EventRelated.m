% Step5 Beta Image Extraction
% FileLocations
%
% This function returns the estimated beta images computed in the first
% level analysis
% 
% Developed by Alireza Kazemi 2023
% kazemi@ucdavis.edu 
%
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



IDs = Info.IDs;
Dir = Info.Dir;
DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');


%% Load Masks
MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 
MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');

mask = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    mask{maskID} = spm_vol(readPath);
end


%% -------------------------->EventRelated Songs
DesignName = 'EventRelated';
SessName = 'Song';
includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
clear betaImage
disp('############################')
%% -------------------------->EventRelated Word
DesignName = 'EventRelated';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
clear betaImage
disp('############################')