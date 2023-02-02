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
FormatPrep = 'wra';% a for Slicetime, r for realignment, w for normalization, s for smoothing
designName = 'Collapsed'; %'Separated'; %

if(strcmp(designName,'Separated'))
    Conditions = {'baseline',...1
	    'target',...2
	    'nreverse',...3
	    'treverse',...4
	    'novel'}; %..5
else
    Conditions = {'baseline',...1
	    'target',...2
	    'reverse',...3
	    'novel'}; %..4
end


%% Get the Directory of the raw files.
Info = SubjectIDs();

%% Convert Dicom files to Nifti format
Dicom2Nifti;
% save('ParticipantsInfo.mat','Info');
%% Load Information data
load ParticipantsInfo.mat
removeIDs = [10,11,12,14,27,40]; % Word Analysis no Functional
% removeIDs = [2,7,28];
Info.IDs(removeIDs)=[];
Info.Group(removeIDs)=[];
Info.age(removeIDs)=[];
Info.BirthD(removeIDs)=[];
Info.ExpDate(removeIDs)=[];
Info.Highres_path(removeIDs)=[];
% Info.Song_path(removeIDs)=[];
% Info.Word_path(removeIDs)=[];
Info.Name(removeIDs)=[];
Info.PID(removeIDs)=[];
Info.Sex(removeIDs)=[];
Info.Song(removeIDs,:)=[];
% For Word Analysis
Info.Word_path([23,36])=[]; % IDs 195 and 226
Info.Word(23,:)=[]; % IDs 195 and 226
%% Preprocessing   Sep 2022 Update  Only Words

% IDs = Info.IDs;
% Dir = Info.Dir;
% oldPWD = pwd;
% for sID = 23:31 %length(IDs)
%     cd(oldPWD)
%     Path = [Dir,Sep,IDs{sID}];
%     Scans = Info.Word_path{sID};
%     Anat = Info.Highres_path{sID};
%     [~, SliceOrder] = sort(Info.Word(sID,:));
%     cd(Path)
%     save('PathInfo','Scans','Anat','SliceOrder');
%     disp('################################################')
%     disp('################################################')
%     disp('################################################')
%     disp('################################################')
%     disp(['Running Batch for ', IDs{sID}])
%     cd(oldPWD)
% %     RunPrepBatch([pwd,Sep,'Batch_Job.m'],Path);
%     RunPrepBatch([pwd,Sep,'Batch_Prep.m'],Path);
%     disp(['Processing is finished for ', IDs{sID}])
%     disp('################################################')
%     disp('################################################')
%     disp('################################################')
%     disp('################################################')
% end

%% Create Movement Regressors
% IDs = Info.IDs;
% Dir = Info.Dir;
% for Sid = 1:length(IDs)
%     CreateMovementReg(Sid,IDs,Dir);
% end

%% First Level Analysis Separated Encoding and Retrieval
% 
% DesignPath = uigetdir(pwd,'Please choose the folder of Design .mat files');
% DD = '/media/data/SIPAlireza/';
% ResultPath = uigetdir(DD,'Please choose a destination folder for results');
% IDs = Info.IDs;
% Dir = Info.Dir;
% oldPWD = pwd;
% Scans = cell(1,length(IDs));
% mvRegs = cell(1,length(IDs));
% for Sid = 1:length(IDs)
%     [Scans{Sid},mvRegs{Sid}] = FileLocations(Sid,IDs,Dir,FormatPrep);
% end
% Path = ResultPath;
% ResultPath = [ResultPath,Sep,designName];
% mkdir(ResultPath)
% % save([Path,Sep,designName,Sep,'Pathinfo1stlevel.mat'],'Scans','DesignPath','ResultPath','IDs')
% disp('################################################')
% disp('################################################')
% disp('################################################')
% disp('################################################')
% RunFirstLevelBatch;
% cd(oldPWD)


%% RSA Analysis

MaskNames = { 'HPC',...
              'aMPFSphere',...
              'aMTL'}; 

IDs = Info.IDs;
Dir = Info.Dir;
DD = '/media/data/SIPAlireza/Jamz/';
ResultPath = uigetdir(DD,'Please choose a destination folder for results');
MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');

Recipe_fMRI_Alltogether;
% BetaWeightExtractions_Activities;

%% Time Series Extraction 

removeIDs = [7,20,22,34]; % Word Analysis no Functional
% removeIDs = [2,7,28];
Info.IDs(removeIDs)=[];
Info.Group(removeIDs)=[];
Info.age(removeIDs)=[];
Info.BirthD(removeIDs)=[];
Info.ExpDate(removeIDs)=[];
Info.Highres_path(removeIDs)=[];
% Info.Song_path(removeIDs)=[];
% Info.Word_path(removeIDs)=[];
Info.Name(removeIDs)=[];
Info.PID(removeIDs)=[];
Info.Sex(removeIDs)=[];
Info.Song(removeIDs,:)=[];
% For Word Analysis
Info.Word_path(removeIDs)=[]; % IDs 195 and 226
Info.Word(removeIDs,:)=[]; % IDs 195 and 226


MaskNames = { 'HPC',...
              'aMPFSphere',...
              'aMTL'}; 
%               'Left_HPC50',...
%               'Right_HPC50',...
 

IDs = Info.IDs;
Dir = Info.Dir;
DD = '/media/data/SIPAlireza/Jamz/';
ResultPath = uigetdir(DD,'Please choose a destination folder for results');
MaskPath   = uigetdir(DD,'Please select the folder contains Mask.nii files');

TimeSeries_Extraction;