function abc=SummarySheetsV6(varargin)
if nargin<1
    [wtfiles,path]=uigetfile('*.wtf','MultiSelect','on')
    if ~iscell(wtfiles)
        WTFiles{1}=[path,wtfiles];
    else
        for i=1:numel(wtfiles)
            WTFiles{i}=[path,wtfiles{i}];
        end
    end
end
if nargin==1
    WTFiles=varargin{1};
end
if nargin>1
    wtfiles=varargin{1};
    wtpaths=varargin{2};
    for i=1:numel(wtfiles)
        WTFiles{i}=[wtpaths{i},wtfiles{i}];
    end
end

for i=1:numel(WTFiles)
    clear kineticinfo;
    clear interactstats;
    try
        %%%%FIGURE INFO
        h1=figure('Visible','on');
        set(gcf,'PaperPositionMode','manual');
        set(gcf,'Units','inches');
        set(gcf,'PaperPosition',[0.1 0.1 8.3 10.8])
        [p n e]=fileparts(WTFiles{i});
        %SAVENAME=[p,'\',n,'_SUMMARY.ps'];
        SAVENAME=[p,'\',n,'_SUMMARY.pdf'];
        %%%%load WTF file
        
        load(WTFiles{i},'-mat')
        annotation('textbox',[0 .98 .9 .02],'String',[n,' | Summary Created:',datestr(now)],'LineStyle','none','Interpreter','none')
        for j=1:6
            offset=[0,.07, .2,.27,.35, .45];
            annotation('textbox',[0+offset(j),.80,.1,.18],'String',FlyData(j,1:end),'LineStyle','none','FontSize',7,'Interpreter','None','FitBoxToText','on')
        end
        
        ric=round(InitialCoordinates);
        flyroi{1}='ROI';
        for j=1:NumberOfFlies
            flyroi{j+1}=num2str(find(squeeze(RegionOfInterest(ric(j,2),ric(j,1),:))));
            froi(j)=find(squeeze(RegionOfInterest(ric(j,2),ric(j,1),:)));
        end
        annotation('textbox',[.57,.80,.07,.18],'String',flyroi','LineStyle','none','FontSize',7,'Interpreter','None','FitBoxToText','on')
        
        %%%% Plot ref image
        try
        subplot('Position',[.6 .8 .4 .18])
        imshow(FirstFrame);
        for j=1:size(RegionOfInterest,3)
            roi=RegionOfInterest(:,:,j);
            [ix,jx]=ind2sub(size(roi),find(roi));
            if(mean(jx)/size(roi,2)>0.5)
                text(max(jx),min(ix),['ROI #',num2str(j)])
            else
                text(min(jx)-150,min(ix),['ROI #',num2str(j)])
            end
            
        end
        catch
            disp('Error With Ref Image');
            disp(['Error With: ',SAVENAME]);
            
        end
        
        
        
        %%%% heatmap
        try
        hm=plotheatmap(Coordinates,NumberOfFlies,Xscale,Yscale,FirstFrame,FramesPerSecond);
        cmap=colormap(jet(128));
        %cmap(1,:)=[1 1 1];
        colormap(cmap);
        
        caxis([log10(1/FramesPerSecond) log10((size(Coordinates,2)/FramesPerSecond)/60)])
        for j=1:size(RegionOfInterest,3)
            if j==size(RegionOfInterest,3)
                subplot('Position',[0.8 .65-(j-1)*.122-.06 .12 .18])
            else
                subplot('Position',[0.8 .65-(j-1)*.122 .12 .12])
            end
            imagesc(hm.Xe,hm.Ye,hm.sN);
            roi=RegionOfInterest(:,:,j);
            [ix,jx]=ind2sub(size(roi),find(roi));
            axis([min(jx)*Xscale,max(jx)*Xscale,min(ix)*Yscale,max(ix)*Yscale])
            axis('square')
            ax=gca;
            ax.XTick=[];
            ax.YTick=[];
            box off
            ylabel(['ROI #',num2str(j)])
        end
        
        c=colorbar('southoutside');
        c.Label.String='Log_{10}(time) s';
        catch
           disp('Error With heatmaps Image');
            disp(['Error With: ',SAVENAME]); 
        end
        %%%% Stats
        
        
        %%%%% Tracks
        try
        TrackColors=flipud(lines(7));
        TrackColors=[TrackColors;[.5 .5 .5];[0 0 0]; [1 0 0]; [0 1 0]; [0 0 1]];
        for j=1:size(RegionOfInterest,3)
            roi=RegionOfInterest(:,:,j);
            [ix,jx]=ind2sub(size(roi),find(roi));
            
            for seg=1:5
                subplot('Position',[.05+(seg-1)/8 .65-.122*(j-1) .12 .12])
                hold on
                segchunk=floor(size(Coordinates,2)/5);
                flyidx=find(froi==j);
                for ifly=1:numel(flyidx)
                    plot(Coordinates(flyidx(ifly)*2,1+segchunk*(seg-1):segchunk*seg)*Xscale,Coordinates(flyidx(ifly)*2+1,1+segchunk*(seg-1):segchunk*seg)*Yscale,'LineWidth',1.25,'Color',TrackColors(ifly,:))
                end
                axis('square')
                ax=gca;
                ax.XTick=[];
                ax.YTick=[];
                axis ij
                box off
                axis([min(jx)*Xscale,max(jx)*Xscale,min(ix)*Yscale,max(ix)*Yscale])
                if seg==3
                  title(strjoin([{['ROI #',num2str(j)]},unique(FlyData(2,flyidx+1)),{'Sex(s):'},unique(FlyData(3,flyidx+1)),{' Age(s): '},unique(FlyData(4,flyidx+1))]),'FontSize',9);
                end
                if j==size(RegionOfInterest,3)
                    xlabel(60*round(seg*segchunk/(FramesPerSecond*60)))
                end
                if seg==1
                    ylabel(['ROI #',num2str(j)])
                end
            end
        end
        catch
            disp('Error With Tracks Image');
            disp(['Error With: ',SAVENAME]);
        end
        %%velocity information
        
        try
            
        clear vel
        filtersize=30;
        
        nCoord=Coordinates;
        [a b]=ind2sub(size(nCoord),find(isnan(nCoord)));
        % number of NaN's before declared not tracked = 3000 (100 s)
        if numel(a)>0 & numel(a)< 3000
            for ii=1:numel(a)
                try
                 nCoord(a(ii),b(ii))=nanmean([nCoord(a(ii),b(ii)-1),nCoord(a(ii),b(ii)+1)]);
                end
            end
        end
        dCoords=diff(nCoord,1,2);
        
        for j=1:NumberOfFlies
            try
            dCoords(j*2,:)=filtfilt(ones(1,filtersize)/filtersize,1,dCoords(j*2,:));
            dCoords(j*2+1,:)=filtfilt(ones(1,filtersize)/filtersize,1,dCoords(j*2+1,:));
            catch
            end
        end
        for j=1:NumberOfFlies
            vel(j+1,:)=sqrt((dCoords(j*2,:)*Xscale).^2+(dCoords(j*2+1,:)*Yscale).^2).*FramesPerSecond;
        end
        vel(1,:)=Coordinates(1,1:end-1);
        zvel=vel;
        zvel(vel<1.5)=0;
        bvel=zvel;
        bvel(zvel>0)=1;
        kineticinfo=zeros(NumberOfFlies,4);
        kineticinfo(:,1)=1:NumberOfFlies;
       % kineticinfo(:,2)=nansum(zvel(2:end,:),2)/(1000*30);
        kineticinfo(:,2)=sum(zvel(2:end,:),2)/(1000*30);
       % kineticinfo(:,3)=nansum(bvel(2:end,:),2)/size(bvel(2:end,:),2)*100;
        kineticinfo(:,3)=sum(bvel(2:end,:),2)/size(bvel(2:end,:),2)*100;
        kineticinfo(:,4)=(nansum(zvel(2:end,:),2)/(30))./(nansum(bvel(2:end,:),2)/30);
        
        clear ki
        ki(1,:)=[{'#'},{'D (m)'},{' %T'},{'Vel(mm/s)'}];
        for j=1:NumberOfFlies
            ki(j+1,1)={num2str(kineticinfo(j,1),2)};
            ki(j+1,2)={num2str(round(10.*kineticinfo(j,2))./10,2)};
            ki(j+1,3)={num2str(round(kineticinfo(j,3)),2)};
            ki(j+1,4)={num2str(round(10.*kineticinfo(j,4))./10,2)};
        end
        cki=ki(2:end,:);
        for j=1:4
            annotation('textbox',[.636+0.0247*j .68 .12 .10],'String',ki(1,j),'LineStyle','none','FontSize',6,'Interpreter','None','FitBoxToText','on')
        end
        
        for j=1:size(RegionOfInterest,3)
            for k=1:4
                
                annotation('textbox',[.642+0.023*k .65-.122*(j-1) .12 .12],'String',cki(froi==j,k),'LineStyle','none','FontSize',6,'Interpreter','None','FitBoxToText','on')
            end
        end
        catch
            disp('Error With Velocity Info Image');
            disp(['Error With: ',SAVENAME]);
        end
        
        
        %%interactogram
        try
        proxrad=3;
        FlyColor=zeros(0,3);
        for j=1:size(RegionOfInterest,3);
           FlyColor=[FlyColor;TrackColors(1:sum(froi==j),:)];
        end
        for j=1:size(RegionOfInterest,3)
            ipos(1)=min(find(froi==j).*.21/NumberOfFlies);
            ipos(2)=max(find(froi==j).*.21/NumberOfFlies);
            ic(1)=min(2*find(froi==j));
            ic(2)=max(2*find(froi==j)+1);
            h2(j)=subplot('Position',[0.05 0.27-ipos(2) 0.65 ipos(2)-ipos(1)]);
            
            
            interactstats=ProxPlotPrev(WTFiles{i},size(Coordinates,2),proxrad,h2(j),1,1,size(Coordinates,2),1,FlyColor,1);
            ax=axis;
            ax(3)=min(find(froi==j))-0.45;
            ax(4)=max(find(froi==j))+0.75;
            axis(ax);
            ylabel(['#',num2str(j)]);
            axis('ij')
            ax=gca;
            ax.XTick=[];
            ax.YTick=[];
        end
        
        xlabel('Time (s)');
        %ylabel(['Interactions d = ',num2str(proxrad),'mm (Fly #)']);
        catch
            disp('Error With Interactogram Image');
            disp(['Error With: ',SAVENAME]);
        end
        
        %%interaction stats
        clear ki
        ki(1,:)=[{'#'},{'IT'},{' nsIT'},{'nI'},{'nsnI'}];
        for j=1:NumberOfFlies
            ki(j+1,1)={num2str(j)};
            ki(j+1,2)={num2str(round(interactstats (j,1)))};
            ki(j+1,3)={num2str(round(interactstats (j,2)))};
            ki(j+1,4)={num2str(round(interactstats (j,3)))};
            ki(j+1,5)={num2str(round(interactstats (j,4)))};
        end
        for k=1:5
            annotation('textbox',[.72+0.04*k .08 .12 .16],'String',ki(:,k),'LineStyle','none','FontSize',8,'Interpreter','None','FitBoxToText','on')
        end
        
        %%%SaveProtocol
        
%          if i==1
%                         print('-dpsc2','-r600',h,'SPKTEST11.ps')
%                     end
%                     if i~=1
%                         print('-dpsc2','-r600','-append',h,'SPKTEST11.ps')
%                     end
%                     delete(h);
%                 end
%                 TGTFILE=[handles.GROUPPOOL(cg).name{1},'_',TGTflSfx{1}];
%                 ps2pdf('psfile','SPKTEST11.ps','pdffile',[TGTPATH,TGTFILE],'gspapersize','letter');
%                 delete('SPKTEST11.ps');
%                 msgbox('PDF Creation Complete');
        
        succsave=0;
        while succsave==0
            try
                %%print('-dpdf','-r600',gcf,SAVENAME)
                %SAVENAME='test123.ps';
                succsave=1;
                print('-dpdf','-r600',gcf,SAVENAME)
%                 print('-dpsc2','-r600',gcf,SAVENAME)
%                 h2=figure;
%                 set(gcf,'PaperPositionMode','manual');
%                 set(gcf,'Units','inches');
%                 set(gcf,'PaperPosition',[0.1 0.1 8.3 10.8])
%                 nroi=numel(unique(froi));
%                 FD=FlyData(:,2:end);
%                 offset=[0  0.04 .20 .23 .27 .38 .47 .52 .57 .64 .70 .78 .83];
%                 hdr=[{'F#'},{'Genotype'},{'Sex'},{'Age'},{'Cond/Info'},{'init. coord.'},{'D (m)'},{'%T'},{'V(mm/s)'},{'IT (s)'},{'mIT (s)'},{'#I'},{'#mI'}];
%                 for k = 1:nroi
%                     try
%                         for j = 1:6
%                             annotation('textbox',[0+offset(j),.99-.2*k,.1,.2],'String',hdr(j),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on')
%                             annotation('textbox',[0+offset(j),.98-0.2*k,.1,.18],'String',FD(j,froi==k),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on')
%                         end
%                     end
%                     try
%                         for j = 1:3
%                             annotation('textbox',[0+offset(6+j),.99-.2*k,.1,.2],'String',hdr(6+j),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on')
%                             annotation('textbox',[0+offset(6+j),.98-0.2*k,.1,.18],'String',num2str(kineticinfo(froi==k,j+1),2),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on');
%                             mv=nanmean(kineticinfo(froi==k,j+1));
%                             annotation('textbox',[0+offset(6+j),.98-.2*k,.1 .12],'String',num2str(mv,2),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on');
%                         end
%                     end
%                     try
%                         for j = 1:4
%                             annotation('textbox',[0+offset(9+j),.99-.2*k,.1,.2],'String',hdr(9+j),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on')
%                             annotation('textbox',[0+offset(9+j),.98-0.2*k,.1,.18],'String',num2str(interactstats(froi==k,j),3),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on');
%                             mv=nanmean(interactstats(froi==k,j));
%                             annotation('textbox',[0+offset(9+j),.98-.2*k,.1 .12],'String',num2str(mv,3),'LineStyle','none','FontSize',9,'Interpreter','None','FitBoxToText','on');
%                         end
%                     end
%                 end
%                 print('-dpsc2','-r600','-append',h2,SAVENAME);
                %ps2pdf('psfile','temp1.ps','pdffile','test123.pdf','gspapersize','letter');
              winopen(SAVENAME)
                
            catch
                ReSave = questdlg('WARNING: invalid file name select new name');
                if strcmp(ReSave,'Yes')
                    succsave=0;
                    [file, path]=uiputfile(SAVENAME);
                    SAVENAME=[path,file];
                else
                    warndlg('PDF not created')
                    succsave=1;
                end
                
            end
        end
        delete(h1);
        delete(h2)
        
        
        
        
    catch
        
        disp(['Error With: ',SAVENAME]);
        
    end
end
end









function abc=plotheatmap(Coordinates,NumberOfFlies,Xscale,Yscale,FirstFrame,FramesPerSecond)
Resolution=0.5;
LogScale=1;
SC(1,:)=Coordinates(1,:);
for i=1:NumberOfFlies
    SC(i*2,:)=Coordinates(i*2,:)*Xscale;
    SC(i*2+1,:)=Coordinates(i*2+1,:)*Yscale;
end
rSC=round(SC/Resolution)*Resolution;
Xe=[0:Resolution:round(size(FirstFrame,2)*Xscale*Resolution)/Resolution];
Ye=[0:Resolution:round(size(FirstFrame,1)*Yscale*Resolution)/Resolution];
Tmin=1;
if Tmin<1
    Tmin=1;
    set(handles.frame_min_edit,'String',num2str(1));
end
Tmax=size(Coordinates,2);
if Tmax>size(Coordinates,2)
    Tmax=size(Coordinates,2);
    set(handles.frame_max_edit,'String',num2str(size(Coordinates,2)));
end
for i=1:NumberOfFlies
    [N(:,:,i) X Y]=histcounts2(rSC(i*2,Tmin:Tmax),rSC(i*2+1,Tmin:Tmax),Xe,Ye);
end
sN=sum(N,3)*1/FramesPerSecond;
if LogScale==1
    sN=log10(sN);
end
abc.Xe=Xe;
abc.Ye=Ye;
abc.sN=sN';

end