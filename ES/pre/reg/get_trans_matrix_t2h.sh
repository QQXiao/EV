basedir='/seastor/helenhelen/ES'
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
resultdir=$basedir/data_singletrial/transform/t2h
#for m in 2
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
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
fsl_sub -q verylong.q bash ${ANTSPATH}/antsRegistrationSyN.sh -d 3 -f $highres_file -m $templatefile -o $resultdir/${SUB}_
done
