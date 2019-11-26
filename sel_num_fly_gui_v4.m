function varargout = sel_num_fly_gui_v4(varargin)
% SEL_NUM_FLY_GUI_V4 MATLAB code for sel_num_fly_gui_v4.fig
%      SEL_NUM_FLY_GUI_V4, by itself, creates a new SEL_NUM_FLY_GUI_V4 or raises the existing
%      singleton*.
%
%      H = SEL_NUM_FLY_GUI_V4 returns the handle to a new SEL_NUM_FLY_GUI_V4 or the handle to
%      the existing singleton*.
%
%      SEL_NUM_FLY_GUI_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEL_NUM_FLY_GUI_V4.M with the given input arguments.
%
%      SEL_NUM_FLY_GUI_V4('Property','Value',...) creates a new SEL_NUM_FLY_GUI_V4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sel_num_fly_gui_v4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sel_num_fly_gui_v4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sel_num_fly_gui_v4

% Last Modified by GUIDE v2.5 08-Jun-2016 11:23:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sel_num_fly_gui_v4_OpeningFcn, ...
                   'gui_OutputFcn',  @sel_num_fly_gui_v4_OutputFcn, ...
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


% --- Executes just before sel_num_fly_gui_v4 is made visible.
function sel_num_fly_gui_v4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sel_num_fly_gui_v4 (see VARARGIN)

% Choose default command line output for sel_num_fly_gui_v4
handles.output = hObject;
PATH=varargin{1};
handles.Colors=get(gca,'ColorOrder');
set(handles.ColorSelector,'string',{'Blue','Orange','Yellow','Purple','Green','Cyan','Maroon'});
set(handles.ColorSelector,'Value',2);
FILENAME=varargin{2};
PreviousInfo = varargin{3};
if nargin>6
    handles.ROI=varargin{4};
else
    handles.ROI=ones(0,0);
end
if nargin>7
    handles.VidInfo=varargin{5};
else
    handles.VidInfo=ones(0,0);
end

if nargin>8
    handles.startFrame=varargin{6}+1;
else
    handles.startFrame=1;
end

try handles.vidobj=VideoReader([PATH,FILENAME]);
catch
   try
      if(mmreader.isPlatformSupported())
         handles.vidobj=mmreader([PATH,FILENAME]); 
      end
   catch
       msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
   end
end
handles.vidobj.CurrentTime=handles.startFrame/handles.vidobj.FrameRate;
handles.frame=readFrame(handles.vidobj);
ctr=1;
while mean(mean(mean(handles.frame))) < 15 & ctr<15
    ctr=ctr+1;
    handles.frame=readFrame(handles.vidobj);
end


guidata(hObject,handles);
frame=handles.frame;
axes(handles.axes1)
imshow(handles.frame);
handles.numflies=0;
set(handles.filename_txt,'String',[PATH,FILENAME]);
set(handles.genotype_edit,'String',PreviousInfo{1});
set(handles.sex_edit,'String',PreviousInfo{2});
set(handles.age_edit,'String',PreviousInfo{3});
set(handles.condition_edit,'String',PreviousInfo{4});
handles.flydata=cell(6,1);
handles.flydata{1,1}='Fly Number';
handles.flydata{2,1}='Genotype';
handles.flydata{3,1}='Sex';
handles.flydata{4,1}='Age (days)';
handles.flydata{5,1}='Condition';
handles.flydata{6,1}='Location Coordinates';
set(handles.uitable1,'Data',handles.flydata);
handles.numflies = NaN;
handles.coordinates = NaN;

% [p n e]=fileparts(FILENAME)
% try
%     load([PATH,n,'.mat'])
%     handles.VidInfo=VidInfo;
%     try
%        handles.nArena=numel(unique(cell2mat(VidInfo.FlyInfo(:,1))));
%     catch
%         handles.nArena=1;
%     end   
% catch
%     warndlg('Vid info not found');
% end
if ~isempty(handles.VidInfo)
    set(handles.genotype_edit,'String',handles.VidInfo.FlyInfo{1,2});
    set(handles.sex_edit,'String',handles.VidInfo.FlyInfo{1,3});
    set(handles.age_edit,'String',handles.VidInfo.FlyInfo{1,4});
    set(handles.condition_edit,'String',handles.VidInfo.FlyInfo{1,5});
end

if(~isempty(handles.ROI) && ~isempty(handles.VidInfo))
    ROI=logical(handles.ROI(:,:,1));
    handles.nf(:,:,1)=frame(:,:,1)-frame(:,:,1).*.7.*uint8(~ROI);
    handles.nf(:,:,2)=frame(:,:,2)-frame(:,:,2).*.7.*uint8(~ROI);
    handles.nf(:,:,3)=frame(:,:,3)-frame(:,:,3).*.7.*uint8(~ROI);
elseif(~isempty(handles.ROI) )
    ROI=logical(sum(handles.ROI,3));
    handles.nf(:,:,1)=frame(:,:,1)-frame(:,:,1).*.7.*uint8(~ROI);
    handles.nf(:,:,2)=frame(:,:,2)-frame(:,:,2).*.7.*uint8(~ROI);
    handles.nf(:,:,3)=frame(:,:,3)-frame(:,:,3).*.7.*uint8(~ROI);
else
    handles.nf=handles.frame;
end
handles.axes1=imshow(handles.nf);

handles.nselfly=0;

% Update handles structure

guidata(hObject, handles);

% UIWAIT makes sel_num_fly_gui_v4 wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sel_num_fly_gui_v4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.numflies=size(handles.flydata,2)-1;
varargout{1} = handles.numflies;
varargout{2} = handles.flydata;
varargout{3} = handles.coordinates;
varargout{4} = handles.ColorCodes;
varargout{5} = {get(handles.genotype_edit,'String'); get(handles.sex_edit,'String'); get(handles.age_edit,'String'); get(handles.condition_edit,'String')};
close(gcf);





function genotype_edit_Callback(hObject, eventdata, handles)
% hObject    handle to genotype_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of genotype_edit as text
%        str2double(get(hObject,'String')) returns contents of genotype_edit as a double


% --- Executes during object creation, after setting all properties.
function genotype_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to genotype_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sex_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sex_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sex_edit as text
%        str2double(get(hObject,'String')) returns contents of sex_edit as a double


% --- Executes during object creation, after setting all properties.
function sex_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sex_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function age_edit_Callback(hObject, eventdata, handles)
% hObject    handle to age_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of age_edit as text
%        str2double(get(hObject,'String')) returns contents of age_edit as a double
age=get(hObject,'String');
% b=str2double(age);
% if isnan(b)
%     set(hObject,'String','-');
% end
% if b<0
%     set(hObject,'String','-')
% end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function age_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function condition_edit_Callback(hObject, eventdata, handles)
% hObject    handle to condition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of condition_edit as text
%        str2double(get(hObject,'String')) returns contents of condition_edit as a double


% --- Executes during object creation, after setting all properties.
function condition_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in locate_add_btn.
function locate_add_btn_Callback(hObject, eventdata, handles)
% hObject    handle to locate_add_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ll=size(handles.flydata);
handles.flydata{1,ll(2)+1}=num2str(ll(2));
handles.flydata{2,ll(2)+1}=get(handles.genotype_edit,'String');
handles.flydata{3,ll(2)+1}=get(handles.sex_edit,'String');
handles.flydata{4,ll(2)+1}=get(handles.age_edit,'String');
handles.flydata{5,ll(2)+1}=get(handles.condition_edit,'String');


point = impoint();
pos = point.getPosition;
point.setColor([handles.Colors(get(handles.ColorSelector,'value'),:)]);

handles.ColorCodes(ll(end)) = get(handles.ColorSelector,'value');

handles.coordinates(ll(2),1)=pos(1);
handles.coordinates(ll(2),2)=pos(2);
posstring=[num2str(round(pos(1))),',',num2str(round(pos(2)))];
handles.flydata{6,ll(2)+1}=posstring;
set(handles.uitable1,'Data',handles.flydata);
handles.nselfly=handles.nselfly+1;
if ~isempty(handles.VidInfo)
    if handles.nselfly<size(handles.VidInfo.FlyInfo,1)
        
        frame=handles.frame;
        rn=cell2mat(handles.VidInfo.FlyInfo(handles.nselfly+1,1));
        
        if(~isempty(handles.ROI))
            ROI=logical(handles.ROI(:,:,rn));
            handles.nf(:,:,1)=frame(:,:,1)-frame(:,:,1).*.7.*uint8(~ROI);
            handles.nf(:,:,2)=frame(:,:,2)-frame(:,:,2).*.7.*uint8(~ROI);
            handles.nf(:,:,3)=frame(:,:,3)-frame(:,:,3).*.7.*uint8(~ROI);
        else
            handles.nf=handles.frame;
        end
        handles.axes1=imshow(handles.nf);
        hold all
        plot(handles.coordinates(:,1),handles.coordinates(:,2),'o','MarkerEdgeColor',[handles.Colors(get(handles.ColorSelector,'Value'),:)]);
        set(handles.genotype_edit,'String',handles.VidInfo.FlyInfo{handles.nselfly+1,2});
        set(handles.sex_edit,'String',handles.VidInfo.FlyInfo{handles.nselfly+1,3});
        set(handles.age_edit,'String',handles.VidInfo.FlyInfo{handles.nselfly+1,4});
        set(handles.condition_edit,'String',handles.VidInfo.FlyInfo{handles.nselfly+1,5});

    else
        h=msgbox('All flies selected');
        uiwait(h);
        handles.axes1=imshow(handles.frame);
        hold all
        plot(handles.coordinates(:,1),handles.coordinates(:,2),'o','MarkerEdgeColor',[handles.Colors(get(handles.ColorSelector,'Value'),:)]);
    end
end



guidata(hObject,handles);
uiwait(handles.figure1);
% --- Executes on button press in done_btn.
function done_btn_Callback(hObject, eventdata, handles)
% hObject    handle to done_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(gcf);
%close(gcf);


% --- Executes on selection change in ColorSelector.
function ColorSelector_Callback(hObject, eventdata, handles)
% hObject    handle to ColorSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorSelector


% --- Executes during object creation, after setting all properties.
function ColorSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
