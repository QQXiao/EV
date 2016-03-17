function allroi()
basedir='/seastor/helenhelen/ES';
datadir=sprintf('%s/group/sme_ori/ROIs',basedir);
resultdir=sprintf('%s/group/sme_ori/ROIs',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'LVVC','LIFG','LHIP','LPHG','RVVC','RIFG','RHIP','RPHG'};
subs=setdiff([1:31],[1 3 15 16 19 31]);
s=subs';
all_data=[];
acc=[8 9 12 13];
for roi=1:length(roi_name)
alltz=[];
	for c=1:4
        tz=[];
	cc=acc(c);
        tz=load(sprintf('%s/cope%d_%s.txt',datadir,cc,roi_name{roi}));
	alltz=[alltz tz];
	end
	si=size(alltz);
        taz=[s roi*ones(size(s,1),1) alltz([1:14 16:26],:)];
	
	all_data=[all_data;taz];
end
        file_name=sprintf('%s/allroi.txt',resultdir);
        eval(sprintf('save %s all_data -ascii',file_name));
end%end function
