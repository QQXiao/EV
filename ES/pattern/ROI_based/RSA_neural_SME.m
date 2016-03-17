function RSA_neural(subs)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based_RSM/ref_space/raw',basedir);
rdir=sprintf('%s/ROI_based_RSM/ref_space/SME/sub/',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/EV/ES/behav
%%%%%%%%%
TN=90;
roi_name={'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...          
'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...         
'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG',...
'LITG','RITG','LpFUS','RpFUS'};

for s=subs
	%get index
	[idx_wi_rem,idx_wi_forg,idx_bi_rem,idx_bi_forg]=get_idx_SME(subs);
        %perpare data
%%get fMRI data
    for roi=1:length(roi_name);
	tmp_xx=[];xx=[];
    	tmp_xx=load(sprintf('%s/%s_sub%02d.txt',datadir,roi_name{roi},s));
    	txx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
	xx=txx;
    cc=1-pdist(xx(:,:),'correlation');
    wi(roi,1)=mean(cc(idx_wi_rem));
    wi(roi,2)=mean(cc(idx_wi_forg));
    bi(roi,1)=mean(cc(idx_bi_rem));
    bi(roi,2)=mean(cc(idx_bi_forg));
  end
	wi_z=0.5*(log(1+wi)-log(1-wi));
	bi_z=0.5*(log(1+bi)-log(1-bi));
end
    eval(sprintf('save %s/wi_sub%02d wi', rdir,s))
    eval(sprintf('save %s/bi_sub%02d bi', rdir,s))
end %end func
