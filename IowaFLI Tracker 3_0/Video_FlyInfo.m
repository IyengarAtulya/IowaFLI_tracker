function varargout = Video_FlyInfo(varargin)
% VIDEO_FLYINFO MATLAB code for Video_FlyInfo.fig
%      VIDEO_FLYINFO, by itself, creates a new VIDEO_FLYINFO or raises the existing
%      singleton*.
%
%      H = VIDEO_FLYINFO returns the handle to a new VIDEO_FLYINFO or the handle to
%      the existing singleton*.
%
%      VIDEO_FLYINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO_FLYINFO.M with the given input arguments.
%
%      VIDEO_FLYINFO('Property','Value',...) creates a new VIDEO_FLYINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Video_FlyInfo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Video_FlyInfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Video_FlyInfo

% Last Modified by GUIDE v2.5 23-May-2016 12:38:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Video_FlyInfo_OpeningFcn, ...
                   'gui_OutputFcn',  @Video_FlyInfo_OutputFcn, ...
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


% --- Executes just before Video_FlyInfo is made visible.
function Video_FlyInfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Video_FlyInfo (see VARARGIN)

% Choose default command line output for Video_FlyInfo
if nargin>3
    handles.LastInfo = varargin(2);
else
    handles.LastInfo=nan;
end

handles.output = hObject;

handles.FlyData = {1,'' '' '' '' };
handles.NumRows = 1;
set(handles.FlyInfoTable,'Data',handles.FlyData)
try
    LastInfo_btn_Callback(hObject, eventdata, handles)
    handles.NumRows = size(get(handles.FlyInfoTable,'RowName'),1);
catch
end
handles.SelectedRow=1;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Video_FlyInfo wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Video_FlyInfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


output.ExperimenterName = handles.ExperimenterName;
output.NFly = numel(handles.FlyInfo(:,1));
output.FlyInfo = handles.FlyInfo;
output.Conditions = handles.Conditions;
output.Comments = handles.Comments;

save('LastInfo.mat','output')

varargout{1} = output;




 close(handles.figure1)



function LastName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to LastName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LastName_edit as text
%        str2double(get(hObject,'String')) returns contents of LastName_edit as a double


% --- Executes during object creation, after setting all properties.
function LastName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LastName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Conditions_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Conditions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Conditions_edit as text
%        str2double(get(hObject,'String')) returns contents of Conditions_edit as a double


% --- Executes during object creation, after setting all properties.
function Conditions_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Conditions_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Comments_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Comments_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Comments_edit as text
%        str2double(get(hObject,'String')) returns contents of Comments_edit as a double


% --- Executes during object creation, after setting all properties.
function Comments_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Comments_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Submit_btn.
function Submit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Submit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FlyInfo = get(handles.FlyInfoTable,'Data');
handles.ExperimenterName = get(handles.LastName_edit,'string');
handles.Conditions = get(handles.Conditions_edit,'string');
handles.Comments = get(handles.Comments_edit,'string');
handles.LastInfo = {handles.FlyInfo; handles.ExperimenterName;handles.Conditions; handles.Comments};
guidata(hObject, handles);
uiresume();







% --- Executes on button press in AddFly_btn.
function AddFly_btn_Callback(hObject, eventdata, handles)
% hObject    handle to AddFly_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.NumRows = handles.NumRows+1;
OldData = get(handles.FlyInfoTable,'Data');
if ~isempty(OldData)
CurrentRowNames = get(handles.FlyInfoTable,'RowName');
CurrentRowNames{handles.NumRows} = ['Fly ' num2str(handles.NumRows)];
NewData = [OldData; OldData(handles.NumRows - 1,:) ];
else
   
    NewData={1,'' '' '' '' };
    CurrentRowNames={['Fly ' num2str(1)]};
end
set(handles.FlyInfoTable,'RowName',CurrentRowNames)
set(handles.FlyInfoTable,'Data',NewData)
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in FlyInfoTable.
function FlyInfoTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to FlyInfoTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if~isempty(eventdata.Indices)
    handles.SelectedRow=eventdata.Indices(1);
    guidata(hObject,handles);
end

% --- Executes on button press in LastInfo_btn.
function LastInfo_btn_Callback(hObject, eventdata, handles)
% hObject    handle to LastInfo_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    load('LastInfo.mat')
    set(handles.FlyInfoTable,'data',output.FlyInfo)
    rn=cell(size(get(handles.FlyInfoTable,'Data'),1),1);
    for i=1:numel(rn)
        rn{i}=['Fly ',num2str(i)];
    end
    handles.NumRows=size(rn,1);
    set(handles.FlyInfoTable,'RowName',rn);
    set(handles.LastName_edit,'string',output.ExperimenterName)
    set(handles.Conditions_edit,'string',output.Conditions)
    set(handles.Comments_edit,'string',output.Comments)
    
catch
   h= warndlg('LastInfo.mat not found. Please manually enter information');
   uiwait(h)
end
guidata(hObject,handles);


% --- Executes on button press in rmvfly_btn.
function rmvfly_btn_Callback(hObject, eventdata, handles)
% hObject    handle to rmvfly_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dat=get(handles.FlyInfoTable,'Data');
idx=ones(handles.NumRows,1);
idx(handles.SelectedRow)=0;
newdat=dat(logical(idx),:);
set(handles.FlyInfoTable,'Data',newdat);
rn=cell(size(get(handles.FlyInfoTable,'Data'),1),1);
for i=1:numel(rn)
    rn{i}=['Fly ',num2str(i)];
end
set(handles.FlyInfoTable,'RowName',rn);
handles.NumRows=size(rn,1);
handles.SelectedRow=max(1,handles.SelectedRow-1);
guidata(hObject,handles);
