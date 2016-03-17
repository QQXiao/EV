function RSA_neural(subs,rr)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
rdir=sprintf('%s/Searchlight_RSM/native_space/sep/SME',basedir);
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
Mmem=19;
Mposit=20;
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
	wi=zeros(xlength,ylength,zlength,2);%1:rem; 2:forgot
	bi=zeros(xlength,ylength,zlength,2);%1:rem; 2:forgot
        %perpare data
        load(sprintf('%s/sub%02d_run%d_singletriallist.mat',labeldir,s,r));
	trial_list_all(:,Mposit)=1:90; 
	trial_list_all(trial_list_all(:,MWM)>=4,Mmem)=1; %rem
	trial_list_all(trial_list_all(:,MWM)<=2,Mmem)=2; %forgot
	trial_list_all(trial_list_all(:,Mlag)<=2,Mclag)=1; %massed
	trial_list_all(trial_list_all(:,Mlag)==520,Mclag)=3; %once
	trial_list_all(trial_list_all(:,Mlag)==29 | trial_list_all(:,Mlag)==30,Mclag)=2; %spaced
        list_once=trial_list_all(trial_list_all(:,Mclag)==3,:); % used for spaced in cons
        list_cons=trial_list_all((trial_list_all(:,Mclag)<=2 & trial_list_all(:,Mcons)==1),:); % used for spaced in cons
        list_incos=trial_list_all((trial_list_all(:,Mclag)<=2 & trial_list_all(:,Mcons)==2),:); %used for spaced in incons
        list_massed=trial_list_all(trial_list_all(:,Mclag)==1,:);%used for ev in massed
        list_spaced=trial_list_all(trial_list_all(:,Mclag)==2,:);%used for ev in spaced

	tmp=trial_list_all(trial_list_all(:,Mclag)~=3,:);
        twice_rep=sortrows(tmp,[MID MAonset]);
	twice_rep(1:2:end,Mrep)=1;
	twice_rep(2:2:end,Mrep)=2;
	list_all=[twice_rep;list_once];
	
	all_lable=sortrows(list_all,MAonset);
	TN=length(all_lable);
        all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
        all_mem1=[]; all_mem2=[]; 
        all_wID1=[]; all_wID2=[]; 
        all_rep1=[]; all_rep2=[];
	for k=2:TN
        all_wID1=[all_wID1 all_lable(k-1,MID)*ones(1,TN-k+1)];
        all_wID2=[all_wID2 all_lable(k:TN,MID)'];
        all_rep1=[all_rep1 all_lable(k-1,Mrep)*ones(1,TN-k+1)];
        all_rep2=[all_rep2 all_lable(k:TN,Mrep)'];
        all_mem1=[all_mem1 all_lable(k-1,Mmem)*ones(1,TN-k+1)];
        all_mem2=[all_mem2 all_lable(k:TN,Mmem)'];

        %check_dis=all_posit2-all_posit1; %interval:1,2,29,30; dis=2,3,30,31
        check_rep=all_rep1==all_rep2; %1=same rep; 0=diff rep
        end

%% get indexes
% self similarity
    idx_wi_rem=find(all_wID1==all_wID2 & all_mem1==1);
    idx_bi_rem=find(all_wID1~=all_wID2 & all_mem1==1 & all_mem2==1 & check_rep==0);
    idx_wi_forg=find(all_wID1==all_wID2 & all_mem1==2);
    idx_bi_forg=find(all_wID1~=all_wID2 & all_mem1==2 & all_mem2==2 & check_rep==0);
%%size of pairs
    %nwi(1)=length(idx_wi_mc);
%%get fMRI data
data_file=sprintf('%s/sub%03d/analysis/singletrial_run%d/stats/pe1ls_one_at_time.nii.gz',basedir,s,r);
data_all=load_nii_zip(data_file);
dataa=data_all.img;
data=dataa(:,:,:,:);
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
                    wi(k,j,i,:)=10;
                    bi(k,j,i,:)=10;
                    else
                    xx=v_data';
                    cc=1-pdist(xx(:,:),'correlation');
                    wi(k,j,i,1)=mean(cc(idx_wi_rem));
                    wi(k,j,i,2)=mean(cc(idx_wi_forg));
                    bi(k,j,i,1)=mean(cc(idx_bi_rem));
                    bi(k,j,i,2)=mean(cc(idx_bi_forg));
                    end %end if
                end %end i
            end %end j
        end %end k

cd (rdir)
         filename=sprintf('wi_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(wi(:,:,:,:));
         data_all.hdr.dime.dim(5)=2; % dimension chagne to 4
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));

         filename=sprintf('bi_sub%02d_run%d.nii',s,r);
         data_all.img=squeeze(bi(:,:,:,:));
         data_all.hdr.dime.dim(5)=2; % dimension chagne to 4
         save_untouch_nii(data_all, filename);
         system(sprintf('gzip -f %s',filename));
end %end run
end %end sub
end %end func
