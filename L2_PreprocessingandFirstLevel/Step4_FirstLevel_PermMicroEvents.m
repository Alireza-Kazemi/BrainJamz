% Main Run
% FileLocations
%
% This function returns the location of images
% 
% Developed by Alireza Kazemi 2019
% kazemi@ucdavis.edu 
%
% For Future the PAth of the SPM should be determined automatically in the 
% preprocessing step.
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


%% First Level Analysis Permuted Micro Events
FormatPrep = 'wra';% a for Slicetime, r for realignment, w for normalization, s for smoothing
DesignName = 'PermMicroEvents';
eventTagName = '_Perm';
DD = '/media/data/SIPAlireza/';
DesignPath = uigetdir(DD,'Please choose the folder of Design .mat files');
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');
IDs = Info.IDs;
Dir = Info.Dir;

Mask = {'/home/kazemi/Documents/MATLAB/spm12/tpm/mask_ICV.nii,1'};
% -------------------------------------> Songs
SessName = 'Song';
SessFolderName = [SessName,'_raw'];
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    includeSubj = Info.(['include',SessName]);
    designFileNameTag = ['_',SessName,mENameTag];
    ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName,mENameTag];
    mkdir(ResultPath)
    
    disp('################################################')
    disp('################################################')
    disp('################################################')
    disp('################################################')
    oldPWD = pwd;
    RunFirstLevelBatch;
    cd(oldPWD)
    
    % Delete residual Files
    copyfile('DeleteResiduals.sh',[ResultPath,Sep])
    cd(ResultPath)
    [status,cmdout]  = system('bash DeleteResiduals.sh');
    cd(oldPWD)
end
% -------------------------------------> Words
SessName = 'Word';
SessFolderName = [SessName,'_raw'];
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    includeSubj = Info.(['include',SessName]);
    designFileNameTag = ['_',SessName,mENameTag];
    ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName,mENameTag];
    mkdir(ResultPath)
    
    disp('################################################')
    disp('################################################')
    disp('################################################')
    disp('################################################')
    oldPWD = pwd;
    RunFirstLevelBatch;
    cd(oldPWD)

    % Delete residual Files
    copyfile('DeleteResiduals.sh',[ResultPath,Sep])
    cd(ResultPath)
    [status,cmdout]  = system('bash DeleteResiduals.sh');
    cd(oldPWD)
end