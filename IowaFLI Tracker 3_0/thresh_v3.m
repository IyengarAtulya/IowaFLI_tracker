function varargout = thresh_v3(varargin)
% THRESH_V3 MATLAB code for thresh_v3.fig
%      THRESH_V3, by itself, creates a new THRESH_V3 or raises the existing
%      singleton*.
%
%      H = THRESH_V3 returns the handle to a new THRESH_V3 or the handle to
%      the existing singleton*.
%
%      THRESH_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESH_V3.M with the given input arguments.
%
%      THRESH_V3('Property','Value',...) creates a new THRESH_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thresh_v3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thresh_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thresh_v3

% Last Modified by GUIDE v2.5 24-Apr-2019 13:42:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thresh_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @thresh_v3_OutputFcn, ...
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


% --- Executes just before thresh_v3 is made visible.
function thresh_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thresh_v3 (see VARARGIN)

% Choose default command line output for thresh_v3
handles.output = hObject;

PATH=varargin{1};
FILENAME=varargin{2};
if nargin>5
handles.InitPos=varargin{3};
else
    handles.InitPos=[0,0];
end

if nargin>6
    handles.startFrame=varargin{4};
else
    handles.startFrame=1;
end

set(handles.text1,'String',[PATH,FILENAME]);
try
    handles.vidobj=VideoReader([PATH,FILENAME]);
catch
   try
      if(mmreader.isPlatformSupported())
         handles.vidobj=mmreader([PATH,FILENAME]); 
      end
   catch
       msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
   end
end
tic;

handles.vidobj.CurrentTime=handles.startFrame/handles.vidobj.FrameRate;
handles.frame=readFrame(handles.vidobj);
handles.originalframe=handles.frame;
handles.frame=readFrame(handles.vidobj);
ctr=1;
while sum(sum(sum(handles.frame))) == 0 & ctr<10
    ctr=ctr+1;
    handles.frame=readFrame(handles.vidobj);
end

try
    def=getIowaFliDefaults('IowaFLI_Tracker Defaults.txt');
    defThresh=def(10);
    handles.checkbox1.Value=def(11);
catch
    defThresh=0.5;
    handles.checkbox1.Value=0;
end

handles.output=[{defThresh},{'none'}];
%handles.frame1=read(vidobj,inf);
% handles.frame1=read(vidobj,round(vidobj.Duration*vidobj.FrameRate*0.9));

handles.vidobj.CurrentTime=round((handles.vidobj.Duration)-(0.05*handles.vidobj.Duration));
handles.frame1=readFrame(handles.vidobj);
handles.originalframe1=handles.frame1;

toc
axes(handles.axes1);
%imshow(im2bw(handles.frame,handles.output{1}));
fr=rgb2gray(handles.frame);
imshow(imbinarize(fr,handles.output{1}));
set(gca,'XTick',[]);
set(gca,'YTick',[]);
if handles.InitPos(1,1)~=0
    hold all
   plot(handles.InitPos(:,1),handles.InitPos(:,2),'go')
end

axes(handles.axes2);
%imshow(im2bw(handles.frame1,handles.output{1}));
fr1=rgb2gray(handles.frame1);
imshow(imbinarize(fr1,handles.output{1}));
set(gca,'XTick',[]);
set(gca,'YTick',[]);

set(handles.slider1,'Value',handles.output{1});
set(handles.edit1,'String',num2str(handles.output{1}));




% Update handles structure
guidata(hObject, handles);
checkbox1_Callback(hObject,eventdata,handles);
% UIWAIT makes thresh_v3 wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = thresh_v3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(handles.figure1);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(hObject,'Value');
handles.output{1}=value;
axes(handles.axes1);


%bwframe=im2bw(handles.frame,handles.output{1});
%imshow(bwframe);

fr=rgb2gray(handles.frame);
if handles.checkbox1.Value
    imshow(imbinarize(fr,'adaptive','ForegroundPolarity','dark','Sensitivity',handles.output{1}));
else
    imshow(imbinarize(fr,handles.output{1}));
end


set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'CLim',[0 1]);
set(handles.edit1,'String',num2str(handles.output{1}));
if handles.InitPos(1,1)~=0
    hold all
   plot(handles.InitPos(:,1),handles.InitPos(:,2),'go')
end

axes(handles.axes2);
%imshow(im2bw(handles.frame1,handles.output{1}));

fr1=rgb2gray(handles.frame1);
if handles.checkbox1.Value
    imshow(imbinarize(fr1,'adaptive','ForegroundPolarity','dark','Sensitivity',handles.output{1}));
else
    imshow(imbinarize(fr1,handles.output{1}));
end


set(gca,'XTick',[]);
set(gca,'YTick',[]);


guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
sthresh=get(hObject,'String');
thresh=str2double(sthresh);
if(isnan(thresh))
    set(hObject,'String',num2str(handles.output{1}));
    thresh=handles.output{1};
end
if(thresh<0)
    set(hObject,'String',num2str(handles.output{1}));
    thresh=handles.output{1};
end
if(thresh>1)
    set(hObject,'String',num2str(handles.output{1}));
    thresh=handles.output{1};
end
set(hObject,'String',num2str(thresh));
set(handles.slider1,'Value',thresh);
handles.output{1}=thresh;
bwframe=im2bw(handles.frame,handles.output{1});
axes(handles.axes1);
imshow(bwframe);

axes(handles.axes2);
imshow(im2bw(handles.frame1,handles.output{1}));
set(gca,'XTick',[]);
set(gca,'YTick',[]);


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_btn.
function ok_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ok_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

%imshow(im2bw(handles.frame,handles.output{1}));

fr=rgb2gray(handles.frame);
axes(handles.axes1);
if handles.checkbox1.Value
imshow(imbinarize(fr,'adaptive','ForegroundPolarity','dark','Sensitivity',handles.output{1}));   
handles.output{2}='gradnormalize';
else
imshow(imbinarize(fr,handles.output{1}));
handles.output{2}='none';
end

set(gca,'XTick',[]);
set(gca,'YTick',[]);
if handles.InitPos(1,1)~=0
    hold all
   plot(handles.InitPos(:,1),handles.InitPos(:,2),'go')
end

if handles.InitPos(1,1)~=0
    hold all
   plot(handles.InitPos(:,1),handles.InitPos(:,2),'go')
end

axes(handles.axes2);
%imshow(im2bw(handles.frame1,handles.output{1}));
fr1=rgb2gray(handles.frame1);
if handles.checkbox1.Value
imshow(imbinarize(fr1,'adaptive','ForegroundPolarity','dark','Sensitivity',handles.output{1}));    
else
imshow(imbinarize(fr1,handles.output{1}));
end
set(gca,'XTick',[]);
set(gca,'YTick',[]);

set(handles.slider1,'Value',handles.output{1});
set(handles.edit1,'String',num2str(handles.output{1}));

guidata(hObject,handles);


function gradfiltsz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gradfiltsz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gradfiltsz_edit as text
%        str2double(get(hObject,'String')) returns contents of gradfiltsz_edit as a double


% --- Executes during object creation, after setting all properties.
function gradfiltsz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gradfiltsz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
