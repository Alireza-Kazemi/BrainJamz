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
SessName = 'Song';
DesignName = 'PermMicroEvents';
includeSubj = Info.(['include',SessName]);
eventTagName = '_Perm';
DesingNameRoot = DesignName;

disp('############################')
disp('-----> Load Betas')
RSA_LoadBetaImages_PermMicroEvent_Jan23;

disp('############################')
disp('-----> Compute RSAs')
DesignName = DesingNameRoot;
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')
disp('############################')


%% RSA for Word EventRelated within Subj between Conditions
SessName = 'Word';
DesignName = 'PermMicroEvents';
includeSubj = Info.(['include',SessName]);
eventTagName = '_Perm';
DesingNameRoot = DesignName;

disp('############################')
disp('-----> Load Betas')
RSA_LoadBetaImages_PermMicroEvent_Jan23;

disp('############################')
disp('-----> Compute RSAs')
DesignName = DesingNameRoot;
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')
disp('############################')