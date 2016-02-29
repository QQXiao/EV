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
a=[];
for r=1:length(roi_name)
    for sub=1:length(subs)
        load(sprintf('%s/LSA/lag_crossrun/lag_sub%02d_RSA_ROI.mat',datadir, subs(sub)));
        a2(sub,:)=RSA_2(:,r)';
        a3(sub,:)=RSA_3(:,r)';
        a4(sub,:)=RSA_4(:,r)';
        mm2=mean(a2);
        mm3=mean(a3);
        mm4=mean(a4);
    end
    data(r,:)=mm4;
end

%subs=setdiff([1:24],[10]);
%subs=setdiff([1:24],[6 11 12 20];
subs=[1:6];

%% matrix
condnames={'1','13','25','38','50'};
condnames_y={'50','38','25','13','1'};
for r=1:length(roi_name)
    plottitle=roi_name{r};
    y=squeeze(data(r,:));
    %generate the temp matrix;
    y_mtx=squareform(y);
  
    p=triu(y_mtx,48);
    pp=p(1:48,49:end);
    q=tril(y_mtx,-48);
    qq=q(49:96,1:48);
    [m,n]=size(qq);
    for i=1:m
        qq(i,i)=0;
    end 
    x=pp+qq;
     m=rot90(x,1);   
    
    eval(sprintf('save %s.txt -ascii -tabs x',plottitle));
    
    figure
    imagesc(x);
    colorbar
    caxis([-1 1])
    
    axis equal
    set(gca,'xlim',[0.5 48.5]);
     set(gca,'XTick',[1:12:49])
     set(gca,'Xticklabel',condnames);
     set(gca,'YTick',[0:12:48])
     set(gca,'Yticklabel',condnames_y);
     
    title(plottitle)
    %saveas(gcf,plottitle);
    hold off
end
 

