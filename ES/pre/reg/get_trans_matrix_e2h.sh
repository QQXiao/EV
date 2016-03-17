basedir='/seastor/helenhelen/ES'
resultdir=$basedir/data_singletrial/transform/e2h
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
SUBDIR=${basedir}/${sub}
highres_file=${SUBDIR}/data/3d_brain.nii.gz
ref_file=${SUBDIR}/data/ref.nii.gz
# n2h
e2h_affine=$resultdir/${SUB}
fsl_sub -q verylong.q ANTS 3 -m MI[$highres_file,$ref_file,1,32] -o ${e2h_affine}_ --rigid-affine true -i 0
done
