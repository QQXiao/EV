function RSA_neural(subs,rr)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
rdir=sprintf('%s/Searchlight_RSM/native_space/sep/EV',basedir);
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
for s=subs
	for r=rr
	gps1=zeros(xlength,ylength,zlength,5);%1: MC; 2: MI; 3:SC; 4:SI; 5:once
	gps2=zeros(xlength,ylength,zlength,5);%1: MC; 2: MI; 3:SC; 4:SI; 5:once
	wi=zeros(xlength,ylength,zlength,4);%1: MC; 2: MI; 3:SC; 4:SI;
	bi=zeros(xlength,ylength,zlength,4);%1: MC; 2: MI; 3:SC; 4:SI;
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
%%size of pairs
    ngps1(1)=length(idx_gps1_mc);
    ngps1(2)=length(idx_gps1_mi);
    ngps1(3)=length(idx_gps1_sc);
    ngps1(4)=length(idx_gps1_si);
    ngps1(5)=length(idx_gps1_once);
    ngps2(1)=length(idx_gps2_mc);
    ngps2(2)=length(idx_gps2_mi);
    ngps2(3)=length(idx_gps2_sc);
    ngps2(4)=length(idx_gps2_si);
    ngps2(5)=length(idx_gps2_once);
    nwi(1)=length(idx_wi_mc);
    nwi(2)=length(idx_wi_mi);
    nwi(3)=length(idx_wi_sc);
    nwi(4)=length(idx_wi_si);
    nbi(1)=length(idx_bi_mc);
    nbi(2)=length(idx_bi_mi);
    nbi(3)=length(idx_bi_sc);
    nbi(4)=length(idx_bi_si);

%%get fMRI data
data_file=sprintf('%s/sub%03d/analysis/singletrial_run%d/stats/pe1ls_one_at_time.nii.gz',basedir,s,r);
data_all=load_nii_zip(data_file);
dataa=data_all.img;
data=dataa;
%%analysis
        for k=radius+1:step:xlength-radius
            for j=radius+1:step:ylength-radius
                for i=radius+1:step:zlength-radius
                    data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic
                    a=size(data_ball);
                    b=a(1)*a(2)*a(3);
                    v_data = reshape(data_ball,b,TN);
                    %bb=reshape(v_data,b*TN,1);
                    if sum(std(v_data(:,:))==0)>epsilon
                    gps1(k,j,i,:)=10;
                    gps2(k,j,i,:)=10;
                    wi(k,j,i,:)=10;
                    bi(k,j,i,:)=10;
                    else
                    xx=v_data';
                    cc=1-pdist(xx(:,:),'correlation');
                    gps1(k,j,i,1)=mean(cc(idx_gps1_mc));
                    gps1(k,j,i,2)=mean(cc(idx_gps1_mi));
                    gps1(k,j,i,3)=mean(cc(idx_gps1_sc));
                    gps1(k,j,i,4)=mean(cc(idx_gps1_si));
                    gps1(k,j,i,5)=mean(cc(idx_gps1_once));
                    gps2(k,j,i,1)=mean(cc(idx_gps2_mc));
                    gps2(k,j,i,2)=mean(cc(idx_gps2_mi));
                    gps2(k,j,i,3)=mean(cc(idx_gps2_sc));
                    gps2(k,j,i,4)=mean(cc(idx_gps2_si));
                    gps2(k,j,i,5)=mean(cc(idx_gps2_once));
                    wi(k,j,i,1)=mean(cc(idx_wi_mc));
                    wi(k,j,i,2)=mean(cc(idx_wi_mi));
                    wi(k,j,i,3)=mean(cc(idx_wi_sc));
                    wi(k,j,i,4)=mean(cc(idx_wi_si));
                    bi(k,j,i,1)=mean(cc(idx_bi_mc));
                    bi(k,j,i,2)=mean(cc(idx_bi_mi));
                    bi(k,j,i,3)=mean(cc(idx_bi_sc));
                    bi(k,j,i,4)=mean(cc(idx_bi_si));
                    end %end if
                end %end i
            end %end j
        end %end k

cd (rdir)
         filename=sprintf('gps1_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(gps1(:,:,:,:));
         data_all.hdr.dime.dim(5)=5; % dimension chagne to 5
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));

         filename=sprintf('gps2_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(gps2(:,:,:,:));
         data_all.hdr.dime.dim(5)=5; % dimension chagne to 5
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));

         filename=sprintf('wi_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(wi(:,:,:,:));
         data_all.hdr.dime.dim(5)=4; % dimension chagne to 4
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));

         filename=sprintf('bi_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(bi(:,:,:,:));
         data_all.hdr.dime.dim(5)=4; % dimension chagne to 4
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));

    eval(sprintf('save %s/ngps1_sub%02d_run%d ngps1', rdir,s,r))
    eval(sprintf('save %s/ngps2_sub%02d_run%d ngps2', rdir,s,r))
    eval(sprintf('save %s/nwi_sub%02d_run%d nwi', rdir,s,r))
    eval(sprintf('save %s/nbi_sub%02d_run%d nbi', rdir,s,r))
end %end run
end %end sub
end %end func
