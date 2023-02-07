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

MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');



%% RSA for Song BlockBased within Subj between Conditions
DesignName = 'BlockBased';
SessName = 'Song';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Word BlockBased within Subj between Conditions
DesignName = 'BlockBased';
SessName = 'Word';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Song EventRelated within Subj between Conditions
DesignName = 'EventRelated';
SessName = 'Song';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Word EventRelated within Subj between Conditions
DesignName = 'EventRelated';
SessName = 'Word';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')