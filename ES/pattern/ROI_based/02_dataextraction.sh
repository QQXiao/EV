#!sh/bin/
basedir=/seastor/helenhelen/ES
#for m in 2
for m in 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
    if [ ${m} -lt 10 ];
    then
       sub=sub00${m}
       SUB=sub0${m}
    else
        sub=sub0${m}
        SUB=sub${m}
    fi
    echo $SUB
maskdir=$basedir/${sub}/roi_ref
resultdir=$basedir/ROI_based_RSM/ref_space/raw
	datadir=$basedir/data_singletrial/LSS/ref_space/merged
	for roi in $maskdir/*.nii.gz
	do
		roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
		fsl_sub -q verylong.q fslmeants -i $datadir/${SUB}.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${roi_prefix}_${SUB}.txt
	done # roi
done
