% RSA Analysis
clear;
clc;
close all;

%% Load Information data
load ParticipantsInfoJan23.mat
IDs = Info.IDs;

MaskNames = { 'HPC',...
              'aMPFCSphere',...
              'aMTL',...
              'Auditory'}; 

DD = '/media/data/SIPAlireza/Jamz/';
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');

DesignName = 'BlockBased';

%% RSA for Song BlockBased within Subj between Conditions
SessName = 'Song';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')


%% RSA for Word BlockBased within Subj between Conditions
SessName = 'Word';
RSA_WithinSubjBetweenConds_Jan23;
disp('############################')
