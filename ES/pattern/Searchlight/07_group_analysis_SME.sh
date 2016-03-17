#!/sh/bin
basedir=/seastor/helenhelen/ES
refdir=$basedir/group/set_model/nsub_25
#for c in SME_EV_L SME_EV_S SME_spacing
for c in SME
do
resultdir=$basedir/Searchlight_RSM/standard_space/group/${c}
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/Searchlight_RSM/standard_space/sub/${c}
for cc in wi bi
do
ddir=$resultdir/$cc
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${cc}_sme_sub*.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 mask 2 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2 0.05 bg_image zstat2
done #end cc
done #c
