%-----------------------------------------------------------------------
% First Level Analysis batch
%-----------------------------------------------------------------------

disp(['Running First Level Analysis for ', SessName])
spm('defaults', 'FMRI');
SessionID  = 1;
for Sid = 1:length(IDs) 
    disp([num2str(Sid),'/',num2str(length(IDs)),' Data for Subject: ', IDs{Sid}])

    if(includeSubj(Sid)==0)
        disp([num2str(Sid),'/',num2str(length(IDs)),' !!!!!!---->',SessName,' Subject Ignored:', IDs{Sid}])
        continue;
    end

    dirS = [Dir,Sep,IDs{Sid},Sep,SessFolderName,Sep];
    [Scans,mvRegs] = FileLocations(dirS,FormatPrep);

    matlabbatch{1}.spm.stats.fmri_spec.dir = {[ResultPath,Sep,'FirstLevel_',IDs{Sid}]};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 23;

    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).scans = Scans;
    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).multi = {[DesignPath,Sep,'S',IDs{Sid},designFileNameTag,'.mat']};
    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).multi_reg = mvRegs;
    matlabbatch{1}.spm.stats.fmri_spec.sess(SessionID).hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'Scaling';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/home/kazemi/Documents/MATLAB/spm12/tpm/mask_ICV.nii,1'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.review.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.review.display.matrix = 1;
    matlabbatch{3}.spm.stats.review.print = 'pdf';


    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
    clear matlabbatch;

end