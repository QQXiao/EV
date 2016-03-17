#!/bin/bash
basedir=/seastor/helenhelen/ES
maskdir=/seastor/helenhelen/roi/ES
resultdir=$basedir/group/sme_ori/ROIs
cd $maskdir
rois=`ls *.nii.gz`
ppheight=50
for c in 8 9 12 13
do
feat_dir=$basedir/group/sme_ori/cope${c}.gfeat/cope1.feat
cd ${feat_dir}
fslmaths filtered_func_data.nii.gz -div mean_func.nii.gz -mul $ppheight pctchange_data    
	for rx in $rois
	do    
	r=`echo $rx | sed "s/.nii.gz//"`
	echo $r
	fslmeants -i filtered_func_data.nii.gz -o ${resultdir}/cope${c}_${r}.txt -m ${maskdir}/${r} 
   	done
        rm -f pctchange_data.nii.gz
done
