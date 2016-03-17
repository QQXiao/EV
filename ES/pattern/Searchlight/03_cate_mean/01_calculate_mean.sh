#substar=$1
#subend=$2

#for ((sub = $substar; sub <= $subend; sub++))
#for sub in 4
for sub in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 20 21 22 23 24 25 26 27 28 29 30
do
  fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "calculate_mean($sub);quit;"
done
