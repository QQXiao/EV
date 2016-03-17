ANTSPATH=/opt/fmritools/ANTs/antsbin/bin/
basedir='/seastor/helenhelen/ES'
resultdir=$basedir/data_singletrial/transform
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

t2e_affine=$resultdir/t2e/${SUB}_Affine.txt
t2h_affine=$resultdir/t2h/${SUB}_0GenericAffine.mat
h2e_affine=$resultdir/h2e/${SUB}_Affine.txt
fsl_sub -q verylong.q ComposeMultiTransform 3 $resultdir/t2e/${SUB}_Affine.txt -R ${h2e_affine} ${h2e_affine} ${t2h_affine}
done
