% RSA Analysis

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

% ----> BiLateral Masks
% MaskNames = { 'HPC',...
%               'aMPFCSphere',...
%               'aMTL',...
%               'Auditory'}; 

% ----> UniLateral Masks
MaskNames = { 'HPC_L',...
              'HPC_R',...
              'aMTL_L',...
              'aMTL_R',...
              'PAuditory_L',...
              'PAuditory_R',...
              'aMPFCSphere'}; 

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');



%% RSA for Song BlockBased within Subj between Conditions
DesignName = 'BlockBased';
SessName = 'Song';
includeSubj = Info.(['include',SessName]);
% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Word BlockBased within Subj between Conditions
DesignName = 'BlockBased';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


