#!/bin/sh
basedir='/seastor/helenhelen/ES'
for c in SME
#for c in SME_EV_L SME_EV_S SME_spacing
do
datadir=$basedir/Searchlight_RSM/native_space/sep/diff/${c}
resultdir=$basedir/Searchlight_RSM/standard_space/sep/sub/${c}
mkdir $resultdir -p
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 20 21 22 23 24 25 26 27 28 29 30
do
    if [ ${m} -lt 10 ];
    then
       SUB=sub00${m}
       sub=sub0${m}
    else
        SUB=sub0${m}
	sub=sub${m}
    fi
    echo $SUB

for run in 1 2 3 4
do
refdir=$basedir/${SUB}/analysis/singletrial_run${run}/reg
        for ci in wi bi
        do
		for cm in rem forg
		do
        	fsl_sub -q verylong.q /opt/fmritools/fsl/bin/applywarp --ref=$refdir/standard --in=$datadir/${ci}_${cm}_${sub}_run${run}.nii.gz --out=$resultdir/${ci}_${cm}_${sub}_run${run} --warp=$refdir/highres2standard_warp --premat=$refdir/example_func2highres.mat --interp=trilinear
        	done
	done
done
done
done
