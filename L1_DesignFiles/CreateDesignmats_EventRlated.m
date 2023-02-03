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

List = dir('*.mat');
Files = {List.name};
for Find=1:length(Files)
    load(Files{Find});
    namesER = [];
    onsetER = [];
    durER = [];    
    for condIdx = 1:length(names)
        onsetT = onsets{condIdx};
        durT   = durations{condIdx};
        onsetN = cell(1,length(onsetT));
%         L = (max(durT)-.5)/1.5;
        L = max(durT);
        namesER = cat(2,namesER,cellstr(repmat(string(names(condIdx)),L,1)+repmat("_",L,1)+string(1:L)')');
        onsetERT = cell(1,L); 
        durERT = cell(1,L);
        for onsIdx = 1:length(onsetT)
%             onsetN = (onsetT(onsIdx)+0.5):1.5:(onsetT(onsIdx)+durT(onsIdx)-1.5);
            onsetN = onsetT(onsIdx):1:(onsetT(onsIdx)+durT(onsIdx)-1);
            for cIdx = 1:length(onsetN)
                onsetERT{cIdx} = cat(2,onsetERT{cIdx},onsetN(cIdx));
%                 durERT{cIdx} = cat(2,durERT{cIdx},1.5);
                durERT{cIdx} = cat(2,durERT{cIdx},1);
            end
        end
        onsetER = cat(2,onsetER,onsetERT);
        durER = cat(2,durER,durERT);
    end
    names = namesER;
    onsets = onsetER;
    durations = durER;
    save(Files{Find},'names','onsets','durations')
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
