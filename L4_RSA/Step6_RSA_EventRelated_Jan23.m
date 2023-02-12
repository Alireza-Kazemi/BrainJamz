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

MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');



%% RSA for Song EventRelated within Subj between Conditions
DesignName = 'EventRelated';
SessName = 'Song';
includeSubj = Info.(['include',SessName]);
% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Word EventRelated within Subj between Conditions
DesignName = 'EventRelated';
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')