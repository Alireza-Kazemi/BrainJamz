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