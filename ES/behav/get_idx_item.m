function [all_lable,u_lable]=get_idx_item(sub)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ES';
labeldir=[basedir,'/behavior/label'];
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
for s=sub
all_lable=[];
u_lable=[];
	for r=1:4
	wi=zeros(xlength,ylength,zlength,2);%1:rem; 2:forgot
	bi=zeros(xlength,ylength,zlength,2);%1:rem; 2:forgot
        %perpare data
        load(sprintf('%s/sub%02d_run%d_singletriallist.mat',labeldir,s,r));
	trial_list_all(:,Mposit)=[1:90]+90*(r-1);
	trial_list_all(trial_list_all(:,MWM)>=5,Mmem)=1; %rem
	trial_list_all(trial_list_all(:,MWM)<=2,Mmem)=2; %forgot
	trial_list_all(trial_list_all(:,Mlag)<=2,Mclag)=1; %massed
	trial_list_all(trial_list_all(:,Mlag)==520,Mclag)=3; %once
	trial_list_all(trial_list_all(:,Mlag)==29 | trial_list_all(:,Mlag)==30,Mclag)=2; %spaced
        list_cons=trial_list_all((trial_list_all(:,Mclag)<=2 & trial_list_all(:,Mcons)==1),:); % used for spaced in cons
        list_incos=trial_list_all((trial_list_all(:,Mclag)<=2 & trial_list_all(:,Mcons)==2),:); %used for spaced in incons
        list_massed=trial_list_all(trial_list_all(:,Mclag)==1,:);%used for ev in massed
        list_spaced=trial_list_all(trial_list_all(:,Mclag)==2,:);%used for ev in spaced
        list_once=trial_list_all(trial_list_all(:,Mclag)==3,:);%once

	tmp=trial_list_all(trial_list_all(:,Mlag)~=520,:);
        twice_rep=sortrows(tmp,MAonset);
	twice_rep(1:2:end,Mrep)=1;
	twice_rep(2:2:end,Mrep)=2;
	list_all=[twice_rep;list_once];
	ul=[twice_rep(1:2:end,:)];
	all_l=sortrows(list_all,MAonset);
	aul=sortrows(ul,MAonset);

	all_lable=[all_lable;all_l];
	u_lable=[u_lable;aul];
	end %run
end %end sub
end %end func
