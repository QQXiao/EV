basedir='/seastor/helenhelen/ES'
resultdir=$basedir/data_singletrial/transform/n2e
mkdir -p ${resultdir}
#for m in 2
#for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
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
SUBDIR=${basedir}/${sub}
refdir=${SUBDIR}/data
refdatadir=${SUBDIR}/data
dimx=`fslval ${refdatadir}/ev_run3.nii.gz dim1`
dimy=`fslval ${refdatadir}/ev_run3.nii.gz dim2`
dimz=`fslval ${refdatadir}/ev_run3.nii.gz dim3`
fslroi ${refdatadir}/ev_run3.nii.gz ${refdir}/ref.nii.gz 0 $dimx 0 $dimy 0 $dimz 0 1
refvol=`ls ${refdir}/ref.nii.gz`
for r in 1 2 3 4
do
funcfile=${refdatadir}/ev_run${r}.nii.gz
funcfile1=${refdir}/ev_run${r}.vol1.nii.gz
    dimx=`fslval $funcfile dim1`
    dimy=`fslval $funcfile dim2`
    dimz=`fslval $funcfile dim3`
    fslroi $funcfile $funcfile1 0 $dimx 0 $dimy 0 $dimz 0 1

n2e_affine=$resultdir/${SUB}_run${r}
fsl_sub -q verylong.q ANTS 3 -m MI[$refvol,$funcfile1,1,32] -o ${n2e_affine}_ --rigid-affine true -i 0
done
done
