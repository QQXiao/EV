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

%cd(datadir);
      
mem_name={'R','K','F'};
ev_name={'Con','Inc'};

%subs=setxor([1:7],[6]);
subs=[7];
%subs=2;
%subs=25;

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
      load(sprintf('%s/behavior/sub%02d_run%d_singletriallist.mat',basedir,subs(sub),r));
      trial_list_all(:,Mposit)=[1:48]; % add the item(trial) posit in the nii file
      tmp=trial_list_all;
                 
      tmp(:,Mwm)=2; % memory performance
      tmp(tmp(:,Mmem)==5,Mwm)=1; % R
      tmp(tmp(:,Mmem)<=2,Mwm)=3; % F
      
      tmp=sortrows(tmp,Mposit); % sort back according to the position in the nii file.
      
      trial_list_all=tmp;
      
        for ev=[1:2] % consistent vs. inconsistentNoswitch   
            a=find(trial_list_all(:,Mcons)==ev); % trial index
            b=trial_list_all(a,:); % smaller matrix
            c=trial_list_all(a,Mposit); % distance
            d=trial_list_all(a,Mtask); % task
            e=trial_list_all(a,Mrep); % rep
            f=trial_list_all(a,Mcons); % consistenty;
            
            utrial = unique(b(:,1));
            TN=length(a);
            all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
         
            % calculate within-item similarity index, distance and task
            within_idx=[];
            within_dis=[];
            within_tsk=[];
        
            for t=1:length(utrial)
                idx=find(b(:,1)==utrial(t));
                within_idx=[within_idx sum([TN-idx(1)+1:TN])+idx(2)-idx(1)-TN]; 
                %within_idx=[within_idx sum(TN-(idx(1)-1):(TN-1))+idx(2)-(idx(1)+1)+1];
                %within_idx=[within_idx (idx(1)-1)*(TN-idx(1)/2)+idx(2)-idx(1)]; 
                %   1    2    x ......TN-1   %% tail number
                %  n-1  n-2  n-x..... n-(n-1) %% all pairs for each trial
                % [(n-1)+(n-x(1)+1)]*(x(1)-1)/2+[x(2)-x(1)] %%idx for within-item
                within_dis=[within_dis c(idx(2))-c(idx(1))];
                within_tsk=[within_tsk abs(d(idx(2))-d(idx(1)))];
                new_label=[new_label;b(idx(1),:)]; % new label
            end
            
            % calculate the between-item similarity index and distance
            all_dis=[];
            all_rep=[];
            all_tsk=[];
            all_cons=[];
            all_item1=[]; % item id, in order to get the activation level for that item
            all_item2=[];
        
            %c=dis; d=task; e=rep; f=ev;
            for k=2:TN
               all_dis=[all_dis abs(c(k:TN)-c(k-1))']; % distance/lag between pair
               all_tsk=[all_tsk abs(d(k:TN)-d(k-1))']; % within or between task
               all_rep=[all_rep abs(e(k:TN)-e(k-1))']; %same==0 or dif==1 rep
               all_cons=[all_cons abs(f(k:TN)-f(k-1))']; % same condition or different condition; 
               all_item1=[all_item1 (k-1)*ones(1,TN-k+1)];
               all_item2=[all_item2 (k:TN)];
            end
        
            % get ride of within pair & same rep & different condition
            same_rep=find(all_rep==0);
            diff_cond=find(all_cons==1);
            
            incld_idx=setdiff(all_idx,[diff_cond same_rep within_idx]);
            
            all_dis=all_dis(incld_idx);
            all_tsk=all_tsk(incld_idx);
            all_idx=all_idx(incld_idx);
        
            % now match distance for between and within
            between_idx=[];
            between_dis=[];

        
            for k=1:length(within_dis)
                tmp=find(all_dis==within_dis(k) & all_tsk==within_tsk(k)) ;
                kk=1;                
                while isempty(tmp) % find closer ones
                    tmp=find((all_dis==(within_dis(k)-kk) | all_dis==(within_dis(k)+kk)) & all_tsk == within_tsk(k));    
                    kk=kk+1;
                end
                
                xx=randperm(length(tmp)); %randomly pick one
                between_idx=[between_idx all_idx(tmp(xx(1)))];
                between_dis=[between_dis all_dis(tmp(xx(1)))];
                
                % get rid of this one
                all_idx(tmp(xx(1)))=[];
                all_dis(tmp(xx(1)))=[];
                all_tsk(tmp(xx(1)))=[];
                
           end % within_list
           
%           %% merge remember and forgotten items.
%           all_idx_within=[all_idx_within within_idx];
%           all_idx_between=[all_idx_between between_idx];
            all_dis_within=[all_dis_within within_dis];
            all_dis_between=[all_dis_between between_dis];           

          %cope_dir=fullfile(basedir,['sub',sprintf('%02d',subs(sub))],'analysis',['singletrial_run' num2str(r)],'stats'); %
          cope_dir=fullfile(basedir,['sub',sprintf('%03d',subs(sub))],['singletrial_run' num2str(r)]);
          for roi=1:length(roi_name);
              mm=[];
              %tmp_raw=load(sprintf('%s/%s_atlas.txt',cope_dir,roi_name{roi}));
              tmp_raw=load(sprintf('%s/RSA_%s.txt',cope_dir,roi_name{roi}));
              xx=tmp_raw(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
              %xx=tmp_raw(4:end,1:end);
                         
              % whether or not to normalize the range;
              yy=[];
              H=[];
              H=ttest2(xx(trial_list_all(:,2)==1,:),xx(trial_list_all(:,2)==2,:),0.05,'Both','unequal');
              
              %voxel_idx=find(H==0); % only use voxels showing no differences in activation level
              voxel_idx=find(H>=0); % use all voxels
              
%               for i=1:size(xx,1)
%                   yy(i,voxel_idx)=xx(i,voxel_idx)-mean(xx(i,voxel_idx));
%                   yy(i,voxel_idx)=yy(i,voxel_idx)./max(yy(i,voxel_idx));
%               end
              
              cc=1-pdist(xx(a,voxel_idx),'correlation'); % use xx or yy to switch from normalize to no-normalize
              % calculate the mean
              tmp=mean(xx(a,voxel_idx),2);
              
              tmp_act_within(:,roi)=tmp(all_item1(within_idx))/2+tmp(all_item2(within_idx))/2;
              tmp_act_between(:,roi)=tmp(all_item1(between_idx))/2+tmp(all_item2(between_idx))/2;
              
              tmp_RSA_within(:,roi)=cc(within_idx)';
              tmp_RSA_between(:,roi)=cc(between_idx)';
          end
          
          all_act_within=[all_act_within;tmp_act_within];
          all_act_between=[all_act_between;tmp_act_between];
          all_RSA_within=[all_RSA_within;tmp_RSA_within];
          all_RSA_between=[all_RSA_between;tmp_RSA_between];
          
          clear tmp*          
 
    end % end if
    
end % end run
    eval(sprintf('save %s/LSA/ev/all/ev_sub%02d_RSA_ROI all_act_within all_act_between all_RSA_within all_RSA_between all_dis_within all_dis_between new_label', datadir,subs(sub)));
    %eval(sprintf('save %s/LSS/ev/no/ev_sub%02d_RSA_ROI all_act_within all_act_between all_RSA_within all_RSA_between all_dis_within all_dis_between new_label', datadir,subs(sub)));
   
    disp(['The ',num2str(subs(sub)),'th subject is processed!']);
    
end % end sub