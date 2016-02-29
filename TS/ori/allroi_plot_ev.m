function allroi_plot_ev(voxels)
basedir='E:\Program_Files\project\variable\TV';
behavdir=fullfile(basedir,'behavior');
datadir=fullfile(basedir,'ROI_based_RSM');
plotsdir=fullfile(datadir,'plot');

addpath('F:\trans\scripts')
%addpath('~/scripts')
%addpath('/expdata/helenhelen/scripts')
voxels=1;
if voxels==1 dir='all';
else dir='no';
end
    

roi_img_dir=fullfile(basedir,'roi');

roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
          'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
          'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
    	  'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
          'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total

mem_name={'R','K','F'};
ev_name={'Con','Inc'};

subs=setxor([1:7],[6]);

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

for sub=1:length(subs)

    %load(sprintf('%s/ev/from_GUI/consistency_sub%02d_RSA_ROI.mat',datadir,subs(sub)));         
    load(sprintf('%s/LSA/ev/%s/ev_sub%02d_RSA_ROI.mat',datadir,dir,subs(sub))); 
        for r=1:length(roi_name)
            
            % regress out the differences in activation leve; 
            
%             [a b c]=glmfit(all_act_within(:,r),all_RSA_within(:,r),'normal','constant','off');
%             all_RSA_within(:,r)=c.resid;
%         
%              [a b c]=glmfit(all_act_within(:,r),all_RSA_between(:,r),'normal','constant','off');
%              all_RSA_between(:,r)=c.resid;
%  
             
            
%             % regress out the differences in LIFG activation leve; 
%             
%             [a b c]=glmfit(all_act_within(:,21),all_RSA_within(:,r),'normal','constant','off');
%             all_RSA_within(:,r)=c.resid;
%         
%              [a b c]=glmfit(all_act_within(:,21),all_RSA_between(:,r),'normal','constant','off');
%              all_RSA_between(:,r)=c.resid;
          
                         
            for ev=1:2
                
                tmp=mean(all_RSA_within(new_label(:,Mcons)==ev,r));
                tmp1=mean(all_RSA_between(new_label(:,Mcons)==ev,r));
                
                all_RSA(r,sub,ev)=tmp;
                all_RSA(r,sub,ev+2)=tmp1;
            end
               
            save ev all_RSA
        end %end ru
end %end sub



subs=[1:6];

% now plot
for r=1:length(roi_name)
    
     y=squeeze(all_RSA(r,subs,:));
%     
    fprintf('ROI: %s\n =============================================\n',roi_name{r});
    f1_num=2; % within_between
    f2_num=2; % ev
    stats=do_anova2(y,f1_num,f2_num,{'wb','ev'});
    withsub_err=sqrt(stats{7,4}/size(y,1));

    meanmat=mean(y);
    meanmat=reshape(meanmat,2,2);

    % use within-subject error
    stdmat=ones(size(meanmat))*withsub_err(1);
     
    figure
    plottitle=roi_name{r};
    condnames={'Consistent','Inconsistent'};

    hold on
    barerror(meanmat,stdmat,0.9,'k',{'r';'g';'b'})
    set(gca,'XTick',[1:2])
    set(gca,'Xticklabel',condnames);
    set(gca,'FontSize',20)
    set(gca,'fontname','Arial')
    set(gcf,'Color',[1 1 1]) % set background to white
    title(plottitle)
    legend('Within','Between');
    
    %xlabel(['F = ' num2str(F1) '; P = ' num2str(P1)]);
    ylabel('Pattern similarity')
    
    hold off
    orient tall

    %y=squeeze(all_RSA(r,subs,[2 4 1 3]));
    
%     fprintf('ROI: %s\n =============================================\n',roi_name{r});
%     f1_num=2; % within_between
%     f2_num=2; % ev
%     stats=do_anova2(y,f1_num,f2_num,{'wb','ev'});
%     withsub_err=sqrt(stats{7,4}/size(y,1));
% %     
% %     do_anova2(y(:,1:4),2,2,{'Mem','Cons'});
% %     do_anova2(y(:,[1 3 5 7]),2,2,{'WB','Mem'});
% %     do_anova2(y(:,[2 4 6 8]),2,2,{'WB','Mem'});
% %     
%     % second, calculate mea do_anova2(y(:,[1 3 5 7]),2,2,{'WB','Mem'});n
%     meanmat=mean(y);
%     meanmat=[meanmat([1:2]);meanmat([3:4])]';
% 
%     % use within-subject error
%     stdmat=ones(size(meanmat))*withsub_err(1);
%      
%     figure
%     plottitle=roi_name{r};
%     condnames={'consistent','inconsistent'};
% 
%     hold on
%     barerror(meanmat,stdmat,0.9,'k',{'r';'g';'b'})
%     set(gca,'XTick',[1:2])
%     set(gca,'Xticklabel',condnames);
%     set(gca,'FontSize',50)
%     set(gca,'fontname','Arial')
%     set(gcf,'Color',[1 1 1]) % set background to white
%     title(plottitle)
%     legend('Within','Between');
%     
%     %xlabel(['F = ' num2str(F1) '; P = ' num2str(P1)]);
%     ylabel('Pattern similarity')
%     
%     % text (1,1,['F = ' num2str(F1) '; P = ' num2str(P1)]);
%     hold off
%     orient tall
%     %print('-dpsc2','-painters','-append',['plots_2bin'])
end
end

