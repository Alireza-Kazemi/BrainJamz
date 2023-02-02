function Info = SubjectIDs(DD)

% SubjectIDconfirm
%
% This function returns the directory path and folder names existed 
% for the desired destination directory.
%
% You can set the default directory as an input argument
%
% Developed by Alireza Kazemi 2019
% kazemi@ucdavis.edu 

DD = '/media/data/SIPAlireza/Jamz/';

if(~exist('DD','var')); DD = pwd; end


Dir = uigetdir(DD,'please choose destination folder');

A = dir(Dir);

IDs = {A(vertcat(A.isdir)).name};
IDs = IDs(3:end);
Info.IDs = IDs;
Info.Dir = Dir;
Info.Group = IDs;