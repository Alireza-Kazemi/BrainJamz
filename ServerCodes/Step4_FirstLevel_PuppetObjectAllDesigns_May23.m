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



%% Load Information data
load ParticipantsInfoJan23.mat
IDs = Info.IDs;
Dir = Info.Dir;

FormatPrep = 'wra';% a for Slicetime, r for realignment, w for normalization, s for smoothing

Mask = {'/home/kazemi/Documents/MATLAB/spm12/tpm/mask_ICV.nii,1'};

DD = '/media/data/SIPAlireza/';
RootDesignPath = uigetdir(DD,'Please choose the folder of Design .mat files');
rootResultPath = uigetdir(DD,'Please choose a destination folder for results');

%% First Level Analysis BlockBased
DesignName = 'BlockBased';
DesignPath = [RootDesignPath,Sep,DesignName];

% -------------------------------------> Wrods
includeSubj = Info.includeWord;
SessName = 'Word';
designFileNameTag = ['_',SessName];
SessFolderName = [SessName,'_raw'];
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];
mkdir(ResultPath)

disp('################################################')
disp('################################################')
disp('################################################')
disp('################################################')
oldPWD = pwd;
RunFirstLevelBatch;
cd(oldPWD)
% Delete residual Files
copyfile('DeleteResiduals.sh',[ResultPath,Sep])
cd(ResultPath)
[status,cmdout]  = system('bash DeleteResiduals.sh');
cd(oldPWD)

%% First Level Analysis BlockEvent
DesignName = 'BlockEvent';
DesignPath = [RootDesignPath,Sep,DesignName];

% -------------------------------------> Wrods
SessName = 'Word';
includeSubj = Info.(['include',SessName]);
designFileNameTag = ['_',SessName];
SessFolderName = [SessName,'_raw'];
ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName];
mkdir(ResultPath)

disp('################################################')
disp('################################################')
disp('################################################')
disp('################################################')
oldPWD = pwd;
RunFirstLevelBatch;
cd(oldPWD)

% Delete residual Files
copyfile('DeleteResiduals.sh',[ResultPath,Sep])
cd(ResultPath)
[status,cmdout]  = system('bash DeleteResiduals.sh');
cd(oldPWD)

%% First Level Analysis Micro Events Block Based
DesignName = 'MicroEvent';
eventTagName = '_ME';
DesignPath = [RootDesignPath,Sep,DesignName];

% -------------------------------------> Words
SessName = 'Word';
SessFolderName = [SessName,'_raw'];
for mEIdx = 1:20
    mENameTag = [eventTagName,num2str(mEIdx)];
    includeSubj = Info.(['include',SessName]);
    designFileNameTag = ['_',SessName,mENameTag];
    ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName,mENameTag];
    mkdir(ResultPath)
    
    disp('################################################')
    disp('################################################')
    disp('################################################')
    disp('################################################')
    oldPWD = pwd;
    RunFirstLevelBatch;
    cd(oldPWD)

    % Delete residual Files
    copyfile('DeleteResiduals.sh',[ResultPath,Sep])
    cd(ResultPath)
    [status,cmdout]  = system('bash DeleteResiduals.sh');
    cd(oldPWD)
end


%% First Level Analysis Permuted Micro Events Medly
DesignNames = {'PermMicroEvents','PermMEBoth','PermMESame','PermMEDiff'};
eventTagName = '_Perm';
for DesignIdx = 1:4
    DesignName = DesignNames{DesignIdx};
    DesignPath = [RootDesignPath,Sep,DesignName];
    
    % -------------------------------------> Words
    SessName = 'Word';
    SessFolderName = [SessName,'_raw'];
    for mEIdx = 1:5
        mENameTag = [eventTagName,num2str(mEIdx)];
        includeSubj = Info.(['include',SessName]);
        designFileNameTag = ['_',SessName,mENameTag];
        ResultPath = [rootResultPath,Sep,DesignName,Sep,SessName,mENameTag];
        mkdir(ResultPath)
        
        disp('################################################')
        disp('################################################')
        disp('################################################')
        disp('################################################')
        oldPWD = pwd;
        RunFirstLevelBatch;
        cd(oldPWD)
    
        % Delete residual Files
        copyfile('DeleteResiduals.sh',[ResultPath,Sep])
        cd(ResultPath)
        [status,cmdout]  = system('bash DeleteResiduals.sh');
        cd(oldPWD)
    end
end

