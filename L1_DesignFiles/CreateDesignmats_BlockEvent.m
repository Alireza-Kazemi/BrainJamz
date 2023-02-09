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
