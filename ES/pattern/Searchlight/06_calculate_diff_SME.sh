basedir=/seastor/helenhelen/ES
#for c in SME_EV_L SME_EV_S SME_spacing
for c in SME
do
datadir=$basedir/Searchlight_RSM/standard_space/sep/mean/${c}
resultdir=$basedir/Searchlight_RSM/standard_space/sub/${c}
mkdir -p $resultdir

cd $datadir
#for m in 2
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 20 21 22 23 24 25 26 27 28 29 30 31
do
    if [ ${m} -lt 10 ];
    then
       s=0${m}
    else
        s=${m}
    fi

fsl_sub -q verylong.q fslmaths wi_rem_sub${s}_mean -sub wi_forg_sub${s}_mean $resultdir/wi_sme_sub${s} 
fsl_sub -q verylong.q fslmaths bi_rem_sub${s}_mean -sub bi_forg_sub${s}_mean $resultdir/bi_sme_sub${s} 
done
done
