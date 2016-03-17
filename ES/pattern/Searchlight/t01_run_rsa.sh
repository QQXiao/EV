#!sh/bin/
#for sub in 2 
#for sub in 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
for sub in 2 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
    for rr in 1 2 3 4
	do
    	#fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "RSA_neural_SME_spacing($sub,$rr);quit;"
    	fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "RSA_neural_SME_EV_L($sub,$rr);quit;"
    	#fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_SME_EV_S($sub,$rr);quit;"
	done
done
