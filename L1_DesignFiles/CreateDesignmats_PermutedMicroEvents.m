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

%% Create Event Related Designs
clear
clc;

SID = [];
permIndex = [];
conditionName = [];
sessionName = [];
onsetTimes = [];

% Constant RNG seed to keep the track
rng(2023);
List = dir('*.mat');
Files = {List.name};
for Find=1:length(Files)
    for permIdx = 1:5
        load(Files{Find});
        onsetER = cell(1,length(names));
        durER = cell(1,length(names));
        for condIdx = 1:length(names)
            onsetT = onsets{condIdx};
            durT   = durations{condIdx};
            onsetN = cell(1,length(onsetT));
            onsetERT = []; 
            for onsIdx = 1:length(onsetT)
                if(durT(onsIdx)<5)
                    continue;
                end
                b = 3;
                n = durT(onsIdx)-b;
                k = 2*floor(n/10);
                k(k==0)=1;
                onsetN = onsetT(onsIdx):1:(onsetT(onsIdx)+durT(onsIdx)-1);
                % Select random time points with minimum b seconds distance
                rMEIdx = sort(randperm(n-(k-1)*(b-1),k))+(0:k-1)*(b-1);
                onsetN = onsetN(rMEIdx);
                onsetERT = cat(2,onsetERT,onsetN);
            end
            durERT = ones(1,length(onsetERT));
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
        save([Files{Find}(1:end-4),'_Perm',num2str(permIdx),'.mat'],'names','onsets','durations')
    end
end
T = table(SID,permIndex,conditionName,sessionName,onsetTimes);
%% plot test
dat = T(T.SID =="S076",:);
for permIdx = 1:length(unique(dat.permIndex))
    datperm = dat(dat.permIndex == permIdx,:);
    names = unique(datperm.conditionName);
    for condIdx = 1:length(names)
        onsets = datperm.onsetTimes(datperm.conditionName==names(condIdx));
%         plot(onsets,ones(size(onsets))+condIdx,'.','DisplayName',names(condIdx));
        stem(onsets,ones(size(onsets))+condIdx,'DisplayName',names(condIdx));
        hold on
        legend();
    end
end
dat = T(T.SID =="S076",:);
dat = dat(dat.sessionName=="Word",:);
dat = dat(dat.conditionName=="target",:);
dat = dat(dat.permIndex==5,:);
hist(rem(dat.onsetTimes,20),1:20)
%% Create Event Related Designs Old for test
% clear
% clc;
% 
% List = dir('*.mat');
% Files = {List.name};
% for Find=1:length(Files)
%     load(Files{Find});
%     for condIdx = 1:length(names)
%         onsetT = onsets{condIdx};
%         durT   = durations{condIdx};
%         onsetN = [];
%         for onsIdx = 1:length(onsets{condIdx})
%             onsetN = cat(2,onsetN,(onsetT(onsIdx)+0.5):1.5:(onsetT(onsIdx)+durT(onsIdx)));
%         end
%         durN = 1.5*ones(size(onsetN));
%         onsets{condIdx} = onsetN;
%         durations{condIdx} = durN;
%         
% %         plot(onsetN,ones(size(onsetN)),'.','DisplayName',names{condIdx});
% %         hold on
% %         legend();
%     end
% %     plot(0,0.9,'k.')
% %     plot(0,1.1,'k.')
% %     close
%     save(Files{Find},'names','onsets','durations')
% end
% 
