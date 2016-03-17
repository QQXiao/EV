#!sh/bin/
    	#fsl_sub -q verylong.q  matlab -nodesktop -nosplash -r "RSA_neural_item($sub);quit;"
#for sub in 2
for sub in 4 5 6 7 8 9 10 11 12 13 14 17 18 20 21 22 23 24 25 26 27 28 29 30
do
    	fsl_sub -q verylong.q  matlab -nodesktop -nosplash -r "RSA_neural_SME($sub);quit;"
    	#fsl_sub -q verylong.q  matlab -nodesktop -nosplash -r "RSA_neural_SME_L($sub);quit;"
    	#fsl_sub -q verylong.q  matlab -nodesktop -nosplash -r "RSA_neural_SME_S($sub);quit;"
    	#fsl_sub -q verylong.q  matlab -nodesktop -nosplash -r "RSA_neural_SME_spacing($sub);quit;"
done
