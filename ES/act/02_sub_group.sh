#!/bin/sh
outputdir=/seastor/helenhelen/ES

#substart=$1
#subend=$2
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
    if [ ${m} -lt 10 ];
    then
       SUB=00${m}
    else
        SUB=0${m}
    fi
    echo $SUB

#sed -e "s/sub002/sub${SUB}/g" $outputdir/script/design/sme_sub_group.fsf > $outputdir/script/fsf/sme_sub${SUB}_group.fsf
fsl_sub -q verylong.q feat $outputdir/script/fsf/sme_sub${SUB}_group.fsf
#sed -e "s/sub002/sub${SUB}/g" $outputdir/script/design/ev_sub_group.fsf > $outputdir/script/fsf/ev_sub${SUB}_group.fsf
#feat $outputdir/script/fsf/ev_sub${SUB}_group.fsf
done

