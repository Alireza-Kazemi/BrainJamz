clear
clc
%% This file is loaded after the preprocessing.
load ParticipantsInfoJan23.mat

ID = [];
sex = [];
age = [];
expDate = [];
birthD = [];
songPrep = [];
songVols = [];
songGroup = [];
wordPrep = [];
wordVols = [];
includeWord = [];
includeSong = [];

% Target Reverse
Replication_IDs = string([76, 92, 93, 95, 97, 98, 123, 124, 132, 133, 134, 141, 151, 153, 154, 156, 157, 158, 165, 177, 190, 195, 220, 221, 223, 226, 228, 230, 232, 234, 235]);
% Non-Target Reverse
Extension_IDs = string([155, 166, 169, 192, 196, 199, 206, 208, 209, 210, 216,218, 219, 233, 239, 240, 242]); 


for ind = 1:length(Info.PID)
    ID = cat(1,ID,string(['S',Info.PID{ind}]));
    sex = cat(1,sex,string(char(Info.Sex(ind))));
    age = cat(1,age,Info.age(ind));
    birthD = cat(1,birthD,Info.BirthD(ind));
    expDate = cat(1,expDate,Info.ExpDate(ind));
    songVols = cat(1,songVols,size(Info.Song_path{ind},1));
    songPrep = cat(1,songPrep,Info.SongComputed(ind));
    if(contains(string(Info.PID{ind}),string(Replication_IDs)))
        songGroup = cat(1,songGroup,"Replication");
    elseif(contains(string(Info.PID{ind}),string(Extension_IDs)))
        songGroup = cat(1,songGroup,"Extension");
    else
        songGroup = cat(1,songGroup,"");
    end
    includeSong = cat(1,includeSong,Info.SongComputed(ind));
    wordVols = cat(1,wordVols,size(Info.Word_path{ind},1));
    wordPrep = cat(1,wordPrep,Info.WordComputed(ind));
    includeWord = cat(1,includeWord,Info.WordComputed(ind));
end
ID = replace(ID," ","");
ageFrac = yearfrac(birthD,expDate);
birthD = string(datestr(birthD));
expDate = string(datestr(expDate));
T = table(ID,sex,age,ageFrac,birthD,expDate,songVols,songPrep,songGroup,includeSong,wordVols,wordPrep,includeWord);
Info.TrackTable = T;
Info.includeSong = includeSong;
Info.includeWord = includeWord;