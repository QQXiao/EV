function allroi_RSM_lag(sub)
basedir='/expdata/helenhelen/sv';
behavdir=fullfile(basedir,'behavior');
datadir=fullfile(basedir,'pattern_TR34');
plotsdir=fullfile(datadir,'plot');
%addpath(pwd)
cd (basedir)
addpath('scripts')

%data structure
%data structure in sv learning
MID=1;  % material id
Mcons=2; % 1=con;2=incon
Msem1=3; % semantic category: 1=living
Msem2=4; % 1=bigger
Mtask=5;%1=living
Mem=6;% 1=rem;2=forgort;3=filler;
Monset=7;
Mposit=8;%trialnumber=position
%added information
Mlag=9; % 1 2
Mrep=10; % 1 2

roi_img_dir=fullfile(basedir,'roi');
roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
          'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
          'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
    	  'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
          'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total

cd(datadir);
      
mem_name={'R','K','F'};
ev_name={'Con','Inc'};

subs=setxor([1:25],[24]);

for sub=1:length(subs)
    all_act_within=[];
    all_act_between=[];
    all_RSA_within=[];
    all_RSA_between=[];
    all_dis_within=[];
    all_dis_between=[];
    new_label=[];
    bad_trial=[];
    
  for r=1:4 % run
      load(sprintf('%s/behavior/sub%02d_run%d_singletriallist.mat',basedir,subs(sub),r))
      tmp=trial_list_all;

      tmp=sortrows(tmp,MID); % sort back according to the position in the nii file.
      tmp(1:2:end,Mlag)=tmp(2:2:end,Mposit)-tmp(1:2:end,Mposit);
      tmp(2:2:end,Mlag)=tmp(2:2:end,Mposit)-tmp(1:2:end,Mposit);
      tmp(1:2:end,Mrep)=ones(40,1);
      tmp(2:2:end,Mrep)=2*ones(40,1);

      tmp=sortrows(tmp,Mposit); % sort back according to the position in the nii file.

      trial_list_all=tmp;

         
            b=trial_list_all; % smaller matrix
            c=trial_list_all(:,Mposit); % distance
            d=trial_list_all(:,Mtask); % task
            e=trial_list_all(:,Mrep); % rep
            f=trial_list_all(:,Mcons); % consistenty;
            a=trial_list_all(:,MID); % ID
            
            utrial = unique(b(:,1));
            TN=length(a);
            all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
         
      all_dis=[];
      all_item1=[];
      all_item2=[];
        
      for k=2:TN
          all_dis=[all_dis abs(c(k:TN)-c(k-1))']; % distance/lag between pair
          %all_tskdiff=[all_tskdiff abs(d(k:TN)-d(k-1))']; % within or between task
          %all_cond=[all_cond d(k-1)*ones(1,TN-k+1)]; % the task condition of first trial
          %all_rep=[all_rep abs(e(k:TN)-e(k-1))']; %same==0 or dif==1 rep
          all_item1=[all_item1 a(k-1)*ones(1,TN-k+1)];
          all_item2=[all_item2 a(k:TN)'];
      end
  
      
     %% get within and between items
          within_idx=find((all_item2-all_item1)==0);
          between_idx=setdiff(all_idx,[within_idx]);
          
           %cope_dir=fullfile(basedir,['sub',sprintf('%03d',subs(sub))],'analysis',['singletrial_run' num2str(r)],'stats'); %
           cope_dir=fullfile(basedir,['sub',sprintf('%02d',subs(sub))],['singletrial_run' num2str(r)]);
           
          for roi=1:length(roi_name);
              mm=[];
             %tmp_raw=load(sprintf('%s/%s_atlas.txt',cope_dir,roi_name{roi}));
             tmp_raw=load(sprintf('%s/%s.txt',cope_dir,roi_name{roi}));
              xx=tmp_raw(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
                             
              cc=1-pdist(xx(:,:),'correlation'); % use xx or yy to switch from normalize to no-normalize
              
              tmp_RSA_within(:,roi)=cc(within_idx)';
              tmp_RSA_between(:,roi)=cc(between_idx)';
          end % end roi
          
          all_dis_within=[all_dis_within all_dis(within_idx)];
          all_dis_between=[all_dis_between all_dis(between_idx)];
          all_RSA_within=[all_RSA_within;tmp_RSA_within];
          all_RSA_between=[all_RSA_between;tmp_RSA_between];
          
          clear tmp*    
end % end run
    eval(sprintf('save %s/lag/lag_sub%02d_RSA_ROI all_RSA_within all_RSA_between all_dis_within all_dis_between', datadir,subs(sub)));

    %disp(['The ',num2str(subs(sub)),'th subject is processed!']);
    
end % end sub
                     end %end function
