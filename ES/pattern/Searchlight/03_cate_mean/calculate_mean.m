function calculate_mean(subs)
addpath /seastor/helenhelen/scripts/NIFTI
basedir='/seastor/helenhelen/ES';
condname={'SME_EV_L','SME_EV_S','SME_spacing','SME'};
itemname={'wi','bi'};
remname={'rem','forg'};
for c=4 %1:3 
datadir=sprintf('%s/Searchlight_RSM/native_space/sep/z/%s',basedir,condname{c});
resultdir=sprintf('%s/Searchlight_RSM/native_space/sep/diff/%s',basedir,condname{c});

list=[];
for s=subs
	for r=1:4
		for ci=1:2
			for cr=1:2
			diff = load_nii_zip(sprintf('%s/%s_sub%02d_run%d.nii.gz',datadir,itemname{ci},s,r)); % read all volume
			diff1 = load_nii_zip(sprintf('%s/%s_sub%02d_run%d.nii.gz',datadir,itemname{ci},s,r),1); % read all volume
			a=diff.img(:,:,:,cr);
        		diff1.img=a;
        		filename=sprintf('%s/%s_%s_sub%02d_run%d.nii',resultdir,itemname{ci},remname{cr},s,r);
        		save_untouch_nii(diff1, filename);
        		system(sprintf('gzip -f %s',filename));
			end %cr
		end %ci
	end %run
end %end sub
end
end %end func
