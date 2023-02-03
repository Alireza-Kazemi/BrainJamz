function RunPrepBatch(Jobfile,Path)
% List of open inputs
cd(Path);
nrun = 1; % enter the number of runs here
jobfile = {Jobfile};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
spm('defaults', 'FMRI');
spm_figure('GetWin','Graphics');
spm_jobman('run', jobs, inputs{:});
end