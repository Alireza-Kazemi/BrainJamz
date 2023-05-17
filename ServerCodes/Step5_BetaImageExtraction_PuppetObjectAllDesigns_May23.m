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



IDs = Info.IDs;
Dir = Info.Dir;
DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');


%% Load Masks

% ----> UniLateral Masks
MaskNames = { 'HPC_L',...
              'HPC_R',...
              'aMTL_L',...
              'aMTL_R',...
              'PAuditory_L',...
              'PAuditory_R',...
              'aMPFCSphere'}; 

MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');

mask = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    mask{maskID} = spm_vol(readPath);
end


%% -------------------------->BlockBased Word
DesignName = 'BlockBased';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
clear betaImage
disp('############################')

%% -------------------------->BlockEvent Word
DesignName = 'BlockEvent';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
clear betaImage
disp('############################')

%% -------------------------->MicroEvent Word
SessName = 'Word';
DesignName = 'MicroEvent';
eventTagName = '_ME';
includeSubj = Info.(['include',SessName]);

DesingNameRoot = DesignName;
for mEIdx = 1:20
    mENameTag = [eventTagName,num2str(mEIdx)];
    ResultPath = [rootResultPath,Sep,DesingNameRoot,Sep,SessName,mENameTag];
    DesignName = [DesingNameRoot,mENameTag];
    disp('################################################')
    disp('################################################')
    BetaImages_Extraction;
    clear betaImage
    disp('################################################')
    disp('################################################')
end

%% -------------------------->PermutedMicroEvent Word
SessName = 'Word';
DesignName = 'PermMicroEvents';
eventTagName = '_Perm';
includeSubj = Info.(['include',SessName]);


DesingNameRoot = DesignName;
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    ResultPath = [rootResultPath,Sep,DesingNameRoot,Sep,SessName,mENameTag];
    DesignName = [DesingNameRoot,mENameTag];
    disp('################################################')
    disp('################################################')
    BetaImages_Extraction;
    clear betaImage
    disp('################################################')
    disp('################################################')
end

%% -------------------------->PermMEBoth Word
SessName = 'Word';
DesignName = 'PermMicroEventsS';
eventTagName = '_PermS';
includeSubj = Info.(['include',SessName]);


DesingNameRoot = DesignName;
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    ResultPath = [rootResultPath,Sep,DesingNameRoot,Sep,SessName,mENameTag];
    DesignName = [DesingNameRoot,mENameTag];
    disp('################################################')
    disp('################################################')
    BetaImages_Extraction;
    clear betaImage
    disp('################################################')
    disp('################################################')
end

%% -------------------------->PermMESame Word
SessName = 'Word';
DesignName = 'PermMicroEventsS';
eventTagName = '_PermS';
includeSubj = Info.(['include',SessName]);


DesingNameRoot = DesignName;
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    ResultPath = [rootResultPath,Sep,DesingNameRoot,Sep,SessName,mENameTag];
    DesignName = [DesingNameRoot,mENameTag];
    disp('################################################')
    disp('################################################')
    BetaImages_Extraction;
    clear betaImage
    disp('################################################')
    disp('################################################')
end

%% -------------------------->PermMEDiff Word
SessName = 'Word';
DesignName = 'PermMicroEventsS';
eventTagName = '_PermS';
includeSubj = Info.(['include',SessName]);


DesingNameRoot = DesignName;
for mEIdx = 1:5
    mENameTag = [eventTagName,num2str(mEIdx)];
    ResultPath = [rootResultPath,Sep,DesingNameRoot,Sep,SessName,mENameTag];
    DesignName = [DesingNameRoot,mENameTag];
    disp('################################################')
    disp('################################################')
    BetaImages_Extraction;
    clear betaImage
    disp('################################################')
    disp('################################################')
end