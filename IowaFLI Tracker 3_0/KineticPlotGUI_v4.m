function varargout = KineticPlotGUI_v4(varargin)
% KINETICPLOTGUI_V4 MATLAB code for KineticPlotGUI_v4.fig
%      KINETICPLOTGUI_V4, by itself, creates a new KINETICPLOTGUI_V4 or raises the existing
%      singleton*.
%
%      H = KINETICPLOTGUI_V4 returns the handle to a new KINETICPLOTGUI_V4 or the handle to
%      the existing singleton*.
%
%      KINETICPLOTGUI_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINETICPLOTGUI_V4.M with the given input arguments.
%
%      KINETICPLOTGUI_V4('Property','Value',...) creates a new KINETICPLOTGUI_V4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KineticPlotGUI_v4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KineticPlotGUI_v4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KineticPlotGUI_v4

% Last Modified by GUIDE v2.5 21-Aug-2019 15:10:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KineticPlotGUI_v4_OpeningFcn, ...
                   'gui_OutputFcn',  @KineticPlotGUI_v4_OutputFcn, ...
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


% --- Executes just before KineticPlotGUI_v4 is made visible.
function KineticPlotGUI_v4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KineticPlotGUI_v4 (see VARARGIN)
if nargin==3
    [files,path]=uigetfile('*.wtf','Select WTF file(s)','MultiSelect','on');
    if ischar(files)
        handles.WTFs={[path,files]};
    else
        for i=1:numel(files)
        handles.WTFs(i)={[path,files{i}]};
        end
    end
else
    handles.WTFfiles=varargin{2};
    handles.WTFpaths=varargin{1};
    for i=1:numel(handles.WTFfiles)
        handles.WTFs(i)={[handles.WTFpaths{i},handles.WTFfiles{i}]};
    end
   
end
handles.WTFs_list.String=handles.WTFs;
handles.WTFs_list.Value=1;
previewROI(hObject,eventdata,handles,handles.WTFs_list.String{1});
popFly_List(hObject,eventdata,handles,handles.WTFs_list.String{1});
handles.text2.String=handles.WTFs_list.String{1};

plot_types=[{'Distance Travelled vs. Time'},{'Velocity vs. Time'},{'Acceleration vs. Time'},{'Angular Velocity vs. Time'},{'Is Moving? vs. Time'}];
handles.plot_type_menu.String=plot_types;

filt_types=[{'None'},{'Running Mean'},{'Running Median'}];
handles.filtertype_menu.String=filt_types;
handles.filter_sz_edit.String=num2str(0);
handles.filter_sz_edit.Enable='off';

%handles.axes1




% Choose default command line output for KineticPlotGUI_v4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KineticPlotGUI_v4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KineticPlotGUI_v4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in fly_list.
function fly_list_Callback(hObject, eventdata, handles)
% hObject    handle to fly_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fly_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fly_list


% --- Executes during object creation, after setting all properties.
function fly_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fly_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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



function filter_sz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filter_sz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_sz_edit as text
%        str2double(get(hObject,'String')) returns contents of filter_sz_edit as a double


% --- Executes during object creation, after setting all properties.
function filter_sz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_sz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filtertype_menu.
function filtertype_menu_Callback(hObject, eventdata, handles)
% hObject    handle to filtertype_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filtertype_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filtertype_menu
nv=handles.filtertype_menu.Value;
if nv==1
   handles.filter_sz_edit.Enable='off';
else
    handles.filter_sz_edit.Enable='on';
end
guidata(hObject,handles);
    

% --- Executes during object creation, after setting all properties.
function filtertype_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtertype_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in WTFs_list.
function WTFs_list_Callback(hObject, eventdata, handles)
% hObject    handle to WTFs_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns WTFs_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WTFs_list
nv=get(hObject,'Value');
fn=handles.WTFs{nv};
handles.text2.String=fn;
previewROI(hObject,eventdata,handles,fn);
popFly_List(hObject,eventdata,handles,fn);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function WTFs_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WTFs_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popFly_List(hObject,eventdata,handles,FILENAME)
load(FILENAME,'-mat')
ric=round(InitialCoordinates);
flyroi{1}='ROI';
for j=1:NumberOfFlies
    flyroi{j+1}=num2str(find(squeeze(RegionOfInterest(ric(j,2),ric(j,1),:))));
    froi(j)=find(squeeze(RegionOfInterest(ric(j,2),ric(j,1),:)));
    gt=FlyData{2,j+1};
    if isempty(gt)
        gt='';
    elseif numel(gt)>10
        gt=gt(1:10);
    end
    sex=FlyData{3,j+1};
    age=FlyData{4,j+1};
    cond=FlyData{5,j+1};
    if isempty(cond)
        cond='';
    elseif numel(cond)>10
        cond=cond(1:10);
    end
    fstr{j}=['#',FlyData{1,j+1},' ROI ',num2str(froi(j)),gt,' ',sex,' ',age,' ',cond];
end
handles.fly_list.String=fstr;
handles.fly_list.Value=1;
guidata(hObject,handles);





function previewROI(hObject,eventdata,handles,FILENAME)
load(FILENAME,'-mat')
handles.ROI_axes;
ROI=sum(RegionOfInterest,3);
imshow(uint8([double(ROI).*.8.*mean(FirstFrame,3)]))
for j=1:size(RegionOfInterest,3)
    roi=RegionOfInterest(:,:,j);
    [ix,jx]=ind2sub(size(roi),find(roi));
    if(mean(jx)/size(roi,2)>0.5)
        text(max(jx),min(ix),['ROI #',num2str(j)],'Color','red')
    else
        text(min(jx)-150,min(ix),['ROI #',num2str(j)],'Color','red')
    end
    
end


% --- Executes on button press in newfig_chk.
function newfig_chk_Callback(hObject, eventdata, handles)
% hObject    handle to newfig_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of newfig_chk
if get(hObject,'Value')==1 
    handles.overlay_chk.Value=0;
end

% --- Executes on button press in overlay_chk.
function overlay_chk_Callback(hObject, eventdata, handles)
% hObject    handle to overlay_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlay_chk
if get(hObject,'Value')==1 
    handles.newfig_chk.Value=0;
end

% --- Executes on button press in plot_btn.
function plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.newfig_chk.Value==1
    handles.h=figure;
else
    axes(handles.axes1);
end

if handles.overlay_chk.Value==1
    if isfield(handles,'h')&ishandle(handles.h)
        figure(handles.h);
    else
        axes(handles.axes1)
    end
    hold on
else
    cla;
end
load(handles.WTFs_list.String{handles.WTFs_list.Value},'-mat')
scale=[Xscale,Yscale];
selfly=handles.fly_list.Value;
plottype=handles.plot_type_menu.Value;
for i=1:numel(selfly)
    hold on
    switch plottype
        case 1 %distance travelled
            dat(i)=distTravel(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
            title('Distance Travelled (mm)');
            xlabel('Time');
            ylabel('Distance (mm)');
        case 2 %velocity
            dat(i)=velocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
            title('Velocity (mm/s)');
            xlabel('Time');
            ylabel('Velocity (mm/s)');
            
        case 3 % linear acceleration
            dat(i)=linearAcceleration(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
            title('Linear Acceleration');
            xlabel('Time');
            ylabel('Acceleration (mm/sec^2)');
            
        case 4 % Angular Velocity
            dat(i)=AngularVelocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
            title('Angular Velocity');
            xlabel('Time');
            ylabel('Angular Velocity (deg/sec)');
            
    end
    plot(dat(i).x,dat(i).y);
    
    
end
legend(handles.fly_list.String{selfly});
hold off
guidata(hObject,handles);

% --- Executes on button press in pltSelAve_chk.
function pltSelAve_chk_Callback(hObject, eventdata, handles)
% hObject    handle to pltSelAve_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltSelAve_chk


% --- Executes on button press in exptwkspace_btn.
function exptwkspace_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exptwkspace_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UseAll=questdlg('Export kinetic data for selected or all .wtf files?','Export Data','selected files','all files','all files');
if strcmp(UseAll,'all files')
    selection=1:numel(handles.WTFs_list.String);
else
    selection=handles.WTFs_list.Value;
end
for j=1:numel(selection)
    [p n e]=fileparts(handles.WTFs_list.String{selection(j)});
    load(handles.WTFs_list.String{selection(j)},'-mat');
    scale=[Xscale,Yscale];
    selfly=1:NumberOfFlies;
    plottype=handles.plot_type_menu.Value;
    data(j).filename=[n,e];
    data(j).FramesPerSecond=FramesPerSecond;
    data(j).InitialCoordinates=InitialCoordinates;
    data(j).FlyData=FlyData;
    data(j).Coordinates=Coordinates;
    for i=1:numel(selfly)
        switch plottype
            case 1 %distance travelled
                dat(i)=distTravel(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).distance(i,:)=dat(i).y;
                exptname='distData';
            case 2 %velocity
                dat(i)=velocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).velocity(i,:)=dat(i).y;
                exptname='velData';
            case 3 % linear acceleration
                dat(i)=linearAcceleration(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                 if i==1
                    data(j).time=dat(i).x;
                end
                data(j).acc(i,:)=dat(i).y;
                exptname='accData';
            case 4 % Angular Velocity
                dat(i)=AngularVelocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).angVel(i,:)=dat(i).y;
                exptname='angVelData';
        end
        
    end
    
end
export2wsdlg({'data'},{exptname},{data});

% --- Executes on button press in expt_to_excel_btn.
function expt_to_excel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to expt_to_excel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FILENAME=uiputfile('*.xlsx');
UseAll=questdlg('Export kinetic data for selected or all .wtf files?','Export Data','selected files','all files','all files');
if strcmp(UseAll,'all files')
    
    selection=1:numel(handles.WTFs_list.String);
else
    selection=handles.WTFs_list.Value;
end

wh=waitbar(0,'Initializing Export to Excel');
for j=1:numel(selection)
    waitbar(j/numel(selection),wh,'Exporting to Excel');
    [p n e]=fileparts(handles.WTFs_list.String{selection(j)});
    load(handles.WTFs_list.String{selection(j)},'-mat');
    scale=[Xscale,Yscale];
    selfly=1:NumberOfFlies;
    plottype=handles.plot_type_menu.Value;
    data(j).filename=[n,e];
    for i=1:numel(selfly)
        switch plottype
            case 1 %distance travelled
                dat(i)=distTravel(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).distance(i,:)=dat(i).y;
                exptname='Distance Travelled (mm)';
            case 2 %velocity
                dat(i)=velocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).velocity(i,:)=dat(i).y;
                exptname='Velocity (mm/s)';
            case 3 % linear acceleration
                dat(i)=linearAcceleration(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                 if i==1
                    data(j).time=dat(i).x;
                end
                data(j).acc(i,:)=dat(i).y;
                exptname='Acceleration (mm/s^2)';
            case 4 % Angular Velocity
                dat(i)=AngularVelocity(hObject,handles,Coordinates,FramesPerSecond,scale,selfly(i));
                if i==1
                    data(j).time=dat(i).x;
                end
                data(j).angVel(i,:)=dat(i).y;
                exptname='Angular Vel (deg/s)';
        end
        
        
    end
    xlswrite(FILENAME,{ n,e;'FPS', FramesPerSecond;'nflies',NumberOfFlies;'Threshold', Threshold; 'Xs (mm/px)', Xscale; 'Ys (mm/px)', Yscale},j,'A1');
    headerline=cell(1,NumberOfFlies+3);
    headerline{1}=exptname;
    for i=4:NumberOfFlies+3
        
        
        headerline{1,i}=['Fly # ',num2str(i-3)];
        
    end
    headerline{3}='Time(s)';
    xlswrite(FILENAME,headerline,j,'A8');
    xlswrite(FILENAME,FlyData,j,'C1');
    xlswrite(FILENAME,data(j).time',j,'C9');
    switch plottype
        case 1
            xlswrite(FILENAME,data(j).distance',j,'D9');
        case 2
            xlswrite(FILENAME,data(j).velocity',j,'D9');
        case 3
            xlswrite(FILENAME,data(j).acc',j,'D9');
        case 4
            xlswrite(FILENAME,data(j).angVel',j,'D9');
    end
end
close(wh);
h=msgbox([{'Exported to excel'};{FILENAME}]);
uiwait(h)








function abc=distTravel(hObject, handles, Coordinates,fps,scale,flynum)
xpos=Coordinates(flynum*2,:).*scale(1);
ypos=Coordinates(flynum*2+1,:).*scale(2);
if sum(isnan(xpos))>30
    h=warndlg(['Fly #',num2str(flynum),' has ', num2str(sum(isnan(xpos))/size(Coordinates,2)*100),'% NaN Coordinate Values. Filters may not work.']);
    uiwait(h);
end
xd=diff(xpos);
yd=diff(ypos);
disp=sqrt(xd.^2+yd.^2);
try
    filtsz=str2num(handles.filter_sz_edit.String);
catch
    filtsz=1;
end
switch handles.filtertype_menu.Value
    case 1
        fdisp=disp;
    case 2
       fdisp=filtfilt(1/filtsz*ones(1,filtsz),1,disp);
    case 3
        fdisp=medfilt1(disp,filtsz);
end
    
dist=cumsum(fdisp);
time=[1:numel(dist)]/fps;
abc.x=time;
abc.y=dist;

function abc=velocity(hObject,handles,Coordinates,fps,scale,flynum);
xpos=Coordinates(flynum*2,:).*scale(1);
ypos=Coordinates(flynum*2+1,:)*scale(2);
if sum(isnan(xpos))>30
    h=warndlg(['Fly #',num2str(flynum),' has ', num2str(sum(isnan(xpos))/size(Coordinates,2)*100),'% NaN Coordinate Values. Filters may not work.']);
    uiwait(h);
end
xd=diff(xpos);
yd=diff(ypos);
vel=sqrt(xd.^2+yd.^2)*fps;
try
    filtsz=str2num(handles.filter_sz_edit.String);
catch
    filtsz=1;
end
switch handles.filtertype_menu.Value
    case 1
        fvel=vel;
    case 2
       fvel=filtfilt(1/filtsz*ones(1,filtsz),1,vel);
    case 3
        fvel=medfilt1(vel,filtsz);
end
vel=fvel;
time=[1:numel(vel)]/fps;
abc.x=time;
abc.y=vel;

function abc=linearAcceleration(hObject,handles,Coordinates,fps,scale,flynum);
xpos=Coordinates(flynum*2,:).*scale(1);
ypos=Coordinates(flynum*2+1,:)*scale(2);
if sum(isnan(xpos))>30
    h=warndlg(['Fly #',num2str(flynum),' has ', num2str(sum(isnan(xpos))/size(Coordinates,2)*100),'% NaN Coordinate Values. Filters may not work.']);
    uiwait(h);
end
xd=diff(diff(xpos));
yd=diff(diff(ypos));
acc=sqrt(xd.^2+yd.^2)*fps;
try
    filtsz=str2num(handles.filter_sz_edit.String);
catch
    filtsz=1;
end
switch handles.filtertype_menu.Value
    case 1
        facc=acc;
    case 2
       facc=filtfilt(1/filtsz*ones(1,filtsz),1,acc);
    case 3
        facc=medfilt1(acc,filtsz);
end
acc=facc;
time=[1:numel(acc)]/fps;
abc.x=time;
abc.y=acc;



function abc=AngularVelocity(hObject,handles,Coordinates,fps,scale,flynum);
xpos=Coordinates(flynum*2,:).*scale(1);
ypos=Coordinates(flynum*2+1,:)*scale(2);
if sum(isnan(xpos))>30
    h=warndlg(['Fly #',num2str(flynum),' has ', num2str(sum(isnan(xpos))/size(Coordinates,2)*100),'% NaN Coordinate Values. Filters may not work.']);
    uiwait(h);
end
xd=(diff(xpos));
yd=(diff(ypos));

try
    filtsz=str2num(handles.filter_sz_edit.String);
catch
    filtsz=1;
end
switch handles.filtertype_menu.Value
    case 1
        fxd=xd;
        fyd=yd;
    case 2
       fxd=filtfilt(1/filtsz*ones(1,filtsz),1,xd);
       fyd=filtfilt(1/filtsz*ones(1,filtsz),1,yd);
    case 3
        fxd=medfilt1(xd,filtsz);
        fyd=medfilt1(yd,filtsz);
end
heading=atan2d(fyd,fxd);
negrev=find(diff(heading)<-150);
posrev=find(diff(heading)>150);
for i=1:numel(negrev)
heading(negrev(i)+1:numel(heading))=heading(negrev(i)+1:numel(heading))+360;
end
for i=1:numel(posrev)
heading(posrev(i)+1:numel(heading))=heading(posrev(i)+1:numel(heading))-360;
end
angVel=diff(heading);
angVel(find(abs(angVel)>45))=0;
angVel=angVel*fps;
switch handles.filtertype_menu.Value
    case 1
        fangVel=angVel;
    case 2
       fangVel=filtfilt(1/filtsz*ones(1,filtsz),1,angVel);
    case 3
        fangVel=medfilt1(angVel,filtsz);
end
time=[1:numel(angVel)]/fps;
abc.x=time;
abc.y=fangVel;
