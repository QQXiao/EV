basedir='E:\Program_Files\project\variable\TV';
behavdir=fullfile(basedir,'behavior');
datadir=fullfile(basedir,'ROI_based_RSM');
plotsdir=fullfile(datadir,'plot');


addpath('F:\trans\scripts')

roi_img_dir=fullfile(basedir,'roi');

%cd(roi_img_dir);
%roi_name=dir('*.nii.gz');
roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
          'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
          'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
    	  'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
          'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total

mem_name={'R','K','F'};
ev_name={'Con','Inc'};

subs=setxor([1:7],[6]);

for sub=1:length(subs)

        load(sprintf('%s/LSA/lag/lag_sub%02d_RSA_ROI.mat',datadir, subs(sub)));
        
        
        lag=unique(all_dis_between);
        %lag=unique(all_dis_within);
        x=lag;
        for r=1:length(roi_name)            
            for i=1:length(lag)
                dis=lag(i);
             all_RSA(r,sub,i)=mean(all_RSA_between(all_dis_between==dis,r)); 
             %all_RSA(r,sub,i)=mean(all_RSA_within(all_dis_within==dis,r));  
            end
        end
end


%subs=setdiff([1:24],[10]);
%subs=setdiff([1:24],[6 11 12 20];
subs=[1:6];

for r=1:length(roi_name)
    figure;
    plottitle=roi_name{r};
    
    y=squeeze(all_RSA(r,subs,:));
    meanmat=mean(y);
    stdmat=std(y)/sqrt(length(subs));
    
    plot(y,'linewidth',3);
    errorbar(meanmat,stdmat,'linewidth',3);
    title(plottitle)  
end

 

