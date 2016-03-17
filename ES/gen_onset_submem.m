%%%combine behav results from different runs and different stages
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

Mcond=16;

basedir='/seastor/helenhelen/ES';
datadir=sprintf('%s/behavior/data',basedir)
%cd results

% subs=[15];
subs=[1:31];
sub_ex=[1 3 15 16]; % what is wrong with sub 15 &16??
%[1 3] fmri data are useless;
%[15 16] tens of same material rise in word_test;
%[19 31] NaN in some conditions;
subs(sub_ex)=[];

cd(datadir)
%% combine files for every sub
for sub=1:size(subs,2)
    subid=subs(sub); subln=[];
    %load ev files
     for runid=1:4
        filename=ls(sprintf('ev_sub%d_run%d*', subid, runid)); %load([runtimelist(runid).name]);
        eval(sprintf('load %s',filename));
        SM(:,Mrun)=runid;  %add Mrun
        subln=[subln; SM];        %merge matrix sub and SM

	%% erro trial
        %tmp1=grate(grate(:,3)<0,5); %% get all the wrong trials
        %tmp2=[tmp1,ones(size(tmp1))*0.5 ones(size(tmp1))];
        %outputfile=sprintf('%s/sub%03d/behav/run%d_grate_err.txt',basedir,subid,runid);
        %eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
    end
    subln=sortrows(subln,[3,12]); % sort according the trial number and study order

    % group into 5 condition
   subln(subln(:,4)==1 & subln(:,6)<4,Mcond)=1;% massed consistent
   subln(subln(:,4)==2 & subln(:,6)<4,Mcond)=2;% massed inconsistent
   subln(subln(:,4)==1 & subln(:,6)>4,Mcond)=3;% spaced consistent
   subln(subln(:,4)==2 & subln(:,6)>4,Mcond)=4;% spaced inconsistent
   subln(subln(:,4)==3 & subln(:,6)==520,Mcond)=5;% once

    %load word&pic recognization result
    subw=[];
    for i=1:2
        filename=ls(sprintf('memtest_words_sub%d_run%d*',subid,i));
        eval(sprintf('load %s',filename));
        SM(:,9)=i; % add run
        subw=[subw;SM];
    end

    subw=sortrows(subw,3);

    subp=[];
    for i=1:2
        filename=ls(sprintf('memtest_pic_sub%d_run%d*',subid,i));
        eval(sprintf('load %s',filename));
        SM(:,12)=i; % add run
        subp=[subp;SM];
    end
    subp=sortrows(subp,3);

   % merge learn and test_words data
   for i=1:size(subln,1)
    ix=find(subw(:,3)==subln(i,3));
    subln(i,MWM)=subw(ix,5);

    ix=find(subp(:,3)==subln(i,3) & subp(:,6)==subln(i,5)); % find the corresponding pic
    subln(i,MPM)=subp(ix,7);
   end


   % creat onset file

   cond_name={'MC','MI','SC','SI','Once'};
   for run=1:4
        for cond = 1:4
            tmp=subln(subln(:,Mrun)==run & subln(:,Mcond)==cond,:);
	    tmp=sortrows(tmp,[3,12]); % sort according the trial number and study order
            for rep = 1:2
                aa=tmp(rep:2:end,MAonset);
    		aa=sortrows(aa);
                tmp1=[[0 0 0];[aa ones(size(aa)) ones(size(aa))]];
                eval(sprintf('save %s/sub%03d/behav/Cate_run%d_%s%d.txt -ascii -tabs tmp1',basedir,subs(sub),run,cond_name{cond},rep));
            end
        end

          aa=subln(subln(:,Mrun)==run & subln(:,Mcond)==5,MAonset);
    	  aa=sortrows(aa);
          tmp1=[[0 0 0];[aa ones(size(aa)) ones(size(aa))]];
          eval(sprintf('save %s/sub%03d/behav/Cate_run%d_%s.txt -ascii -tabs tmp1',basedir,subs(sub),run,cond_name{5}));


          aa=subln(subln(:,Mrun)==run & subln(:,Mcond)==5,MAonset);
          tmp1=[[0 0 0];[aa ones(size(aa)) ones(size(aa))]];
          eval(sprintf('save %s/sub%03d/behav/Submem_run%d_filler.txt -ascii -tabs tmp1',basedir,subs(sub),run));

          aa=subln(subln(:,Mrun)==run & subln(:,Mcond)<5 & subln(:,MWM)<=4,MAonset);
          tmp1=[[0 0 0];[aa(1:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
          eval(sprintf('save %s/sub%03d/behav/Submem_run%d_R1.txt -ascii -tabs tmp1',basedir,subs(sub),run));

        tmp1=[[0 0 0];[aa(2:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
           eval(sprintf('save %s/sub%03d/behav/Submem_run%d_R2.txt -ascii -tabs tmp1',basedir,subs(sub),run));


          aa=subln(subln(:,Mrun)==run & subln(:,Mcond)<5 & subln(:,MWM)==3,MAonset);
         tmp1=[[0 0 0];[aa(1:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
           eval(sprintf('save %s/sub%03d/behav/Submem_run%d_K1.txt -ascii -tabs tmp1',basedir,subs(sub),run));

          tmp1=[[0 0 0];[aa(2:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
         eval(sprintf('save %s/sub%03d/behav/Submem_run%d_K2.txt -ascii -tabs tmp1',basedir,subs(sub),run));

          aa=subln(subln(:,Mrun)==run & subln(:,Mcond)<5 & subln(:,MWM)<3,MAonset);
        tmp1=[[0 0 0];[aa(1:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
           eval(sprintf('save %s/sub%03d/behav/Submem_run%d_F1.txt -ascii -tabs tmp1',basedir,subs(sub),run));

         tmp1=[[0 0 0];[aa(2:2:end) ones(length(aa)/2,1) ones(length(aa)/2,1)]];
          eval(sprintf('save %s/sub%03d/behav/Submem_run%d_F2.txt -ascii -tabs tmp1',basedir,subs(sub),run));

	%single trial
	%SM=subln(subln(:,Mrun)==run,:);
      	%SM=sortrows(SM,MAonset); %% sort according to onset;
       	%tmp1=SM(:,MAonset); %% onset;
       	%tmp2=[tmp1,ones(size(tmp1))*2 ones(size(tmp1))];
       	%outputfile=sprintf('%s/sub%03d/behav/run%d_all.txt',basedir,subs(sub),run);
        %eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));

        %trial_list_all=SM; % ID;learning condition; Word memory; picture memory;lag; rep
        %eval(sprintf('save sub%02d_run%d_singletriallist trial_list_all',subs(sub),run));
   end % end run
end % end sub
