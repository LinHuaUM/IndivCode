#! /bin/csh

# export CBIG_MATLAB_DIR=/Applications/MATLAB_R2016b.app
# export CBIG_CODE_DIR=/Users/Selven/Desktop/RsCode
# export SUBJECTS_DIR=/Users/Selven/Desktop/AD_DATA

##
set count = 1
set stop =  235

set att_file = $SUBJECTS_DIR/SubList.txt

while($count <= $stop)
    set s = `head -n $count $att_file | tail -n 1 | awk '{print $1}'`
    set a = `echo $s|cut -c 5-9`

    $CBIG_CODE_DIR/CBIG_preproc_skip.csh -s subj${a} -d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest -skip 4
    $CBIG_CODE_DIR/CBIG_preproc_fslslicetimer.csh -s subj${a} -d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4 -slice_order ${SUBJECTS_DIR}/subj${a}/bold/001/slice_order.txt
    $CBIG_CODE_DIR/CBIG_preproc_fslmcflirt_outliers.csh -s subj${a} -d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4_stc -FD_th 0.2 -DV_th 50 -discard-run 50 -rm-seg 5 -spline_final
    $CBIG_CODE_DIR/CBIG_preproc_bbregister.csh -s subj${a} -d ${SUBJECTS_DIR} -anat_s subj${a}_FS -anat_d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4_stc_mc
    $CBIG_CODE_DIR/CBIG_preproc_create_mask.csh -s subj${a} -d ${SUBJECTS_DIR} -anat_s subj${a}_FS -anat_d ${SUBJECTS_DIR} -bld 001 -REG_stem _rest_skip4_stc_mc_reg -MASK_stem _rest_skip4_stc_mc -whole_brain -wm -csf -gm
    $CBIG_CODE_DIR/CBIG_preproc_regression.csh -s subj${a} -d ${SUBJECTS_DIR} -anat_s subj${a}_FS -anat_d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4_stc_mc -REG_stem _rest_skip4_stc_mc_reg -MASK_stem _rest_skip4_stc_mc -OUTLIER_stem _FDRMS0.2_DVARS50_motion_outliers.txt -whole_brain -wm -csf -motion12_itamar -detrend_method detrend -per_run -censor -polynomial_fit 1
    $CBIG_CODE_DIR/CBIG_preproc_censor.csh -s subj${a} -d ${SUBJECTS_DIR} -anat_s subj${a}_FS -anat_d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4_stc_mc_residc -REG_stem _rest_stc_mc_reg -OUTLIER_stem _FDRMS0.2_DVARS50_motion_outliers.txt -max_mem NONE
    $CBIG_CODE_DIR/CBIG_preproc_bandpass_fft.csh -s subj${a} -d ${SUBJECTS_DIR} -bld 001 -BOLD_stem _rest_skip4_stc_mc_residc_interp_FDRMS0.2_DVARS50 -OUTLIER_stem _FDRMS0.2_DVARS50_motion_outliers.txt -low_f 0.009 -high_f 0.08 -detrend
    $CBIG_CODE_DIR/CBIG_preproc_native2fsaverage.csh -s subj${a} -d ${SUBJECTS_DIR} -anat_s subj${a}_FS -anat_d ${SUBJECTS_DIR} -bld 001 -proj fsaverage6 -sm 6 -down fsaverage4 -BOLD_stem _rest_skip4_stc_mc_residc_interp_FDRMS0.2_DVARS50_bp_0.009_0.08 -REG_stem _rest_skip4_stc_mc_reg

  	@ count = $count + 1
end



