#!/bin/sh
basedir='/seastor/helenhelen/ES'
for c in SME
#for c in SME_EV_L SME_EV_S SME_spacing
do
datadir=$basedir/Searchlight_RSM/standard_space/sep/sub/${c}
resultdir=$basedir/Searchlight_RSM/standard_space/sep/merged/${c}
result2dir=$basedir/Searchlight_RSM/standard_space/sep/mean/${c}
mkdir $resultdir -p
mkdir $result2dir -p
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 20 21 22 23 24 25 26 27 28 29 30
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

	for ci in wi bi
	do
        	for cr in rem forg
        	do
    		#fsl_sub -q verylong.q fslmerge -t $resultdir/${ci}_${cr}_${SUB}_all $datadir/${ci}_${cr}_${SUB}*.nii.gz
    		fsl_sub -q verylong.q fslmaths $resultdir/${ci}_${cr}_${SUB}_all -Tmean $result2dir/${ci}_${cr}_${SUB}_mean
		done
	done
done
done
