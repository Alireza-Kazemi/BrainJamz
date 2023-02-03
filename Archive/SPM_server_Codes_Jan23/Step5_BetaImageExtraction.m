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



%% Extract Beta Images

MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 

IDs = Info.IDs;
Dir = Info.Dir;
DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');
MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');


% Load Masks
mask = cell(1,length(MaskNames));
for maskID = 1:length(MaskNames)
    readPath = [MaskPath,Sep,MaskNames{maskID},'.nii'];
    mask{maskID} = spm_vol(readPath);
end

%-------------------------->BlockBased Songs
DesignName = 'BlockBased';
SessName = 'Song';
includeSubj = Info.includeSong;
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
save(['BetaImages',DesignName,'_',SessName,'.mat'],'betaImage','-v7.3');
clear betaImage
%-------------------------->EventRelated Songs
DesignName = 'EventRelated';
SessName = 'Song';
includeSubj = Info.includeSong;
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
save(['BetaImages',DesignName,'_',SessName,'.mat'],'betaImage','-v7.3');
clear betaImage
%-------------------------->BlockBased Word
DesignName = 'BlockBased';
SessName = 'Word';
includeSubj = Info.includeWord;
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
save(['BetaImages',DesignName,'_',SessName,'.mat'],'betaImage','-v7.3');
clear betaImage
%-------------------------->EventRelated Word
DesignName = 'EventRelated';
SessName = 'Word';
includeSubj = Info.includeWord;
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];

BetaImages_Extraction;
save(['BetaImages',DesignName,'_',SessName,'.mat'],'betaImage','-v7.3');
clear betaImage