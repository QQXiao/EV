#!sh/bin/
basedir=/seastor/helenhelen/ES
resultdir=$basedir/data_singletrial/LSS/ref_space
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
#merege file
fsl_sub -q verylong.q fslmerge -t $resultdir/merged/${SUB} $resultdir/sep/${SUB}_run*.nii.gz
done #sub
