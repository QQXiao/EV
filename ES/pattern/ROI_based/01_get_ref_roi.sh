#!sh/bin/
basedir=/seastor/helenhelen/ES
roidir=/seastor/helenhelen/roi/ISR/single
affinedir=$basedir/data_singletrial/transform/t2e
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
resultdir=$basedir/${sub}/roi_ref
mkdir $resultdir -p

ref_file=$basedir/${sub}/data/ref.nii.gz
cd $roidir
for roi in *.nii.gz
do
roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
fsl_sub -q verylong.q WarpImageMultiTransform 3 ${roi} $resultdir/${roi_prefix}.nii.gz -R $ref_file $affinedir/${SUB}_Affine.txt
done
done
