function ProxPlot(WTFFile, FramesPerPlot,ProximityRadius,PlotEntireVideo,tgtdir,saveasfig,PlotSits,usecolors,varargin)



load(WTFFile, '-mat');
axcolor = get(gca,'ColorOrder');

if NumberOfFlies > 7
   axcolor = [axcolor; 0 .5 .5; 0 1 0]; 
end

if PlotEntireVideo ==1
    FramesPerPlot = Coordinates(1,end);
    Plots = 1;
    Frames = FramesPerPlot;
else
    Plots = Coordinates(1,end)/FramesPerPlot;
    Frames = FramesPerPlot;
end

for plotnum = 1:Plots
    
    ClosePoints = NaN(NumberOfFlies,FramesPerPlot);
    for q = 1:NumberOfFlies
        ClosePoints(q,:) = q;
    end
    ClosePoints(:,1) = -1;
    
    for j = 2:1:FramesPerPlot
        Spots = NaN(1,NumberOfFlies);
        Distance = NaN(1,NumberOfFlies);
        for k = 1:NumberOfFlies
            Xcoord = Coordinates(k*2, j+plotnum*Frames-Frames);
            Ycoord = Coordinates(k*2+1, j+plotnum*Frames-Frames);
            for l = 1:NumberOfFlies
                OtherX = Coordinates(l*2, j+plotnum*Frames-Frames);
                OtherY = Coordinates(l*2+1, j+plotnum*Frames-Frames);
                Distance(l) = realsqrt(((((Xcoord-OtherX)*Xscale)^2) + (((Ycoord-OtherY)*Yscale)^2)));
            end
            
            Spots = find(Distance < ProximityRadius);
            
            
            for x = 1: numel(Spots)
                if Spots(x) ~= ClosePoints(k,j)
                    ClosePoints(k,j) = Spots(x);
                    break;
                end
            end
        end
        for z = 1: NumberOfFlies
            if ClosePoints(z,j) == z
                ClosePoints(z,j) = -1;
            end
        end
    end
    
    PlotMatrix = [];
    StartFrame = plotnum*Frames-Frames +1;
    EndFrame = plotnum*Frames;
for q = 1:NumberOfFlies
 %     ADD IN A DIFFERENT MARK FOR NON-MOTION LASTING > 5 SECONDS
                    if PlotSits == 1
                        
                        WindowCount = 0;
                        PreviousIndex = 0;
                        SittingCoord = zeros(1,Frames);
                        
                        MovedX = abs(diff(Coordinates(q*2,StartFrame:EndFrame)));
                        MovedY = abs(diff(Coordinates(q*2+1,StartFrame:EndFrame)));
                        
                        NoMotionX = (MovedX) < 3;
                        NoMotionY = (MovedY) < 3;
                        
                        sits = find(NoMotionX == NoMotionY);
                        
                        for x = 1:numel(sits)
                            
                            if ((sits(x) - PreviousIndex) == 1)
                                WindowCount = WindowCount+1;
                            else
                                WindowCount = 0;
                            end
                            
                            PreviousIndex = sits(x);
                            
                            
                            if WindowCount>FramesPerSecond*2.5
                                try
                                    SittingCoord(1,sits(x) - FramesPerSecond*5:sits(x)) = .5;
                                catch ME
                                    ME
                                end
                                WindowCount = 0;
                            end
                        end
                       MatrixLine = ClosePoints(q,:);
                       NewLine = MatrixLine + SittingCoord;
                       PlotMatrix = [PlotMatrix; NewLine];
                    else
                       PlotMatrix =ClosePoints; 
                    end
                       
                       
end
    
% determine which fly is which from color scheme
try
    ColorMapping = zeros(1,NumberOfFlies);
    
    for zz = 1:NumberOfFlies
        FoundXPos = Coordinates(2*zz,1);
        FoundYPos = Coordinates(2*zz+1,1);
        
        Distance = 10000;
        Position = 0;
        
        for qq =1:NumberOfFlies
            EnteredXPos = InitialCoordinates(qq,1);
            EnteredYPos = InitialCoordinates(qq,2);
            
            dx = (EnteredXPos - FoundXPos)^2;
            dy = (EnteredYPos - FoundYPos)^2;
            
            if(sqrt(dx+dy) < Distance)
                Distance = sqrt(dx+dy);
                Position = qq;
            end
            
        end
        
        ColorMapping(zz) = Position;
        
    end
catch
    for qq = 1:NumberOfFlies
        ColorMapping(qq) = qq;
    end
end

if(usecolors)
    for qq = 1:NumberOfFlies
        ColorMapping(qq) = qq;
        ColorCodes(qq) =qq;
    end
end

% axcolor(ColorMapping(e),:)

% end of color mapping insert

    f = figure('Visible', 'off');
    
    StartSecond = (Frames*plotnum - Frames) / FramesPerSecond;
    EndSecond = (Frames*plotnum)/FramesPerSecond;
    SecondRatio = 1/FramesPerSecond;
    Seconds = Frames/FramesPerSecond;
    
    if StartSecond < 1
        StartSecond = 0;
    end

    axis([ plotnum*Seconds-Seconds plotnum*Seconds 0 NumberOfFlies+1]);
    hold on;

    for e = 1:numel(ClosePoints(:,1))
        names{e}=['Fly ',num2str(e)];
        scatter(StartSecond+SecondRatio:SecondRatio:EndSecond,PlotMatrix(e,:),150,axcolor(ColorCodes(ColorMapping(e)),:),'+','LineWidth',1.5);
    end
    
    %legend(names)
    
    array = zeros(FramesPerPlot,1);
for e = 1:numel(ClosePoints(:,1))
    array(:,1) = e;
    line(StartSecond+SecondRatio:SecondRatio:EndSecond,array,'Color',axcolor(ColorCodes(ColorMapping(e)),:));
    array = array +.5;
    line(1:Frames,array,'Color',axcolor(ColorCodes(ColorMapping(e)),:),'LineStyle',':');
end
    
    [~,fname,extn]=fileparts(WTFFile);
    SAVENAME=([tgtdir,'\',fname,'_ProxPlot_',num2str(plotnum),'.tif']);
    SAVENAME2=([tgtdir,'\',fname,'_ProxPlot_',num2str(plotnum),'.fig']);
    
    set(0,'CurrentFigure',f)
    print(f,'-dtiff','-r300',SAVENAME)
    
    if exist('WuTrackId','var')
                TextFile = fopen('\\biodata3\wu_lab\Lab\wuTRACK\Contact Sheet DB\Plots.xml','r+');
                fseek(TextFile, -10, 'eof');
                
                fprintf(TextFile,'<Plot>\n');
                fprintf(TextFile,'<Type>Interaction</Type>\n');
                fprintf(TextFile,'<WuTrackID>%s</WuTrackID>\n',num2str(WuTrackID));
                fprintf(TextFile,'<Location>%s</Location>\n',SAVENAME);

                fprintf(TextFile,'<StartFrame>%s</StartFrame>\n',num2str(StartFrame));
                fprintf(TextFile,'<StopFrame>%s</StopFrame>\n',num2str(EndFrame));
                fprintf(TextFile,'<Filter></Filter>\n');
                fprintf(TextFile,'<Filter_Size></Filter_Size>\n');
                   fprintf(TextFile,'<Sits_Marked></Sits_Marked>\n');

                
                   fprintf(TextFile,'<Background_Shown></Background_Shown>\n');

                
                   fprintf(TextFile,'<Individual_Plot></Individual_Plot>\n');

                if usecolors
                   fprintf(TextFile,'<Native_Colors>No</Native_Colors>\n');
                else
                    fprintf(TextFile,'<Native_Colors>Yes</Native_Colors>\n');
                end
                
                   fprintf(TextFile,'<Time_Shown></Time_Shown>\n');

                   fprintf(TextFile,'<Proximity_Marked>Yes</Proximity_Marked>\n');
                   fprintf(TextFile,'<Proximity_Radius>%s</Proximity_Radius>\n',num2str(ProximityRadius));
                if PlotSits
                   fprintf(TextFile,'<Elevate_NonMovements>Yes</Elevate_NonMovements>\n');
                else
                    fprintf(TextFile,'<Elevate_NonMovements>No</Elevate_NonMovements>\n');
                end
                fprintf(TextFile,'<Max_Y_Value></Max_Y_Value>\n');
                fprintf(TextFile,'</Plot>\n');
                fprintf(TextFile,'</Plots>\n');
                fclose(TextFile);
    end
    if saveasfig==1
        saveas(f,SAVENAME2);
    end
    close(f);
    hold off;
end
end
