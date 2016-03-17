basedir=/seastor/helenhelen/ES
datadir=$basedir/Searchlight_RSM/standard_space/sep/mean
resultdir=$basedir/Searchlight_RSM/cateMean/subs
mkdir -p $resultdir

cd $datadir
#for m in 2
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
    if [ ${m} -lt 10 ];
    then
       s=0${m}
    else
        s=${m}
    fi

        for c in gps1 gps2 wi bi
        do
	fslmaths ${c}_mi_sub${s}_mean -sub ${c}_mc_sub${s}_mean $resultdir/${c}_mimc_sub${s} 
	fslmaths ${c}_si_sub${s}_mean -sub ${c}_sc_sub${s}_mean $resultdir/${c}_sisc_sub${s} 
	fslmaths ${c}_mi_sub${s}_mean -sub ${c}_si_sub${s}_mean $resultdir/${c}_misi_sub${s} 
	fslmaths ${c}_mc_sub${s}_mean -sub ${c}_sc_sub${s}_mean $resultdir/${c}_mcsc_sub${s} 
	fslmaths ${c}_mi_sub${s}_mean -add ${c}_si_sub${s}_mean -sub ${c}_mc_sub${s}_mean -sub ${c}_sc_sub${s}_mean $resultdir/${c}_ic_sub${s} 
	fslmaths ${c}_si_sub${s}_mean -add ${c}_sc_sub${s}_mean -sub ${c}_mc_sub${s}_mean -sub ${c}_mi_sub${s}_mean $resultdir/${c}_sm_sub${s} 
	done
	for c in gps1 gps2
	do
	fslmaths ${c}_mi_sub${s}_mean -sub ${c}_once_sub${s}_mean $resultdir/${c}_mio_sub${s} 
	fslmaths ${c}_si_sub${s}_mean -sub ${c}_once_sub${s}_mean $resultdir/${c}_sio_sub${s} 
	fslmaths ${c}_mc_sub${s}_mean -sub ${c}_once_sub${s}_mean $resultdir/${c}_mco_sub${s} 
	fslmaths ${c}_sc_sub${s}_mean -sub ${c}_once_sub${s}_mean $resultdir/${c}_sco_sub${s} 
	done
done
