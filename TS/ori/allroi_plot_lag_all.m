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
        load(sprintf('%s/LSA/lag/all/lag_sub%02d_RSA_ROI.mat',datadir, subs(sub)));
        a(sub,:)=RSA(:,r)';
        mm=mean(a);
    end
    data(r,:)=mm;
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
    [m,n]=size(y_mtx);
    for i=1:m
        y_mtx(i,i)=1;
    end
    x=rot90(y_mtx,1);
    
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
    saveas(gcf,plottitle);
    hold off
end
 

