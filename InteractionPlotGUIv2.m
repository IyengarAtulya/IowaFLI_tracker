function varargout = InteractionPlotGUIv2(varargin)
% INTERACTIONPLOTGUIV2 M-file for InteractionPlotGUIv2.fig
%      INTERACTIONPLOTGUIV2, by itself, creates a new INTERACTIONPLOTGUIV2 or raises the existing
%      singleton*.
%
%      H = INTERACTIONPLOTGUIV2 returns the handle to a new INTERACTIONPLOTGUIV2 or the handle to
%      the existing singleton*.
%
%      INTERACTIONPLOTGUIV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIONPLOTGUIV2.M with the given input arguments.
%
%      INTERACTIONPLOTGUIV2('Property','Value',...) creates a new INTERACTIONPLOTGUIV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InteractionPlotGUIv2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InteractionPlotGUIv2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InteractionPlotGUIv2

% Last Modified by GUIDE v2.5 10-Apr-2012 12:27:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InteractionPlotGUIv2_OpeningFcn, ...
                   'gui_OutputFcn',  @InteractionPlotGUIv2_OutputFcn, ...
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


% --- Executes just before InteractionPlotGUIv2 is made visible.
function InteractionPlotGUIv2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InteractionPlotGUIv2 (see VARARGIN)

% Choose default command line output for InteractionPlotGUIv2
handles.output = hObject;
if nargin>3
    
    handles.wtfpaths = varargin{1};
    handles.wtfs = varargin{2};
else
    [wtfiles,wtpath]=uigetfile('*.wtf','MultiSelect','on');
    if iscell(wtfiles)
        for i=1:numel(wtfiles)
           handles.wtfs(i)=wtfiles(i);
           handles.wtfpaths{i}=wtpath;
        end
        
    else
        handles.wtfs{1}=wtfiles;
        handles.wtfpaths{1}=wtpath;
    end
    
    
end

handles.Selectedwtfs=1;

set(handles.wtf_list,'String',handles.wtfs);
load([handles.wtfpaths{1},handles.wtfs{1}],'-mat');
set(handles.fly_info_table,'Data',FlyData(2:end,2:end));
set(handles.start_frame_edit,'String',num2str(1));
set(handles.stop_frame_edit,'String',num2str(size(Coordinates,2)));
set(handles.prox_radius_edit,'String',num2str(4));
set(handles.interval_size_edit,'String',num2str(900));
set(handles.Plot_Sits_chk,'Value',1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InteractionPlotGUIv2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InteractionPlotGUIv2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in wtf_list.
function wtf_list_Callback(hObject, eventdata, handles)
% hObject    handle to wtf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wtf_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wtf_list
handles.Selectedwtfs=get(hObject,'Value');

load([handles.wtfpaths{handles.Selectedwtfs(1)},handles.wtfs{handles.Selectedwtfs(1)}],'-mat');
set(handles.fly_info_table,'Data',FlyData(2:end,2:end));
a=get(handles.fly_info_table,'ColumnEditable');
a=true(size(a));
set(handles.fly_info_table,'ColumnEditable',a);
guidata(hObject,handles)



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



function prox_radius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prox_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prox_radius_edit as text
%        str2double(get(hObject,'String')) returns contents of prox_radius_edit as a double


% --- Executes during object creation, after setting all properties.
function prox_radius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prox_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function start_frame_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start_frame_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_frame_edit as text
%        str2double(get(hObject,'String')) returns contents of start_frame_edit as a double


% --- Executes during object creation, after setting all properties.
function start_frame_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_frame_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stop_frame_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stop_frame_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop_frame_edit as text
%        str2double(get(hObject,'String')) returns contents of stop_frame_edit as a double


% --- Executes during object creation, after setting all properties.
function stop_frame_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_frame_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interval_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to interval_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interval_size_edit as text
%        str2double(get(hObject,'String')) returns contents of interval_size_edit as a double


% --- Executes during object creation, after setting all properties.
function interval_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interval_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preview_btn.
function preview_btn_Callback(hObject, eventdata, handles)
% hObject    handle to preview_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');
index_selected = min(get(handles.wtf_list,'Value'));
ProxPlotPrev([handles.wtfpaths{index_selected},handles.wtfs{index_selected}],str2double(get(handles.interval_size_edit,'String')),(str2double(get(handles.prox_radius_edit,'String'))),handles.axes1,get(handles.plot_entire_video_chk,'Value'),str2double(get(handles.start_frame_edit,'String')),str2double(get(handles.stop_frame_edit,'String')),get(handles.Plot_Sits_chk,'Value'),get(handles.dont_use_colors_chk,'value'));

% --- Executes on button press in export_sel_btn.
function export_sel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_sel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=waitbar(0,[num2str(0),' of ',num2str(max(size(handles.Selectedwtfs))),' completed'],'Name','Exporting Plots');
handles.targetdir = uigetdir('Select where to save the exported files');
for x=1:max(size(handles.Selectedwtfs))
    i = handles.Selectedwtfs(x);
    ProxPlot([handles.wtfpaths{i},handles.wtfs{i}], str2double(get(handles.interval_size_edit,'String')),str2double(get(handles.prox_radius_edit,'String')),get(handles.plot_entire_video_chk,'Value'),handles.targetdir,get(handles.save_as_fig_chk,'Value'),get(handles.Plot_Sits_chk,'Value'),get(handles.dont_use_colors_chk,'value'))
    waitbar(x/max(size(handles.Selectedwtfs)),h,[num2str(x),' of ',num2str(max(size(handles.Selectedwtfs))),' completed']);
end
close(h);

% --- Executes on button press in export_all_btn.
function export_all_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_all_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=waitbar(0,[num2str(0),' of ',num2str(size(handles.wtfs,1)),' completed'],'Name','Exporting Plots');
handles.targetdir = uigetdir('Select where to save the exported files');
for i=1:size(handles.wtfs,1)
    ProxPlot([handles.wtfpaths{i},handles.wtfs{i}], str2double(get(handles.interval_size_edit,'String')),str2double(get(handles.prox_radius_edit,'String')),get(handles.plot_entire_video_chk,'Value'),handles.targetdir,get(handles.save_as_fig_chk,'Value'),get(handles.Plot_Sits_chk,'Value'),get(handles.dont_use_colors_chk,'value'))
    waitbar(i/size(handles.wtfs,1),h,[num2str(i),' of ',num2str(size(handles.wtfs,1)),' completed']);
end
close(h);
% --- Executes on button press in done_btn.
function done_btn_Callback(hObject, eventdata, handles)
% hObject    handle to done_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --- Executes on button press in save_as_fig_chk.
function save_as_fig_chk_Callback(hObject, eventdata, handles)
% hObject    handle to save_as_fig_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_as_fig_chk


% --- Executes on button press in show_prox_chk.
function show_prox_chk_Callback(hObject, eventdata, handles)
% hObject    handle to show_prox_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_prox_chk


% --- Executes on button press in plot_entire_video_chk.
function plot_entire_video_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_entire_video_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_entire_video_chk


% --- Executes on button press in Plot_Sits_chk.
function Plot_Sits_chk_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Sits_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Plot_Sits_chk


% --- Executes on button press in dont_use_colors_chk.
function dont_use_colors_chk_Callback(hObject, eventdata, handles)
% hObject    handle to dont_use_colors_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dont_use_colors_chk


% --- Executes on button press in Interaction_Matrix_btn.
function Interaction_Matrix_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Interaction_Matrix_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([handles.wtfpaths{handles.Selectedwtfs(1)},handles.wtfs{handles.Selectedwtfs(1)}],'-mat');

DistMatrix = nan(NumberOfFlies,NumberOfFlies,size(Coordinates,2));

for i = 1:NumberOfFlies
   for j=1:NumberOfFlies
      sXDist = ((Coordinates(i*2,:) - Coordinates(j*2,:))*Xscale).^2;
      sYDist = ((Coordinates(i*2+1,:) - Coordinates(j*2+1,:))*Yscale).^2;
      
      DistMatrix(i,j,:) = sqrt(sXDist+sYDist);
      
      
      
   end
end


matrix1 = ones(NumberOfFlies,NumberOfFlies);
matrix1 = triu(matrix1,1);

for q = 1:size(Coordinates,2)
   DistMatrix(:,:,q) = DistMatrix(:,:,q).*matrix1; 
   MeanDist(q) = nansum(nansum(DistMatrix(:,:,q)))/((NumberOfFlies^2+NumberOfFlies)/2);
   
   LinearMeanDist = reshape(MeanDist, 1, numel(MeanDist));
   
   SEMDist(q) = std(LinearMeanDist(find(LinearMeanDist)))/sqrt(numel(find(LinearMeanDist)));
   
end

figure, plot(MeanDist);



% --- Executes on button press in ChannelAnalysis_btn.
function ChannelAnalysis_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelAnalysis_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([handles.wtfpaths{handles.Selectedwtfs(1)},handles.wtfs{handles.Selectedwtfs(1)}],'-mat');
ProximityRadius = str2double(get(handles.prox_radius_edit,'string'));
PlotSits = 1;

    FramesPerPlot = Coordinates(1,end);
    Plots = 1;
    Frames = FramesPerPlot;

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
                                    SittingCoord(1,sits(x) - FramesPerSecond*5:sits(x)) = -25;
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
    

    StartSecond = (Frames*plotnum - Frames) / FramesPerSecond;
    EndSecond = (Frames*plotnum)/FramesPerSecond;
    SecondRatio = 1/FramesPerSecond;
    Seconds = Frames/FramesPerSecond;
    
    if StartSecond < 1
        StartSecond = 0;
    end


    Interactions = ClosePoints>1;
    
    
    NoInteractIndex = 1;
    InteractIndex = 1;
    for e = 1:numel(ClosePoints(:,1))
        % Interact = 0 means no interactions. 1 means an interaction. 
        OldInteract = 0;
        NewInteract = 0; 
        NoInteractCount = 0;
        InteractCount = 0;
        
        
        
       for f = 1:numel(ClosePoints(1,:))
          if Interactions(e,f) == 1;
             NewInteract = 1; 
          else
             NewInteract = 0;  
          end
          
          % if last frame was a non-interaction and this frame is a
          % non-interaction, then add one to the non interaction count
          if OldInteract == NewInteract && NewInteract == 0
             NoInteractCount = NoInteractCount +1; 
          end
          
          % if last frame was an interaction and this frame is an
          % interaction then add one to the interaction count
          if OldInteract == NewInteract && NewInteract == 1
             InteractCount = InteractCount +1; 
          end
          
          
          %if last frame was an interaction and this frame is a
          %non-interaction then send the interaction length to the vector
          %and reset the counter to zero.
          if OldInteract ~= NewInteract && NewInteract == 0
             InteractLength(InteractIndex) = InteractCount;
             InteractIndex = InteractIndex+1;
             InteractCount = 0;
          end
          
          
          if OldInteract ~= NewInteract && NewInteract == 1
             NoInteractLength(NoInteractIndex) = NoInteractCount;
             NoInteractIndex = NoInteractIndex+1;
             NoInteractCount = 0;
          end
          
          
          OldInteract = NewInteract;
       end
        
    end
   
    InteractLength = InteractLength/FramesPerSecond;
    NoInteractLength = NoInteractLength/FramesPerSecond;
    
    bins = 5000;
    
    
   figure, hist(InteractLength,bins)
   title('Interactions')
   
   figure, hist(NoInteractLength,bins)
   title('Non-Interactions')
   

end








% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
