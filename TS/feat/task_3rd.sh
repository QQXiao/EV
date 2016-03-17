#!/bin/sh
basedir=/seastor/helenhelen/TS
scriptdir=/home/helenhelen/DQ/project/TS/feat/design
outputdir=/home/helenhelen/DQ/project/TS/feat/fsf

substart=$1
subend=$2

for ((m = $substart; m <= $subend; m++))
do
#sed -e "s/cope1/cope${m}/g" $scriptdir/task_3rd.fsf > $outputdir/task_cope${m}_3rd.fsf
feat $outputdir/task_cope${m}_3rd.fsf
done
