function [abc,varargout]=ProxPlotPrev(WTFFile, FramesPerPlot,ProximityRadius,input_axes,PlotEntireVideo,StartFrame,EndFrame,PlotSits,usecolors,varargin)


TwoFlies = 0;
ThreeFlies = 0;
FourFlies = 0;
FiveFlies = 0;

load(WTFFile, '-mat');
axcolor = get(gca,'ColorOrder');

if NumberOfFlies > 7
   axcolor = [axcolor; 0 .5 .5; 0 1 0]; 
end
if NumberOfFlies > 8
   axcolor = lines(NumberOfFlies); 
end

if numel(usecolors)>1
    axcolor=usecolors;
end
    

if PlotEntireVideo ==1
    FramesPerPlot = Coordinates(1,end);
    StartFrame = 1;
    EndFrame = Coordinates(1,end);
end

if EndFrame > Coordinates(1,end)
    EndFrame = Coordinates(1,end);
end

ClosePoints = NaN(NumberOfFlies,EndFrame-StartFrame);
for q = 1:NumberOfFlies
    ClosePoints(q,:) = q;
end
ClosePoints(:,1) = -1;

for j = StartFrame+1:1:EndFrame-1
    Spots = NaN(1,NumberOfFlies);
    Distance = NaN(1,NumberOfFlies);
    if j==1000
        1;
    end
    for k = 1:NumberOfFlies
        Xcoord = Coordinates(k*2, j);
        Ycoord = Coordinates(k*2+1, j);
        for l = 1:NumberOfFlies
            OtherX = Coordinates(l*2, j);
            OtherY = Coordinates(l*2+1, j);
            Distance(l) = realsqrt(((((Xcoord-OtherX)*Xscale)^2) + (((Ycoord-OtherY)*Yscale)^2)));
        end
        
        Spots = find(Distance < ProximityRadius);
        switch numel(Spots)
            case 2
                TwoFlies = TwoFlies +1;
                
            case 3
                ThreeFlies = ThreeFlies+1;
                
            case 4
                FourFlies = FourFlies+1;
            case 5
                FiveFlies = FiveFlies+1;
                
        end
        
        for x = 1: numel(Spots)
            if Spots(x) ~= ClosePoints(k,j-StartFrame)
                ClosePoints(k,j - StartFrame) = Spots(x);
                break;
            end
            
        end
        if isempty(Spots)
            ClosePoints(k,j-StartFrame) = NaN;
        end
        
    end
    for z = 1: NumberOfFlies
        if ClosePoints(z,j - StartFrame) == z
            ClosePoints(z,j - StartFrame) = -1;
        end
    end
    
end

PlotMatrix = [];
isSitting= [];
for q = 1:NumberOfFlies
    %     ADD IN A DIFFERENT MARK FOR NON-MOTION LASTING > 5 SECONDS
    if PlotSits == 1
        
        WindowCount = 0;
        PreviousIndex = 0;
        SittingCoord = zeros(1,EndFrame-StartFrame);
        
        MovedX = Xscale.*abs(diff(Coordinates(q*2,StartFrame:EndFrame)));
        MovedY = Yscale.*abs(diff(Coordinates(q*2+1,StartFrame:EndFrame)));
        
        vel = sqrt(MovedX.^2+MovedY.^2)*FramesPerSecond;
        vel(isnan(vel))=0;
        vel(isinf(vel))=0;
        try
        fvel=filtfilt(1/FramesPerSecond.*ones(FramesPerSecond,1),1,vel);%% one sec running ave filter
        catch
            fvel=vel;
            disp('filter not used')
        end
        
        NoMotionX = (MovedX) < .1;
        NoMotionY = (MovedY) < .1;
        
        sits = find(NoMotionX == NoMotionY);
        sits = find(fvel<1);
        for x = 1:numel(sits)
            
            if ((sits(x) - PreviousIndex) == 1)
                WindowCount = WindowCount+1;
            else
                WindowCount = 0;
            end
            
            PreviousIndex = sits(x);
            
            
            if WindowCount>FramesPerSecond*2.5
                try
                    SittingCoord(1,sits(x) - FramesPerSecond*5:sits(x)) = 0.25;
                catch ME
                    ME
                end
                WindowCount = 0;
            end
        end
        MatrixLine = ClosePoints(q,:);
        NewLine = MatrixLine + SittingCoord;
        isSitting = [isSitting;SittingCoord];
        PlotMatrix = [PlotMatrix; NewLine];
    else
        PlotMatrix =ClosePoints;
    end
    
    
end




StartSecond = StartFrame / FramesPerSecond;
EndSecond = (EndFrame)/FramesPerSecond;
SecondRatio = 1/FramesPerSecond;


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

%if numel(usecolors)==1;
    for qq = 1:NumberOfFlies
        ColorMapping(qq) = qq;
        ColorCodes(qq) = qq;
    end
%end

% axcolor(ColorMapping(i),:)

% end of color mapping insert


%links in the previewing to the axes on the wu_TRACK_GUI
axes(input_axes);
axis([StartSecond  EndSecond 0 NumberOfFlies+1]);
%set(input_axes,'YGrid','on');



set(input_axes,'LineWidth', 1);
hold on;



for e = 1:numel(ClosePoints(:,1))
    scatter(StartSecond:SecondRatio:(EndSecond - SecondRatio),PlotMatrix(e,:),0.1+75.*double(isSitting(e,:)==0),axcolor(ColorCodes(ColorMapping(e)),:),'+','LineWidth',1,'MarkerEdgeAlpha',0.25);
    scatter(StartSecond:SecondRatio:(EndSecond - SecondRatio),PlotMatrix(e,:),0.1+15.*double(~isSitting(e,:)==0),axcolor(ColorCodes(ColorMapping(e)),:),'+','LineWidth',1,'MarkerEdgeAlpha',0.25);
end
warning('off', 'MATLAB:legend:IgnoringExtraEntries');
%stats = {['Two Flies: ' num2str(TwoFlies)]; ['Three Flies: ' num2str(ThreeFlies)]; ['Four Flies: ' num2str(FourFlies)]};

%legend_handle = legend(stats);
%set(legend_handle, 'Color', 'None')

array = zeros(EndFrame,1);
for e = 1:numel(ClosePoints(:,1))
    array(:,1) = e;
    line(1:EndFrame,array,'Color',axcolor(ColorCodes(ColorMapping(e)),:),'LineWidth',1);
    array = array +.25;
    line(1:EndFrame,array,'Color',axcolor(ColorCodes(ColorMapping(e)),:),'LineStyle',':');
end
%total time interacting
abc(1,:)=sum((PlotMatrix(:,:)>0),2)/FramesPerSecond;
abc(1,sum(isnan(PlotMatrix),2)>3000)=nan;
%non-sit time interacting
abc(2,:)=sum((PlotMatrix(:,:)>0).*(PlotMatrix==round(PlotMatrix)),2)/FramesPerSecond;
abc(2,sum(isnan(PlotMatrix),2)>3000)=nan;
% number of interactions
abc(3,:)=sum(diff(PlotMatrix>0,1,2)==1,2);
abc(3,sum(isnan(PlotMatrix),2)>3000)=nan;
% number of non-sit interactions
abc(4,:)=sum(diff(((PlotMatrix(:,:)>0).*(PlotMatrix==round(PlotMatrix))),1,2)==1,2);
abc(4,sum(isnan(PlotMatrix),2)>3000)=nan;

varargout{1} = PlotMatrix;

abc=abc';
end
