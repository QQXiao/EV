%basedir='/expdata/gxue/spacing_ev';
basedir='E:\Program_Files\project\variable\TV';
behavdir=fullfile(basedir,'behavior');
datadir=fullfile(basedir,'ROI_based_RSM');
plotsdir=fullfile(datadir,'plot');
%addpath(pwd)
addpath('F:\trans\scripts')

%data structure 
MID=1;  % material id
Mcons=2; %1:CONSISTENT, 2 INCONSISTENT;
Mtask=3; %1:living, 2 size;
Mswi=4; %1:CONSISTENT, 2 INCONSISTENT;3: switch
Mmem=5; % word memory: 5=R 3~4=k 1~2=f
Mlag=6; % 1 2
Mrep=7; % 1 2
%% added information
Mposit=8;% posititon in each run
Mwm=9;%mem performance 1=R 2=K 3=F

roi_img_dir=fullfile(basedir,'roi');
roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
          'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
          'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
    	  'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
          'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total

%cd(roi_img_dir);
%roi_name=dir('*.nii.gz');    

cd(datadir);
      

subs=setxor([1:7],[6]);

for sub=1:length(subs)
    RSA_2=[];
    RSA_3=[];
    RSA_4=[];
    for roi=1:length(roi_name);
        data_1=[];
        data_2=[];
        data_3=[];
        data_4=[];
        for r=1:4 % run 
          cope_dir=fullfile(basedir,['sub',sprintf('%03d',subs(sub))],['singletrial_run' num2str(r)]);
          tmp_raw=load(sprintf('%s/RSA_%s.txt',cope_dir,roi_name{roi}));
          eval(sprintf('data_%d=tmp_raw(4:end,1:end-1);',r)); % remove the final zero and the first three rows showing the coordinates
          eval(sprintf('s(1,r)=size(data_%d,2);',r));
        end   %end run
        n=min(s);
        for i=2:4 %compare run
              data_all=[];
              eval(sprintf('data_all_%d=[data_1(:,1:n);data_%d(:,1:n)];',i,i))
        end
        cc_2=1-pdist(data_all_2(:,:),'correlation'); % use xx or yy to switch from normalize to no-normalize
        cc_3=1-pdist(data_all_3(:,:),'correlation'); % use xx or yy to switch from normalize to no-normalize  
        cc_4=1-pdist(data_all_4(:,:),'correlation'); % use xx or yy to switch from normalize to no-normalize   
        for i=2:4
            eval(sprintf('tmp_RSA_%d(:,roi)=cc_%d;',i,i));   
        end
    end %end roi   
    RSA_2=[RSA_2 tmp_RSA_2];
    RSA_3=[RSA_3 tmp_RSA_3];
    RSA_4=[RSA_4 tmp_RSA_4];
    
    eval(sprintf('save %s/LSA/lag_crossrun/lag_sub%02d_RSA_ROI RSA_2 RSA_3 RSA_4', datadir,subs(sub)));
    disp(['The ',num2str(subs(sub)),'th subject is processed!']);    
end %end sub