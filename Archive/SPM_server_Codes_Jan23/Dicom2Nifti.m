% function Info = Dicom2Nifti(Info)

% This function convert Dicom2Nifti.
%
% Developed by Alireza Kazemi 2019
% kazemi@ucdavis.edu 

if (ispc)
    Sep = '\';
else
    Sep = '/';
end
subfolders = {'Highres','Song','Word'};
IDs = Info.IDs;

Info.Word = cell(length(IDs),1);
Info.Word_path = cell(length(IDs),1);
Info.Song = cell(length(IDs),1);
Info.Song_path = cell(length(IDs),1);
Info.Highres_path = cell(length(IDs),1);

Info.age = zeros(length(IDs),1);
Info.BirthD = zeros(length(IDs),1);
Info.ExpDate = zeros(length(IDs),1);
Info.Name = cell(length(IDs),1);
Info.PID = cell(length(IDs),1);
Info.Sex = zeros(length(IDs),1);

%%
for Sid = 1:length(IDs)
    disp(['coversion for ID ------------------------------> ',IDs{Sid}])
    for subfolds = 1:length(subfolders)
        disp(['Folder ---------> ',subfolders{subfolds}])
        directory = [Info.Dir,Sep,IDs{Sid},Sep,subfolders{subfolds}];
        if(~isempty(dir([directory,Sep,'run*'])))
            list = dir([directory,Sep,'run*']);
            for Runs = 1:length(list)
                disp(['Run ---> ',list(Runs).name])
                Currentpath = pwd;
                cd(directory);
                mkdir([list(Runs).name,'_raw'])
                destination = [directory,Sep,list(Runs).name,'_raw'];
                filesPath = covert2nifti([directory,Sep,list(Runs).name],destination);
                Info.([subfolders{subfolds},'_path'])(Sid) = cat(1,Info.([subfolders{subfolds},'_path']){Sid},{filesPath.files});
                cd(Currentpath);
            end
            hdr = spm_dicom_headers([directory,Sep,list(Runs).name,Sep,'0001.dcm']);
            if isfield( hdr{1}, 'Private_0019_1029' )
                Info.(subfolders{subfolds}){Sid} = hdr{1}.Private_0019_1029;
                Info.age(Sid) = str2double(hdr{1}.PatientAge(1:end-1));
                Info.BirthD(Sid) = hdr{1}.PatientBirthDate;
                Info.ExpDate(Sid) = hdr{1}.AcquisitionDate;
                Info.Name{Sid} = hdr{1}.PatientName;
                Info.PID{Sid} = hdr{1}.PatientID;
                Info.Sex(Sid) = hdr{1}.PatientSex(1);
            end
        elseif(~isempty(dir([directory,Sep,'*.dcm'])))
            Currentpath = pwd;
            cd(directory);
            cd('..')
            mkdir([subfolders{subfolds},'_raw'])
            destination = [pwd,Sep,subfolders{subfolds},'_raw'];
            filesPath = covert2nifti(directory,destination);
            Info.([subfolders{subfolds},'_path'])(Sid) = cat(1,Info.([subfolders{subfolds},'_path']){Sid},{filesPath.files});
            cd(Currentpath);
            hdr = spm_dicom_headers([directory,Sep,'0002.dcm']);
            if isfield( hdr{1}, 'Private_0019_1029' )
                Info.(subfolders{subfolds}){Sid} = hdr{1}.Private_0019_1029;
                Info.age(Sid) = str2double(hdr{1}.PatientAge(1:end-1));
                Info.BirthD(Sid) = hdr{1}.PatientBirthDate;
                Info.ExpDate(Sid) = hdr{1}.AcquisitionDate;
                Info.Name{Sid} = hdr{1}.PatientName;
                Info.PID{Sid} = hdr{1}.PatientID;
                Info.Sex(Sid) = hdr{1}.PatientSex(1);
            end
        else
            disp('!!!!! No files or folders !!!!!')
            continue;
        end
    end
end


