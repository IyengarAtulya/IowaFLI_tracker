function varargout = iowaFLI_Tracker_3_1(varargin)
% IOWAFLI_TRACKER_3_1 MATLAB code for iowaFLI_Tracker_3_1.fig
%      IOWAFLI_TRACKER_3_1, by itself, creates a new IOWAFLI_TRACKER_3_1 or raises the existing
%      singleton*.
%
%      H = IOWAFLI_TRACKER_3_1 returns the handle to a new IOWAFLI_TRACKER_3_1 or the
%      handle to
%      the existing singleton*.
%
%      IOWAFLI_TRACKER_3_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IOWAFLI_TRACKER_3_1.M with the given input
%      arguments.
%
%      IOWAFLI_TRACKER_3_1('Property','Value',...) creates a new IOWAFLI_TRACKER_3_1 or
%      raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iowaFLI_Tracker_3_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iowaFLI_Tracker_3_1_OpeningFcn via varargin.

%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iowaFLI_Tracker_3_1

% Last Modified by GUIDE v2.5 13-Nov-2019 11:31:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @iowaFLI_Tracker_3_1_OpeningFcn, ...
    'gui_OutputFcn',  @iowaFLI_Tracker_3_1_OutputFcn, ...
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


% --- Executes just before iowaFLI_Tracker_3_1 is made visible.
function iowaFLI_Tracker_3_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iowaFLI_Tracker_3_1 (see VARARGIN)

% Choose default command line output for iowaFLI_Tracker_3_1
handles.output = hObject;

% Turning off Warnings
warning('off', 'MATLAB:mmreader:isPlatformSupported:FunctionToBeRemoved');
warning('off', 'MATLAB:str2func:invalidFunctionName');

% Disabling buttons until there are WTFs present
set(handles.exptwksp_btn,'Enable','on');
set(handles.plot_kinematic_btn,'Enable','off');
set(handles.PETracks_btn,'Enable','off');
set(handles.plot_interaction_btn,'Enable','off');
set(handles.HeatMap_plot_btn,'Enable','off');
set(handles.remove_wtf_btn,'Enable','off');
set(handles.expttoexcel,'Enable','off');
set(handles.exptwksp_btn,'Enable','off');

% Initialization of Variables
handles.VideoFiles=cell(0,1);
handles.VideoPaths=cell(0,1);
handles.wtfs=cell(0,1);
handles.wtfpaths=cell(0,1);
handles.seltype=1;
handles.targetdir = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes iowaFLI_Tracker_3_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = iowaFLI_Tracker_3_1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Analysis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str1={'IowaFLI Tracker version 3.0'};
str2={'Iyengar A., Imoehl J., Ueda A., Nirschl J., Wu C.-F. (2012)'};
str3={'Automated Quantification of Locomotion, Social Interaction,'};
str4={'and Mate Preference in Drosophila mutants'};
str5={'J. Neurogenet. 26(3-4) 316-328.'};

msgbox([str1;str2;str3;str4;str5],'About','help');

% --------------------------------------------------------------------
function ProjectWiki_menu_Callback(hObject, eventdata, handles)
% hObject    handle to ProjectWiki_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('https://github.com/IyengarAtulya/IowaFLI_tracker','-browser');

% --------------------------------------------------------------------
function AnalyzeAVI_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyzeAVI_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OK = get(handles.filenames_list,'String');

if ~isempty(OK)
AnalyzeAVI = @analyze_videos_btn_Callback;
AnalyzeAVI(handles.analyze_videos_btn,eventdata,handles);
else
msgbox('Please Load a Video First!');
end

% --------------------------------------------------------------------
function VETracks_menu_Callback(hObject, eventdata, handles)
% hObject    handle to VETracks_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VETracks = @PETracks_btn_Callback;
VETracks(handles.PETracks_btn,eventdata,handles);

% --------------------------------------------------------------------
function VEKinematic_menu_Callback(hObject, eventdata, handles)
% hObject    handle to VEKinematic_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VEKin = @plot_kinematic_btn_Callback;
VEKin(handles.plot_kinematic_btn,eventdata,handles);

% --------------------------------------------------------------------
function VEInteraction_menu_Callback(hObject, eventdata, handles)
% hObject    handle to VEInteraction_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VEInt=@plot_interaction_btn_Callback;
VEInt(handles.plot_interaction_btn,eventdata,handles);

% --------------------------------------------------------------------
function VESummary_menu_Callback(hObject, eventdata, handles)
% hObject    handle to VESummary_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VESum = @PEGroup_btn_Callback;
VESum(handles.HeatMap_plot_btn,eventdata,handles);

% --------------------------------------------------------------------
function EditWTF_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to EditWTF_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILE PATH]=uigetfile('*.wtf');
editwtf(PATH,FILE);

% --------------------------------------------------------------------
function CreateSel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to CreateSel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Preferences_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Preferences_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadAVI_menu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadAVI_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadVideo = @LoadVideo_btn_Callback;
LoadVideo(handles.LoadVideo_btn, eventdata, handles);

% --------------------------------------------------------------------
function RecordMovie_menu_Callback(hObject, eventdata, handles)
% hObject    handle to RecordMovie_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RecordMovie = @VAM_btn_Callback;
RecordMovie(handles.VAM_btn,eventdata,handles);

% --------------------------------------------------------------------
function LoadWTF_Callback(hObject, eventdata, handles)
% hObject    handle to LoadWTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadWTF = @add_wtf_btn_Callback;
LoadWTF(handles.add_wtf_btn,eventdata,handles);

% --------------------------------------------------------------------
function SaveWTF_menu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveWTF_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Close_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Close_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in filenames_list.
function filenames_list_Callback(hObject, eventdata, handles)

% hObject    handle to filenames_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filenames_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filenames_list
handles.SelectedFiles=get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function filenames_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenames_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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
a=get(handles.wtf_info_table,'ColumnEditable');
a=true(size(a));
set(handles.wtf_info_table,'ColumnEditable',a);
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


% --- Executes on button press in analyze_videos_btn.
function analyze_videos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_videos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% This forces a save directory to be chosen, prevents later problems
CancelCount = 0;
RunCount = 0;
while RunCount < 1
    while CancelCount <1
        handles.targetdir=uigetdir(handles.targetdir,'Please Select A Save Directory');
        if ~handles.targetdir
            CancelCount = CancelCount+1;
        else
            if isempty(dir(handles.targetdir))
                CancelCount = 0;
            else
                CancelCount = 10000;
            end
        end
    end
    if CancelCount ~= 10000
        break;
    end
    
    SelectionOnly = get(handles.analyzesel_chk,'Value');
    PreviousInfo = cell(1,4);
    
    if SelectionOnly
        SV=get(handles.filenames_list,'Value');
        SelVal = get(handles.filenames_list,'String');
        SelectionValues=SelVal(SV);
    else
        SelectionValues = get(handles.filenames_list,'String');
    end
    try
        def=getIowaFliDefaults('IowaFLI_Tracker Defaults.txt');
        ROIFPS=num2str(def(5));
        ROIL1=num2str(def(7));
        ROIL2=num2str(def(8));
        startFrame=def(9);
    catch
        ROIFPS='30';
        ROIL1='28';
        ROIL2='28';
        startFrame=1;
    end
    
    for i = 1:numel(SelectionValues)
        try
            [p n e]=fileparts([handles.VideoPaths{i},handles.VideoFiles{i}])
            load([p,'\',n,'.mat'])
            handles.VidInfo(i)=VidInfo;
            if exist('tempdat')==1
               handles.tempdat{i} = tempdat; 
            else
                handles.tempdat{i} =nan;
            end
            
        catch
            handles.VidInfo(i).ExperimenterName=' ';
        end
    end
    
    
    %ROI Selection
    for i = 1:numel(SelectionValues)
        roierr=1;
        while roierr==1
            try
                x = SelectionValues(i);
                if get(handles.Analyze_Choice_chk,'value')
                    [roiout(i).roi,fps(1,i),xscal(1,i),yscal(1,i),ROIFPS,ROIL1,ROIL2,Targets,startFrame] = roi_define_v7(handles.VideoPaths{i},handles.VideoFiles{i},handles.seltype,ROIFPS,ROIL1,ROIL2,0,startFrame);
                else
                    [roiout(i).roi,fps(1,i),xscal(1,i),yscal(1,i),ROIFPS,ROIL1,ROIL2,Targets,startFrame] = roi_define_v7(handles.VideoPaths{i},handles.VideoFiles{i},handles.seltype,ROIFPS,ROIL1,ROIL2,handles.VidInfo(i),startFrame);
                end
                roierr=0;
                if xscal(1,i)==0
                    roierr=1;
                    warndlg('Warning: Coordinates are linearly dependent. Please Reselect','Warning');
                end
                if yscal(1,i)==0
                    roierr=1;
                    warndlg('Warning: Coordinates are linearly dependent. Please Reselect','Warning');
                end
            catch ME
                ME;
                roierr=1;
                c=questdlg('Error: invalid input (ROI). Do you want to re-enter ROI information or terminate analysis?','ROI Error','Re-Enter','Terminate','Re-Enter');
               
               % warndlg('Warning: invalid input (ROI). Please reenter data','Warning','modal');
                %uiwait;
                 if strcmp('Terminate',c)
                    uiresume;
                     return
                    
                end
                if (roierr>size(SelectionValues,2))
                    roierr = 0;
                end
            end
        end
    end
    
    
    for i=1:numel(SelectionValues)
        locerr=1;
        while locerr==1
            try
                x = SelectionValues(i);
                if ~strcmp(handles.VidInfo(i).ExperimenterName,' ');
                    [numflies(i),flychars(i).data,flychars(i).initialcoords, flychars(i).ColorCode,PreviousInfo]=sel_num_fly_gui_v4(handles.VideoPaths{i},handles.VideoFiles{i},PreviousInfo,roiout(i).roi,handles.VidInfo(i),startFrame);
                else
                    [numflies(i),flychars(i).data,flychars(i).initialcoords, flychars(i).ColorCode,PreviousInfo]=sel_num_fly_gui_v4(handles.VideoPaths{i},handles.VideoFiles{i},PreviousInfo,roiout(i).roi,ones(0,0),startFrame);
                end
                locerr=0;
            catch
                locerr=1;
                c=questdlg('Error: invalid input (Initial Positions). Do you want to re-enter coordinate data or terminate analysis?','Initial Coordinates Error','Re-Enter','Terminate','Re-Enter');
                %warndlg('Warning: invalid input (Init Pos). Please reenter data','Warning','modal')
                %uiwait;
                if strcmp('Terminate',c)
                    uiresume;
                    return
                    
                end
                if (locerr>size(SelectionValues,2))
                    locerr = 0;
                end
            end
        end
    end
    
    
    for i=1:numel(SelectionValues)
        thresherr=1;
        while thresherr==1
            try
                x = SelectionValues(i);
                if get(handles.Analyze_Choice_chk,'value')
                    threshoutput(i).thresh = thresh_v3(handles.VideoPaths{i},handles.VideoFiles{i},flychars(i).initialcoords,startFrame);
                else
                    threshoutput(i).thresh = thresh_v3(handles.VideoPaths{i},handles.VideoFiles{i},flychars(i).initialcoords,startFrame);
                end
                thresherr=0;
            catch
                thresherr=1;
                c=questdlg('Error: invalid input (Threshold). Do you want to re-enter threshold data or terminate analysis?','Threshold Error','Re-Enter','Terminate','Re-Enter');
                %warndlg('Warning: invalid input (Thresh). Please reenter data','Warning','modal');
                %uiwait;
                if strcmp('Terminate',c)
                    uiresume;
                    return
                end
                if (thresherr>size(SelectionValues,2))
                    thresherr = 0;
                end
            end
        end
    end
    for i=1:numel(SelectionValues)
        try
            x = SelectionValues(i);
            [p n e]=fileparts([handles.VideoPaths{i},handles.VideoFiles{i}]);
            savename=[n,'.wtf'];
            
            title([handles.VideoFiles{i},' ',num2str(i),' of ',num2str(size(SelectionValues))]);
            
            %parse and pass starting X and Y values
            flyinfo=flychars(i).data;
            fnum = size(flyinfo,2)-1;
            InitCoords = zeros(fnum,2);
            for a = 1:fnum
                XY = flyinfo(6,a+1);
                comma = strfind(XY,',');
                charss = char(XY);
                InitX = str2num(charss(1:comma{1}-1));
                InitY = str2num(charss(comma{1}+1:end));
                InitCoords(a,1) = InitX;
                InitCoords(a,2) = InitY;
            end
            
            if get(handles.Analyze_Choice_chk,'value')
                
                
                Coordinates=TrackVideo_v8c(handles.VideoPaths{i},handles.VideoFiles{i},numflies(i),threshoutput(i).thresh,roiout(i).roi,150,InitCoords,Targets,startFrame);
            else
               % Coordinates=TrackVideo_v8b(handles.VideoPaths{i},handles.VideoFiles{i},numflies(i),threshoutput(i).thresh,roiout(i).roi,150,InitCoords,[],startFrame);
                Coordinates=TrackVideo_v8c(handles.VideoPaths{i},handles.VideoFiles{i},numflies(i),threshoutput(i).thresh,roiout(i).roi,150,InitCoords,[],startFrame);
            end
            
            RegionOfInterest=roiout(i).roi;
            Threshold=threshoutput(i);
            NumberOfFlies=numflies(i);
            FlyData=flychars(i).data;
            InitialCoordinates=flychars(i).initialcoords;
            FramesPerSecond=fps(i);
            Xscale=xscal(i);
            Yscale=yscal(i);
            
            % This code makes this version backwards compatible with 2010a
            try
                vidobj=VideoReader([handles.VideoPaths{i},handles.VideoFiles{i}]);
            catch
                try
                    if(mmreader.isPlatformSupported())
                        vidobj=mmreader([handles.VideoPaths{i},handles.VideoFiles{i}]);
                    end
                catch
                    msgbox('Neither VideoReader nor mmreader supported by this matlab verison.  Fatal Error');
                end
            end
            FirstFrame=read(vidobj,startFrame);
            
            save([handles.targetdir,'\',savename],'RegionOfInterest','FirstFrame','Coordinates','Threshold','NumberOfFlies','FlyData','InitialCoordinates','FramesPerSecond','Xscale','Yscale','startFrame');
            if get(handles.Analyze_Choice_chk,'value')
                save([handles.targetdir,'\',savename],'Targets', '-append');
            end
            if isfield(handles,'tempdat')
                TempDat=handles.tempdat{i};
                save([handles.targetdir,'\',savename],'TempDat', '-append');
            end
            wtfcell=cell(1);
            
            wtfcell{1}=savename;
            
            wtfp=cell(1);
            
            wtfp{1}=[handles.targetdir,'\'];
            handles.wtfs(size(handles.wtfs,1)+1,1)=wtfcell;
            handles.wtfpaths(size(handles.wtfpaths,1)+1,1)=wtfp;
            set(handles.wtf_list,'String',handles.wtfs);
            set(handles.remove_wtf_btn,'Enable','on');
        catch ME
            ME
            warndlg(['Error with ', handles.VideoPaths{i},handles.VideoFiles{i}],'Warning');
            warndlg([ME.message]);
        end
        
        
        
    end
    set(handles.PETracks_btn,'Enable','on');
    set(handles.plot_kinematic_btn,'Enable','on');
    set(handles.plot_interaction_btn,'Enable','on');
    set(handles.HeatMap_plot_btn,'Enable','on');
    set(handles.expttoexcel,'Enable','on');
    set(handles.exptwksp_btn,'Enable','on');
    
    
    guidata(hObject,handles);
    RunCount = 2;
end



% --- Executes on button press in analyzesel_chk.
function analyzesel_chk_Callback(hObject, eventdata, handles)
% hObject    handle to analyzesel_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyzesel_chk


% --- Executes on button press in LoadVideo_btn.
function LoadVideo_btn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadVideo_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off MATLAB:VideoReader:unknownNumFrames
[FILENAME, PATHNAME]=uigetfile({'*.avi;*mp4','Movie Files';'*','All Files'},'MultiSelect','on');
if PATHNAME~=0
    l=0;
    if(ischar(FILENAME))
        FNAME=cell(1);
        FNAME{1}=FILENAME;
        clear(FILENAME);
        FILENAME=FNAME;
    end
    for i=1:size(FILENAME,2)
%         try
            vid=VideoReader([PATHNAME,FILENAME{i}]);
%         catch ME
%             ME;
% %             try
%                 if(mmreader.isPlatformSupported())
%                     vid=mmreader([PATHNAME,FILENAME{i}]);
%                 end
% %             catch ME
% %                 ME;
% %                 msgbox([FILENAME{i},' cannot be read, entry was ignored'],'Jordan Says....','warn');
% %                 l(i)=1;
% %             end
%         end
    end
    FILENAME(:,find(l))=[];
    
    PATHCELL=cell(size(FILENAME));
    for i=1:size(FILENAME,2)
        PATHCELL{i}=PATHNAME;
    end
    handles.VideoFiles(size(handles.VideoFiles,1)+1:size(handles.VideoFiles,1)+size(FILENAME,2),1)=FILENAME';
    handles.VideoPaths(size(handles.VideoPaths,1)+1:size(handles.VideoPaths,1)+size(FILENAME,2),1)=PATHCELL';
    set(handles.filenames_list,'String',handles.VideoFiles);
    if(~isempty(handles.VideoFiles))
        set(handles.removevideo_btn,'Enable','on');
        set(handles.analyze_videos_btn,'Enable','on');
        %set(handles.exptwksp_btn,'Enable','on');
    end
end

guidata(hObject,handles);

% --- Executes on button press in exptwksp_btn.
function exptwksp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exptwksp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.Selectedwtfs)>1
    h=warndlg('Warning: multiple .wtf files selected. Exporting the first .wtf file');
    uiwait(h)
end
str=['load(''',handles.wtfs{handles.Selectedwtfs(1)},''',''-mat'')'];
evalin('base',str)
% index_selected = min(get(handles.wtf_list,'Value'));
% if isempty(get(handles.wtf_list,'String'))
%   %  index_selected = min(get(handles.filenames_list,'Value'));
%   blank = 'NoPath';
%     UserVideoAnalysis(blank)
% else
%     UserVideoAnalysis([handles.wtfpaths{index_selected},handles.wtfs{index_selected}])
% end


% --- Executes on button press in HeatMap_plot_btn.
function HeatMap_plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to HeatMap_plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Heatmap_gui([handles.wtfpaths{min(get(handles.wtf_list,'Value'))},handles.wtfs{min(get(handles.wtf_list,'Value'))}]);

% --- Executes on button press in plot_interaction_btn.
function plot_interaction_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_interaction_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InteractionPlotGUIv2(handles.wtfpaths,handles.wtfs);

% --- Executes on button press in plot_kinematic_btn.
function plot_kinematic_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_kinematic_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KineticPlotGUI_v4(handles.wtfpaths,handles.wtfs);

% --- Executes on button press in PETracks_btn.
function PETracks_btn_Callback(hObject, eventdata, handles)
% hObject    handle to PETracks_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plottracksGUI_2(handles.wtfpaths,handles.wtfs);

% --- Executes on button press in removevideo_btn.
function removevideo_btn_Callback(hObject, eventdata, handles)
% hObject    handle to removevideo_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LL=size(handles.VideoFiles,1);
a=1:LL;
try
b=handles.SelectedFiles;
catch
    b = get(handles.filenames_list,'value');
end

c=a(~ismember(a,b));
newFileNameSet=cell(size(c'));
newPathNameSet=cell(size(c'));
newFileNameSet=handles.VideoFiles(c);
newPathNameSet=handles.VideoPaths(c);
clear('handles.VideoFiles');
clear('handles.VideoPaths');
handles.VideoFiles=newFileNameSet;
handles.VideoPaths=newPathNameSet;
set(handles.filenames_list,'String',handles.VideoFiles);
set(handles.filenames_list,'Value',1);
handles.SelectedFiles=1;
if(isempty(handles.VideoFiles))
    set(handles.removevideo_btn,'Enable','off');
    set(handles.analyze_videos_btn,'Enable','off');
    if(isempty(handles.wtfs))
        set(handles.exptwksp_btn,'Enable','on');
    end
end
guidata(hObject,handles);


% --- Executes on button press in VAM_btn.
function VAM_btn_Callback(hObject, eventdata, handles)
% hObject    handle to VAM_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AcquireVideo_v3_0;


% --- Executes on button press in add_wtf_btn.
function add_wtf_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_wtf_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME]=uigetfile({'*.wtf';'*'},'MultiSelect','on');
if(PATHNAME~=0)
    
    if(ischar(FILENAME))
        FNAME=cell(1);
        FNAME{1}=FILENAME;
        clear(FILENAME);
        FILENAME=FNAME;
    end
    PATHCELL=cell(size(FILENAME));
    for i=1:size(FILENAME,2)
        PATHCELL{i}=PATHNAME;
    end
    handles.wtfs(size(handles.wtfs,1)+1:size(handles.wtfs,1)+size(FILENAME,2),1)=FILENAME';
    handles.wtfpaths(size(handles.wtfpaths,1)+1:size(handles.wtfpaths,1)+size(FILENAME,2),1)=PATHCELL';
    set(handles.wtf_list,'String',handles.wtfs);
    set(handles.remove_wtf_btn,'Enable','on');
    set(handles.exptwksp_btn,'Enable','on');
    set(handles.plot_kinematic_btn,'Enable','on');
    set(handles.PETracks_btn,'Enable','on');
    set(handles.plot_interaction_btn,'Enable','on');
    set(handles.HeatMap_plot_btn,'Enable','on');
    set(handles.VEInteraction_menu,'Enable','On')
    set(handles.VEKinematic_menu,'Enable','On')
    set(handles.VETracks_menu,'Enable','On')
    set(handles.VESummary_menu,'Enable','On')
    set(handles.expttoexcel,'Enable','on');
    handles.wtf_list.Value=1;
    handles.Selectedwtfs=1;
    load([handles.wtfpaths{1},handles.wtfs{1}],'-mat');
    set(handles.wtf_info_table,'Data',FlyData(2:end,2:end));
end

guidata(hObject,handles);

% --- Executes on button press in remove_wtf_btn.
function remove_wtf_btn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_wtf_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LL=size(handles.wtfs,1);
a=1:LL;
b=handles.Selectedwtfs;
c=a(~ismember(a,b));
newFileNameSet=cell(size(c'));
newPathNameSet=cell(size(c'));
newFileNameSet=handles.wtfs(c);
newPathNameSet=handles.wtfpaths(c);
clear('handles.wtfs');
clear('handles.wtfpaths');
handles.wtfs=newFileNameSet;
handles.wtfpaths=newPathNameSet;
set(handles.wtf_list,'String',handles.wtfs);
set(handles.wtf_list,'Value',1);
handles.Selectedwtfs=1;
if(isempty(handles.wtfs))
    set(handles.removevideo_btn,'Enable','off');
    set(handles.analyze_videos_btn,'Enable','off');
    set(handles.expttoexcel,'Enable','off');
    if(isempty(handles.VideoFiles))
        set(handles.exptwksp_btn,'Enable','on');
    end
end
guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over wtf_list.
function wtf_list_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to wtf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on wtf_list and none of its controls.
function wtf_list_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to wtf_list (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

k= eventdata.Key; %k is the key that is pressed
if strcmp(k,'delete') %if delete was pressed\
    Remove = @remove_wtf_btn_Callback;
    Remove(handles.remove_wtf_btn,eventdata,handles);
end


% --- Executes on key press with focus on filenames_list and none of its controls.
function filenames_list_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to filenames_list (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
k= eventdata.Key; %k is the key that is pressed
if strcmp(k,'delete') %if delete was pressed\
    Remove = @removevideo_btn_Callback;
    Remove(handles.removevideo_btn,eventdata,handles);
end


% --- Executes on button press in plot_sel_chk.
function plot_sel_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_sel_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_sel_chk


% --------------------------------------------------------------------
function find_wtf_menu_Callback(hObject, eventdata, handles)
% hObject    handle to find_wtf_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PATHWAY=uigetdir(pwd,'Select Originating Folder');
[TgTNAME, TGTPATH]=uiputfile('.xlsx','Please Name Search Result');
FILES=findfiles('wtf',PATHWAY,1);
summary=cell(12,1);
summary{1,1}='Filename';
summary{2,1}='Name';
summary{3,1}='#';
summary{4,1}='Genotype';
summary{5,1}='Sex';
summary{6,1}='Age';
summary{7,1}='Condition';
summary{8,1}='Ini. Coord.';
summary{9,1}='FPS';
summary{10,1}='Thresh';
summary{11,1}='X-Sc';
summary{12,1}='Y-Sc';
k=2;
for i=1:size(FILES,2);
    load(FILES{i},'-mat');
    [a b c]=fileparts(FILES{i});
    for j=1:NumberOfFlies
        try
        summary{1,k}=FILES{i};
        summary{2,k}=b;
        summary{3,k}=FlyData{1,j+1};
        summary{4,k}=FlyData{2,j+1};
        summary{5,k}=FlyData{3,j+1};
        summary{6,k}=FlyData{4,j+1};
        summary{7,k}=FlyData{5,j+1};
        summary{8,k}=FlyData{6,j+1};
        summary{9,k}=FramesPerSecond;
        summary{10,k}=Threshold;
        summary{11,k}=Xscale;
        summary{12,k}=Yscale;
        catch
        end
        k=k+1;
    end
end
xlswrite([TGTPATH,TgTNAME],summary');
msgbox('Search Complete!');

        
    


% --- Executes on button press in SummarySheets.
function SummarySheets_Callback(hObject, eventdata, handles)
% hObject    handle to SummarySheets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SumType=questdlg('Choice or Kinetic Summary Sheets?','Summary Type','Choice','Kinetic','Cancel','Kinetic');
if strcmp(SumType,'Choice')
    ChoiceSummarySheets(handles.wtfs,handles.wtfpaths);
elseif strcmp(SumType,'Kinetic')
    SummarySheetsV7noback(handles.wtfs,handles.wtfpaths);
end



% --- Executes on button press in Analyze_Choice_chk.
function Analyze_Choice_chk_Callback(hObject, eventdata, handles)
% hObject    handle to Analyze_Choice_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Analyze_Choice_chk


% --------------------------------------------------------------------
function expttoexcel_Callback(hObject, eventdata, handles)
% hObject    handle to expttoexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TGTFOLDER=uigetdir;
if isnumeric(TGTFOLDER)
    return
end
h=waitbar(0,'exporting to excel');
for i=1:size(handles.wtfs,1);
    waitbar(i/size(handles.wtfs,1),h,['Exporting to Excel, #',num2str(i),' of ', num2str(size(handles.wtfs,1))]);
    try
    load([handles.wtfpaths{i},handles.wtfs{i}],'-mat');
    [a b c]=fileparts(handles.wtfs{i});
    TGTFILENAME=[TGTFOLDER,'\',b,'.xlsx']
    if ~exist('WuTrackID')
        WuTrackID=nan;
    end
   
        xlswrite(TGTFILENAME,{'WuTrack ID#',WuTrackID; 'FPS', FramesPerSecond;'nflies',NumberOfFlies;'Threshold', Threshold; 'Xs (mm/px)', Xscale; 'Ys (mm/px)', Yscale},1,'A1');
        headerline=cell(2,NumberOfFlies*2+1);
        for j=2:NumberOfFlies*2+1
            if j/2==round(j/2)
                headerline{2,j}='x(px)';
                headerline{1,j}=['Fly # ',num2str(j/2)];
            end
            if j/2~=round(j/2)
                headerline{2,j}='y(px)';
            end
        end
        headerline{2,1}='Frame #';
        xlswrite(TGTFILENAME,headerline,1,'A7');
        xlswrite(TGTFILENAME,FlyData,1,'C1')
        xlswrite(TGTFILENAME,Coordinates',1,'A9')
    catch
        
        warndlg('Error exporting file #',str2num(i));
        
    end
    
end
delete(h);


% --------------------------------------------------------------------
function expt_to_txt_menu_Callback(hObject, eventdata, handles)
% hObject    handle to expt_to_txt_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PATH=uigetdir;
if ~isnumeric(PATH)
    for i=1: numel(handles.wtfs)
        try
            [p n e]=fileparts([handles.wtfpaths{i},handles.wtfs{i}]);
            FILENAME=[PATH,'\',n,'.txt'];
            load([handles.wtfpaths{i},handles.wtfs{i}],'-mat');
            fid=fopen(FILENAME,'w+')
            fprintf(fid,'%s %f %s %f %s %d %s','COORDINATES IN PIXELS, Xscale',Xscale,' px/mm Yscale', Yscale, 'px/mm FPS:', FramesPerSecond, ' Threshold: ');
            if isstruct(Threshold)
                fprintf(fid, '%f ', Threshold.thresh{1});
            else
                fprintf(fid,'%f ', Threshold);
            end
            fprintf(fid,'\r\n','\r\n');
            for i=1:size(FlyData,1)
                fprintf(fid,'%s \t',FlyData{i,:});
                fprintf(fid,'\r\n','\r\n');
            end
            fclose(fid)
            dlmwrite(FILENAME,Coordinates','Delimiter','\t','-append')
        catch
            warndlg('error with WTF#',num2str(i));
        end
    end
    msgbox('Export to text complete');
end
