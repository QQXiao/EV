#!/sh/bin
basedir=/seastor/helenhelen/ES
refdir=$basedir/group/set_model
resultdir=$basedir/Searchlight_RSM/group
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/Searchlight_RSM/cateMean/subs
for c in gps1 gps2 wi bi
do
for cc in mimc sisc misi mcsc sm ic
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_${cc}_sub*.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 mask 2.3 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2.3 0.05 bg_image zstat2
done #end cc
done #end c
for c in gps1 gps2
do
for cc in mco mio sco sio
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_${cc}_sub*.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 mask 2.3 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2.3 0.05 bg_image zstat2
done #end cc
done #end c
