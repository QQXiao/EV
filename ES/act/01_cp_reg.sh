#!/bin/sh
basedir='/seastor/helenhelen/ES'
#for m in 2
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
#for m in 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
    if [ ${m} -lt 10 ];
    then
       SUB=sub00${m}
       sub=sub0${m}
    else
        SUB=sub0${m}
        sub=sub${m}
    fi
    echo $SUB
for run in 1 2 3 4
do
refdir=$basedir/${SUB}/analysis/singletrial_run${run}/reg
resultdir=$basedir/${SUB}/analysis/sme_run${run}.feat
#cp ${refdir} ${resultdir}/ -r
featregapply $resultdir
done
done

