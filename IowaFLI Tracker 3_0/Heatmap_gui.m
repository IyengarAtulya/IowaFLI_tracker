function varargout = Heatmap_gui(varargin)
% HEATMAP_GUI MATLAB code for Heatmap_gui.fig
%      HEATMAP_GUI, by itself, creates a new HEATMAP_GUI or raises the existing
%      singleton*.
%
%      H = HEATMAP_GUI returns the handle to a new HEATMAP_GUI or the handle to
%      the existing singleton*.
%
%      HEATMAP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATMAP_GUI.M with the given input arguments.
%
%      HEATMAP_GUI('Property','Value',...) creates a new HEATMAP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Heatmap_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Heatmap_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Heatmap_gui

% Last Modified by GUIDE v2.5 16-Aug-2019 11:15:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Heatmap_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Heatmap_gui_OutputFcn, ...
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


% --- Executes just before Heatmap_gui is made visible.
function Heatmap_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Heatmap_gui (see VARARGIN)

% Choose default command line output for Heatmap_gui
handles.output = hObject;

handles.availCmap=[{'parula'},{'jet'},{'hsv'},{'hot'}];
set(handles.popupmenu1,'String',handles.availCmap);
handles.FILE=varargin{1};
load(handles.FILE,'-mat');
set(handles.frame_min_edit,'String','1');
set(handles.frame_max_edit,'String',size(Coordinates,2));
set(handles.resolution_edit,'String','1');

prevheatmap(hObject, handles,handles.axes1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Heatmap_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Heatmap_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
prevheatmap(hObject, handles,handles.axes1)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function PlotRange_slider_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRange_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function PlotRange_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotRange_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function frame_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to frame_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_min_edit as text
%        str2double(get(hObject,'String')) returns contents of frame_min_edit as a double


prevheatmap(hObject, handles,handles.axes1)

% --- Executes during object creation, after setting all properties.
function frame_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frame_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to frame_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_max_edit as text
%        str2double(get(hObject,'String')) returns contents of frame_max_edit as a double
prevheatmap(hObject, handles,handles.axes1)

% --- Executes during object creation, after setting all properties.
function frame_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_fig_btn.
function plot_fig_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_fig_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
ax=gca
prevheatmap(hObject, handles,ax)

function prevheatmap(hObject, handles,ax)
axes(ax)
cla
hold all
Resolution=str2num(get(handles.resolution_edit,'String'));
LogScale=get(handles.LogScale_chk,'Value');

try
    load(handles.FILE,'-mat')
catch
    disp('FILE NOT FOUND');
    return
end
if handles.firstFrameChk.Value==1
    imagesc(FirstFrame)
end

SC(1,:)=Coordinates(1,:);
for i=1:NumberOfFlies
   SC(i*2,:)=Coordinates(i*2,:)*Xscale;
   SC(i*2+1,:)=Coordinates(i*2+1,:)*Yscale;
end
rSC=round(SC/Resolution)*Resolution;
Xe=[0:Resolution:round(size(FirstFrame,2)*Xscale*Resolution)/Resolution];
Ye=[0:Resolution:round(size(FirstFrame,1)*Yscale*Resolution)/Resolution];
Tmin=str2num(get(handles.frame_min_edit,'String'));
if Tmin<1
    Tmin=1
    set(handles.frame_min_edit,'String',num2str(1));
end
Tmax=str2num(get(handles.frame_max_edit,'String'));
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
% imagesc(Xe,Ye, sN');
% axis ij
F=griddedInterpolant(sN)
[sx sy]=size(sN);
xq=[0:Xscale:sx];
yq=[0:Yscale:sy];
vF=F({xq,yq});
Ad=ones(size(vF));
if LogScale==1
Ad(find(vF==-Inf))=0;
else
    Ad(find(vF==0))=0;
end
imagesc(vF','AlphaData',Ad');

cmap=colormap(handles.availCmap{get(handles.popupmenu1,'Value')});
cmap(1,:)=[ 1 1 1];
colormap(cmap);
c=colorbar;
if LogScale
    c.Label.String='log(seconds)';
else
    c.Label.String='log(seconds)';
end

ax.XTick=[];
ax.YTick=[];




% --- Executes on button press in LogScale_chk.
function LogScale_chk_Callback(hObject, eventdata, handles)
% hObject    handle to LogScale_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LogScale_chk
prevheatmap(hObject, handles,handles.axes1)


function resolution_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resolution_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution_edit as text
%        str2double(get(hObject,'String')) returns contents of resolution_edit as a double
prevheatmap(hObject, handles,handles.axes1)

% --- Executes during object creation, after setting all properties.
function resolution_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Expt2Wksp_btn.
function Expt2Wksp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Expt2Wksp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Resolution=str2num(get(handles.resolution_edit,'String'));
LogScale=get(handles.LogScale_chk,'Value');

try
    load(handles.FILE,'-mat')
catch
    disp('FILE NOT FOUND');
    return
end
SC(1,:)=Coordinates(1,:);
for i=1:NumberOfFlies
   SC(i*2,:)=Coordinates(i*2,:)*Xscale;
   SC(i*2+1,:)=Coordinates(i*2+1,:)*Yscale;
end
rSC=round(SC/Resolution)*Resolution;
Xe=[0:Resolution:round(size(FirstFrame,2)*Xscale*Resolution)/Resolution];
Ye=[0:Resolution:round(size(FirstFrame,1)*Yscale*Resolution)/Resolution];
Tmin=str2num(get(handles.frame_min_edit,'String'));
if Tmin<1
    Tmin=1;
    set(handles.frame_min_edit,'String',num2str(1));
end
Tmax=str2num(get(handles.frame_max_edit,'String'));
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
export2wsdlg({'Heatmap'},{'Heatmap'},{sN});


% --- Executes on button press in firstFrameChk.
function firstFrameChk_Callback(hObject, eventdata, handles)
% hObject    handle to firstFrameChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of firstFrameChk
prevheatmap(hObject, handles,handles.axes1)