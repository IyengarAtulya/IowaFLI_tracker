function varargout = roi_define_v7(varargin)
% ROI_DEFINE_V7 MATLAB code for roi_define_v7.fig
%      ROI_DEFINE_V7, by itself, creates a new ROI_DEFINE_V7 or raises the existing
%      singleton*.
%
%      H = ROI_DEFINE_V7 returns the handle to a new ROI_DEFINE_V7 or the handle to
%      the existing singleton*.
%
%      ROI_DEFINE_V7('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROI_DEFINE_V7.M with the given input arguments.
%
%      ROI_DEFINE_V7('Property','Value',...) creates a new ROI_DEFINE_V7 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before roi_define_v7_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to roi_define_v7_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help roi_define_v7

% Last Modified by GUIDE v2.5 14-Aug-2019 16:00:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @roi_define_v7_OpeningFcn, ...
                   'gui_OutputFcn',  @roi_define_v7_OutputFcn, ...
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


% --- Executes just before roi_define_v7 is made visible.
function roi_define_v7_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to roi_define_v7 (see VARARGIN)

% Choose default command line output for roi_define_v7
tic
handles.output = hObject;
handles.PATH=varargin{1};
handles.FILENAME=varargin{2};
handles.seltype=varargin{3};
ROIFPS=varargin{4};
ROIL1=varargin{5};
ROIL2=varargin{6};

handles.INPUTVAR=varargin;

if nargin>9
    handles.VidInfo=varargin{7};
else
    handles.VidInfo=0;
end
if nargin>10
    handles.startFrame=varargin{8};
else
    handles.startFrame=1;
end

try % this is for the backwards compatibility with 2010a
handles.vidobj=VideoReader([handles.PATH,handles.FILENAME]);
catch
   try
      if(mmreader.isPlatformSupported())
         handles.vidobj=mmreader([handles.PATH,handles.FILENAME]); 
      end
   catch
       msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
   end
end
set(handles.text1,'String',[handles.PATH,handles.FILENAME]);
%handles.frame=read(vidobj,1);
handles.frame=readFrame(handles.vidobj);
ctr=1;
while sum(sum(sum(handles.frame))) == 0 & ctr<10
    ctr=ctr+1;
    handles.frame=readFrame(handles.vidobj);
    handles.startFrame=ctr;
end
axes(handles.axes1);
imagesc(handles.frame);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(handles.ROI_sel_menu,'String',{'Ellipse','Rectangle','Polygon','Free Hand','Whole Frame'})
try
    def=getIowaFliDefaults('IowaFLI_Tracker Defaults.txt');
    handles.ROI_sel_menu.Value=def(6);
catch
    set(handles.ROI_sel_menu,'Value',handles.seltype);
end


set(handles.tgtsel_menu,'String',{'Ellipse','Fixed Size'})
set(handles.tgtsel_btn,'Enable','on')
handles.nTarget=0;
set(handles.nTarget_txt,'String',['Number of Targets: ',num2str(handles.nTarget)]);




handles.fps=nan;
handles.output=ones(0,0);
handles.L1x=nan;
handles.L1y=nan;
handles.L2x=nan;
handles.L2y=nan;
set(handles.FPS_edit,'String',ROIFPS);
set(handles.L1_edit,'String',ROIL1);
set(handles.L2_edit,'String',ROIL2);
set(handles.done_btn,'Enable','off');
set(handles.L1_btn,'Enable','off');
set(handles.L2_btn,'Enable','off');
if ~isnan(str2double(get(handles.FPS_edit,'String')))
    set(handles.ROI_sel_btn,'Enable','on');
    handles.fps=str2double(get(handles.FPS_edit,'String'));
end
if ~isnan(str2double(get(handles.L1_edit,'String')))
    set(handles.L1_btn,'Enable','on');
    handles.L1d=str2num(get(handles.L1_edit,'String'));
end
if ~isnan(str2double(get(handles.L2_edit,'String')))
    set(handles.L2_btn,'Enable','on');
     handles.L2d=str2num(get(handles.L2_edit,'String'));
end

drawnow;
toc
try
    def=getIowaFliDefaults('IowaFLI_Tracker Defaults.txt');
    nArena=def(4);
catch
    nArena=1;
end
nAs=1;
while nAs==1;
    try
        nArena=numel(unique(cell2mat(handles.VidInfo.FlyInfo(:,1))));
    catch
    end
    nA=inputdlg('Please enter the number of ROIs','Number of ROIs',1,{num2str(nArena)});
    try
        nArena=str2num(nA{1});
        if isempty(nArena)
            nAs=1;
            h=warndlg('please re-enter number of ROIs');
            uiwait(h)
        else
            nAs=0;
        end
    catch
        nAs=1;
        h=warndlg('please re-enter number of ROIs');
        uiwait(h)
    end
end
handles.nArena=nArena;
handles.nROI=0;
handles.output=zeros(size(handles.frame(:,:,1)));
set(handles.nROI_txt,'String',['Number of ROIs: 0/',num2str(nArena)]);
guidata(hObject, handles);

% UIWAIT makes roi_define_v7 wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = roi_define_v7_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
varargout{2}=handles.fps;
varargout{3}=handles.xscale;
varargout{4}=handles.yscale;
varargout{5}=get(handles.FPS_edit,'String');
varargout{6}=get(handles.L1_edit,'String');
varargout{7}=get(handles.L2_edit,'String');
if isfield(handles,'targets')
    varargout{8}=handles.targets;
else
    varargout{8}=zeros(size(handles.output(:,:,1)));
end
varargout{9}=handles.startFrame;
close(handles.figure1);




% --- Executes on selection change in roi_menu.
function roi_menu_Callback(hObject, eventdata, handles)
% hObject    handle to roi_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi_menu

handles.roi_style = get(hObject,'Value');


guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function roi_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in done_btn.
function done_btn_Callback(hObject, eventdata, handles)
% hObject    handle to done_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d1=handles.L1d;
d2=handles.L2d;
p1x=handles.L1x;
p1y=handles.L1y;
p2x=handles.L2x;
p2y=handles.L2y;
SS=[p1x.^2 p1y.^2 d1.^2;p2x.^2 p2y.^2 d2.^2];
solmat=rref(SS);
handles.xscale=sqrt(solmat(1,3));
handles.yscale=sqrt(solmat(2,3));
guidata(hObject,handles);
uiresume(handles.figure1);

% --- Executes on button press in ROI_sel_btn.
function ROI_sel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_sel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.seltype==1
    h=imellipse;
    wait(h);
    set(handles.ROI_Selected_chk, 'Value',1);
    set(handles.L1_edit, 'Enable', 'on');
    output=createMask(h);
    if handles.nROI<handles.nArena
        handles.output(:,:,handles.nROI+1)=output;
        handles.nROI=handles.nROI+1;
        set(handles.nROI_txt,'String',['Number of ROIs: ',num2str(handles.nROI) '/',num2str(handles.nArena)])
    else
        warndlg('Maximum number of ROIs designated')
        delete(h)
    end
end
if handles.seltype==2
    h=imrect;
    wait(h);
    set(handles.ROI_Selected_chk, 'Value',1);        
    set(handles.L1_edit, 'Enable', 'on');
    output=createMask(h);
    if handles.nROI<handles.nArena
        handles.output(:,:,handles.nROI+1)=output;
        handles.nROI=handles.nROI+1;
        set(handles.nROI_txt,'String',['Number of ROIs: ',num2str(handles.nROI) '/',num2str(handles.nArena)])
    else
        warndlg('Maximum number of ROIs designated')
        delete(h)
    end
end
if handles.seltype==3
    h=impoly;
    wait(h);
    set(handles.ROI_Selected_chk, 'Value',1);
    set(handles.L1_edit, 'Enable', 'on');
    output=createMask(h);
    if handles.nROI<handles.nArena
        handles.output(:,:,handles.nROI+1)=output;
        handles.nROI=handles.nROI+1;
        set(handles.nROI_txt,'String',['Number of ROIs: ',num2str(handles.nROI) '/',num2str(handles.nArena)])
    else
        warndlg('Maximum number of ROIs designated')
        delete(h)
    end
end
if handles.seltype==4
    h=imfreehand;
    wait(h);
    set(handles.ROI_Selected_chk, 'Value',1);
    set(handles.L1_edit, 'Enable', 'on');
    output=createMask(h);
    if handles.nROI<handles.nArena
        handles.output(:,:,handles.nROI+1)=output;
        handles.nROI=handles.nROI+1;
        set(handles.nROI_txt,'String',['Number of ROIs: ',num2str(handles.nROI) '/',num2str(handles.nArena)])
    else
        warndlg('Maximum number of ROIs designated')
        delete(h)
    end
end
if handles.seltype==5
    x=size(handles.frame,1);
    y=size(handles.frame,2);
    handles.output=ones(x,y);
end

if (((~isnan(handles.fps)&&~isempty(handles.output))&&~isnan(handles.L1x))&&~isnan(handles.L2x))
    set(handles.done_btn,'Enable','on');
end


set(handles.nROI_txt,'String',['Number of ROIs: ',num2str(handles.nROI) '/',num2str(handles.nArena)])
guidata(hObject,handles);
uiwait(handles.figure1);

% --- Executes on selection change in ROI_sel_menu.
function ROI_sel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_sel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ROI_sel_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROI_sel_menu
handles.seltype=get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ROI_sel_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_sel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to L1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L1_edit as text
%        str2double(get(hObject,'String')) returns contents of L1_edit as a double
L1s=get(hObject,'String');
L1d=str2double(L1s);
if~isnan(L1d)
    if L1d>0
        set(handles.L1_btn,'Enable','on');
        handles.L1d=L1d;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function L1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in L1_btn.
function L1_btn_Callback(hObject, eventdata, handles)
% hObject    handle to L1_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.L1_btn,'Enable','off');
h=imline;
pos=wait(h);
x1=pos(1,1);
y1=pos(1,2);
x2=pos(2,1);
y2=pos(2,2);
handles.L1x=abs(x2-x1);
handles.L1y=abs(y2-y1);
delete(h);
set(handles.L1_Selected_chk,'Value',1);
if ~isnan(handles.fps)&&~isempty(handles.output)&&~isnan(handles.L1x)&&~isnan(handles.L2x)
    set(handles.done_btn,'Enable','on');
end
set(handles.L2_edit, 'Enable', 'on');
guidata(hObject,handles)
uiwait(handles.figure1);


function L2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to L2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L2_edit as text
%        str2double(get(hObject,'String')) returns contents of L2_edit as a double
L2s=get(hObject,'String');
L2d=str2double(L2s);
if~isnan(L2d)
    if L2d>0
        set(handles.L2_btn,'Enable','on');
        handles.L2d=L2d;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function L2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in L2_btn.
function L2_btn_Callback(hObject, eventdata, handles)
% hObject    handle to L2_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.L2_btn,'Enable','off');
h=imline;
pos=wait(h);
x1=pos(1,1);
y1=pos(1,2);
x2=pos(2,1);
y2=pos(2,2);
delete(h)
handles.L2x=abs(x2-x1);
handles.L2y=abs(y2-y1);
set(handles.L2_Selected_chk,'Value',1);
if ~isnan(handles.fps)&&~isempty(handles.output)&&~isnan(handles.L1x)&&~isnan(handles.L2x)
    set(handles.done_btn,'Enable','on');
end
guidata(hObject,handles)
uiwait(handles.figure1);


function FPS_edit_Callback(hObject, eventdata, handles)
% hObject    handle to FPS_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FPS_edit as text
%        str2double(get(hObject,'String')) returns contents of FPS_edit as a double
fpss=get(hObject,'String');
handles.fps=str2double(fpss);
handles.fps=abs(handles.fps);
if ~isnan(handles.fps)&&~isempty(handles.output)&&~isnan(handles.L1x)&&~isnan(handles.L2x)
    set(handles.done_btn,'Enable','on');
end
set(handles.ROI_sel_btn, 'Enable', 'on');
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function FPS_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FPS_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ROI_Selected_chk.
function ROI_Selected_chk_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_Selected_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI_Selected_chk


% --- Executes on button press in L1_Selected_chk.
function L1_Selected_chk_Callback(hObject, eventdata, handles)
% hObject    handle to L1_Selected_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of L1_Selected_chk


% --- Executes on button press in L2_Selected_chk.
function L2_Selected_chk_Callback(hObject, eventdata, handles)
% hObject    handle to L2_Selected_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of L2_Selected_chk


% --- Executes on button press in reset_btn.
function reset_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reset_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)

roi_define_v7(handles.INPUTVAR{1}, handles.INPUTVAR{2}, handles.INPUTVAR{3}, handles.INPUTVAR{4}, handles.INPUTVAR{5}, handles.INPUTVAR{6})


handles.output = hObject;
PATH=handles.INPUTVAR{1};
FILENAME=handles.INPUTVAR{2};
handles.seltype=handles.INPUTVAR{3};
ROIFPS=handles.INPUTVAR{4};
ROIL1=handles.INPUTVAR{5};
ROIL2=handles.INPUTVAR{6};
try % this is for the backwards compatibility with 2010a
vidobj=VideoReader([PATH,FILENAME]);
catch
   try
      if(mmreader.isPlatformSupported())
         vidobj=mmreader([PATH,FILENAME]); 
      end
   catch
       msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
   end
end
set(handles.text1,'String',[PATH,FILENAME]);
handles.frames=read(vidobj,[1 180]);
handles.frame=handles.frames(:,:,:,1);
axes(handles.axes1);
imagesc(handles.frame);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(handles.ROI_sel_menu,'String',{'Ellipse','Rectangle','Polygon','Free Hand','Whole Frame'})
set(handles.ROI_sel_menu,'Value',handles.seltype);


handles.fps=nan;
handles.output=ones(0,0);
handles.L1x=nan;
handles.L1y=nan;
handles.L2x=nan;
handles.L2y=nan;
set(handles.FPS_edit,'String',ROIFPS);
set(handles.L1_edit,'String',ROIL1);
set(handles.L2_edit,'String',ROIL2);
set(handles.done_btn,'Enable','off');
set(handles.L1_btn,'Enable','off');
set(handles.L2_btn,'Enable','off');
if ~isnan(str2double(get(handles.FPS_edit,'String')))
    set(handles.ROI_sel_btn,'Enable','on');
    handles.fps=str2double(get(handles.FPS_edit,'String'));
end
if ~isnan(str2double(get(handles.L1_edit,'String')))
    set(handles.L1_btn,'Enable','on');
    handles.L1d=str2num(get(handles.L1_edit,'String'));
end
if ~isnan(str2double(get(handles.L2_edit,'String')))
    set(handles.L2_btn,'Enable','on');
     handles.L2d=str2num(get(handles.L2_edit,'String'));
end


% --- Executes on button press in Target_Selected_Chk.
function Target_Selected_Chk_Callback(hObject, eventdata, handles)
% hObject    handle to Target_Selected_Chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Target_Selected_Chk


% --- Executes on selection change in tgtsel_menu.
function tgtsel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tgtsel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tgtsel_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tgtsel_menu


% --- Executes during object creation, after setting all properties.
function tgtsel_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tgtsel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tgtsel_btn.
function tgtsel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tgtsel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.nTarget=handles.nTarget+1;
hh=imellipse;
wait(hh)
target=createMask(hh);
handles.targets(:,:,handles.nTarget)=target;

set(handles.nTarget_txt,'String',['Number of Targets: ',num2str(handles.nTarget)]);
guidata(hObject,handles);
uiwait(handles.figure1);
    


% --- Executes on button press in Next_Frame_btn.
function Next_Frame_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Next_Frame_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fr=readFrame(handles.vidobj);
handles.startFrame=handles.startFrame+1;
ct=handles.vidobj.CurrentTime;
frameInterval=1/handles.vidobj.FrameRate;
set(handles.Prev_Frame_Btn,'Enable','on');
handles.frame=fr;
axes(handles.axes1);
imagesc(handles.frame);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
guidata(hObject,handles);



% --- Executes on button press in Prev_Frame_Btn.
function Prev_Frame_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to Prev_Frame_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ct=handles.vidobj.CurrentTime;
frameInterval=1/handles.vidobj.FrameRate;
if ct-frameInterval>=frameInterval
    handles.vidobj.CurrentTime=ct-2*frameInterval;
    handles.startFrame=handles.startFrame-1;
    fr=readFrame(handles.vidobj);
    handles.frame=fr;
    axes(handles.axes1);
    imagesc(handles.frame);
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
else
    set(handles.Prev_Frame_Btn,'Enable','off');
end
guidata(hObject,handles);