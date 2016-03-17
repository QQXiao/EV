function allroi()
basedir='/seastor/helenhelen/ES';
datadir=sprintf('%s/ROI_based_RSM/ref_space/SME',basedir);
resultdir=sprintf('%s/ROI_based_RSM/ref_space/SME',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'LVVC','LIFG','LHIP','LPHG','RVVC','RIFG','RHIP','RPHG'};
subs=setdiff([1:31],[1 3 15 16 19 31]);
s=subs';
all_data=[];
for roi=1:length(roi_name)
        tz=[];
        tz=load(sprintf('%s/%s_wi.txt',datadir,roi_name{roi}));
        taz=[s roi*ones(size(s,1),1) tz];
	
	all_data=[all_data;taz];
end
        file_name=sprintf('%s/allroi.txt',resultdir);
        eval(sprintf('save %s all_data -ascii',file_name));
end%end function
