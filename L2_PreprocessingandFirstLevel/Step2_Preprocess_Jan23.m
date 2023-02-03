% Pre-Processing
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


%% Load Information data
load ParticipantsInfoJan23.mat


%% Preprocessing  Jan 2023 Update
Info.WordComputed = zeros(length(Info.IDs),1);
Info.SongComputed = zeros(length(Info.IDs),1);

IDs = Info.IDs;
Dir = Info.Dir;
oldPWD = pwd;
for sID = 1:length(IDs)
    cd(oldPWD)
    Path = [Dir,Sep,IDs{sID}];
    Scans = Info.Word_path{sID};
    Anat = Info.Highres_path{sID};
    if(size(Scans,1)>100)
        [~, SliceOrder] = sort(Info.Word{sID});
        cd(Path)
        save('PathInfo','Scans','Anat','SliceOrder');
        disp('################################################')
        disp('################################################')
        disp('################################################')
        disp('###################### Word ##########################')
        disp(['Running Batch for ', IDs{sID}])
        cd(oldPWD)
        RunPrepBatch([pwd,Sep,'Batch_Prep_Jan23.m'],Path);
        disp(['Processing is finished for ', IDs{sID}])
        disp('################################################')
        disp('################################################')
        disp('################################################')
        disp('################################################')
        Info.WordComputed(sID) = 1;
    end

    cd(oldPWD)
    Path = [Dir,Sep,IDs{sID}];
    Scans = Info.Song_path{sID};
    Anat = Info.Highres_path{sID};
    if(size(Scans,1)>100)
        [~, SliceOrder] = sort(Info.Song{sID});
        cd(Path)
        save('PathInfo','Scans','Anat','SliceOrder');
        disp('################################################')
        disp('################################################')
        disp('################################################')
        disp('####################### Song #########################')
        disp(['Running Batch for ', IDs{sID}])
        cd(oldPWD)
        RunPrepBatch([pwd,Sep,'Batch_Prep_Jan23.m'],Path);
        disp(['Processing is finished for ', IDs{sID}])
        disp('################################################')
        disp('################################################')
        disp('################################################')
        disp('################################################')
        Info.SongComputed(sID) = 1;
    end
end