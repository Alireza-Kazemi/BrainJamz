% Run the Design Files to Store .mat Files
clear;
clc;

delete *.mat

List = dir('*.m');
Files = {List.name};
for Find=1:length(Files)
    if(~strcmp(Files{Find},'CreateDesignmats.m'))
        i=0;
        names = [];
        onsets = [];
        durations = [];
        feval(Files{Find}(1:end-2))
    end
end

%% Create Block Event Designs
clear
clc;

List = dir('*.mat');
Files = {List.name};
for Find=1:length(Files)
    load(Files{Find});
    namesBE = [];
    onsetBE = [];
    durBE = [];    
    for condIdx = 1:length(names)
        onsetT = onsets{condIdx};
        durT   = durations{condIdx};
        onsetN = cell(1,length(onsetT));
        L = length(onsetT);
        namesBE = cat(2,namesBE,cellstr(repmat(string(names(condIdx)),L,1)+repmat("_",L,1)+string(1:L)')');
        onsetBE = cat(2,onsetBE,num2cell(onsetT));
        durBE = cat(2,durBE,num2cell(durT));
    end
    names = namesBE;
    onsets = onsetBE;
    durations = durBE;
    save(Files{Find},'names','onsets','durations')
end
%% Create Permuted Micro Event Related Designs Separated Per Blocks
clear
clc;

SID = [];
permIndex = [];
conditionName = [];
sessionName = [];
onsetTimes = [];

% Constant RNG seed to keep the track
rng(20234);
List = dir('*.mat');
Files = {List.name};
for Find=1:length(Files)
    for permIdx = 1:5
        load(Files{Find});
        onsetER = cell(1,length(names));
        durER = cell(1,length(names));
        emptyCondIdx = [];
        for condIdx = 1:length(names)
            onsetT = onsets{condIdx};
            durT   = durations{condIdx};
            onsetN = cell(1,length(onsetT));
            onsetERT = []; 
            for onsIdx = 1:length(onsetT)
                if(durT(onsIdx)<5)
                    continue;
                end
                b = 4;
                n = durT(onsIdx)-b;
                k = 2*floor(n/10);
                k(k==0)=1;
                onsetN = onsetT(onsIdx):1:(onsetT(onsIdx)+durT(onsIdx)-1);
                % Select random time points with minimum b seconds distance
                rMEIdx = sort(randperm(n-(k-1)*(b-1),k))+(0:k-1)*(b-1);
%                 disp(rMEIdx)
                if(rem(condIdx,2)==0)
                    rMEIdx(rem(rMEIdx,2)==1) = rMEIdx(rem(rMEIdx,2)==1)+1;
                else
                    rMEIdx(rem(rMEIdx,2)==0) = rMEIdx(rem(rMEIdx,2)==0)+1;
                end
%                 disp(rMEIdx)
                onsetN = onsetN(rMEIdx);
                onsetERT = cat(2,onsetERT,onsetN);
            end
            durERT = ones(1,length(onsetERT));
            if(isempty(durERT))
                emptyCondIdx = cat(1,emptyCondIdx,condIdx);
            end
            onsetER{condIdx} = onsetERT;
            durER{condIdx} = durERT;
            
            % Form a table to check the designs and distributions
            onsetTimes = cat(1,onsetTimes,onsetERT');
            L = length(onsetERT);
            SID = cat(1,SID,repmat(string(Files{Find}(1:4)),L,1));
            permIndex = cat(1,permIndex,repmat(permIdx,L,1));
            conditionName = cat(1,conditionName,repmat(string(names{condIdx}),L,1));
            sessionName = cat(1,sessionName,repmat(string(Files{Find}(6:9)),L,1));
        end
        onsets = onsetER;
        durations = durER;
        
        onsets(emptyCondIdx) = [];
        durations(emptyCondIdx) = [];
        names(emptyCondIdx) = [];
        save([Files{Find}(1:end-4),'_PermMEDiff',num2str(permIdx),'.mat'],'names','onsets','durations')
    end
end
T = table(SID,permIndex,conditionName,sessionName,onsetTimes);
