%-----------------------------------------------------------------------
% Job saved on 31-Jan-2023 01:49:49 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.dir = {'/media/data/SIPAlireza/Jamz/ResultsJan23'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 23;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                                 '/media/data/SIPAlireza/Jamz/PreprocessJan23/076/Song_raw/wraf076-0005-00001-000001-01.img,1'
                                                 '/media/data/SIPAlireza/Jamz/PreprocessJan23/076/Song_raw/af076-0005-00001-000001-01.img,1'
                                                 '/media/data/SIPAlireza/Jamz/PreprocessJan23/076/Song_raw/af076-0005-00002-000002-01.img,1'
                                                 };
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {'/media/data/SIPAlireza/Jamz/DesignFiles/DesignFilesSongWordJan23/S076_Song.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {'/media/data/SIPAlireza/Jamz/PreprocessJan23/076/Song_raw/rp_af076-0005-00001-000001-01.txt'};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
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
