% Recipe_fMRI
% this 'recipe' performs region of interest analysis on fMRI data.
% Cai Wingfield 5-2010, 6-2010, 7-2010, 8-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

%%%%%%%%%%%%%%%%%%%%
%% Initialisation %%
%%%%%%%%%%%%%%%%%%%%

% toolboxRoot = 'toolboxPathOnYourMachine'; addpath(genpath(toolboxRoot));
userOptions = defineUserOptions_Alltogether(Dir,ResultPath, MaskPath, MaskNames, Conditions,IDs,SessionNum,designName);

%%%%%%%%%%%%%%%%%%%%%%
%% Data preparation %%
%%%%%%%%%%%%%%%%%%%%%%

[fullBrainVols,Betas]  = rsa.fmri.fMRIDataPreparation('SPM', userOptions);
binaryMasks_nS = rsa.fmri.fMRIMaskPreparation(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, 'SPM', userOptions);
% oldresponsePatterns = responsePatterns;
% for i=1:length(MaskNames)
%     for j = 1:length(IDs)
%         temp = responsePatterns.(MaskNames{i}).(IDs{j});
%         IndE = find(sign(abs(squeeze(temp(1,1,:)))));
%         IndR = find(1-sign(abs(squeeze(temp(1,1,:)))));
%         RespNew = temp(:,:,IndE)+temp(:,:,IndR);
%         responsePatterns.(MaskNames{i}).(IDs{j}) = RespNew;
%     end
% end
% clear RespNew;


%%%%%%%%%%%%%%%%%%%%%
%% RDM calculation %%
%%%%%%%%%%%%%%%%%%%%%

RDMs  = rsa.constructRDMs(responsePatterns, 'SPM', userOptions);
sRDMs = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session');
save([ResultPath,Sep,'RDMS.mat'],'RDMs','sRDMs','userOptions');
RDMs  = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session', 'subject');

% save([ResultPath,Sep,'RDMS.mat'],'RDMs','userOptions');
% RDMs(1).RDM = RDMs(1).RDM([1:5,14:18],[1:5,14:18]);
% RDMs(2).RDM = RDMs(2).RDM([1:5,14:18],[1:5,14:18]);
rsa.figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
clear Models;
Models.main_clusters = RDMs(1).RDM;
userOptions.analysisName = 'RDM1';
Models = rsa.constructModelRDMs(Models, userOptions);
Models.main_clusters = RDMs(2).RDM;
userOptions.analysisName = 'RDM2';
Models = rsa.constructModelRDMs(Models, userOptions);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First-order visualisation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rsa.figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
% rsa.figureRDMs(Models, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));

rsa.MDSConditions(RDMs, userOptions);
rsa.dendrogramConditions(RDMs, userOptions);
