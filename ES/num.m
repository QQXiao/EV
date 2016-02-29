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

%basedir='/seastor/helenhelen/ES';
basedir='/Users/xiaoqian/Documents/experiment/encoding_variability/ES_2012';
datadir=sprintf('%s/data/behav',basedir);
subs=[1:31];
sub_ex=[1 3 15 16]; % what is wrong with sub 15 &16??
%[1 3] fmri data are useless;
%[15 16] tens of same material rise in word_test;
%[19 31] NaN in some conditions;
subs(sub_ex)=[];

%% combine files for every sub
for sub=1:size(subs,2)
    subid=subs(sub); subln=[];
    %load ev files
     for runid=1:4
        filename=ls(sprintf('%s/ev_sub%d_run%d*', datadir, subid, runid)); %load([runtimelist(runid).name]);
        eval(sprintf('load %s',filename));
        SM(:,Mrun)=runid;  %add Mrun
        subln=[subln; SM];        %merge matrix sub and SM
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
        filename=ls(sprintf('%s/memtest_words_sub%d_run%d*',datadir, subid,i));
        eval(sprintf('load %s',filename));
        SM(:,9)=i; % add run
        subw=[subw;SM];
    end

    subw=sortrows(subw,3);

    subp=[];
    for i=1:2
        filename=ls(sprintf('%s/memtest_pic_sub%d_run%d*',datadir, subid,i));
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
   subln=sortrows(subln,MID);
    tln=subln(subln(:,Mcond)~=5,:);
    sln=tln(1:2:end,:);

   % get num for each memory strength
   for run=1:4
        for m=1:5
        nm=sum(sln(:,Mrun)==run & sln(:,MWM)==m);
        runm(sub,m,run)=nm;
        end %end m
        tsm=[sum(sln(:,Mrun)==run & sln(:,MWM)<=2) sum(sln(:,Mrun)==run & sln(:,MWM)>=4)];
        sm(sub,:,run)=tsm;
   end % end run
end % end sub
