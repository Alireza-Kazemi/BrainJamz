% Run the Design Files to Store .mat Files
clear;
clc;

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
            durERT = [];
            for onsIdx = 1:length(onsetT)
                n = durT(onsIdx);
                b = 3;
                k = 2*floor(n/10);
                k(k==0)=1;
                onsetN = onsetT(onsIdx):1:(onsetT(onsIdx)+durT(onsIdx)-1);
                rMEIdx = sort(randperm(n-(k-1)*(b-1),k))+(0:k-1)*(b-1);
                onsetN = onsetN(rMEIdx);
                for cIdx = 1:length(onsetN)
                    onsetERT = cat(2,onsetERT,onsetN(cIdx));
                    durERT = cat(2,durERT,1);
                end
            end
            onsetER{condIdx} = onsetERT;
            durER{condIdx} = durERT;
        end
        onsets = onsetER;
        durations = durER;
        save([Files{Find}(1:end-4),'_Perm',num2str(permIdx),'.mat'],'names','onsets','durations')
    end
end
%% plot test
for condIdx = 1:length(names)      
    plot(onsets{condIdx},ones(size(onsets{condIdx})),'.','DisplayName',names{condIdx});
    hold on
    legend();
end
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
