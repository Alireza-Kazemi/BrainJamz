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


%% Get the Directory of the raw files.
Info = SubjectIDs();

%% Convert Dicom files to Nifti format
Dicom2Nifti;
save('ParticipantsInfoJan23.mat','Info');
