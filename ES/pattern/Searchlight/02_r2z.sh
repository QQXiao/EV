basedir='/seastor/helenhelen/ES'
#for c in SME_EV_L
for c in SME
#for c in SME_spacing SME_EV_L SME_EV_S
do
resultdir=$basedir/Searchlight_RSM/native_space/sep/z/${c}
datadir=$basedir/Searchlight_RSM/native_space/sep/${c}
mkdir $resultdir -p
cd $datadir
for x in *.nii.gz
do
dataname=`echo $x|sed -e "s/.nii.gz//g"`
fslmaths $x -uthr 1 $x

#y=`echo ${x: 0:15}`
#echo $y

fslmaths $x -add 1 -log tmp
fslmaths $x -sub 1 -mul -1 -log tmp1
#fslmaths tmp -sub tmp1 -div 2 z_$dataname
fslmaths tmp -sub tmp1 -div 2 ${resultdir}/${dataname}
done
done
