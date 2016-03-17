#!/bin/sh
basedir=/seastor/helenhelen/TS
#for m in 22 23 25
for m in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 25
do
    if [ ${m} -lt 10 ];
    then
       SUB=sub0${m}
    else
        SUB=sub${m}
    fi
    echo $SUB
scriptdir=/home/helenhelen/DQ/project/TS/feat/design
outputdir=/home/helenhelen/DQ/project/TS/feat/fsf
mkdir $outputdir
for r in 1 2 3
	do
    sed -e "s/sub01/${SUB}/g" -e "s/run1/run${r}/g" $scriptdir/sme.fsf > $outputdir/sme_${SUB}_run${r}.fsf
	#fsl_sub -q verylong.q feat $outputdir/sme_${SUB}_run${r}.fsf
	done
done
