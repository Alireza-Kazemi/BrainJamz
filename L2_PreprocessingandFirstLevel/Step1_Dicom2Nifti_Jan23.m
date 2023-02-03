% Dicom2Nifti Conversion
% Developed by Alireza Kazemi 2023
% kazemi@ucdavis.edu 
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
