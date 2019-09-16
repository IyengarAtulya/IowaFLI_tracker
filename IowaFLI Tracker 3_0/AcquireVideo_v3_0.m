function varargout = AcquireVideo_v3_0(varargin)
% ACQUIREVIDEO_V3_0 MATLAB code for AcquireVideo_v3_0.fig
%      ACQUIREVIDEO_V3_0, by itself, creates a new ACQUIREVIDEO_V3_0 or raises the existing
%      singleton*.
%
%      H = ACQUIREVIDEO_V3_0 returns the handle to a new ACQUIREVIDEO_V3_0 or the handle to
%      the existing singleton*.
%
%      ACQUIREVIDEO_V3_0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQUIREVIDEO_V3_0.M with the given input arguments.
%
%      ACQUIREVIDEO_V3_0('Property','Value',...) creates a new ACQUIREVIDEO_V3_0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AcquireVideo_v3_0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AcquireVideo_v3_0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AcquireVideo_v3_0

% Last Modified by GUIDE v2.5 23-May-2016 13:16:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AcquireVideo_v3_0_OpeningFcn, ...
    'gui_OutputFcn',  @AcquireVideo_v3_0_OutputFcn, ...
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


% --- Executes just before AcquireVideo_v3_0 is made visible.
function AcquireVideo_v3_0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AcquireVideo_v3_0 (see VARARGIN)

% Choose default command line output for AcquireVideo_v3_0
handles.output = hObject;
handles.LastName = '';
handles.LastInfo = cell(1,7);
handles.VidInfo=struct([]);
handles.PATH=[''];
handles.FILENAME='';
handles.RecordCancel = 0;
set(handles.save_txt,'String',[handles.PATH,handles.FILENAME]);
devicenames=cell(1,1);
imaqreset;
a=imaqhwinfo('winvideo');
if size(a.DeviceInfo,2)==0
    uiwait(warndlg('Warning: no video acquisition devices found. Press Refresh after connecting device', 'Acquisition Warning','modal'));
end


if size(a.DeviceInfo,2)>0
    for i=1:size(a.DeviceInfo,2)
        devicenames{i}=a.DeviceInfo(i).DeviceName;
    end
    set(handles.Device_Menu,'String',devicenames);
    handles.selecteddevice=1;
    b=imaqhwinfo('winvideo',handles.selecteddevice);
    set(handles.Formats_Menu,'String',b.SupportedFormats);
    set(handles.Formats_Menu,'Value',numel(b.SupportedFormats));
    handles.selectedformat=numel(b.SupportedFormats);
    
    handles.vid=videoinput('winvideo',handles.selecteddevice,b.SupportedFormats{handles.selectedformat});
    handles.src=getselectedsource(handles.vid);
    axes(handles.axes1);
    
    vidRes = get(handles.vid, 'VideoResolution');
    nBands = get(handles.vid, 'NumberOfBands');
    
    handles.hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
    
    preview(handles.vid,handles.hImage);
    
   % handles.src.ZoomMode = 'manual';
   handles.VidOptions=fieldnames(handles.vid.source);
   set(handles.Cam_ParamAdj_menu,'String',handles.VidOptions);
   
   
   try
    set(handles.Frame_Rate_Menu,'String',set(handles.src,'FrameRate'));
   catch
       'warning, frame rate not pulled, set to 30fps'
%        set(handles.src,'FrameRate',30);
       set(handles.Frame_Rate_Menu,'String','30');
   end
    set(handles.preview_btn,'Enable','on');
    set(handles.record_btn,'Enable','on');
end
set(handles.AqTypeSel_menu,'String',{'Single Capture','Snapshot','User-Defined Capture','Delay Capture','Scheduled Capture','Time-Lapsed Capture (Scheduled Captures)','Time-Lapsed Capture (Interval Captures)','Single Capture with Temp Log'})
set(handles.frames_edit,'String','300');
set(handles.frames_edit,'Enable','on');
set(handles.num_video_edit,'String','1')
set(handles.video_interval_edit,'String','0')

handles.framestorecord=300;
handles.videostocreate=1;
handles.videointervals=0;
handles.InfoError = 1;

handles.LastVideoPath = [pwd,'\Recorded Video'];
handles.PATH=handles.LastVideoPath;
if exist(handles.PATH)~=7
   mkdir(handles.PATH); 
else
    
end
set(handles.save_txt,'String',handles.LastVideoPath);

set(handles.save_to_btn,'Enable','on')
handles.LastInfo{1}=ones(0,0);

% %%%%%ARDUINO TEMP SENSOR%%%
% handles.tempdevtype={'None','Uno','Nano'};
% set(handles.Temp_Dev_menu,'String',handles.tempdevtype);
% set(handles.Temp_Dev_menu,'Value',2);
% handles.tempComPort={'None','COM1','COM2','COM3','COM4','COM5','COM6','COM7','COM8','COM9','COM10'};
% set(handles.TempComPort_menu,'String',handles.tempComPort);
% set(handles.TempComPort_menu,'Value',7);
% set(handles.InputChannel_menu,'String',{'ai0','ai1','ai2','ai3','ai4','ai5','ai6','ai7'});
% set(handles.tempSampleRate_edit,'String','0.5');
% handles.ard_com=handles.tempComPort{7};
% handles.ard_dev=handles.tempdevtype{2};
% try
%     handles.ard=arduino(handles.ard_com,handles.ard_dev);
%     handles.ardchan=handles.ard.AvailablePins(12+get(handles.InputChannel_menu,'Value'));
%     set(handles.curr_temp_btn,'Enable','on')
%     drawnow
%     curr_temp_btn_Callback(hObject, eventdata, handles)
%     handles.stoptemp=0;
%     
%     
%     
% catch
%     set(handles.Temp_Dev_menu,'Value',1);
%     set(handles.TempComPort_menu,'Value',1);
%     set(handles.InputChannel_menu,'Enable','off')
%     set(handles.rec_temp_chk,'Value',0);
%     h=warndlg('No Arduino Device Found. Please Retry');
%     uiwait(h);
%     handles.ard=0;
%     
% end

try
    handles.temp_dev=daq.getDevices;
    if ~isempty(handles.temp_dev)
        %try
        for i=1:numel(handles.temp_dev)
            availDev{i}=handles.temp_dev(i).ID;
        end
        handles.temp_Session=daq.createSession('ni');
        handles.temp_Session.addAnalogInputChannel('Dev2','ai0','Thermocouple')
        handles.temp_ch=handles.temp_Session.Channels(1);
        handles.temp_ch.ThermocoupleType='T';
        handles.temp_ch.Units='Celsius';
        currtemp= handles.temp_Session.inputSingleScan;
        
        %  catch
        % end
    end
    set(handles.Temp_Dev_menu,'String',availDev);
    set(handles.InputChannel_menu,'Visible','off')
    set(handles.tempSampleRate_edit,'Visible','off')
    set(handles.TempComPort_menu,'Visible','off')
    set(handles.temp_txt,'String',['initial temp: ',num2str(currtemp),' C']);
    set(handles.curr_temp_btn,'Enable','on');
catch
    disp('No Temp Sensor Found');
    handles.temp_dev='none';
end





% Update handles structure
guidata(hObject, handles);

% while handles.stoptemp==0
%     curr_temp_btn_Callback(hObject, eventdata, handles)
%     pause(2)
% end



% % UIWAIT makes AcquireVideo_v3_0 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AcquireVideo_v3_0_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.stoptemp=1;

varargout{1} = handles.output;


% --- Executes on button press in record_btn.
function record_btn_Callback(hObject, eventdata, handles)
% hObject    handle to record_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if get(handles.AutoAdvFile_chk,'Value')
    [p n e]=fileparts(handles.FILENAME);
    C=strsplit(n,'_');
    C{end}=datestr(datetime,'yyyymmddHHMM');
    handles.FILENAME=[strjoin(C,'_'),'.mp4'];
    guidata(hObject,handles);
end
[p n e]=fileparts(handles.FILENAME);
if isempty(handles.VidInfo) & get(handles.ReqVidInfo_Chk,'Value')
    Video_Info_btn_Callback(hObject, eventdata, handles)
end
if ~isempty(handles.VidInfo)
    VidInfo=handles.VidInfo;
    save([handles.PATH,'\',n,'.mat'],'VidInfo');
end

if isempty(handles.FILENAME)
    handles.FILENAME =['test_',datestr(datetime,'yyyymmddHHMM'),'.mp4'];
    handles.FILENAME_txt.String=handles.FILENAME;
end
guidata(hObject,handles);

%%% Video Acquisition
if get(handles.AqTypeSel_menu,'Value')==1
    handles.aviobj=VideoWriter([handles.PATH,'\',handles.FILENAME],'MPEG-4');
   
    handles.aviobj.FrameRate=str2num(get(handles.vid.source,'FrameRate'));
    handles.vid.LoggingMode='disk';
    handles.vid.DiskLogger=handles.aviobj;
    handles.framestorecord=str2num(get(handles.frames_edit,'String'));
    
    
    set(handles.vid,'FramesPerTrigger',handles.framestorecord);
    start(handles.vid);
    try
        h1=waitbar(0,['Recorded Frames: ',num2str(handles.vid.DiskLoggerFrameCount)]);
    end
    if strcmp(handles.temp_dev,'none')~=1
        ctemp=handles.temp_Session.inputSingleScan;
    else
        ctemp=nan;
    end
%     if(handles.ard~=0)
%         ctemp=readVoltage(handles.ard,handles.ardchan{1});
%     else
%         ctemp=nan
%     end
    handles.tempdat=[0,ctemp];
    while handles.vid.DiskLoggerFrameCount<handles.framestorecord
        try
%             if handles.ard~=0
%                 handles.tempdat(end+1,1)=handles.vid.DiskLoggerFrameCount;
%                 handles.tempdat(end,2)=47.921+(-0.1384*100*readVoltage(handles.ard,handles.ardchan{1}));
%             else
%                 handles.tempdat(end+1,1)=nan;
%                 handles.tempdat(end,2)= nan;
%             end
            if strcmp(handles.temp_dev,'none')~=1
                handles.tempdat(end+1,1)=handles.vid.DiskLoggerFrameCount;
                handles.tempdat(end,2)=handles.temp_Session.inputSingleScan;
                ct=handles.tempdat(end,2);
                disp(['Current Temp = ',num2str(ct) ,' C'])
                cd=datetime('now','Format','HH:mm:ss');
                set(handles.temp_txt,'String',[num2str(ct,'%3.1f'), ' C  ',char(cd)]);
            else
               handles.tempdat(end+1,1)=nan;
               handles.tempdat(end,2)= nan;
            end
        catch
             handles.tempdat(end+1,1)=nan;
             handles.tempdat(end,2)= nan;
            
        end
            waitbar(handles.vid.DiskLoggerFrameCount/handles.framestorecord,h1,['Recorded Frames: ',num2str(handles.vid.DiskLoggerFrameCount), '     Temp: ',num2str(handles.tempdat(end,2))]);
            
%             pause(1/str2num(get(handles.tempSampleRate_edit,'String')))
            
        
    end
    close(h1);
    
end
[p n e]=fileparts(handles.FILENAME);
tempdat=handles.tempdat;
try
    save([handles.PATH,'\',n,'.mat'],'tempdat','-append');
catch
%    save([handles.PATH,n,'.mat'],'tempdat');
end

if get(handles.AqTypeSel_menu,'Value')==3
    handles.aviobj=VideoWriter([handles.PATH,'\',handles.FILENAME],'MPEG-4');
    
    handles.aviobj.FrameRate=str2num(get(handles.vid.source,'FrameRate'));
    handles.vid.LoggingMode='disk';
    handles.vid.DiskLogger=handles.aviobj;
    set(handles.vid,'FramesPerTrigger',inf);
    start(handles.vid);
    waitfor(msgbox('Press Ok to Stop Video','Recording...','modal'));
    stop(handles.vid);
    
    
end

if get(handles.AqTypeSel_menu,'Value')==4
    handles.aviobj=VideoWriter([handles.PATH,'\',handles.FILENAME],'MPEG-4');
    
    handles.aviobj.FrameRate=str2num(get(handles.vid.source,'FrameRate'));
    handles.vid.LoggingMode='disk';
    handles.vid.DiskLogger=handles.aviobj;
    set(handles.vid,'FramesPerTrigger',handles.framestorecord);
    idelay=handles.videointervals;
    delay=idelay;
    h=waitbar(1,'Delay Remaining');
    while delay~=0
        try
            waitbar(delay/idelay,h)
            pause(1)
            delay=delay-1;
        catch
            delay = delay -1;
        end
    end
    close(h);
    start(handles.vid);
    h=waitbar(0,'Recording');
    while handles.vid.DiskLoggerFrameCount~=handles.framestorecord
        pause(0.5)
        waitbar(handles.vid.DiskLoggerFrameCount/handles.framestorecord,h,['Recorded Frames: ',num2str(handles.vid.DiskLoggerFrameCount)]);
    end
    close(h);
    
end

if get(handles.AqTypeSel_menu,'Value')==5
    ctime=clock;
    ttime(1:3)=ctime(1:3);
    enttime=get(handles.CapStTime_edit,'String');
    c=textscan(enttime,'%d','delimiter',':');
    b=c{1};
    ttime(4:6)=b(1:3);
    dt=etime(ttime,ctime);
    if dt<0
        dt = dt+24*3600;
    end
    initialwait=dt;
    h=waitbar(1,[num2str(initialwait),' Seconds to Recording']);
    while dt>0
        pause(0.5);
        ctime=clock;
        dt=round(etime(ttime,ctime));
        if dt<0
            dt = dt+24*3600;
        end
        waitbar(dt/initialwait,h,['Record Countdown:' datestr(dt/86400,'HH:MM:SS')]);
    end
    
    C=strsplit(n,'_');
    C{end}=datestr(datetime,'yyyymmddHHMM');
    handles.FILENAME=[strjoin(C,'_'),'.mp4'];
    guidata(hObject,handles);
    close(h);
    handles.aviobj=VideoWriter([handles.PATH,handles.FILENAME],'MPEG-4');
    handles.aviobj.FrameRate=str2double(get(handles.vid.source,'FrameRate'));
    handles.vid.LoggingMode='disk';
    handles.vid.DiskLogger=handles.aviobj;
    set(handles.vid,'FramesPerTrigger',handles.framestorecord);
    start(handles.vid);
    h=waitbar(0,['Time Remaining: ',datestr((handles.framestorecord-handles.vid.DiskLoggerFrameCount)/2592000,'HH:MM:SS')]);
    handles.vid.DiskLoggerFrameCount
    handles.framestorecord
    while handles.vid.DiskLoggerFrameCount<handles.framestorecord
        try
        pause(0.5)
        waitbar(handles.vid.DiskLoggerFrameCount/handles.framestorecord,h,['Time Remaining: ',datestr((handles.framestorecord-handles.vid.DiskLoggerFrameCount)/2592000,'HH:MM:SS')]);
        catch
        end
    end
    close(h);
end
handles.LastName = '';
guidata(hObject, handles);




function frames_edit_Callback(hObject, eventdata, handles)
% hObject    handle to frames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frames_edit as text
%        str2double(get(hObject,'String')) returns contents of frames_edit as a double

frames=get(hObject,'String');
nframes=str2double(frames);
nframes=round(nframes);
nframes=abs(nframes);
if isnan(nframes)
    set(hObject,'String',num2str(handles.framestorecord));
end
if nframes==0
    nframes=1;
end
if ~isnan(nframes)
    handles.framestorecord=nframes;
    set(hObject,'String',num2str(nframes));
end
if handles.framestorecord>0
    set(handles.record_btn,'Enable','on');
end
if handles.framestorecord==0
    set(handles.record_btn,'Enable','off');
end

%modify the duration
try
    frate=get(handles.Frame_Rate_Menu,'String');
    fvals=get(handles.Frame_Rate_Menu,'Value');
    FPS=frate{fvals};
    vidduration=handles.framestorecord/FPS;
    vidmin=floor(vidduration/60);
    vidsec=mod(vidduration,60);
    durstr=[num2str(vidmin),':',num2str(vidsec)];
    set(handles.Dur_txt,'String',durstr);
catch
    set(handles.Dur_txt,'String','');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function frames_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Device_Menu.
function Device_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Device_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Device_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Device_Menu
handles.selecteddevice=get(hObject,'Value');
b=imaqhwinfo('winvideo',handles.selecteddevice);
set(handles.Formats_Menu,'Value',1);
set(handles.Formats_Menu,'String',b.SupportedFormats);
set(handles.Formats_Menu,'Value',numel(b.SupportedFormats));
handles.vid=videoinput('winvideo',handles.selecteddevice);
handles.selectedformat=numel(b.SupportedFormats);
handles.src=getselectedsource(handles.vid);
try
set(handles.Frame_Rate_Menu,'String',set(handles.src,'FrameRate'));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Device_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Device_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Formats_Menu.
function Formats_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Formats_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Formats_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Formats_Menu
handles.selectedformat=get(hObject,'Value');
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Formats_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Formats_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Frame_Rate_Menu.
function Frame_Rate_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Frame_Rate_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Frame_Rate_Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Frame_Rate_Menu


% --- Executes during object creation, after setting all properties.
function Frame_Rate_Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frame_Rate_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AqTypeSel_menu.
function AqTypeSel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to AqTypeSel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AqTypeSel_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AqTypeSel_menu
seltype=get(hObject,'Value');
if seltype==1
    set(handles.frames_edit,'Enable','on');
    set(handles.frames_edit,'String','300');
    set(handles.num_video_edit,'Enable','off');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Interval between Videos (s)');
    set(handles.video_interval_edit,'Enable','off');
    set(handles.video_interval_edit,'String','0');
    set(handles.CapStTime_edit,'Enable','off');
    set(handles.CapStTime_edit,'String','-');
end
if seltype==2
    set(handles.frames_edit,'Enable','off');
    set(handles.frames_edit,'String','1');
    set(handles.num_video_edit,'Enable','off');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Interval between Videos (s)');
    set(handles.video_interval_edit,'Enable','off');
    set(handles.video_interval_edit,'String','0');
    set(handles.CapStTime_edit,'Enable','off');
    set(handles.CapStTime_edit,'String','-');
end
if seltype==3
    set(handles.frames_edit,'Enable','off');
    set(handles.frames_edit,'String','-');
    set(handles.num_video_edit,'Enable','off');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Interval between Videos (s)');
    set(handles.video_interval_edit,'Enable','off');
    set(handles.video_interval_edit,'String','0');
    set(handles.CapStTime_edit,'Enable','off');
    set(handles.CapStTime_edit,'String','-');
end
if seltype==4
    set(handles.frames_edit,'Enable','on');
    set(handles.frames_edit,'String','300');
    set(handles.num_video_edit,'Enable','off');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Delay (s)');
    set(handles.video_interval_edit,'Enable','on');
    set(handles.video_interval_edit,'String','1');
    set(handles.CapStTime_edit,'Enable','off');
    set(handles.CapStTime_edit,'String','-');
end
if seltype==5
    set(handles.frames_edit,'Enable','on');
    set(handles.frames_edit,'String','300');
    set(handles.num_video_edit,'Enable','off');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Interval between Videos (s)');
    set(handles.video_interval_edit,'Enable','off');
    set(handles.video_interval_edit,'String','0');
    ct=fix(clock);
    cthr=mod(ct(4)+1,24);
    ctm=ct(5);
    cts=ct(6);
    set(handles.CapStTime_edit,'Enable','on');
    set(handles.CapStTime_edit,'String',[num2str(cthr,'%02.0f'),':',num2str(ctm,'%02.0f'),':',num2str(cts,'%02.0f')]);
end
if seltype==6
    set(handles.frames_edit,'Enable','on');
    set(handles.frames_edit,'String','300');
    set(handles.num_video_edit,'Enable','on');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Interval between Videos (s)');
    set(handles.video_interval_edit,'Enable','on');
    set(handles.video_interval_edit,'String','0');
    ct=fix(clock);
    cthr=mod(ct(4)+1,24);
    ctm=ct(5);
    cts=ct(6);
    set(handles.CapStTime_edit,'Enable','on');
    set(handles.CapStTime_edit,'String',[num2str(cthr,'%02.0f'),':',num2str(ctm,'%02.0f'),':',num2str(cts,'%02.0f')]);
end
if seltype==7
    set(handles.frames_edit,'Enable','on');
    set(handles.frames_edit,'String','300');
    set(handles.num_video_edit,'Enable','on');
    set(handles.num_video_edit,'String','1');
    set(handles.text10,'String','Intervals between Videos (s)');
    set(handles.video_interval_edit,'Enable','on');
    set(handles.video_interval_edit,'String','0');
    set(handles.CapStTime_edit,'Enable','off');
    set(handles.CapStTime_edit,'String','-');
end

% --- Executes during object creation, after setting all properties.
function AqTypeSel_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AqTypeSel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preview_btn.
function preview_btn_Callback(hObject, eventdata, handles)
% hObject    handle to preview_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% h=imaqhwinfo('winvideo',handles.selecteddevice);
% format=h.SupportedFormats{handles.selectedformat};



delete(handles.vid);
clear handles.vid

cla(handles.axes1);
axes(handles.axes1);

b=imaqhwinfo('winvideo',handles.selecteddevice);
handles.vid=videoinput('winvideo',handles.selecteddevice,b.SupportedFormats{handles.selectedformat});
handles.VidOptions=fieldnames(handles.vid.source);
set(handles.Cam_ParamAdj_menu,'String',handles.VidOptions);
try
    set(handles.Cam_ParamAdj_menu,'Value',find(strcmp(handles.VidOptions,'Focus')));
    
catch
    set(handles.Cam_ParamAdj_menu,'Value',1);
end
Cam_ParamAdj_menu_Callback(handles.Cam_ParamAdj_menu, eventdata, handles);

vidRes = get(handles.vid, 'VideoResolution');
nBands = get(handles.vid, 'NumberOfBands');
%  handles.src=getselectedsource(handles.vid);
% %    handles.src.ZoomMode = 'manual';
handles.hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(handles.vid,handles.hImage)
guidata(hObject,handles)





% --- Executes on button press in save_to_btn.
function handles = save_to_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_to_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D=datestr(datetime,'yyyymmddHHMM')
if~isempty(handles.LastInfo{1})
    SuggestedName = [handles.LastVideoPath, '\', num2str(handles.NumOfFlies), '_', handles.Genotype{1}, '_', handles.Sex{1}, '_', handles.Age{1},'_', D,'.mp4'];
else
    SuggestedName=[handles.LastVideoPath,'\Test_',D,'.mp4'];
end
[FILENAME,PATH]=uiputfile('*.mp4','Save Video As',SuggestedName);
if FILENAME~=0
    set(handles.save_txt,'String',PATH);
    set(handles.FILENAME_txt,'String',FILENAME);
    handles.LastVideoPath = PATH;
    FILENAME = FILENAME(FILENAME~=' ');
    handles.FILENAME=FILENAME;
    handles.PATH=PATH;
else
    
end

guidata(hObject, handles);


% --- Executes on button press in Refresh_Btn.
function Refresh_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imaqreset;
a=imaqhwinfo('winvideo');
if size(a.DeviceInfo,2)==0
    uiwait(warndlg('Warning: no video acquisition devices found. Press Refresh after connecting device', 'Acquisition Warning','modal'));
    set(handles.preview_btn,'Enable','off');
    set(handles.record_btn,'Enable','off');
    
end


if size(a.DeviceInfo,2)>0
    for i=1:size(a.DeviceInfo,2)
        devicenames{i}=a.DeviceInfo(i).DeviceName;
    end
    set(handles.Device_Menu,'String',devicenames);
    handles.selecteddevice=1;
    
    b=imaqhwinfo('winvideo',handles.selecteddevice);
    set(handles.Formats_Menu,'String',b.SupportedFormats);
    set(handles.Formats_Menu,'Value',find(strcmp(b.DefaultFormat,b.SupportedFormats)));
    handles.selectedformat=find(strcmp(b.DefaultFormat,b.SupportedFormats));
    
    handles.vid=videoinput('winvideo',handles.selecteddevice,b.SupportedFormats{handles.selectedformat});
    handles.src=getselectedsource(handles.vid);
    axes(handles.axes1);
    
    vidRes = get(handles.vid, 'VideoResolution');
    nBands = get(handles.vid, 'NumberOfBands');
    
    handles.hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
    
    preview(handles.vid,handles.hImage);
    
   % handles.src.ZoomMode = 'manual';
   handles.VidOptions=fieldnames(handles.vid.source);
    
   
    handles.src=getselectedsource(handles.vid);
    try
    set(handles.Frame_Rate_Menu,'String',get(handles.src,'FrameRate'));
    catch
        warndlg('Warning, Frame-Rate may be unreliable, check video/calibration. Nominally set to 30 fps')
        set(handles.Frame_Rate_Menu,'String','30');
    end
    try
       handles.VidOptions=fieldnames(handles.vid.source);
        set(handles.Cam_ParamAdj_menu,'String',handles.VidOptions)
    catch
        
    end
    set(handles.preview_btn,'Enable','on');
    set(handles.record_btn,'Enable','on');
end
guidata(hObject,handles);



function num_video_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_video_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_video_edit as text
%        str2double(get(hObject,'String')) returns contents of num_video_edit as a double
nvideo=str2double(get(hObject,'String'));
nvideo=round(nvideo)
nvideo=abs(nvideo)
if nvideo==0
    nvideo=1;
end
if ~isnan(nvideo)
    set(hObject,'String',num2str(nvideo));
    handles.videostocreate=nvideo;
end
if isnan(nvideo)
    set(hObject,'String',num2str(handles.videostocreate));
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function num_video_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_video_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function video_interval_edit_Callback(hObject, eventdata, handles)
% hObject    handle to video_interval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of video_interval_edit as text
%        str2double(get(hObject,'String')) returns contents of video_interval_edit as a double

intervalsize=str2double(get(hObject,'String'));
intervalsize=round(intervalsize);
intervalsize=abs(intervalsize);
if isnan(intervalsize)
    set(hObject,'String',num2str(handles.videointervals));
end
if ~isnan(intervalsize)
    set(hObject,'String',num2str(intervalsize));
    handles.videointervals=intervalsize;
end


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function video_interval_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_interval_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Stop_Btn.
function Stop_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(0.5)
stop(handles.vid);
%set(handles.Stop_Btn,'Enable','off');
set(handles.text12,'String','');
handles.aviobj=close(handles.vid.DiskLogger);
delete(handles.vid);
clear handles.vid;


function CapStTime_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CapStTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CapStTime_edit as text
%        str2double(get(hObject,'String')) returns contents of CapStTime_edit as a double
    try
   enttime=get(hObject,'String');
   c=textscan(enttime,'%d','delimiter',':');
   b=c{1};
   hour=mod(round(abs(b(1))),24);
   min=mod(round(abs(b(2))),60);
   sec=mod(round(abs(b(3))),60);
   set(hObject,'String',[num2str(hour,'%02.0f'),':',num2str(min,'%02.0f'),':', num2str(sec,'%02.0f')]);
   
   
    catch
        warndlg('Invalid Time Format. Reverting to Default Time','Time Warning','modal')
        ct=fix(clock);
        cthr=mod(ct(4)+1,24);
        ctm=ct(5);
        cts=ct(6);
        set(hObject,'String',[num2str(cthr,'%02.0f'),':',num2str(ctm,'%02.0f'),':',num2str(cts,'%02.0f')]);
    end
    


% --- Executes during object creation, after setting all properties.
function CapStTime_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CapStTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function handles = WriteToFile(handles)
fvals=get(handles.Frame_Rate_Menu,'Value');
frates = get(handles.Frame_Rate_Menu,'string');
formats = get(handles.Formats_Menu,'string');
format=get(handles.Formats_Menu,'Value');

TextFile = fopen('Z:\wuTRACK\Contact Sheet DB\Videos.xml','r');
AllText = textscan(TextFile,'%s');
TextSize = size(AllText{1});
x = TextSize(1);

while x > 0
    try
    if strcmp(AllText{1}{x}(1:11), '<WuTrackID>')
        index = x;
        break
    end
    end
        x = x-1;
end

startbracket = strfind(AllText{1}{index},'ID>');
endbracket = strfind(AllText{1}{index},'</Wu');

handles.WuTrackID = str2num(AllText{1}{index}(startbracket(1)+3:endbracket-1)) + 1;

fclose(TextFile);


%DEFINE WHERE TO SAVE
%THIS IS HERE SO THAT IF YOU CANCEL WHEN SAVING THE LOG FILE DOESNT GET 
%WRITTEN TO WITHOUT A VIDEO BEING CREATED
SaveButtonPress = @save_to_btn_Callback;
handles = SaveButtonPress(handles.save_to_btn, '', handles);


if  handles.RecordCancel == 0
% WRITE TO TEXT FILE
TextFile = fopen('Z:\wuTRACK\Contact Sheet DB\Videos.xml','r+');
fseek(TextFile, -11, 'eof');

fprintf(TextFile,'<Video>\n');
fprintf(TextFile,'<WuTrackID>%s</WuTrackID>\n',num2str(handles.WuTrackID));
fprintf(TextFile,'<Experimenter_Last_Name>%s</Experimenter_Last_Name>\n',handles.LastName);
for x = 1:handles.NumOfFlies
    fprintf(TextFile,'<Fly_%s>\n',num2str(x));
    fprintf(TextFile,'<WuTrackID>%s</WuTrackID>\n',num2str(handles.WuTrackID));
    fprintf(TextFile,'<Genotype>%s</Genotype>\n',handles.Genotype{x});
    fprintf(TextFile,'<Sex>%s</Sex>\n',handles.Sex{x});
    fprintf(TextFile,'<Age>%s</Age>\n',handles.Age{x});    
    fprintf(TextFile,'<LineID>%s</LineID>\n',handles.LineID{x});
    fprintf(TextFile,'</Fly_%s>',num2str(x));
end

fprintf(TextFile,'<Experimental_Conditions>%s</Experimental_Conditions>\n',handles.Conditions);
fprintf(TextFile,'<Other_Comments>%s</Other_Comments>\n',handles.Comments);
fprintf(TextFile,'<Date_Time>%s</Date_Time>\n',datestr(now));
fprintf(TextFile,'<File_Location>%s</File_Location>\n',get(handles.save_txt,'string'));
fprintf(TextFile,'<Frame_Rate>%s</Frame_Rate>\n',frates{fvals});
fprintf(TextFile,'<Format_of_Video>%s</Format_of_Video>\n',formats{format});
fprintf(TextFile,'</Video>\n</Database>');
fclose(TextFile);
clear TextFile

TextFile = fopen('Z:\wuTRACK\WuTrackLog_Viewable.txt','a');
fprintf(TextFile,'\n************************************************************\n');
fprintf(TextFile,'WuTrackID: %s\n',num2str(handles.WuTrackID));
fprintf(TextFile,'Experimenter Last Name: %s\n',handles.LastName);
fprintf(TextFile,'Genotype\tSex\tAge (days)\tLineID\n');
for x = 1:handles.NumOfFlies
fprintf(TextFile,'   %s',handles.Genotype{x});
fprintf(TextFile,'\t%s',handles.Sex{x});
fprintf(TextFile,'\t%s',handles.Age{x});
fprintf(TextFile,'\t%s\n',handles.LineID{x});
end
fprintf(TextFile,'Experimental Conditions: %s\n',handles.Conditions);
fprintf(TextFile,'Other Comments: %s\n',handles.Comments);
fprintf(TextFile,'Date & Time: %s\n',datestr(now));
fprintf(TextFile,'File Location: %s\n',get(handles.save_txt,'string'));
fprintf(TextFile,'Frame Rate of Video: %s\n',frates{fvals});
fprintf(TextFile,'Format of Video: %s\n',formats{format});
fprintf(TextFile,'************************************************************\n');
fclose(TextFile);
clear TextFile

end
guidata(handles.save_to_btn,handles);



% --- Executes on button press in Video_Info_btn.
function Video_Info_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Video_Info_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% try
handles.VidInfo = Video_FlyInfo(0,handles.LastInfo);
handles.InfoError = 0;
guidata(hObject, handles);
% catch
%     handles.InfoError = 1;
%     guidata(hObject, handles);
% end


% --- Executes on slider movement.
function Cam_ParamAdj_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdj_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
nv=get(hObject,'Value');
VidOpt=handles.VidOptions{get(handles.Cam_ParamAdj_menu,'Value')};
switch VidOpt
    case 'Focus'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Focus',(nv));
    case 'Brightness'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Brightness',(nv));
    case 'Contrast'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Contrast',(nv));
    case 'Gain'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Gain',(nv));
    case 'ExposureMode'
        if round(nv)==1
            set(handles.Cam_ParamAdjVal_edit,'String','manual');
            set(handles.vid.source,'ExposureMode','manual');
        else
            set(handles.Cam_ParamAdjVal_edit,'String','auto');
            set(handles.vid.source,'ExposureMode','auto');
        end
        
    case 'Exposure'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Exposure',(nv));
        
    case 'BacklightCompensation'
        if round(nv)==1
            set(handles.Cam_ParamAdjVal_edit,'String','on');
            set(handles.vid.source,'BacklightCompensation','on');
        else
            set(handles.Cam_ParamAdjVal_edit,'String','off');
            set(handles.vid.source,'BacklightCompensation','off');
        end
        
    case 'WhiteBalanceMode'
        if round(nv)==1
            set(handles.Cam_ParamAdjVal_edit,'String','manual');
            set(handles.vid.source,'WhiteBalanceMode','manual');
        else
            set(handles.Cam_ParamAdjVal_edit,'String','auto');
            set(handles.vid.source,'WhiteBalanceMode','auto');
        end
        
    case 'WhiteBalance'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'WhiteBalance',(nv));
    case 'Saturation'
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(nv));
        set(handles.vid.source,'Saturation',(nv));
        
    otherwise
end

% --- Executes during object creation, after setting all properties.
function Cam_ParamAdj_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdj_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in Cam_ParamAdj_menu.
function Cam_ParamAdj_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdj_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Cam_ParamAdj_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Cam_ParamAdj_menu
try
    VidOpt=handles.VidOptions{get(hObject,'Value')};
catch
    VidOpt='null';
end
set(handles.Cam_ParamAdj_Slider,'SliderStep',[0.01,0.1]);
switch VidOpt
    case 'Focus'
        set(handles.vid.source,'FocusMode','manual');
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Focus')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Focus');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Focus'));
        
    case 'Brightness'
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Brightness')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Brightness');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Brightness'));
        
    case 'Contrast'
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Contrast')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Contrast');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Contrast'));
        
    case 'Gain'
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Gain')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Gain');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Gain'));
        
    case 'ExposureMode'
        set(handles.Cam_ParamAdjVal_edit,'Enable','off');
        set(handles.Cam_ParamAdjVal_edit,'String',get(handles.vid.source,'ExposureMode'));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'ExposureMode');
        set(handles.Cam_ParamAdj_Slider,'Max',1);
        set(handles.Cam_ParamAdj_Slider,'Min',0);
        set(handles.Cam_ParamAdj_Slider,'Value',strcmp(get(handles.vid.source,'ExposureMode'), 'manual'));
        set(handles.Cam_ParamAdj_Slider,'SliderStep',[1,1]);
        
    case 'Exposure'
        set(handles.vid.source,'ExposureMode','manual');
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Exposure')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Exposure');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Exposure'));
        
    case 'BacklightCompensation'
        set(handles.Cam_ParamAdjVal_edit,'Enable','off');
        set(handles.Cam_ParamAdjVal_edit,'String',get(handles.vid.source,'BacklightCompensation'));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'BacklightCompensation');
        set(handles.Cam_ParamAdj_Slider,'Max',1);
        set(handles.Cam_ParamAdj_Slider,'Min',0);
        set(handles.Cam_ParamAdj_Slider,'Value',strcmp(get(handles.vid.source,'BacklightCompensation'), 'on'));
        set(handles.Cam_ParamAdj_Slider,'SliderStep',[1,1]);
        
    case 'WhiteBalanceMode'
        set(handles.Cam_ParamAdjVal_edit,'Enable','off');
        set(handles.Cam_ParamAdjVal_edit,'String',get(handles.vid.source,'WhiteBalanceMode'));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'WhiteBalanceMode');
        set(handles.Cam_ParamAdj_Slider,'Max',1);
        set(handles.Cam_ParamAdj_Slider,'Min',0);
        set(handles.Cam_ParamAdj_Slider,'Value',strcmp(get(handles.vid.source,'WhiteBalanceMode'), 'manual'));
        set(handles.Cam_ParamAdj_Slider,'SliderStep',[1,1]);
        
    case 'WhiteBalance'
        set(handles.vid.source,'WhiteBalanceMode','manual');
        set(handles.Cam_ParamAdjVal_edit,'Enable','on');
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'WhiteBalance')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'WhiteBalance');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'WhiteBalance'));
        
    case 'Saturation'
        set(handles.Cam_ParamAdjVal_edit,'Enable','on')
        set(handles.Cam_ParamAdjVal_edit,'String',num2str(get(handles.vid.source,'Saturation')));
        set(handles.Cam_ParamAdj_Slider,'Enable','on');
        a=propinfo(handles.vid.source,'Saturation');
        set(handles.Cam_ParamAdj_Slider,'Max',a.ConstraintValue(2));
        set(handles.Cam_ParamAdj_Slider,'Min',a.ConstraintValue(1));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Saturation'));
        
        
        
    otherwise
        
        set(handles.Cam_ParamAdjVal_edit,'Enable','off')
        set(handles.Cam_ParamAdjVal_edit,'String','')
        set(handles.Cam_ParamAdj_Slider,'Enable','off')
end

    

% --- Executes during object creation, after setting all properties.
function Cam_ParamAdj_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdj_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles



function Cam_ParamAdjVal_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdjVal_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cam_ParamAdjVal_edit as text
%        str2double(get(hObject,'String')) returns contents of Cam_ParamAdjVal_edit as a double

nv=get(hObject,'String')
VidOpt=handles.VidOptions{get(handles.Cam_ParamAdj_menu,'Value')};
switch VidOpt
    case 'Focus'
        if~isempty(str2num(nv))
           set(handles.vid.source,'Focus',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'Focus')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Focus'));
    case 'Brightness'
        if~isempty(str2num(nv))
           set(handles.vid.source,'Brightness',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'Brightness')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Brightness'));
    
         case 'Contrast'
        if~isempty(str2num(nv))
           set(handles.vid.source,'Contrast',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'Contrast')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Contrast'));
        
          case 'Gain'
        if~isempty(str2num(nv))
           set(handles.vid.source,'Gain',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'Gain')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Gain'));
        
         case 'Exposure'
        if~isempty(str2num(nv))
           set(handles.vid.source,'Exposure',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'Exposure')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'Exposure'));
        
        case 'WhiteBalance'
        if~isempty(str2num(nv))
           set(handles.vid.source,'WhiteBalance',str2num(nv));
        end
        set(hObject,'String',num2str(get(handles.vid.source,'WhiteBalance')));
        set(handles.Cam_ParamAdj_Slider,'Value',get(handles.vid.source,'WhiteBalance'));
        
    otherwise
        
end




% --- Executes during object creation, after setting all properties.
function Cam_ParamAdjVal_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cam_ParamAdjVal_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ReqVidInfo_Chk.
function ReqVidInfo_Chk_Callback(hObject, eventdata, handles)
% hObject    handle to ReqVidInfo_Chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReqVidInfo_Chk


% --- Executes on button press in AutoAdvFile_chk.
function AutoAdvFile_chk_Callback(hObject, eventdata, handles)
% hObject    handle to AutoAdvFile_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoAdvFile_chk


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in curr_temp_btn.
function curr_temp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to curr_temp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.ardchan=handles.ard.AvailablePins(12+get(handles.InputChannel_menu,'Value'));
% ct=47.921+(-0.1384*100*readVoltage(handles.ard,handles.ardchan{1}));

ct=handles.temp_Session.inputSingleScan;
cd=datetime('now','Format','HH:mm:ss');
set(handles.temp_txt,'String',[num2str(ct,'%3.1f'), ' C  ',char(cd)]);

guidata(hObject,handles);


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Temp_Dev_menu.
function Temp_Dev_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_Dev_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Temp_Dev_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Temp_Dev_menu


% --- Executes during object creation, after setting all properties.
function Temp_Dev_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temp_Dev_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InputChannel_menu.
function InputChannel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to InputChannel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InputChannel_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InputChannel_menu


% --- Executes during object creation, after setting all properties.
function InputChannel_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputChannel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSampleRate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tempSampleRate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tempSampleRate_edit as text
%        str2double(get(hObject,'String')) returns contents of tempSampleRate_edit as a double


% --- Executes during object creation, after setting all properties.
function tempSampleRate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSampleRate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TempComPort_menu.
function TempComPort_menu_Callback(hObject, eventdata, handles)
% hObject    handle to TempComPort_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TempComPort_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TempComPort_menu


% --- Executes during object creation, after setting all properties.
function TempComPort_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempComPort_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TempArduinoRefresh_btn.
function TempArduinoRefresh_btn_Callback(hObject, eventdata, handles)
% hObject    handle to TempArduinoRefresh_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


devnum=get(handles.Temp_Dev_menu,'Value');


portnum=get(handles.TempComPort_menu,'Value');
set(handles.InputChannel_menu,'String',{'ai0','ai1','ai2','ai3','ai4','ai5','ai6','ai7'});
set(handles.tempSampleRate_edit,'String','0.5');
handles.ard_com=handles.TempComPort{portnum};
handles.ard_dev=handles.tempdevtype{devnum};
try
    handles.ard=0;
    handles.ard=arduino(handles.ard_com,handles.ard_dev);
    set(handles.curr_temp_btn,'Enable','on')
catch
    set(handles.InputChannel_menu,'Enable','off');
    set(handles.curr_temp_btn,'Enable','off');
    h=warndlg('No Arduino Device Found. Please Retry');
    uiwait(h);
    handles.ard=0;
end


% --- Executes on button press in rec_temp_chk.
function rec_temp_chk_Callback(hObject, eventdata, handles)
% hObject    handle to rec_temp_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rec_temp_chk
