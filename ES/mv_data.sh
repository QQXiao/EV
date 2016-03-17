#!sh/bin
basedir=/seastor/helenhelen/ES
for m in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
do
        if [ ${m} -lt 10 ];
            then
            sub=sub00${m}
            else
            sub=sub0${m}
         fi
subdir=${basedir}/${sub}
#cd ${subdir}/behav
#rm -r *
#cd ${subdir}/roi_ref -r
#done
#cd ${subdir}/analysis
#rm *.gfeat -r
#rm recall Recall recog switch var -r
#rm *err* *all* *forgot* *filler* *Recog*
#cd ${subdir}
#mkdir analysis -p
	for r in 1 2 3 4
	do
	rm ${subdir}/analysis/sme_run${r}.feat/reg/R*
	rm ${subdir}/analysis/sme_run${r}.feat/reg/L*
	rm ${subdir}/analysis/sme_run${r}.feat/reg/invwarp.*
	done
done

