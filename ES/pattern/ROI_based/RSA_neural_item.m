function RSA_neural()
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based_RSM/ref_space/raw',basedir);
rdir=sprintf('%s/ROI_based_RSM/ref_space/me/data',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/EV/ES/behav

%data structure
Mtrial=1; % trial number
MID=2;
PID=3;  % material id
Mcons=4; %1:CONSISTENT, 2 INCONSISTENT;3: filler/once
Mfile=5; %picture is from which file
Mlag=6; %mass(Mlag=1,2);Space(Mlag=29,30); once(lag=520) ??
Msem=7; % 1=smaller,2=bigger
Mres=8; % left or right key. 1 small 2 bigger
Mscore=9; % 1: correct; 0 wrong;
MRT=10; % reaction time;
Monset=11; % designed onset time
MAonset=12; % actually onset time
Mrun=13; %run 1-4
MWM=14; % word memory
MPM=15; % p memory
Mcond=16; % learning condition; 1: MC; 2: MI; 3:SC; 4:SI; 5:Once;
%add information
Mclag=17; %distance condition;1:massed;2:spaced;3once
Mrep=18; %repetition: 1 2 0
Mmem=19;
Mposit=20;
%%%%%%%%%
roi_name={'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...          
'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...         
'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG',...
'LITG','RITG','LpFUS','RpFUS'};
subs=setdiff(1:31,[1 3 15 16 19 31]);
for roi=1:length(roi_name);
all=[];	
	for s=subs
	tmp_xx=[];xx=[];
    	tmp_xx=load(sprintf('%s/%s_sub%02d.txt',datadir,roi_name{roi},s));
    	txx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
        cc=1-pdist(txx(:,:),'correlation');
	zcc=0.5*(log(1+cc)-log(1-cc));

	%get lable list
	[all_lable,u_lable]=get_idx_item(s);
	data_list=[s*ones(size(u_lable,1),1) u_lable(:,[2 4 17 16 19 14]);]
	%1=subid;2=wid;3=cons/incons;%4=mass/space/once/;
	%5=MC/MI/SC/SI/ONCE;%6=mem/forg;7=word memory(1-5);
	%8=act1;9=act2;10=act_mean;11=ps;
	list_word=unique(all_lable(all_lable(:,Mclag)~=3,MID));
		TN=length(all_lable);
		all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
		all_mem1=[]; all_mem2=[];
		all_wID1=[]; all_wID2=[];
		all_rep1=[]; all_rep2=[];
		all_run1=[]; all_run2=[];
		for k=2:TN
		all_wID1=[all_wID1 all_lable(k-1,MID)*ones(1,TN-k+1)];
		all_wID2=[all_wID2 all_lable(k:TN,MID)'];
		all_rep1=[all_rep1 all_lable(k-1,Mrep)*ones(1,TN-k+1)];
		all_rep2=[all_rep2 all_lable(k:TN,Mrep)'];
		all_mem1=[all_mem1 all_lable(k-1,Mmem)*ones(1,TN-k+1)];
		all_mem2=[all_mem2 all_lable(k:TN,Mmem)'];
		all_run1=[all_run1 all_lable(k-1,Mrun)*ones(1,TN-k+1)];
		all_run2=[all_run2 all_lable(k:TN,Mrun)'];

		%check_dis=all_posit2-all_posit1; %interval:1,2,29,30; dis=2,3,30,31       
		check_rep=all_rep1==all_rep2; %1=same rep; 0=diff rep                      
		check_run=all_run1==all_run2; %1=same rep; 0=diff rep                                            
		end 		
		%% get indexes 
		for t=1:160
		wt=list_word(t);
		idx_wi=find(all_wID1==wt & all_wID1==all_wID2);
		p=all_lable(all_lable(:,MID)==wt,Mposit);
		tact1=mean(txx(p(1),:),2);
		tact2=mean(txx(p(2),:),2);
		tactmean=mean(mean(txx(p,:),2));
		ps=zcc(idx_wi);
		data_list(data_list(:,2)==wt,8)=tact1;	
		data_list(data_list(:,2)==wt,9)=tact2;	
		data_list(data_list(:,2)==wt,10)=tactmean;	
		data_list(data_list(:,2)==wt,11)=ps;	
		end
	all=[all;data_list]
	end %sub
    eval(sprintf('save %s/%s all', rdir,roi_name{roi}))
end %roi
end %end func
