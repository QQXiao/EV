function RSA_neural(subs,rr)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based_RSM/native_space/raw',basedir);
rdir=sprintf('%s/ROI_based_RSM/native_space/sub',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
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
%%%%%%%%%
xlength =  64;
ylength =  64;
zlength =  41;
radius  =  2;     % the cubic size is (2*radius+1) by (2*radius+1) by (2*radius+1)
step    =  1;     % compute accuracy map for every STEP voxels in each dimension
epsilon =  1e-6;
%%%%%%%%%
TN=90;
roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
            'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
            'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
            'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
            'LFFA','RFFA',...
            'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total

for s=subs
	for r=rr
        %perpare data
        load(sprintf('%s/sub%02d_run%d_singletriallist.mat',labeldir,s,r));
	trial_list_all(trial_list_all(:,Mlag)<=2,Mclag)=1; %massed
	trial_list_all(trial_list_all(:,Mlag)==520,Mclag)=3; %once
	trial_list_all(trial_list_all(:,Mlag)==29 | trial_list_all(:,Mlag)==30,Mclag)=2; %spaced
        tmp=sortrows(trial_list_all,[Mclag,MAonset]);
        twice_rep=tmp(tmp(:,Mclag)~=3,:);
        once_rep=tmp(tmp(:,Mclag)==3,:);
	twice_rep(1:2:end,Mrep)=1;
	twice_rep(2:2:end,Mrep)=2;
	once_rep(:,Mrep)=0;
	list_all=[once_rep;twice_rep];
	
	all_lable=sortrows(list_all,MAonset);

        all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
        all_clag1=[]; all_clag2=[]; all_lag1=[]; all_lag2=[]; all_cons1=[]; all_cons2=[];  all_posit1=[]; all_posit2=[]; all_dis=[]; all_wID1=[]; all_wID2=[]; all_rep1=[]; all_rep2=[]; 
        for k=2:TN
        all_wID1=[all_wID1 all_lable(k-1,MID)*ones(1,TN-k+1)];
        all_wID2=[all_wID2 all_lable(k:TN,MID)'];
        all_lag1=[all_lag1 all_lable(k-1,Mlag)*ones(1,TN-k+1)];
        all_lag2=[all_lag2 all_lable(k:TN,Mlag)'];
        all_clag1=[all_clag1 all_lable(k-1,Mclag)*ones(1,TN-k+1)];
        all_clag2=[all_clag2 all_lable(k:TN,Mclag)'];
        all_cons1=[all_cons1 all_lable(k-1,Mcons)*ones(1,TN-k+1)];
        all_cons2=[all_cons2 all_lable(k:TN,Mcons)'];
        all_posit1=[all_posit1 all_lable(k-1,Mtrial)*ones(1,TN-k+1)];
        all_posit2=[all_posit2 all_lable(k:TN,Mtrial)'];
        all_rep1=[all_rep1 all_lable(k-1,Mrep)*ones(1,TN-k+1)];
        all_rep2=[all_rep2 all_lable(k:TN,Mrep)'];

        check_dis=all_posit2-all_posit1; %interval:1,2,29,30; dis=2,3,30,31
        check_rep=all_rep1==all_rep2; %1=same rep; 0=diff rep
        end

%% get indexes
% self similarity
    idx_wi_mc=find(all_wID1==all_wID2 & all_clag1==1 & all_cons1==1);
    idx_bi_mc=find(all_wID1~=all_wID2 & all_clag1==1 & all_cons1==1 & check_dis<=3 & check_dis>=2 & check_rep==0);
    idx_wi_mi=find(all_wID1==all_wID2 & all_clag1==1 & all_cons1==2);
    idx_bi_mi=find(all_wID1~=all_wID2 & all_clag1==1 & all_cons1==2 & check_dis<=3 & check_dis>=2 & check_rep==0);
    idx_wi_sc=find(all_wID1==all_wID2 & all_clag1==2 & all_cons1==1);
    idx_bi_sc=find(all_wID1~=all_wID2 & all_clag1==2 & all_cons1==1 & check_dis<=31 & check_dis>=30 & check_rep==0);
    idx_wi_si=find(all_wID1==all_wID2 & all_clag1==2 & all_cons1==2);
    idx_bi_si=find(all_wID1~=all_wID2 & all_clag1==2 & all_cons1==2 & check_dis<=31 & check_dis>=30 & check_rep==0);
% gps   
    idx_gps1_mc=find(all_rep1==1 & all_clag1==1 & all_cons1==1);
    idx_gps1_mi=find(all_rep1==1 & all_clag1==1 & all_cons1==2);
    idx_gps1_sc=find(all_rep1==1 & all_clag1==2 & all_cons1==1);
    idx_gps1_si=find(all_rep1==1 & all_clag1==2 & all_cons1==2);
    idx_gps1_once=find(all_rep1==0);

    idx_gps2_mc=find(all_rep1==2 & all_clag1==1 & all_cons1==1);
    idx_gps2_mi=find(all_rep1==2 & all_clag1==1 & all_cons1==2);
    idx_gps2_sc=find(all_rep1==2 & all_clag1==2 & all_cons1==1);
    idx_gps2_si=find(all_rep1==2 & all_clag1==2 & all_cons1==2);
    idx_gps2_once=find(all_rep1==0);

%%get fMRI data
    for roi=1:length(roi_name);
	tmp_xx=[];xx=[];
    	tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
    	xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
                    cc=1-pdist(xx(:,:),'correlation');
                    gps1(roi,1)=mean(cc(idx_gps1_mc));
                    gps1(roi,2)=mean(cc(idx_gps1_mi));
                    gps1(roi,3)=mean(cc(idx_gps1_sc));
                    gps1(roi,4)=mean(cc(idx_gps1_si));
                    gps1(roi,5)=mean(cc(idx_gps1_once));
                    gps2(roi,1)=mean(cc(idx_gps2_mc));
                    gps2(roi,2)=mean(cc(idx_gps2_mi));
                    gps2(roi,3)=mean(cc(idx_gps2_sc));
                    gps2(roi,4)=mean(cc(idx_gps2_si));
                    gps2(roi,5)=mean(cc(idx_gps2_once));
                    wi(roi,1)=mean(cc(idx_wi_mc));
                    wi(roi,2)=mean(cc(idx_wi_mi));
                    wi(roi,3)=mean(cc(idx_wi_sc));
                    wi(roi,4)=mean(cc(idx_wi_si));
                    bi(roi,1)=mean(cc(idx_bi_mc));
                    bi(roi,2)=mean(cc(idx_bi_mi));
                    bi(roi,3)=mean(cc(idx_bi_sc));
                    bi(roi,4)=mean(cc(idx_bi_si));
		end
	gps1_z=0.5*(log(1+gps1)-log(1-gps1));
	gps2_z=0.5*(log(1+gps2)-log(1-gps2));
	wi_z=0.5*(log(1+wi)-log(1-wi));
	bi_z=0.5*(log(1+bi)-log(1-bi));
end
end
    eval(sprintf('save %s/gps1_sub%02d_run%d gps1', rdir,s,r))
    eval(sprintf('save %s/gps2_sub%02d_run%d gps2', rdir,s,r))
    eval(sprintf('save %s/wi_sub%02d_run%d wi', rdir,s,r))
    eval(sprintf('save %s/bi_sub%02d_run%d bi', rdir,s,r))
end %end func
