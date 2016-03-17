basedir=/seastor/helenhelen/ES
resultdir=$basedir/data_singletrial/LSS/ref_space/sep
mkdir $resultdir -p
affinedir=$basedir/data_singletrial/transform/n2e
for m in 2
#for m in 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
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
ref_file=$basedir/${sub}/data/ref.nii.gz

for r in 1 2 3 4
do
datafile=$basedir/${sub}/analysis/singletrial_run${r}/stats/pe1ls_one_at_time.nii.gz
fsl_sub -q short.q WarpTimeSeriesImageMultiTransform 4 $datafile $resultdir/${SUB}_run${r}.nii.gz -R $ref_file $affinedir/${SUB}_run${r}_Affine.txt
done
done

