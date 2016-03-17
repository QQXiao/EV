function allroi_items(c)
condname={'SME_EV_L','SME_EV_S','SME_spacing','SME'};
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based_RSM/ref_space/%s/sub/',basedir,condname{c});
resultdir=sprintf('%s/ROI_based_RSM/ref_space/%s',basedir,condname{c});
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...          
'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...         
'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG',...
'LITG','RITG','LpFUS','RpFUS'};
subs=setdiff([2:31],[3 15 16 19 31]);
s=subs';
ccname={'wi','bi'};
for roi=1:length(roi_name)
	for cc=1:2
	all_ps=[];
	for sub=subs
	load(sprintf('%s/%s_sub%02d',datadir,ccname{cc},sub));
	eval(sprintf('tmp=%s;',ccname{cc}));
	tps=tmp(roi,:);
	ps=[sub tps];
	all_ps=[all_ps;ps];
	end %end sub
	file_name=sprintf('%s/%s_%s.txt', resultdir,roi_name{roi},ccname{cc});
	eval(sprintf('save %s all_ps -ascii',file_name));
	end %end cc
end %end roi
end%end function
