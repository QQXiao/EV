#!sh/bin/
#for c in 1 2 3
for c in 4
do
fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "allsubs_item(${c});quit;"
done

