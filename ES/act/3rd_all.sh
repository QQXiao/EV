#!/bin/sh
basedir=/seastor/helenhelen/ES

#   sed -e "s/rp_ev2/ev/g" design.fsf > ev.fsf
#   sed -e "s/submem/cate/g" ../submem.fsf > cate.fsf
substart=$1
subend=$2

for ((m = $substart; m <= $subend; m++))
do
#sed -e "s/cope1/cope${m}/" $basedir/script/design/ev_3rd.fsf > $basedir/script/fsf/ev_3rd_cope${m}.fsf
#feat $basedir/script/fsf/ev_3rd_cope${m}.fsf
#sed -e "s/cope1/cope${m}/" $basedir/script/design/sme_3rd.fsf > $basedir/script/fsf/sme_3rd_cope${m}.fsf
fsl_sub -q verylong.q feat $basedir/script/fsf/sme_3rd_cope${m}.fsf
done


