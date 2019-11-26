function varargout = plottracksGUI_2(varargin)
% PLOTTRACKSGUI_2 MATLAB code for plottracksGUI_2.fig
%      PLOTTRACKSGUI_2, by itself, creates a new PLOTTRACKSGUI_2 or raises the existing
%      singleton*.
%
%      H = PLOTTRACKSGUI_2 returns the handle to a new PLOTTRACKSGUI_2 or the handle to
%      the existing singleton*.
%
%      PLOTTRACKSGUI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTTRACKSGUI_2.M with the given input arguments.
%
%      PLOTTRACKSGUI_2('Property','Value',...) creates a new PLOTTRACKSGUI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plottracksGUI_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plottracksGUI_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plottracksGUI_2

% Last Modified by GUIDE v2.5 16-Aug-2019 15:00:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plottracksGUI_2_OpeningFcn, ...
    'gui_OutputFcn',  @plottracksGUI_2_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before plottracksGUI_2 is made visible.
function plottracksGUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plottracksGUI_2 (see VARARGIN)

% Choose default command line output for plottracksGUI_2
handles.output = hObject;
handles.wtfs=varargin{2};
handles.wtfpaths=varargin{1};
handles.Selectedwtfs=1;
set(handles.wtf_list,'String',handles.wtfs);
load([handles.wtfpaths{1},handles.wtfs{1}],'-mat');
set(handles.wtf_info_table,'Data',FlyData(2:end,2:end));
set(handles.start_fr_edit,'String',num2str(1));
set(handles.stop_fr_edit,'String',num2str(size(Coordinates,2)));
set(handles.prox_rad_edit,'String',num2str(1));
set(handles.plot_type_menu,'String',{'Plot all frames';'Single interval';'Use interval size'});
set(handles.int_sz_edit,'String',num2str(900));
set(handles.start_fr_edit,'Enable','off');
set(handles.stop_fr_edit,'Enable','off');
set(handles.int_sz_edit,'Enable','off');
set(handles.prox_rad_edit,'Enable','off');
set(handles.MarkSits_chk,'Value',1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plottracksGUI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plottracksGUI_2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in expt_sel_btn.
function expt_sel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to expt_sel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [PATHNAME, fname extension]=fileparts([handles.wtfpaths{handles.Selectedwtfs},handles.wtfs{handles.Selectedwtfs}]);
    [file,path]=uiputfile([fname,'.jpg'],'Save file as',[PATHNAME,'\',fname,'.jpg']);
    SAVENAME=[path,file];
    [PATHNAME,FNAME,EXTN]=fileparts(SAVENAME);
    SAVENAME2=[PATHNAME,'\',FNAME,'.fig'];
    
    nwtfe=size(handles.wtfs,1);
    f = figure('Visible', 'off');
    tgtax=f.Children;
    plottype=get(handles.plot_type_menu,'Value');
    axcolor = get(gca,'ColorOrder');
    axcolor(8:12,:) = 0;
    
    plot_trx(hObject,eventdata,handles,tgtax)
    print(f,'-dtiff','-r300',[SAVENAME])
         
        
 
catch me
    me
    msgbox('Plotting of tracks failed');
end

% --- Executes on selection change in wtf_list.
function wtf_list_Callback(hObject, eventdata, handles)
% hObject    handle to wtf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wtf_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wtf_list
handles.Selectedwtfs=get(hObject,'Value');
load([handles.wtfpaths{handles.Selectedwtfs(1)},handles.wtfs{handles.Selectedwtfs(1)}],'-mat');
set(handles.wtf_info_table,'Data',FlyData(2:end,2:end));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function wtf_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wtf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_trx(hObject,eventdata,handles,tgtax)
axcolor = get(gca,'ColorOrder'); % generates the color order for plotting
axcolor=[axcolor;axcolor;axcolor;axcolor;axcolor;axcolor;];
%axcolor(8:12,:) = 0;
axes=tgtax;
hold all




cla;
newplot;
set(gca,'XTick',[]);
set(gca,'YTick',[]);
hold on
load([handles.wtfpaths{handles.Selectedwtfs(1)},handles.wtfs{handles.Selectedwtfs(1)}],'-mat');
plottype=get(handles.plot_type_menu,'Value');
if plottype==1
    startfr=1;
    stopfr=size(Coordinates,2);
end
if plottype==2
    startfr=str2num(get(handles.start_fr_edit,'String'));
    stopfr=str2num(get(handles.stop_fr_edit,'String'));
end
if plottype==3
    startfr=str2num(get(handles.start_fr_edit,'String'));
    stopfr=str2num(get(handles.int_sz_edit,'String'))+startfr-1;
end
if stopfr>size(Coordinates,2)
    stopfr=size(Coordinates,2);
    warndlg('Warning: Stop Frame exceeds Last Frame of video, reverting to Last Frame');
    uiwait;
end
if get(handles.prox_chk,'Value')==1
    CloseValue=str2num(get(handles.prox_rad_edit,'String'));
    ClosePoints=NaN(NumberOfFlies*2,size(Coordinates,2));
    % Spots is an array holding the local locations of where flies are "close"
    Spots = NaN(NumberOfFlies,NumberOfFlies,size(Coordinates,2));
    % Distance is an array holding how far apart each fly is
    Distance = NaN(NumberOfFlies,NumberOfFlies,size(Coordinates,2));
    for k = 1:NumberOfFlies
        Xcoord = Coordinates(k*2,:);
        Ycoord = Coordinates(k*2+1,:);
        for l = 1:NumberOfFlies
            OtherX = Coordinates(l*2,:);
            OtherY = Coordinates(l*2+1,:);
            % This fills the distance array with triangulated
            % distances to each of the other flies in the frame
            Distance(k,l,:) = realsqrt(((((Xcoord-OtherX)*Xscale).^2) + (((Ycoord-OtherY)*Yscale).^2)));
        end
    end
    for k=1:NumberOfFlies
        %SelfDistances(k,k,:) = Distance(k,k,:);
        Distance(k,k,:) = NaN; % The fly will have no distance to itself so that entry is cleared
    end
    for k=1:NumberOfFlies
        Spots(find(Distance<CloseValue))=1;
        Contacts=nansum(Spots);
        Contacts=shiftdim(Contacts);
        ClosePoints(k*2-1,find(Contacts(k,:)))=Coordinates(k*2,find(Contacts(k,:)));
        ClosePoints(k*2,find(Contacts(k,:)))=Coordinates(k*2+1,find(Contacts(k,:)));
    end
    
    
end

numflies=NumberOfFlies;
if get(handles.single_fly_chk,'Value')==1
    numflies=1;
end
if get(handles.bkgnd_btn,'Value')==1
    imshow(FirstFrame);
end

% % determine which fly is which from color scheme
try
    ColorMapping = zeros(1,NumberOfFlies);
    ColorCodes;
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
        ColorCodes(qq) = qq;
    end
end

% if(get(handles.dont_use_colors_chk,'value'))
%     for qq = 1:NumberOfFlies
%         ColorMapping(qq) = qq;
%         ColorCodes(qq) = qq;
%     end
%     
% end

%axcolor(ColorMapping(k),:)

% end of color mapping insert
hold all
for k=1:numflies
    trkplt(k)=plot(Coordinates(k*2,startfr:stopfr),Coordinates(k*2+1,startfr:stopfr),'Color',axcolor(ColorCodes(ColorMapping(k)),:),'LineWidth', 2,'DisplayName',FlyData{2,ColorMapping(k)+1});
    if get(handles.prox_chk,'Value')==1
        plot(ClosePoints(k*2-1,startfr:stopfr),ClosePoints(k*2,startfr:stopfr),'Color',axcolor(ColorCodes(ColorMapping(k)),:),'LineWidth',8);
        %Below is the original
        %plot(ClosePoints(i*2-1,startfr:stopfr),ClosePoints(i*2,startfr:stopfr),'.','Color',axcolor(ColorCodes(ColorMapping(i)),:),'MarkerSize',20);
    end

    
    %     ADD IN A DIFFERENT MARK FOR NON-MOTION LASTING > 5 SECONDS
    if get(handles.MarkSits_chk,'Value')
        WindowCount = 0;
        PreviousIndex = 0;
        index = 0;
        
        MovedX = abs(diff(Coordinates(k*2,startfr:stopfr)));
        MovedY = abs(diff(Coordinates(k*2+1,startfr:stopfr)));
        
        NoMotionX = (MovedX) < 1.1;
        NoMotionY = (MovedY) < 1.1;
        
        sits = find(NoMotionX == NoMotionY);
        
        for x = 1:numel(sits)
            
            if ((sits(x) - PreviousIndex) == 1)
                WindowCount = WindowCount+1;
            else
                WindowCount = 0;
            end
            
            PreviousIndex = sits(x);
            
            
            if WindowCount>FramesPerSecond*5.5
                try
                    SittingCoord(k*2-1,sits(x) - FramesPerSecond*5:sits(x)) = Coordinates(k*2,startfr+sits(x)-FramesPerSecond*5:startfr+sits(x));
                    SittingCoord(k*2,sits(x)- FramesPerSecond*5:sits(x)) = Coordinates(k*2+1,startfr+sits(x)-FramesPerSecond*5:startfr+sits(x));
                catch ME
                    ME
                end
                WindowCount = 0;
            end
        end
        
        try
            plot(SittingCoord(k*2-1,:),SittingCoord(k*2,:),'x','Color',axcolor(ColorCodes(ColorMapping(k)),:),'MarkerSize',10);
        end
    end
end
axis([1,size(FirstFrame,2),1,size(FirstFrame,1)])
axis ij
showframes = get(handles.show_frames_chk,'Value');
if (showframes)
                    StartSeconds = startfr/FramesPerSecond;
                    StopSeconds = stopfr/FramesPerSecond;
                    
                    StartMinute = floor(StartSeconds/60);
                    StopMinute = floor(StopSeconds/60);
                    
                    StartSeconds = floor(StartSeconds-(StartMinute * 60));
                    StopSeconds = floor(StopSeconds - (StopMinute * 60));
                    
                    Minute1 = num2str(StartMinute);
                    Second1 = num2str(StartSeconds);
                    
                    Minute2 = num2str(StopMinute);
                    Second2 = num2str(StopSeconds);
                    
                    if numel(Minute1) < 2
                       Minute1 = ['0' Minute1]; 
                    end
                    if numel(Minute2) < 2
                       Minute2 = ['0' Minute2];
                    end
                    
                    if numel(Second1) < 2
                        Second1 = ['0' Second1];
                    end
                    if numel(Second2) <2
                       Second2 = ['0' Second2]; 
                    end
                    
text(10,10,['Duration Plotted (mm:ss): ',Minute1 ':' Second1 ' - ' Minute2 ':' Second2]);
%text(545,465,[num2str(FramesPerSecond) ' FPS']);
end
    if get(handles.legend_chk,'Value')==1
    legend(FlyData(1,2:17))
end
hold off

% --- Executes on button press in prev_plt_btn.
function prev_plt_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prev_plt_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.fig_chk.Value
    figure;
    tgtax=gca;
else
    tgtax=handles.axes1;
end
plot_trx(hObject,eventdata,handles,tgtax)



% --- Executes on button press in expt_all_btn.
function expt_all_btn_Callback(hObject, eventdata, handles)
% hObject    handle to expt_all_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% try

PATH=uigetdir;
WTFFILES=(handles.wtf_list.String);
cval=handles.wtf_list.Value;
for i=1:numel(WTFFILES)
    [p n e]=fileparts(WTFFILES{i});
    SAVENAME=[PATH,'\',n,'.jpg'];
    handles.wtf_list.Value=i;
    f = figure('Visible', 'off');
    tgtax=f.Children;
    plot_trx(hObject,eventdata,handles,tgtax)
    print(f,'-dtiff','-r300',[SAVENAME])
    %close f
end
handles.wtf_list.Value=cval

% nwtfe=size(handles.wtfs,1);
% f = figure('Visible', 'off');
% set(0,'CurrentFigure',f)
% plottype=get(handles.plot_type_menu,'Value');
% axcolor = get(gca,'ColorOrder');
% axcolor(8:12,:) = 0;
% 
% 
% tgtdir=uigetdir;
% 
% for i=1:nwtfe
%     
%     load([handles.wtfpaths{i},handles.wtfs{i}],'-mat');
%     
%     
%     switch plottype
%         
%         case 1
%             nchunk=1;
%             startfr=1;
%             stopfr=size(Coordinates,2);
%             intervsize=1;
%             
%         case 2
%             nchunk=1;
%             startfr=str2num(get(handles.start_fr_edit,'String'));
%             stopfr=str2num(get(handles.stop_fr_edit,'String'));
%             intervsize=1;
%             if stopfr > size(Coordinates,2)
%                 stopfr = size(Coordinates,2);
%             end
%             
%         case 3
%             startfr=str2num(get(handles.start_fr_edit,'String'));
%             stopfr=str2num(get(handles.stop_fr_edit,'String'));
%             if stopfr > size(Coordinates,2)
%                 stopfr = size(Coordinates,2);
%             end
%             
%             nchunk=ceil((stopfr-startfr)/str2num(get(handles.int_sz_edit,'String')));
%             
%             stopfr = str2num(get(handles.int_sz_edit,'String'));
%             
%             intervsize=str2num(get(handles.int_sz_edit,'String'));
%             
%     end
%     
%     nplts=1;
%     numflies=NumberOfFlies;
%     
%     if get(handles.single_fly_chk,'Value')==1
%         nplts=NumberOfFlies;
%         numflies=1;
%     end
%     
%     
%     if get(handles.prox_chk,'Value')==1
%         CloseValue=str2num(get(handles.prox_rad_edit,'String'));
%         ClosePoints=NaN(NumberOfFlies*2,size(Coordinates,2));
%         % Spots is an array holding the local locations of where flies are "close"
%         Spots = NaN(NumberOfFlies,NumberOfFlies,size(Coordinates,2));
%         % Distance is an array holding how far apart each fly is
%         Distance = NaN(NumberOfFlies,NumberOfFlies,size(Coordinates,2));
%         for k = 1:NumberOfFlies
%             Xcoord = Coordinates(k*2,:);
%             Ycoord = Coordinates(k*2+1,:);
%             for l = 1:NumberOfFlies
%                 OtherX = Coordinates(l*2,:);
%                 OtherY = Coordinates(l*2+1,:);
%                 % This fills the distance array with triangulated
%                 % distances to each of the other flies in the frame
%                 Distance(k,l,:) = realsqrt(((((Xcoord-OtherX)*Xscale).^2) + (((Ycoord-OtherY)*Yscale).^2)));
%             end
%         end
%         for k=1:NumberOfFlies
%             Distance(k,k,:) = NaN; % The fly will have no distance to itself so that entry is cleared
%         end
%         for k=1:NumberOfFlies
%             Spots(find(Distance<CloseValue))=1;
%             Contacts=nansum(Spots);
%             Contacts=shiftdim(Contacts);
%             ClosePoints(k*2-1,find(Contacts(k,:)))=Coordinates(k*2,find(Contacts(k,:)));
%             ClosePoints(k*2,find(Contacts(k,:)))=Coordinates(k*2+1,find(Contacts(k,:)));
%         end
%     end
%     
%     
%     
%     for j=1:nchunk
%         
%         for k=1:nplts
%             
%             
%             newplot;
%             set(0,'CurrentFigure',f)
%             set(gca,'XTick',[]);
%             set(gca,'YTick',[]);
%             axis([1,size(FirstFrame,2),1,size(FirstFrame,1)])
%             axis ij
%             if (get(handles.show_frames_chk,'Value'))
%                                StartSeconds = startfr/FramesPerSecond;
%                     StopSeconds = stopfr/FramesPerSecond;
%                     
%                     StartMinute = floor(StartSeconds/60);
%                     StopMinute = floor(StopSeconds/60);
%                     
%                     StartSeconds = floor(StartSeconds-(StartMinute * 60));
%                     StopSeconds = floor(StopSeconds - (StopMinute * 60));
%                     
%                     Minute1 = num2str(StartMinute);
%                     Second1 = num2str(StartSeconds);
%                     
%                     Minute2 = num2str(StopMinute);
%                     Second2 = num2str(StopSeconds);
%                     
%                     if numel(Minute1) < 2
%                        Minute1 = ['0' Minute1]; 
%                     end
%                     if numel(Minute2) < 2
%                        Minute2 = ['0' Minute2];
%                     end
%                     
%                     if numel(Second1) < 2
%                         Second1 = ['0' Second1];
%                     end
%                     if numel(Second2) <2
%                        Second2 = ['0' Second2]; 
%                     end
%                     
% text(10,465,[Minute1 ':' Second1 ' - ' Minute2 ':' Second2]);
%             end
%             hold on
%             
%             if get(handles.bkgnd_btn,'Value')==1
%                 imshow(FirstFrame);
%                 hold on
%             end
%             
%             if get(handles.single_fly_chk,'Value')==1
%                 numflies=1;
%             end
%             
%             % determine which fly is which from color scheme
%             try
%                 ColorMapping = zeros(1,NumberOfFlies);
%                 ColorCodes;
%                 for zz = 1:NumberOfFlies
%                     FoundXPos = Coordinates(2*zz,1);
%                     FoundYPos = Coordinates(2*zz+1,1);
%                     
%                     Distance = 10000;
%                     Position = 0;
%                     
%                     for qq =1:NumberOfFlies
%                         EnteredXPos = InitialCoordinates(qq,1);
%                         EnteredYPos = InitialCoordinates(qq,2);
%                         
%                         dx = (EnteredXPos - FoundXPos)^2;
%                         dy = (EnteredYPos - FoundYPos)^2;
%                         
%                         if(sqrt(dx+dy) < Distance)
%                             Distance = sqrt(dx+dy);
%                             Position = qq;
%                         end
%                         
%                     end
%                     
%                     ColorMapping(zz) = Position;
%                     
%                 end
%             catch
%                 for qq = 1:NumberOfFlies
%                     ColorMapping(qq) = qq;
%                     ColorCodes(qq) = qq;
%                 end
%             end
%             
% %             if(get(handles.dont_use_colors_chk,'value'))
% %                 for qq = 1:NumberOfFlies
% %                     ColorMapping(qq) = qq;
% %                     ColorCodes(qq) = qq;
% %                 end
% %             end
%             
%             % axcolor(ColorMapping(l),:)
%             
%             % end of color mapping insert
%             
%             
%             
%             for l=1:numflies
%                 hold on
%                 if get(handles.single_fly_chk,'Value')==1
%                     l=k;
%                 end
%                 
%                 
%                 plot(Coordinates(l*2,startfr:stopfr),Coordinates(l*2+1,startfr:stopfr),'Color',axcolor(ColorCodes(ColorMapping(l)),:),'LineWidth', 2,'DisplayName',['Fly #',num2str(l)]);
%                 
%                 
%                 if get(handles.prox_chk,'Value')==1
%                     plot(ClosePoints(l*2-1,startfr:stopfr),ClosePoints(l*2,startfr:stopfr),'.','Color',axcolor(ColorCodes(ColorMapping(l)),:),'MarkerSize',20);
%                 end
%                 
%                 
%                 if get(handles.single_fly_chk,'Value')==1
%                     l=1;
%                 end
%                 
%             end
%             hold off
%             if get(handles.legend_chk,'Value')==1
%                 hold on
%                 trkplt(l)=plot(Coordinates(l*2,startfr:stopfr),Coordinates(l*2+1,startfr:stopfr),'Color',axcolor(ColorCodes(ColorMapping(l)),:),'LineWidth', 2,'DisplayName',FlyData(2,ColorMapping(l)+1));
%                 legend(trkplt);
%                 hold off
%             end
%             for q = 1:numflies
%                 %     ADD IN A DIFFERENT MARK FOR NON-MOTION LASTING > 5 SECONDS
%                 if get(handles.MarkSits_chk,'Value')
%                     set(0,'CurrentFigure',f)
%                     hold on
%                     WindowCount = 0;
%                     PreviousIndex = 0;
%                     index = 0;
%                     SittingCoord = [];
%                     
%                     MovedX = abs(diff(Coordinates(q*2,startfr:stopfr)));
%                     MovedY = abs(diff(Coordinates(q*2+1,startfr:stopfr)));
%                     
%                     NoMotionX = (MovedX) < 1.1;
%                     NoMotionY = (MovedY) < 1.1;
%                     
%                     sits = find(NoMotionX == NoMotionY);
%                     
%                     for x = 1:numel(sits)
%                         
%                         if ((sits(x) - PreviousIndex) == 1)
%                             WindowCount = WindowCount+1;
%                         else
%                             WindowCount = 0;
%                         end
%                         
%                         PreviousIndex = sits(x);
%                         
%                         
%                         if WindowCount>FramesPerSecond*5.5
%                             try
%                                 SittingCoord(q*2-1,sits(x) - FramesPerSecond*5:sits(x)) = Coordinates(q*2,startfr+sits(x)-FramesPerSecond*5:startfr+sits(x));
%                                 SittingCoord(q*2,sits(x)- FramesPerSecond*5:sits(x)) = Coordinates(q*2+1,startfr+sits(x)-FramesPerSecond*5:startfr+sits(x));
%                             catch ME
%                                 ME
%                             end
%                             WindowCount = 0;
%                         end
%                     end
%                     
%                     try
%                         plot(SittingCoord(q*2-1,:),SittingCoord(q*2,:),'x','Color',axcolor(ColorCodes(ColorMapping(q)),:),'MarkerSize',10);
%                     catch ME
%                         ME
%                     end
%                     hold off
%                 end
%             end
%             
%             
%             if get(handles.fig_chk,'Value')==1
%                 saveas(f,SAVENAME2);
%             end
%             
%             [~, fname extension]=fileparts([handles.wtfpaths{i},handles.wtfs{i}]);
%             SAVENAME=[tgtdir,'\',fname,'_',num2str(j),'_',num2str(k),'.jpg'];
%             SAVENAME2=[tgtdir,'\',fname,'_',num2str(j),'_',num2str(k),'.fig'];
%             
%             
%             
%             print(f,'-dtiff','-r300',SAVENAME)
%  
%             if exist('WuTrackId','var')
%                 TextFile = fopen('\\biodata3\wu_lab\Lab\wuTRACK\Contact Sheet DB\Plots.xml','r+');
%                 fseek(TextFile, -10, 'eof');
%                 
%                 fprintf(TextFile,'<Plot>\n');
%                 fprintf(TextFile,'<Type>Tracks</Type>\n');
%                 fprintf(TextFile,'<WuTrackID>%s</WuTrackID>\n',num2str(WuTrackID));
%                 fprintf(TextFile,'<Location>%s</Location>\n',SAVENAME);
% 
%                 fprintf(TextFile,'<StartFrame>%s</StartFrame>\n',num2str(startfr));
%                 fprintf(TextFile,'<StopFrame>%s</StopFrame>\n',num2str(stopfr));
%                                 fprintf(TextFile,'<Filter></Filter>\n');
%                 fprintf(TextFile,'<Filter_Size></Filter_Size>\n');
%                                 if get(handles.MarkSits_chk,'value')
%                    fprintf(TextFile,'<Sits_Marked>Yes</Sits_Marked>\n');
%                 else
%                     fprintf(TextFile,'<Sits_Marked>No</Sits_Marked>\n');
%                 end
%                 if get(handles.bkgnd_btn,'value')
%                    fprintf(TextFile,'<Background_Shown>Yes</Background_Shown>\n');
%                 else
%                     fprintf(TextFile,'<Background_Shown>No</Background_Shown>\n');
%                 end
%                 if get(handles.single_fly_chk,'value')
%                    fprintf(TextFile,'<Individual_Plot>Yes</Individual_Plot>\n');
%                 else
%                     fprintf(TextFile,'<Individual_Plot>No</Individual_Plot>\n');
%                 end
%                 if get(handles.dont_use_colors_chk,'value')
%                    fprintf(TextFile,'<Native_Colors>No</Native_Colors>\n');
%                 else
%                     fprintf(TextFile,'<Native_Colors>Yes</Native_Colors>\n');
%                 end
%                 if get(handles.show_frames_chk,'value')
%                    fprintf(TextFile,'<Time_Shown>Yes</Time_Shown>\n');
%                 else
%                     fprintf(TextFile,'<Time_Shown>No</Time_Shown>\n');
%                 end
%                 if get(handles.prox_chk,'value')
%                    fprintf(TextFile,'<Proximity_Marked>Yes</Proximity_Marked>\n');
%                    fprintf(TextFile,'<Proximity_Radius>%s</Proximity_Radius>\n',get(handles.prox_rad_edit,'string'));
%                 else
%                     fprintf(TextFile,'<Proximity_Marked>No</Proximity_Marked>\n');
%                     fprintf(TextFile,'<Proximity_Radius></Proximity_Radius>\n');
%                 end
%                 fprintf(TextFile,'<Elevate_NonMovements></Elevate_NonMovements>');
%                 fprintf(TextFile,'<Max_Y_Value></Max_Y_Value>\n');
%                 fprintf(TextFile,'</Plot>\n');
%                 fprintf(TextFile,'</Plots>\n');
%                 fclose(TextFile);
%         end
%             
%             
%         end
%         
%         if plottype==3
%             startfr=stopfr+1;
%             stopfr=stopfr+intervsize;
%             
%             if stopfr > size(Coordinates,2)
%                 stopfr =  size(Coordinates,2);
%             end
%             
%         end
%         
%         
%         
%     end
%     
% end
% close(f);
% 
% msgbox(['Successfully Created Plots for ', num2str(i), ' WTF files'],'Success!');
% % catch ME
% %     ME;
% %     msgbox(['Failed to Create Plots after the ', num2str(i), ' WTF file'],'Failed!');
% % end


% --- Executes on button press in bkgnd_btn.
function bkgnd_btn_Callback(hObject, eventdata, handles)
% hObject    handle to bkgnd_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bkgnd_btn


% --- Executes on button press in single_fly_chk.
function single_fly_chk_Callback(hObject, eventdata, handles)
% hObject    handle to single_fly_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of single_fly_chk


% --- Executes on button press in fig_chk.
function fig_chk_Callback(hObject, eventdata, handles)
% hObject    handle to fig_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fig_chk


% --- Executes on button press in prox_chk.
function prox_chk_Callback(hObject, eventdata, handles)
% hObject    handle to prox_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prox_chk
chk=get(hObject,'Value');
if chk==1
    set(handles.prox_rad_edit,'Enable','on');
end
if chk==0
    set(handles.prox_rad_edit,'Enable','off');
end
guidata(hObject,handles);


function prox_rad_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prox_rad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prox_rad_edit as text
%        str2double(get(hObject,'String')) returns contents of prox_rad_edit as a double
fnums=get(hObject,'String');
fnum=str2num(fnums);
if isempty(fnum)
    fnum=1;
end
if fnum<0.0001
    fnum=0.0001;
end

set(hObject,'String',num2str(fnum));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function prox_rad_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prox_rad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_fr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start_fr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_fr_edit as text
%        str2double(get(hObject,'String')) returns contents of start_fr_edit as a double
fnums=get(hObject,'String');
stframe=str2num(get(handles.stop_fr_edit,'String'));
fnum=str2num(fnums);
if isempty(fnum)
    fnum=1;
end
if fnum<1
    fnum=1;
end
if stframe<fnum+1
    set(handles.stop_fr_edit,'String',num2str(fnum+1));
end
fnum=round(fnum);
set(hObject,'String',num2str(fnum));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function start_fr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_fr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_sz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to int_sz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of int_sz_edit as text
%        str2double(get(hObject,'String')) returns contents of int_sz_edit as a double
fnums=get(hObject,'String');
fnum=str2num(fnums);
if isempty(fnum)
    fnum=1;
end
if fnum<1
    fnum=1;
end
fnum=round(fnum);
set(hObject,'String',num2str(fnum));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function int_sz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to int_sz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plot_type_menu.
function plot_type_menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot_type_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_type_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_type_menu
handles.plottype=get(hObject,'Value');
if handles.plottype==1
    set(handles.start_fr_edit,'Enable','off');
    set(handles.stop_fr_edit,'Enable','off');
    set(handles.int_sz_edit,'Enable','off');
end
if handles.plottype==2
    set(handles.start_fr_edit,'Enable','on');
    set(handles.stop_fr_edit,'Enable','on');
    set(handles.int_sz_edit,'Enable','off');
end
if handles.plottype==3
    set(handles.start_fr_edit,'Enable','on');
    set(handles.stop_fr_edit,'Enable','on');
    set(handles.int_sz_edit,'Enable','on');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function plot_type_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_type_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stop_fr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stop_fr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop_fr_edit as text
%        str2double(get(hObject,'String')) returns contents of stop_fr_edit as a double
fnums=get(hObject,'String');
sframe=str2num(get(handles.start_fr_edit,'String'));
fnum=str2num(fnums);
if isempty(fnum)
    fnum=sframe+1;
end
if fnum<sframe+1
    fnum=sframe+1;
end
fnum=round(fnum);
set(hObject,'String',num2str(fnum));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function stop_fr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_fr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in legend_chk.
function legend_chk_Callback(hObject, eventdata, handles)
% hObject    handle to legend_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of legend_chk


% --- Executes on button press in done_btn.
function done_btn_Callback(hObject, eventdata, handles)
% hObject    handle to done_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in MarkSits_chk.
function MarkSits_chk_Callback(hObject, eventdata, handles)
% hObject    handle to MarkSits_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MarkSits_chk




% --- Executes on button press in show_frames_chk.
function show_frames_chk_Callback(hObject, eventdata, handles)
% hObject    handle to show_frames_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_frames_chk
