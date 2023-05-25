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

MaskNames = { 'HPC_L',...
              'HPC_R',...
              'aMTL_L',...
              'aMTL_R',...
              'PAuditory_L',...
              'PAuditory_R',...
              'aMPFCSphere'}; 

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');

SessName = 'Word';
includeSubj = Info.(['include',SessName]);

%% RSA for Word BlockBased within Subj between Conditions
DesignName = 'BlockBased';

% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')

%% RSA for Word BlockEvent within Subj between Conditions
DesignName = 'BlockEvent';

% Load SPM Data
load([rootResultPath,Sep,'BetaImages',DesignName,'_',SessName,'.mat']);
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')

%% RSA for Word MicroEvent within Subj between Conditions Within MEs
DesignName = 'MicroEvent';
eventTagName = '_ME';
DesingNameRoot = DesignName;

disp('############################')
disp('-----> Load Betas')
RSA_LoadBetaImages_MicroEvent_Jan23;

disp('############################')
disp('-----> Compute RSAs')
DesignName = DesingNameRoot;
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')
disp('############################')


%% -------------------------->Permuted Micro Events Medly Word
DesignNames = {'PermMicroEvents','PermMEBoth','PermMESame','PermMEDiff'};
eventTagName = '_Perm';
for DesignIdx = 1:4
    DesingNameRoot = DesignNames{DesignIdx};

    disp('############################')
    disp('-----> Load Betas')
    RSA_LoadBetaImages_PermMicroEvent_Jan23;
    
    disp('############################')
    disp('-----> Compute RSAs')
    DesignName = DesingNameRoot;
    RSA_WithinSubjBetweenConds_Jan23;
    disp('############################')
    disp('############################')
end

