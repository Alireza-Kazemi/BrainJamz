clear;
clc;
close all;

Files = dir("*.gz");


Files = {Files(:).name};

Files(contains(Files,'mask')) = [];

for fIndex = 1:length(Files)
    temp = niftiread(Files{fIndex});
    info = niftiinfo(Files{fIndex});
    niftiwrite(temp,string(Files{fIndex}(1:end-7))+".nii",info);
end