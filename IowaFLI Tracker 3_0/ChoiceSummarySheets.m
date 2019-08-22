function abc=ChoiceSummarySheets(varargin)
alphabet=[{'A'},{'B'},{'C'},{'D'},{'E'},{'F'},{'G'},{'H'}];
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
    try
        %%%%FIGURE INFO
        h1=figure('Visible','on');
        set(gcf,'PaperPositionMode','manual');
        set(gcf,'Units','inches');
        set(gcf,'PaperPosition',[0.1 0.1 8.3 10.8])
        [p n e]=fileparts(WTFiles{i});
        SAVENAME=[p,'\',n,'_SUMMARY.pdf'];
        %%%%load WTF file
        
        load(WTFiles{i},'-mat')
        annotation('textbox',[0 .98 .9 .02],'String',[n,' | Summary Created:',datestr(now)],'LineStyle','none')
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
        subplot('Position',[.6 .82 .4 .18])
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
        FrameSize=size(FirstFrame);
        nTargets=size(Targets,3)
        
        for k=1:size(RegionOfInterest,3)
             tl=1;
            for j=1:nTargets
               
                TargetCoord(j,1)=sum(sum(Targets(:,:,j).*(ones(1,FrameSize(1))'*[1:FrameSize(2)])))/sum(sum(Targets(:,:,j)));
                TargetCoord(j,2)=sum(sum(Targets(:,:,j).*([1:FrameSize(1)]'*ones(1,FrameSize(2)))))/sum(sum(Targets(:,:,j)));
                if (RegionOfInterest(round(TargetCoord(j,2)),round(TargetCoord(j,1)),k))
                    targetname{j}=['T',num2str(k),alphabet{tl}];
                    text(TargetCoord(j,1),TargetCoord(j,2)+35,['T',num2str(k),alphabet{tl}],'Color',[.7 .4 1]);
                    
                    tl=tl+1;
                end
            end
        end
        %%%% heatmap
        hm=plotheatmap(Coordinates,NumberOfFlies,Xscale,Yscale,FirstFrame,FramesPerSecond);
        cmap=colormap((jet(256)));
        cmap(1,:)=[1 1 1];
        colormap(cmap);
        range=5;
        res=0.5;
        
        TC=round([TargetCoord(:,1)*Xscale,TargetCoord(:,2)*Yscale]);
        
        
        hh=hm.sN;
        hh(isinf(hh))=-1.5;
        heatSize=size(hm.sN);
        xv=round(linspace(1,FrameSize(1),heatSize(1)));
        yv=round(linspace(1,FrameSize(2),heatSize(2)));
        
        for j=1:size(RegionOfInterest,3)
            nhh=hh;
            if j==size(RegionOfInterest,3)
                subplot('Position',[0.05+(j-1)*.4 .48 .4 .3])
            else
                subplot('Position',[0.05+(j-1)*.4 .48 .32 .3])
            end
            nhh(~RegionOfInterest(xv,yv,j))=nan;
            imagesc(hm.Xe,hm.Ye,nhh);
            hold all
            for k=1:nTargets
                tX=[0:200];
                tY=TC(k,2)+sqrt(range^2-(tX-TC(k,1)).^2);
                tnY=TC(k,2)-sqrt(range^2-(tX-TC(k,1)).^2);
                plot(tX(imag(tY)==0),tY(imag(tY)==0),'--','Color',[.9 .6 .8],'LineWidth',2);
                plot(tX(imag(tnY)==0),tnY(imag(tnY)==0),'--','Color',[.9 .6 .8],'LineWidth',2);
                if RegionOfInterest(round(TargetCoord(k,2)),round(TargetCoord(k,1)),j)
                    text(TargetCoord(k,1)*Xscale,(TargetCoord(k,2)+35)*Yscale,targetname{k},'Color',[.9 .6 .8],'FontSize',14);
                end
            end
            roi=RegionOfInterest(:,:,j);
            [ix,jx]=ind2sub(size(roi),find(roi));
            axis([min(jx)*Xscale,max(jx)*Xscale,min(ix)*Yscale,max(ix)*Yscale])
            axis('square')
            ax=gca;
            ax.XTick=[];
            ax.YTick=[];
            box off
            ylabel(['ROI #',num2str(j)])
            caxis([-1.6 2])
            
        end
        c=colorbar('eastoutside');
        c.Label.String='Log_{10}(time) s';
        %%%%% Target Loiter Info
        range=5;
        res=0.5;
        T1D=zeros(size(hm.sN));
        yV=[1:size(T1D,1)]*res;
        xV=[1:size(T1D,2)]*res;
        TC=round([TargetCoord(:,1)*Xscale,TargetCoord(:,2)*Yscale]);
        for j=1:size(Targets,3)
            TnT(j)= sum(sum(10.^hm.sN.*logical(sqrt(bsxfun(@plus,(xV-TC(j,1)).^2,(yV-TC(j,2)).^2'))<=range)));
        end
        for k=1:NumberOfFlies
            fRoi(k)=find(RegionOfInterest(ric(k,2),ric(k,1),:));
        end
        for k=1:size(Targets,3)
            tRoi(k)=find(RegionOfInterest(round(TargetCoord(k,2)),round(TargetCoord(k,1)),:));
        end
        TLinfo=[{['T1: ',num2str(TnT(1))]};{['T2: ',num2str(TnT(2))]}];
        for j=1:size(RegionOfInterest,3)
            fR=find(tRoi==j);
            TLinfo{1}=['Tgt','   ','Time(s)','    %T',]
            for k=1:numel(fR)
                TLinfo{k+1}=[targetname{fR(k)},':    ',num2str(round(TnT(fR(k))*10)/10),',    ',num2str(round(1000*TnT(fR(k))./(sum(fRoi==j)*size(Coordinates,2)/FramesPerSecond))/10)];
            end
            gROI=griddedInterpolant(double(RegionOfInterest(:,:,1)));
            xq=linspace(0, size(FirstFrame,2),size(xV,2));
            yq=linspace(0, size(FirstFrame,1),size(yV,2));
            nq=uint8(gROI({yq,xq}));
            nullpercent=sum(sum(logical(sqrt(bsxfun(@plus,(xV-TC(j,1)).^2,(yV-TC(j,2)).^2'))<=range)))/sum(sum(nq));
            TLinfo{k+2}=['         ',num2str(round((sum(fRoi==j)*size(Coordinates,2)/FramesPerSecond))),',    ',num2str(round(nullpercent*1000)/10),'    Range: ',num2str(range),'mm,   Res: ',num2str(res), 'mm'];
            annotation('textbox',[0.05+(j-1)*.4 0.755 0.3 0.06],'String',TLinfo,'FontSize',8,'LineStyle','none')
            
        end
        %%%%% Tracks
        
        for j=1:size(RegionOfInterest,3)
            roi=RegionOfInterest(:,:,j);
            [ix,jx]=ind2sub(size(roi),find(roi));
            
            for seg=1:5
                subplot('Position',[.05+(seg-1)/6 .33-.16*(j-1) .15 .15])
                hold on
                segchunk=floor(size(Coordinates,2)/5);
                for ifly=1:NumberOfFlies
                    plot(Coordinates(ifly*2,1+segchunk*(seg-1):segchunk*seg)*Xscale,Coordinates(ifly*2+1,1+segchunk*(seg-1):segchunk*seg)*Yscale,'LineWidth',1.25)
                end
                axis('square')
                ax=gca;
                ax.XTick=[];
                ax.YTick=[];
                axis ij
                box off
                axis([min(jx)*Xscale,max(jx)*Xscale,min(ix)*Yscale,max(ix)*Yscale])
                if j==size(RegionOfInterest,3)
                    xlabel(60*round(seg*segchunk/(FramesPerSecond*60)))
                end
                if seg==1
                    ylabel(['ROI #',num2str(j)])
                end
            end
        end
        
        %%velocity information
        filtersize=30;
        dCoords=diff(Coordinates,1,2);
        for j=1:NumberOfFlies
            dCoords(j*2,:)=filtfilt(ones(1,filtersize)/filtersize,1,dCoords(j*2,:));
            dCoords(j*2+1,:)=filtfilt(ones(1,filtersize)/filtersize,1,dCoords(j*2+1,:));
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
        kineticinfo(:,2)=sum(zvel(2:end,:),2)/(1000*30);
        kineticinfo(:,3)=sum(bvel(2:end,:),2)/size(bvel(2:end,:),2)*100;
        kineticinfo(:,4)=(sum(zvel(2:end,:),2)/(30))./(sum(bvel(2:end,:),2)/30);
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
            annotation('textbox',[.836+0.0247*j .38 .12 .10],'String',ki(1,j),'LineStyle','none','FontSize',6,'Interpreter','None','FitBoxToText','on')
        end
        
        for j=1:size(RegionOfInterest,3)
            for k=1:4
                
                annotation('textbox',[.842+0.023*k .35-.15*(j-1) .12 .12],'String',cki(froi==j,k),'LineStyle','none','FontSize',6,'Interpreter','None','FitBoxToText','on')
            end
        end
        
        %%%%%Interactions vs Time Charts
        T=[1:size(Coordinates,2)]/30;
        for ii=1:nTargets
            fidx=find(fRoi==tRoi(ii));
            for j=1:numel(fidx)
                Ti(ii).fd(j,:)=sqrt(((Coordinates(fidx(j)*2,:)-TargetCoord(ii,1))*Xscale).^2+((Coordinates(fidx(j)*2+1,:)-TargetCoord(ii,2))*Yscale).^2);
                cmp=lines(fidx(j));
                Ti(ii).c(j,:)=cmp(end,:)
            end
        end
        for j=1:nTargets
            subplot('Position',[.05 0.116-(j-1)*0.032 .8 .027])
            
  
            hold all
            for k=1:size(Ti(j).fd,1)
                plot(T(find(Ti(j).fd(k,:)<5)),k*ones(1,numel(find(Ti(j).fd(k,:)<5))),'+','Color',Ti(j).c(k,:),'LineWidth',1.5)
                plot([min(T),max(T)],ones(2,1)*k,'Color',Ti(j).c(k,:),'LineWidth',1.5)
            end
            cax=axis;
            cax(3:4)=[0 size(Ti(j).fd,1)];
            axis(cax);
            ax=gca;
            ax.XTick=[];
            ax.YTick=[];
            ylabel([targetname{j}])
            box off
            if j==1
                title('Interaction Time')
            end
        end
        
        xlabel('Time')
        
        %%%SaveProtocol
        
        succsave=0;
        while succsave==0
            try
                print('-dpdf','-r600',gcf,SAVENAME)
                succsave=1;
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
        
        
        
    catch
        disp(['Error With: ',SAVENAME]);
    end
end
end




