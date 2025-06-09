function varargout = EEGProcessing(varargin)
% EEGPROCESSING MATLAB code for EEGProcessing.fig
%      EEGPROCESSING, by its    elf, creates a new EEGPROCESSING or raises the existing
%      singleton*.
%
%      H = EEGPROCESSING returns the handle to a new EEGPROCESSING or the handle to
%      the e xisting singleton*.
%
%      EEGPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEGPROCESSING.M with the given input arguments.
%
%      EEGPROCESSING('Property','Value',...) creates a new EEGPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EEGProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EEGProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EEGProcessing

% Last Modified by GUIDE v2.5 25-Sep-2022 15:19:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EEGProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @EEGProcessing_OutputFcn, ...
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


% --- Executes just before EEGProcessing is made visible.
function EEGProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EEGProcessing (see VARARGIN)

% Choose default command line output for EEGProcessing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global EEGvInit Database DatabaseFile pathnameDatasessions currentFile DatabaseFileList EEGv

Database={};
DatabaseFile={};
DatabaseFileList={};
pathnameDatasessions='';
currentFile='';

contents = get(handles.ListTasks,'String');
if ~isempty(contents)
    EEGvInit.ListTasks = contents;
else
    EEGvInit.ListTasks={};
    set(handles.ListTasks,'String',EEGvInit.ListTasks);
end



EEGvInit.pathname='';
EEGvInit.filename='';
EEGvInit.pathnameDatasessions='';
EEGvInit.filenameSess='';
EEGvInit.Props.SetCH={'1. F7','2. T3','3. T5','4. Fp1','5. F3','6. C3','7. P3',...
    '8. O1','9. F8','10.T4','11.T6','12.Fp2','13.F4','14.C4','15.P4',...
    '16.O2','17.Fz','18.Cz','19.Pz','20.Oz','A1','A2'}; %'FOTO','Annotations';...
%     1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9,[],[];
%     1,2,2,1,1,2,3,3,1,2,2,1,1,2,3,3,4,5,6,6,[],[]};
EEGvInit.Props.SetCHgr=[1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9;...
    2,3,3,1,2,6,6,8,2,4,4,1,2,7,7,8,2,5,5,8;...
    1,0,3,1,1,2,3,0,1,0,4,1,1,2,4,0,1,2,0,0;...
    0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1,0,0,1,1];

EEGvInit.Nchannels=20;
EEGvInit.ProcessApplied.HP=0;
EEGvInit.ProcessApplied.LP=0;
EEGvInit.ProcessApplied.Detrend=1;
EEGvInit.ProcessApplied.OffsetRem=0;
EEGvInit.ProcessApplied.ASR=0;
EEGvInit.ProcessApplied.CAR=0;
EEGvInit.ProcessApplied.ICA=0;

set(handles.popupCh,'String',EEGvInit.Props.SetCH(1,:))

EEGvInit.TaskProcess.Detrend=0;
EEGvInit.TaskProcess.LP=0;
EEGvInit.TaskProcess.HP=0;
EEGvInit.TaskProcess.Notch=0;

EEGvInit.TaskProcess.CAR=0;
EEGvInit.TaskProcess.ICA=0;
EEGvInit.TaskProcess.ASR=0;

EEGvInit.History={};

%% View
EEGvInit.Props.flagPlot=1;
EEGvInit.Props.hiddenPlots=0;

EEGv=EEGvInit;
% UpdateInterface (handles)

% UIWAIT makes EEGProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EEGProcessing_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ListTasks.
function ListTasks_Callback(hObject, eventdata, handles)
% hObject    handle to ListTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListTasks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListTasks


% --- Executes during object creation, after setting all properties.
function ListTasks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuTasks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chHP.
function chHP_Callback(hObject, eventdata, handles)
% hObject    handle to chHP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chHP


% --- Executes on button press in chLP.
function chLP_Callback(hObject, eventdata, handles)
% hObject    handle to chLP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chLP


function Filterhp_Callback(hObject, eventdata, handles)
% hObject    handle to Filterhp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filterhp as text
%        str2double(get(hObject,'String')) returns contents of Filterhp as a double


% --- Executes during object creation, after setting all properties.
function Filterhp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filterhp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Filterlp_Callback(hObject, eventdata, handles)
% hObject    handle to Filterlp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filterlp as text
%        str2double(get(hObject,'String')) returns contents of Filterlp as a double


% --- Executes during object creation, after setting all properties.
function Filterlp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filterlp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuTasks.
function popupmenuTasks_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuTasks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuTasks
global EEGv

contents = cellstr(get(hObject,'String'));
sel=get(hObject,'Value');

%         contentsLT = cellstr(get(handles.ListTasks,'String'));
% EEGv.ListTasks = get(handles.ListTasks,'String');
% task=length(EEGv.ListTasks)+1;
% EEGv.ListTasks{task} = contents{sel};
% % set(handles.ListTasks,'Value',1);
% set(handles.ListTasks,'String',EEGv.ListTasks);

ListTasks = get(handles.ListTasks,'String');
task=length(ListTasks)+1;
ListTasks{task} = contents{sel};
set(handles.ListTasks,'Value',task);
set(handles.ListTasks,'String',ListTasks);



% --- Executes on button press in ListTasksRem.
function ListTasksRem_Callback(hObject, eventdata, handles)
% hObject    handle to ListTasksRem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

% contents = get(handles.popupmenuTasks,'String');
sel=get(handles.ListTasks,'Value');
ListTasks = get(handles.ListTasks,'String');

ListTasks(sel)=[];
if sel>length(ListTasks)
    set(handles.ListTasks,'Value',1);
end
set(handles.ListTasks,'String',ListTasks);


% --- Executes on button press in ListTasksClear.
function ListTasksClear_Callback(hObject, eventdata, handles)
% hObject    handle to ListTasksClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

set(handles.ListTasks,'String','');
set(handles.ListTasks,'Value',1);
% EEGv.ListTasks = {};


function TimeP1_Callback(hObject, eventdata, handles)
% hObject    handle to TimeP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeP1 as text
%        str2double(get(hObject,'String')) returns contents of TimeP1 as a double


% --- Executes during object creation, after setting all properties.
function TimeP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupICAk.
function popupICAk_Callback(hObject, eventdata, handles)
% hObject    handle to popupICAk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupICAk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupICAk


% --- Executes during object creation, after setting all properties.
function popupICAk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupICAk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupICAmethod.
function popupICAmethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupICAmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupICAmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupICAmethod


% --- Executes during object creation, after setting all properties.
function popupICAmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupICAmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupDatabase.
function popupDatabase_Callback(hObject, eventdata, handles)
% hObject    handle to popupDatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupDatabase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupDatabase
global EEGv DatabaseFile

val=get(hObject,'Value');
if val>1
    load(DatabaseFile{val-1})
    % set(handles.editFilename,'String',Database{val-1});
    % set(handles.editFilename,'String',DatabaseFile{val-1});
    UpdateInterface (handles)
    setFileRun(handles,'pop')
end


% --- Executes during object creation, after setting all properties.
function popupDatabase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupDatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MEfile_Callback(hObject, eventdata, handles)
% hObject    handle to MEfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MEedit_Callback(hObject, eventdata, handles)
% hObject    handle to MEedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function MEchanLoc_Callback(hObject, eventdata, handles)
% hObject    handle to MEchanLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MEview_Callback(hObject, eventdata, handles)
% hObject    handle to MEview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MEtools_Callback(hObject, eventdata, handles)
% hObject    handle to MEtools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MEplots_Callback(hObject, eventdata, handles)
% hObject    handle to MEplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv
if strcmp(get(handles.MEplots,'Checked'),'on')
    set(handles.MEplots,'Checked','off')
    EEGv.Props.flagPlot=0;
else
    set(handles.MEplots,'Checked','on')
    EEGv.Props.flagPlot=1;
end


% --------------------------------------------------------------------
function MEhiddenPlots_Callback(hObject, eventdata, handles)
% hObject    handle to MEhiddenPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv
if strcmp(get(handles.MEhiddenPlots,'Checked'),'on')
    set(handles.MEhiddenPlots,'Checked','off')
else
    set(handles.MEhiddenPlots,'Checked','on')
end

% --------------------------------------------------------------------
function MEspectrum_Callback(hObject, eventdata, handles)
% hObject    handle to MEspectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global EEGv
% if strcmp(get(handles.MEspectrum,'Checked'),'on')
%     set(handles.MEspectrum,'Checked','off')
%     EEGv.Props.hiddenPlots=0;
% else
%     set(handles.MEspectrum,'Checked','on')
%     EEGv.Props.hiddenPlots=1;
% end

Spectr_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MEloadSession_Callback(hObject, eventdata, handles)
% hObject    handle to MEloadSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Information

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','...')

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple session files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for ff=1:length(Datafile)
    
variableInfo = who('-file', Datafile{ff});

if ~ismember('EEGv', variableInfo) 
    warndlg('Variable from session was not found','File wrong!')
    return
end

% load(Datafile{ff},'EEGv')
% load(Datafile{ff},'Information','EEGv')

load(Datafile{ff},'Information')
% disp(['Sync Vector: ',num2str(EEGv.events.EEG_0)]) % Usado para fazer
% seguimento dos valores do vetor sincronismo.
disp(['Session loaded: ', filename{ff}])

EEGv.pathname=pathname; % REVISAR SE DA ERRO
Information.pathname=pathname;
Information.filename=filename{ff};

UpdateDatabase (handles)
UpdateDatabaseList(handles)
setFileRun(handles,'pop')   % REVISAR
end

% UpdateInterface (handles) % REVISAR SI INCLUIR
set(handles.endInfo,'String','Done!')


function UpdateDatabaseList(handles)
global DatabaseFileList Information

content=get(handles.DatabaseList,'String');
if isempty(content)
%     set(handles.DatabaseList,'String',{EEGv.filename(1:end-4)})
    set(handles.DatabaseList,'String',{Information.filename(1:end-4)})
    set(handles.DatabaseList,'Value',1)
elseif iscell(content)
%     set(handles.DatabaseList,'String',{content{:},EEGv.filename(1:end-4)})
    set(handles.DatabaseList,'String',{content{:},Information.filename(1:end-4)})
    set(handles.DatabaseList,'Value',length(content)+1)
%     set(handles.DatabaseList,'Value',1)
else
%     set(handles.DatabaseList,'String',{content,EEGv.filename(1:end-4)})
    set(handles.DatabaseList,'String',{content,Information.filename(1:end-4)})
    set(handles.DatabaseList,'Value',size(content,1)+1)
%     set(handles.DatabaseList,'Value',1)
end
% DatabaseFileList{length(DatabaseFileList)+1}=fullfile(EEGv.pathname,EEGv.filename);
DatabaseFileList{length(DatabaseFileList)+1}=fullfile(Information.pathname,Information.filename);
% setFileRun(handles,'pop') % REVISAR


% --------------------------------------------------------------------
function MEloadFolderSession_Callback(hObject, eventdata, handles)
% hObject    handle to MEloadFolderSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname EEGv Database DatabaseFile Information

set(handles.endInfo,'String','...')
if ~ischar(pathname)
    pathname='';
end

pathname2 = uigetdir(pathname);

if isequal(pathname,0)
   disp('Selection canceled')
   return
end 
pathname=pathname2;

oldFolder = cd(pathname);
ldir=dir ('*.mat');  % Leitura de arquivos com extensão mat
cd(oldFolder);

name={ldir.name};
name=name';

oldstate=get(handles.MEplots,'Checked');
set(handles.MEplots,'Checked','off')
set(handles.MEhiddenPlots,'Checked','off')

flagfilewrong=0;
for ifile=1:length(name)
    
    Datafile=fullfile(pathname, name{ifile});
    variableInfo = who('-file', Datafile);

    if ~ismember('EEGv', variableInfo) 
        disp(['File wrong:',name{ifile},'Variable from session was not found'])
        flagfilewrong=1;
        continue
    end
%     load(Datafile,'EEGv')
    load(Datafile,'Information')
    disp(['Session loaded:', name{ifile}])
    EEGv.pathname=pathname; % REVISAR SE DA ERRO
    Information.pathname=pathname;
    
    UpdateDatabase (handles)
    UpdateDatabaseList(handles)
    
end

setFileRun(handles,'pop')

set(handles.MEplots,'Checked',oldstate)

if flagfilewrong
    warndlg('At least, one file was not loaded','File wrong!')
end

set(handles.endInfo,'String','Done!')


function UpdateDatabase (handles)
global Database DatabaseFile Information

% Popup
content=get(handles.popupDatabase,'String');
if iscell(content)
%     set(handles.popupDatabase,'String',{content{:},EEGv.filename(1:end-4)})
    set(handles.popupDatabase,'String',{content{:},Information.filename(1:end-4)})
    set(handles.popupDatabase,'Value',length(content)+1)
else
%     set(handles.popupDatabase,'String',{content,EEGv.filename(1:end-4)})
    set(handles.popupDatabase,'String',{content,Information.filename(1:end-4)})
    set(handles.popupDatabase,'Value',size(content,1)+1)
end

Database=get(handles.popupDatabase,'String');
% DatabaseFile{length(DatabaseFile)+1}=fullfile(EEGv.pathname,EEGv.filename);
DatabaseFile{length(DatabaseFile)+1}=fullfile(Information.pathname,Information.filename);


function UpdateInterface (handles)
global EEGv Information

% % Updating ListTasks
% if ~isempty(EEGv.ListTasks)
%     set(handles.ListTasks,'String',EEGv.ListTasks);
% end

% if ~isempty(EEGv.History)
% %     set(handles.ListTasks,'String',EEGv.History);
%     set(handles.listboxInformation,'String',{EEGv.History{:}})
%     addlistInformation(handles,EEGv.History)
% end

% Updating Information
set(handles.listboxInformation,'String','')
contents = cellstr(get(handles.listboxInformation,'String')) ;
if ~isempty(EEGv.History)
    set(handles.listboxInformation,'String',{contents{:},EEGv.History{:}})
%     set(handles.listboxInformation,'Value',length(contents)+length(text))
    set(handles.listboxInformation,'Value',1)
end

% Updating field: file
% set(handles.editFilename,'String',fullfile(EEGv.pathname,EEGv.filename));
set(handles.editFilename,'String',fullfile(Information.pathname,Information.filename));

% set(handles.editFilename,'String',Datafile);

props={};
set(handles.properties,'String',props);

% Updating properties
try
if length(EEGv.chanlocs)>0; chanlocs='Ok'; else chanlocs='No'; end
if ~isfield(EEGv,'dataEpoch'); 
    nEpochs='No'; 
else
    for lep=1:length(EEGv.dataEpoch)
        numepochs(lep)=length(EEGv.dataEpoch{lep});
    %     nEpochs=[num2str(numepochs),' : ',EEGv.Props.Epochs.Totaltime];
    end
    nEpochs=num2str(numepochs);
end
if ~isempty(EEGv.icaweights)
    ica=num2str(size(EEGv.icaweights,1));
else
    ica='No';
end
end

stSamp=EEGv.TimeParam.stSamp(1);
endSamp=EEGv.TimeParam.endSamp(1);
    
props={['Properties ',EEGv.filename],...
    ['Channels:  ',num2str(EEGv.nbchan)]...
    ['Samples:  ',num2str(EEGv.pnts)]...
    ['Time (total):  ', datestr(seconds(EEGv.TimeParam.Timetest),'HH:MM:SS'),' / ', num2str(EEGv.TimeParam.Timetest),' s']...
    ['Time process:  ',datestr(seconds(stSamp/EEGv.srate),'HH:MM:SS'),' - ',...
    datestr(seconds(endSamp/EEGv.srate),'HH:MM:SS')]...
    ['ICA Comp:  ',ica]...
    ['Segments removed:  ',num2str(length(EEGv.event))]...
    ['Epoch size:  ',num2str(EEGv.epochsize)]... % ADICIONAR TEMPO REMOVIDO
    ['Epochs:  ',nEpochs]...
    ['Channel Labels:  ', chanlocs]...
    ['Sampling:  ',num2str(EEGv.srate)]...
    };

if isfield(EEGv,'icacomponents')
    set(handles.EditRemComp,'String',num2str(EEGv.icacomponents))
end
set(handles.Properties_Listbox,'String',props);
set(handles.properties,'String',props);
set(handles.popupCh,'String',EEGv.Props.SetCH(1,:))


% --------------------------------------------------------------------
function MEloadFolder_Callback(hObject, eventdata, handles)
% hObject    handle to MEloadFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname Database DatabaseFile

set(handles.endInfo,'String','...')

if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)
   disp('Selection canceled')
   return
end 

oldFolder = cd(pathname);
ldir=dir ('*.mat');  % Leitura de arquivos com extensão mat
cd(oldFolder);

name={ldir.name};
name=name';

oldstate=get(handles.MEplots,'Checked');
set(handles.MEplots,'Checked','off')
set(handles.MEhiddenPlots,'Checked','off')

for ifile=1:length(name)
    
    Datafile=fullfile(pathname, name{ifile});
    disp(['You Selected:', name{ifile}])
    
    loadData (handles,Datafile,name{ifile})

    UpdateDatabase (handles)
 
end

setFileRun(handles,'pop')

set(handles.MEplots,'Checked',oldstate)
set(handles.endInfo,'String','Done!')


% --------------------------------------------------------------------
function MEloadData_Callback(hObject, eventdata, handles)
% hObject    handle to MEloadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Loading file
% clear all
global pathname EEGv currentFile Database DatabaseFile

set(handles.endInfo,'String','...')
try
    pathname=EEGv.pathnameData;
catch, end

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','Loading ...')

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple Data files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end
% disp(['File Selected: ', filename])
% 
% % handles.database.Children(1).Text=filename(1:end-4);
% 
% ifile=1; % single file
for ff=1:length(Datafile)
    
% variableInfo = who('-file', Datafile{ff});
% 
% if ~ismember('data', variableInfo) 
%     warndlg('Variable from session was not found','File wrong!')
%     return
% end
loadData (handles,Datafile{ff},filename{ff})

UpdateDatabase (handles)
setFileRun(handles,'pop')
end

set(handles.endInfo,'String','Done!')


function loadData (handles,Datafile,filename)

global pathname EEGv EEGvInit currentFile

formatLabels = false; % It's used when labels can be extracted from filename

load(Datafile)

if ~exist('data','var')
    errordlg('Variable "data" was not found','File wrong')
    return
end
fprintf(['============================================', ...
    '\nLoading data... \n============================================\n'])


if formatLabels
    
filename=filename;
sub=str2num(filename(1:2)); % To obtain the subject code
instantTest=filename(4:6); % To obtain the instant code

if isempty(sub) % For EEGData cases
    sub=str2num(filename(8:9)); % To obtain the subject code
    instantTest=filename(11:13); % To obtain the instant code
end

end

%% Initial conditions
% if ~exist('Fs','var'), Fs=200; end  % It was removed to avoid a wrong Fs

impEvt=0;
nfileEvents=0;

epochsize = str2num(get(handles.epochW,'String')); %1*Fs; % 1 s of epoch size
slidew = epochsize*str2num(get(handles.epochS,'String')); % 50% of slidding window
% Lwin = Lwin - mod(Lwin,2);    % Make sure the number of samples is even
% Nwin = floor((nTime - Loverlap) ./ (Lwin - Loverlap));

tblink=0.5*Fs; % Time of signal to discard after a blink
tp=4*60*Fs; % Time for processing: 4 min
etr=20*Fs; % end time discarded: 20 s

hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end
% EEGv.icach=icach;
% EEGv.TimeParam.slidew=slidew;
% EEGv.TimeParam.tblink=tblink;
% EEGv.TimeParam.tp=tp;
% EEGv.TimeParam.etr=etr;
% EEGv.srate=Fs;

%% EditTest identification

if formatLabels

if ~isempty(sub) && ~isempty(instantTest)              % Test Carol
    [Inst,nTest,x,y,nfileEvents,TypeTest] = Filecodes(filename,sub,instantTest,0);
% % if exist('F','var')
% %     data=F';
% %     clear F
% % end
%     
% switch instantTest % To detect the type of instantTest
%     case 'pre'      %(4:6)
%         Inst=1;      
%         TypeTest=filename(8:10);
%     case 'pos'
%         Inst=2;    
%         TypeTest=filename(8:10); 
%     case 'bik'
%         Inst=3;        
%         TypeTest=filename(9:11); 
%         di=3*60*Fs; % Initial delay, to remove from 3th minute
% %         data=data(di:end,:);
%     case 'str'
%         Inst=4;
%         TypeTest=filename(11:13);
%     otherwise
%         Inst=0;
%         TypeTest=0;
% end
% 
% 
% switch TypeTest % To detect the test
%     case 'con' % control
%         nTest=1;
%     case 'str' % stroop
%         nTest=2;
%     case 'stm' % stm
%         nTest=3;    
%     case 'st_' % stm
%         nTest=3; 
%     case 'st.' % stm
%         nTest=3; 
%     otherwise 
%         nTest=0;
% end
% 
% %% Identification of file with events
% % ================================
% % Two instants considered: Pre and Stroop
% % 1 -> pre control: 40 m        6-10 s
% % 2 -> pre st: 10 m             last 4 min
% % 3 -> pre stroop: 10 m         last 4 min
% % 4 -> stroop control: 40 m     last 4 min
% % 5 -> stroop st: X             last 4 min
% % 6 -> stroop stroop: X         last 4 min
% %
% % X -> instant
% % Y -> edittest
% 
% MatEvent=[1 2 3; 4 5 6];
% 
% switch instantTest
%     case 'pre'
%         x=1;
%     case 'str'
%         x=2;
%     otherwise
%         x=[];
% end
% switch TypeTest 
%     case 'con'
%         y=1;
%     case 'stm'
%         y=2;
%     case 'str'
%         y=3;
%     case 'st.'
%         y=3;
%     case 'st_'
%         y=3;
%     otherwise
%         y=[];
% end
% 
% if ~isempty(x) && ~isempty(y)
%     nfileEvents=MatEvent(x,y);
% else
%     nfileEvents=0;
% end
% 
%
else                                            % Test Luana
    
    impEvt=0;
    if ~exist('datafull','var') 
        if ~exist('data','var')
            errordlg('Data does not exist','Error')
            return
        end
    else
        data=datafull;
        clear datafull    
    end
    
end

end

%% Data conditioning

if exist('F','var') % Alternative name for dataset
    data=F';
    clear F
end

[Nelectrodes,Nsamples] =size(data);
if Nelectrodes>Nsamples
    data=data';
    [Nelectrodes,Nsamples] =size(data);
end

if max(max(abs(data)))>10
    data=data*1e-1;
end

if exist('EEGchannels','var')
    if length(EEGvInit.Props.SetCH) ~= Nelectrodes
        EEGvInit.Props.SetCH = EEGchannels;
    end
end

%% EEGLab format

% Loading data
% EEG = pop_importdata('dataformat','array','nbchan',0,'data',data','setname','DaEx','srate',200,'pnts',0,'xmin',0);
if exist('sub') && ~isempty(sub) && ~isempty(instantTest)
    EEG = pop_importdata('dataformat','array','nbchan',0,'data',data,'setname',filename(1:end-4),'srate',Fs,'subject',sub,'pnts',0,'condition',instantTest,'xmin',0,'session',TypeTest,'chanlocs','');
else
    EEG = pop_importdata('dataformat','array','nbchan',0,'data',data,'setname',filename(1:end-4),'srate',Fs,'subject',[],'pnts',0,'xmin',0,'chanlocs','');
    warndlg('Subject or Test labels were not recognized!','Warning')
end
% EEG=pop_chanedit(EEG, 'lookup','D:\\Work1\\EEG Analysis\\eeglab2019_1\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp','load',{'D:\\Work1\\EEG Analysis\\eeglab2019_1\\Brainnet10-20.ced' 'filetype' 'autodetect'});

if hiddenPlots
    f=figure;
    plotEEG(f,EEG.data,EEG.times/1000,Fs,EEGvInit.Props.SetCH,[0 1 100],'b','',1)
end

EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, [21 22] );
EEG = eeg_checkset( EEG );

fprintf(['============================================', ...
    '\nRe-reference done! \n============================================\n'])

try
EEG = pop_chanedit(EEG,'load',{'Brainnet10-20_Ch20.ced' 'filetype' 'autodetect'});
% EEG = pop_chanedit(EEG, 'lookup','\standard-10-5-cap385.elp','load',{'Brainnet10-20.ced' 'filetype' 'autodetect'});
% EEG = pop_chanedit(EEG, 'lookup','\standard-10-5-cap385.elp','load',{'Brainnet10-20.ced' 'filetype' 'autodetect'},'delete',23);
catch

    % if ~exist('Brainnet10-20.ced','file')
    [filenamelocch, pathnamelocch] = uigetfile( ...
        {'*.ced','CED Files (*.ced)';
        '*.*',  'All files (*.*)'}, ...
        'Select the location file',pathname);

    if isequal(filenamelocch,0)

       disp('FIle location canceled')
       
    else
    
    filelocationchan=fullfile(pathnamelocch,filenamelocch);    
    EEG = pop_chanedit(EEG,'load',{filelocationchan 'filetype' 'autodetect'});
    
    end
    
% else
%     EEG = pop_chanedit(EEG, 'lookup','D:\\Documents\\eeglab2019_1\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp','load',{'Brainnet10-20.ced' 'filetype' 'autodetect'});
% end

end
if ~isstruct(EEG.chanlocs)
        warndlg('Channel Location is empty','Warning!')
end
EEG = eeg_checkset( EEG );
% EEG = pop_reref( EEG, [21 22] );
% EEG = eeg_checkset( EEG );
EEG.data = double(EEG.data);


%%
fname=fieldnames(EEGvInit);
% try, EEGvInit.ListTasks=EEGv.ListTasks; end % To get current ListTasks
for fn=1:length(fname)    
    eval(strcat('EEG.',fname{fn},'=EEGvInit.',fname{fn},';'));
end
EEGv=EEG;
clear EEG
% EEGv.data=data;
% EEGv.time=t;

EEGv.ProcessApplied.HP=0;
EEGv.ProcessApplied.LP=0;
EEGv.ProcessApplied.Detrend=0;
EEGv.ProcessApplied.RemSeg=0;
EEGv.ProcessApplied.CAR=0;
EEGv.ProcessApplied.RemICA=0;
EEGv.ProcessApplied.ASR=0;
EEGv.ProcessApplied.Epoch=0;
EEGv.ProcessApplied.PSD=0;
EEGv.ProcessApplied.Sync=0;

set(handles.popupCh,'String',EEGv.Props.SetCH(1,:)) 
addlistInformation(handles,['Imported file:', filename])


%% Synchronization
% EEGv.ProcessApplied.Sync=1;
if exist('sync')
    
sync=sync/(min(sync));
EEG_0 = find(diff(sync)==1);

if ~EEGv.ProcessApplied.Sync & ~(strcmp(instantTest,'pre'))
   

if ~isempty(EEG_0)
%     EEG_0 = EEG_0(1);
%     EEG_0 = EEG_0 - 95*Fs;
    figure, plot(EEGv.times/1000, sync), title('Synchronism'), xlabel('Seconds [s]')
    EEGv.data = EEGv.data(:,EEG_0(1):end);
    EEGv.times = (EEGv.times(EEG_0(1):end) - EEGv.times(EEG_0(1)));
    
    EEGv = eeg_checkset( EEGv );
    
    EEGv.ProcessApplied.Sync=1;
    addlistInformation(handles,'EEG Data Syncronized')
    fprintf(['============================================', ...
    '\nSyncronism recognized! \n============================================\n'])
else
    fprintf(['============================================', ...
    '\nSyncronism unrecognized! \n============================================\n'])
end

else
    fprintf(['============================================', ...
    '\nWARNING: Syncronism was already applied! \n============================================\n'])
end

else
    EEG_0=[];
end
%% ImportEvents
% ======Variables to divide the results======
% nt= number of edittest
% b= Number of bands
% ch= Channel
% tt= Different times for processing edittest
% m= fraction of the edittest
% sub= subject
% vis= visit for the edittest   
% ============================================

if impEvt
%% Load data and initial conditions
try
flagPlot=0; % to show internal plots

filename='DADOS_CAROL.mat';
% File=fullfile('C:\Users\CECOM\Dropbox\Pasta John-Luana\EEG Analysis\EEGProcessing',filename);
File=fullfile(cd,filename);

sig=['S',num2str(sub,'%02.f'),'_',num2str(nfileEvents)];
load(File,sig)

% Loading prperties and events
Fs=eval([sig,'.F.prop.sfreq']);
events=eval([sig,'.F.events']);
nsamples=eval([sig,'.F.header.nsamples']);
Time=eval([sig,'.Time']);

clear (sig)

% Convert blink times in samples
Nevents=size(events,2);
blink=[];
for i = 1:Nevents
    if strcmp(events(i).label(1:5),'blink')
        blink=[blink events(i).times];
    end
end
% blink=blink(blink>TimeVector(1));
% blink2=blink-TimeVector(1)+1/Fs;
% blinkSamp=round(blink2*Fs);
blinkSamp=round(blink*Fs);
blinkSamp=sort(blinkSamp);

if flagPlot % To plot data and blink events
    figure, plot(TimeVector,data(:,1))
    hold on
    plot(blink,max(data(:))*1.1*ones(length(blink),1),'o')
    axis tight
end
end

clear(sig)

end

%% Selecting tests

if strcmp(instantTest,'DES')
    nTests = 2; % To identify the number of test into the same file
else 
    nTests = 1;
end

for nt = 1: nTests
    
    if strcmp(instantTest,'DES') & nt == 1
        EEGvPos = EEGv;
        EEGvPos.data = EEGv.data(:,EEG_0(end):end);
        EEGvPos.times = (EEGv.times(EEG_0(end):end) - EEGv.times(EEG_0(end)));
        EEGv.data = EEGv.data(:,1:EEG_0(end));
        EEGv.times = (EEGv.times(1:EEG_0(end)));
    end
    
    if nt ==2 
        EEGv = EEGvPos;
        EEGv = eeg_checkset(EEGv);
        EEG_0 = [];
%         filenameData = EEGv.filenameData;
        filename(4:6)='POS';
%         EEGv.filenameData=filenameData;
    end
    
    

%% Times for processing

Nsamples = size(EEGv.data,2);

endSamp=Nsamples-etr; % Last sample for processing
stSamp=endSamp-tp; % First sample for processing

if nfileEvents==1 % Case1 when first 10 minutes correspond to a separeted test
    stSamp=6*60*Fs; % First sample for processing, 6 min
    endSamp=stSamp+tp; % Last sample for processing, 10 min
end

% % data=data(stSamp:endSamp,:);
% 
% nW = floor((endSamp-stSamp)/slidew); % n of epochs
% 
% % EEGv.TimeParam.stSamp=stSamp;
% % EEGv.TimeParam.endSamp=endSamp;

ttest=Nsamples/Fs;
% EEGv.TimeParam.Timetest=ttest;
disp({['Time of test [s] ',datestr(seconds(ttest),'HH:MM:SS')]})

% for i=1:Nelectrodes
%     vz(i)=any(data(i,:));
% end
% 
% data=data(vz,:); % To remove reference channels (all zeros vector)

%% Parameters: Initial conditions

EEGv.pathnameData=pathname;
EEGv.filenameData=filename;
EEGv.epochsize=epochsize;
EEGv.TimeParam.slidew=slidew;
EEGv.TimeParam.tblink=tblink;
EEGv.TimeParam.tp=tp;
EEGv.TimeParam.etr=etr;
EEGv.srate=Fs;
EEGv.TimeParam.stSamp=stSamp;
EEGv.TimeParam.endSamp=endSamp;
EEGv.TimeParam.Timetest=ttest;

EEGv.events.EEG_0 = EEG_0;

%% Saving File
EEGv = eeg_checkset(EEGv); 
saveData(handles,'S',strcat(EEGv.filenameData(1:end-4),'_Raw'))


end
currentFile=EEGv.filename;

fprintf(['============================================', ...
    '\nSession Saved! \n============================================\n'])
% currentFile=Information.filename;


function [Inst,nTest,x,y,nfileEvents,TypeTest] = Filecodes(File,sub,instantTest,d)

% Example filename: S02_pos_V5 / S02_pre_V4_
%                   123456789
% EditTest Carol 
% Tests:
% 1. Control / 2. Stroop / 3. Stm
% Instants:
% 1. pre - 2. stroop - 3. Bike - 4. pos

% EditTest Luana
% Tests:
% 1. V3 / 2. V4 / 3. V5                 % Luana Thesis
% Instants:
% 1. pre 2. pos                         % Luana Thesis

    switch instantTest % To detect the type of instantTest
        case 'pre'      %(4:6)
            Inst=1;      
            TypeTest=File(d+8:d+10);
        case 'pos'
            Inst=4;    
            TypeTest=File(d+8:d+10); 
        case 'POS'
            Inst=2; % Inst=4;      
            TypeTest=File(d+8:d+10); 
        case 'bik'
            Inst=3;        
            TypeTest=File(d+9:d+11); 
%             di=3*60*Fs; % Initial delay, to remove from 3th minute
    %         data=data(di:end,:);
        case 'str'
            Inst=2;
            TypeTest=File(d+11:d+13);
        case 'DES'
            Inst=3;    
            TypeTest=File(d+7:d+9); 
        otherwise
            Inst=0;
            TypeTest=0;
    end

    switch TypeTest % To detect the test
        case 'con' % control
            nTest=1;
        case 'str' % stroop
            nTest=2;
        case 'stm' % stm
            nTest=3;    
        case 'st_' % stm
            nTest=3; 
        case 'st.' % stm
            nTest=3; 
        case 'V1_'
            nTest=4;
        case 'V3_'
            nTest=1;
        case 'V4_'
            nTest=2;
        case 'V5_'
            nTest=3;
        otherwise 
            nTest=0;
    end

%% Identification of file with events
% ================================
% Two instants considered: Pre and Stroop
% 1 -> pre control: 40 m        6-10 s
% 2 -> pre st: 10 m             last 4 min
% 3 -> pre stroop: 10 m         last 4 min
% 4 -> stroop control: 40 m     last 4 min
% 5 -> stroop st: X             last 4 min
% 6 -> stroop stroop: X         last 4 min
%
% X -> instant
% Y -> edittest

MatEvent=[1 2 3; 4 5 6];

switch instantTest
    case 'pre'
        x=1;
    case 'str'
        x=2;
    otherwise
        x=[];
end
switch TypeTest 
    case 'con'
        y=1;
    case 'stm'
        y=2;
    case 'str'
        y=3;
    case 'st.'
        y=3;
    case 'st_'
        y=3;
    otherwise
        y=[];
end

if ~isempty(x) && ~isempty(y)
    nfileEvents=MatEvent(x,y);
else
    nfileEvents=0;
end


% --- Executes on button press in A_run.
function A_run_Callback(hObject, eventdata, handles)
% hObject    handle to A_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv Database DatabaseFile

% val=get(handles.popupDatabase,'Value');
% file=DatabaseFile{val-1};
set(handles.endInfo,'String','Processing...')
pause(0.1)
currentFile = getFileRun();
if isempty(currentFile)
   errordlg('Please, load a file','Error') 
   return
end

fprintf(['============================================', ...
    '\nLoading file! \n============================================\n'])

try
    load(currentFile)
catch
   errordlg('Error loading session file','Error') 
   return
end
EEGv.ListTasks = get(handles.ListTasks,'String');

ListTasks=EEGv.ListTasks;
task=length(EEGv.ListTasks);
sett=settingPlotEEG(EEGv);

Fs=EEGv.srate;
SetCH=EEGv.Props.SetCH;
flagPlot=get(handles.MEplots,'Checked');
switch flagPlot
    case 'off'
        flagPlot=false;
    case 'on'
        flagPlot=true;
end
hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end

if isempty(EEGv.History)
    EEGv.dataRaw=EEGv.data;
end

flagtrasp=0;
UpdateInterface (handles)
for i=1:task
    
    data=double(EEGv.data);
    [Nsamples,Nelectrodes] =size(data);
    if Nelectrodes>Nsamples
        data=data';
        [Nsamples,Nelectrodes] =size(data);
        flagtrasp=1;
    end
    
    switch ListTasks{i}
        
        case 'Synchronism'
            MEImport_Event_Callback(hObject, eventdata, handles)
        case 'Filter Data'
%             data=EEGv.data;
            fprintf(['============================================', ...
                '\nFiltering data... \n============================================\n'])
            EEGv.TaskProcess.LP=get(handles.chLP,'Value');
            EEGv.TaskProcess.HP=get(handles.chHP,'Value');
            EEGv.TaskProcess.Notch=get(handles.chNotch,'Value');
            
%             EEGv.TaskProcess.Detrend=Detrend;      
%             f1=figure;
%             plotEEG(f1,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'b',''), hold on

%             EEGv.dataPreFILTER = EEGv.data; 
            Preprocessing;
%             plotEEG(f1,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'r','Performance EditTest Filtered')
             
            if flagtrasp==1; EEGv.data=data'; else; EEGv.data=data; end
            if flagPlot
            eegplot( EEGv.data, 'srate', EEGv.srate, 'title', 'Black = channel before filter; red = after filter', ...
            	 'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 
            end
            
            details = strcat([num2str(HPf.cut),'-',num2str(LPf.cut),'Hz. (n=',...
                num2str(HPf.n),'-',num2str(LPf.n),')']);
            addlistInformation(handles,strcat('Band-Pass filter applied:',details))
            saveData(handles,'','_BP')
            
        case 'Filter data'
%             data=EEGv.data;
            fprintf(['============================================', ...
                '\nFiltering data... \n============================================\n'])
            EEGv.TaskProcess.LP=get(handles.chLP,'Value');
            EEGv.TaskProcess.HP=get(handles.chHP,'Value');
            EEGv.TaskProcess.Notch=get(handles.chNotch,'Value');
            
%             EEGv.TaskProcess.Detrend=Detrend;      
%             f1=figure;
%             plotEEG(f1,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'b',''), hold on

%             EEGv.dataPreFILTER = EEGv.data; 
            Preprocessing;
%             plotEEG(f1,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'r','Performance EditTest Filtered')
             
            if flagtrasp==1; EEGv.data=data'; else; EEGv.data=data; end
%             if flagPlot
%             eegplot( EEGv.dataPreFILTER, 'srate', EEGv.srate, 'title', 'Black = channel before filter; red = after filter', ...
%             	 'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 
%             end
             
            details = strcat([num2str(HPf.cut),'-',num2str(LPf.cut),'Hz. (n=',...
                num2str(HPf.n),'-',num2str(LPf.n),')']);
            addlistInformation(handles,strcat('Band-Pass filter applied:',details))
            saveData(handles,'','_BP')
            
        case 'CAR'
%             data=EEGv.data;
%             fcar=figure;
%             plotEEG(fcar,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'b',''), hold on
            fprintf(['============================================', ...
                '\nCAR filter... \n============================================\n'])
            dataPreCAR = EEGv.data;
            handles.ICAcomps
            
            % LAR Using selected channels

            % C3, CZ, C4, Pz, Fz    
            %  6  18  14  19  17
            LAR_Ch = [6 14 17 18 19];
            data(:,LAR_Ch) = CAR_Filter(data(:,LAR_Ch));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%             % Using all chanels
%             data(:,1:EEGv.Nchannels) = CAR_Filter(data(:,1:EEGv.Nchannels));
% %             plotEEG(fcar,data(:,1:EEGv.Nchannels),Fs,SetCH,sett,'r','Performance EditTest CAR')
             
%             EEGv.data=data;
            EEGv.ProcessApplied.CAR=1;
            if flagtrasp==1; EEGv.data=data'; else; EEGv.data=data; end
            if flagPlot
            eegplot( dataPreCAR, 'srate', EEGv.srate, 'title', 'Black = channel before CAR; red = after CAR', ...
            	 'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 
            end
            
            addlistInformation(handles,'CAR filter applied')
            saveData(handles,'','_CAR')
            
        case 'ICA'
%             data=EEGv.data;            
            
            flagICA=1;
            if ~isempty(EEGv.icaweights)
                flagICA=questdlg('Do you want to calculate again?','ICA weights','Yes','No','No');
                if strcmp(flagICA,'No')
                    flagICA=0;
                end
            end
            
            if flagICA
                
                fprintf(['============================================', ...
                    '\nApplying ICA... \n============================================\n'])
            
                ICAch = str2num(get(handles.ICAch,'String'));
                if isempty(ICAch)
                    ICAch=1:EEGv.nbchan;
                end
%                 ICAVilla(data(:,1:EEGv.Nchannels)');
                ICAVilla(data',ICAch);
    %             EEGv.data=data;
                addlistInformation(handles,'ICA components calculated')
            
%         case 'Iclabel'
            %% iclabel
            EEGv = pop_iclabel(EEGv, 'default');
            
            if flagPlot
                comp=size(EEGv.icaweights,1);
                try
                pop_viewprops( EEGv, 0, [1:comp], {'freqrange', [2 80]}, {}, 1, 'ICLabel' )
                catch ME
                    stop=1; % Undefined function
                    
                end
                    
            end
            
            addlistInformation(handles,{'ICA labels calculated','Artefacts:'})
            lab=EEGv.etc.ic_classification.ICLabel.classes
            class=EEGv.etc.ic_classification.ICLabel.classifications
            
%             nch=length(ICAch);
%             nlab=length(lab);
%             AA=table(mat2cell(class,ones(1,nch),ones(1,nlab)));
%             disp(AA)
            
            % For information
            eyeSel=get(handles.MEICAEyes,'Checked'); % For select only eye artifacts
            EEGv.eyeSel = eyeSel;
            
            if strcmp(eyeSel,'on')
                eyeSel=1;
            else
                eyeSel=0;
            end
            if eyeSel==1
                art=find(strcmp(lab,'Eye'));
%                 artEye=find(strcmp(lab,'Eye'));
            else
                art=2:length(lab);
            end
            th=0.2;
            
%             artEye=find(strcmp(lab,'Eye'));
            
%             % Information only for eye artifact
%             [components,artefact]=find(EEGv.etc.ic_classification.ICLabel.classifications(:,artEye)>th);
%             if ~isempty(components) && ~isempty(artefact)
% %             artefact = artefact+1;    
%             for cc=1:length(components)
%                 msgcomp{cc}=strcat(['Component: ',num2str(components(cc)),' ',EEGv.etc.ic_classification.ICLabel.classes{artEye},' [%] ',num2str(EEGv.etc.ic_classification.ICLabel.classifications(components(cc),artEye)*100)]);
%                 disp(msgcomp{cc})                
%             end            
%             addlistInformation(handles,msgcomp)
%             else
%                 addlistInformation(handles,['No artefacts above ',num2str(th*100),'% were detected'])
%             end
            
            [components,artefact]=find(EEGv.etc.ic_classification.ICLabel.classifications(:,2:end)>th);
            if ~isempty(components) && ~isempty(artefact)
            artefact = artefact+1;    
            for cc=1:length(components)
                msgcomp{cc}=strcat(['Component: ',num2str(components(cc)),' ',EEGv.etc.ic_classification.ICLabel.classes{artefact(cc)},' [%]',num2str(EEGv.etc.ic_classification.ICLabel.classifications(components(cc),artefact(cc))*100)]);
                disp(msgcomp{cc})                
            end            
            addlistInformation(handles,msgcomp)
            else
                addlistInformation(handles,['No artefacts above ',num2str(th*100),'% were detected'])
            end
            
            percRemComp = str2num(get(handles.percRemComp,'String'))/100;
            
            clear components
            componentstmp=find(sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2)>percRemComp);
%             components=find(sum(EEGv.etc.ic_classification.ICLabel.classifications(:,2:end)')>percRemComp);
            components(1,:)=unique(sort(componentstmp));
            set(handles.EditRemComp,'String',num2str(components))
            TotalCmp = sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2);
            
%             percRemComp = str2num(get(handles.percRemComp,'String'))/100;
%             components=find(sum(EEGv.etc.ic_classification.ICLabel.classifications(:,2:end)')>percRemComp);
%             components=unique(sort(components));
%             set(handles.EditRemComp,'String',num2str(components))
            
            EEGv.icacomponents=components;
            EEGv.icacomponentsPerc = TotalCmp(components);
            EEGv.icapercRemComp=percRemComp;
            EEGv.ProcessApplied.ICA=1;
            
            saveData(handles,'','_ICA')
            end
            
        case 'Remove ICA comp'
            %% Removing ICA components
            
            if ~isempty(EEGv.icawinv)
                ProcessApplied=EEGv.ProcessApplied;
                if (isfield(ProcessApplied,'RemICA') && ~EEGv.ProcessApplied.RemICA)
            
            fprintf(['============================================', ...
                '\nRemoving ICA components... \n============================================\n'])
            if flagPlot
                fica=figure;
                plotEEG(fica,data,EEGv.times/100,Fs,SetCH,[0 4],'b','',1), hold on
            end
            
            percRemComp = str2num(get(handles.percRemComp,'String'))/100;
            percConserveComp = str2num(get(handles.percConserveComp,'String'))/100;
            EEGv.icapercRemComp=percRemComp;
            lab=EEGv.etc.ic_classification.ICLabel.classes;
            
            eyeSel=get(handles.MEICAEyes,'Checked'); % For select only eye artifacts
            
            if strcmp(eyeSel,'on')
                eyeSel=1;
            else
                eyeSel=0;
            end
            if eyeSel==1
                art=find(strcmp(lab,'Eye'));
            else
                art=2:length(lab);
            end
            EEGv.eyeSel = eyeSel;
            componentstmp=find(sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2)>percRemComp);
%             components=find(sum(EEGv.etc.ic_classification.ICLabel.classifications(:,2:end)')>percRemComp);
            components(1,:)=unique(sort(componentstmp));
            
            
            % Total artifact for labels selected
            TotalCmp = sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2);
            % Brain activity per component
            TotalBrain = find(EEGv.etc.ic_classification.ICLabel.classifications(components,1)>percConserveComp);
            components(TotalBrain)=[]; % To hold components with brain activity above 10%
            
            set(handles.EditRemComp,'String',num2str(components))
            
            EEGv.icacomponentsPerc = TotalCmp(components);
            
            RemComponent_Callback(hObject, eventdata, handles)
%             EEGv.dataPreICA = EEGv.data; 
% 
%             components = str2num ( get(handles.EditRemComp,'String') ); % components=[1 2];      
%             EEGv.icacomponents=components;
%             EEGv = pop_subcomp( EEGv, components, 0);
%             EEGv = eeg_checkset( EEGv );
%             addlistInformation(handles,['ICA components removed: ',num2str(components)])
%             try addlistInformation(handles,['Below [%] :  ',num2str(EEGv.icapercRemComp)]), end
%             
%             EEGv.ProcessApplied.RemICA=1;
%             saveData(handles,'','_RemICA')
            
            if flagPlot
                eegplot( EEGv.dataPreICA, 'srate', EEGv.srate, 'title', 'Black = channel before removal; red = after removal', ...
                     'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 

                plotEEG(fica,data,EEGv.times/100,Fs,SetCH,[0 1],'r','Performance Test. ICA',1)

            end
                else
                    errordlg('ICA components were removed yet. Calculate ICA again!','ERROR')
                end
            else
                errordlg('ICA must be calculated before!','ERROR')
            end
            
        case 'Remove Segment'
            
            fprintf(['============================================', ...
                '\nRemoving segments (ASR)... \n============================================\n'])
            dataPreRemSeg = EEGv.data;

%             data(:,1:EEGv.Nchannels) = 
%             try
% %             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
            EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','on','LineNoiseCriterion',[],'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] ); %Funcionando 19/09/2022
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','on','LineNoiseCriterion',[],'Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] ); %Somente ASR
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','on','LineNoiseCriterion',[],'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] ); %Somente remove janelas
% %             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','on','LineNoiseCriterion',[],'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
            %%%% REVISAR: vis_artifacts
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion',[],'Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','on','LineNoiseCriterion',[],'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion',[],'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
%             EEGtmp = pop_clean_rawdata(EEGv, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion',[],'Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
            
            EEGtmp.setname='RemBadCh';
            EEGtmp = eeg_checkset( EEGtmp );      
            if flagPlot vis_artifacts(EEGtmp,EEGv); end
            
%             EEGv.dataPosRemSeg=EEGv.dataPreRemSeg;
            EEGv.event=EEGtmp.event;
            EEGv.etc=EEGtmp.etc;
            
            EEGv = eeg_checkset( EEGv );
            
%             for i=1:length(EEGtmp.event)
%                 if strcmp(EEGtmp.event(i).type,'boundary')
%                     si=round(EEGtmp.event(i).latency);
%                     se=si+EEGtmp.event(i).duration;
%                     EEGv.dataPosRemSeg(:,si:se)=NaN;
%                 end
%             end
%             EEGv.dataPosRemSeg(:,EEGtmp.etc.clean_sample_mask)=NaN;
            
            %%%%%%% PRESENTAR TIEMPO ELIMINADO
            if hiddenPlots
                figure, hold on, plot(dataPreRemSeg(1,:)),plot(EEGtmp.etc.clean_sample_mask*150), plot(EEGv.data(1,:))
            end
%             EEGv.data=data;
            if flagtrasp==1; EEGv.data=data'; else; EEGv.data=data; end
            if flagPlot
            
            eegplot( dataPreRemSeg, 'srate', EEGv.srate, 'title', 'Black = channel before ASR; red = after ASR', ...
            	 'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 
            
            
            eegplot( EEGv.data, 'srate', EEGv.srate, 'title', 'Segmentes Removed', ...
            	 'limits', [EEGv.xmin EEGv.xmax]*1000); 
            end
            
            EEGv.ProcessApplied.RemSeg=1;
            addlistInformation(handles,'Segments removed')
            saveData(handles,'','_RemSeg')
            
%             catch ME
%                 stop=1;
%             end
        
        case 'ASR'
%             data=EEGv.data;
%             fica=figure;
%             plotEEG(fica,data,Fs,SetCH,[0 4],'b',''), hold on
            fprintf(['============================================', ...
                '\nApplying ASR... \n============================================\n'])
            epochsize = EEGv.epochsize;
            method = get(handles.popupICAmethod,'String');
            k=get(handles.popupICAk,'String');
            
%             EEGv.dataPreASR = EEGv.data;
            
            Main
            
%             EEGv.data=data;
            EEGv.ProcessApplied.ASR=1;
%             if flagtrasp==1; EEGv.data=data'; else; EEGv.data=data; end
            
            if flagPlot
            eegplot( EEGv.dataPreASR, 'srate', EEGv.srate, 'title', 'Black = channel before ASR; red = after ASR', ...
            	 'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 
            end
            
            addlistInformation(handles,['ASR applied: ',])
            saveData(handles,'','_ASR')
            
        case 'Pause'
            warndlg('Press a key to continue','Warning!')
            pause()
        
        case 'Epoch'
        
        case 'MRCP'
            fprintf(['============================================', ...
            '\nMRCP processing... \n============================================\n'])

            MRCP_ep = MRCP(EEGv,handles);

            fprintf(['============================================', ...
                '\nMRCP completed! \n============================================\n'])

        case 'PSD'
        
            fprintf(['============================================', ...
                '\nProcessing PSD... \n============================================\n'])
            Props=EEGv.Props;
            if ~isfield(Props,'SetCHgr')
                EEGv.Props.SetCHgr=[1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9;...
                    2,3,3,1,2,6,6,8,2,4,4,1,2,7,7,8,2,5,5,8;...
                    1,0,3,1,1,2,3,0,1,0,4,1,1,2,4,0,1,2,0,0;...
                    0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1,0,0,1,1];
            end

                EEGv.Props.SetCH={'1. F7','2. T3','3. T5','4. Fp1','5. F3','6. C3','7. P3',...
                    '8. O1','9. F8','10.T4','11.T6','12.Fp2','13.F4','14.C4','15.P4',...
                    '16.O2','17.Fz','18.Cz','19.Pz','20.Oz','A1','A2'}; %'FOTO','Annotations';...
                %     1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9,[],[];
                %     1,2,2,1,1,2,3,3,1,2,2,1,1,2,3,3,4,5,6,6,[],[]};
                % EEGv.Props.SetCHgr=[1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9;...
                %     2,3,3,1,2,6,6,8,2,4,4,1,2,7,7,8,2,5,5,8;...
                %     1,0,3,1,1,2,3,0,1,0,4,1,1,2,4,0,1,2,0,0;...
                %     0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1,0,0,1,1];

%             epochsize=EEGv.epochsize;
            epochsize = str2num(get(handles.epochW,'String'))*Fs; 
            slidew = epochsize*str2num(get(handles.epochS,'String'));
            EEGv.epochsize = epochsize/Fs;
            EEGv.TimeParam.slidew = slidew;
            
            if isfield(EEGv.events,'EEG_0')
                if ~isempty(EEGv.events.EEG_0)
                    Events = EEGv.events.EEG_0(1);
                else
                    Events = [];
                end
            end
            %% Initial conditions
            etr=20*Fs; % time discarded: 20 s
            if get(handles.chkTimeProcessing,'Value')
                tp=str2num(get(handles.TimeP2,'String'))*60*Fs;
                if isempty(tp)
                    tp = Nsamples - etr*2;
                end
            else
                tp=4*60*Fs; % Time for processing: 4 min
            end
            % [Nsamples,Nchannels] =size(data);
            flagEv = false;
            
        if get(handles.chkTimeProcess,'Value')
            
            P1 = get(handles.TimeP1,'String');
            if ~isempty(findstr(P1,'e'))        % TO USE EVENTS (FIND 'e'IN THE FIELD)
                ev = findstr(P1,'e'); % detect 'e' characters correspondig to events
                % Later use for to convert vectors
                nev = str2num(P1(ev(1)+1)); % detect the ith event for a vector os event marks
                P1([ev(1) ev(1)+1])=[]; % Clean the 'e' and ith digits from vectors
                Events(nev);
                st_Input=str2num(P1); % convert times in the string to numbers
                factTime = Fs; %60*Fs; % Fator de conversão de tempo [s] para amostras
                
                flagEv = true;
            elseif strcmp(P1(1),'%')            % TO USE PERCENTAGE OF TEST
                st_Input=str2num(P1(2:end));
                st_Input = round (Nsamples*st_Input/100);
                factTime = 1; % Fator de conversão de tempo [s] para amostras
            else
                st_Input=str2num(P1);
                factTime = Fs; %60*Fs; % Fator de conversão de tempo [s] para amostras
            end
            st_Input = st_Input*factTime;
            
%                 k = strfind(end_t,'-');
%                 fracInst = str2num(end_t(k+1:end));
            
%                 Aquecimento: 3x agachamento isométrico 1min + flexão fechada 20x


            %% Times for processing
%             etr=20*Fs; % time discarded: 20 s
%             tp=4*60*Fs; % Time for processing: 4 min

            
            if isempty(tp) & flagEv % When events define segments to be processed
                
                st(1) = st_Input (1)+etr;
                endt(1) = Events(1)-etr;
                st(2) = Events(1)+etr;
                endt(2) = EEGv.pnts-etr;
                
            elseif isempty(tp) & ~flagEv % When there are no events and time processing is empty
                
                for ss=1:length(st_Input)-1 % When there are more than one segment
                    if ss<length(st_Input)
                        tp = st_Input(ss+1);
                        if tp > Nsamples | tp < 0
%                             warndlg('Time for processing was adjusted because it was greater than total time!','Warning!')
                            disp('WARNING: Time for processing was adjusted to the total time!')
                            tp = Nsamples - etr;
                        end
                    end
                    if st_Input(ss)==0
                        st(ss) = st_Input(ss) + etr; % First sample for processing
                        endt(ss) = tp; % Last sample for processing
                    elseif st_Input(ss)>0
                        st(ss) = st_Input(ss); % First sample for processing
                        endt(ss) = tp; % Last sample for processing
                    elseif st_Input(ss)<0
                        endt(ss) = Nsamples - etr; % Last sample for processing
                        st(ss) = endt(ss) - st(ss-1); % First sample for processing
                    end
                end
                if st_Input(end)<0
                    endt(ss+1) = Nsamples - etr; % Last sample for processing
                    st(ss+1) = endt(ss+1) - st(ss); % First sample for processing    
                end
            
            else
                
                for ss=1:length(st_Input)
                    if st_Input(ss)==0
                        st(ss) = st_Input(ss) + etr; % First sample for processing
                        endt(ss) = st(ss) + tp; % Last sample for processing
                    elseif st_Input(ss)>0
                        st(ss) = st_Input(ss); % First sample for processing
                        endt(ss) = st(ss) + tp; % Last sample for processing
                    elseif st_Input(ss)<0
                        endt(ss) = Nsamples - etr; % Last sample for processing
                        st(ss) = endt(ss) - tp; % First sample for processing
                    end
                end
                if endt(ss) > Nsamples
                    disp('WARNING: Time for processing was adjusted because it was greater than total time!')
                    endt(ss) = Nsamples - etr;
                    %st(ss) = endt(ss) - tp; % First sample for processing
                end
            
            end

        else
            st=EEGv.TimeParam.stSamp;
            endt=EEGv.TimeParam.endSamp;
        end

%             if endt(end)> %%%%%%%%%%%%%%%%%%%%%%%%
        for ss=1:length(st)
                
            stSamp = st(ss);
            endSamp = endt(ss);
            EEGv.TimeParam.stSamp(ss) = stSamp;
            EEGv.TimeParam.endSamp(ss) = endSamp;
               
            try
            Epochs    
            catch ME_Ep
                errordlg(['Error in ',EEGv.filename,'. Line: ',num2str(ME_Ep.stack(1).line),' ',ME_Ep.stack(1).name,':', ME_Ep.message])
                disp(ME_Ep)
            end
            EEGv.Props.Epochs.remEpochsEvents(ss)=remEvt;
            EEGv.Props.Epochs.nEpochs(ss)=k;
            EEGv.Props.Epochs.nEpochsRejected(ss)=jj;
            EEGv.Props.Epochs.Totaltime={};
            EEGv.Props.Epochs.Totaltime{ss} = datestr(seconds(length(epochs)*epochsize/Fs),'HH:MM:SS');
            
            EEGv.Props.Process.OffsetRem=1;
%             EEGv.dataEpoch3=dataEpoch;
            EEGv.dataEpoch{ss}=epochs;  
%             EEGv.LEpochs(ss) = length(epochs);
                        
            addlistInformation(handles,['Epochs: ',num2str(EEGv.Props.Epochs.nEpochs(ss)),'. Total time: ', EEGv.Props.Epochs.Totaltime{ss}])
            
        end
            
            EEGv.ProcessApplied.Epoch=1;
            flagl50=0;
            for chknEp=1:length(EEGv.Props.Epochs.nEpochs)
                if EEGv.Props.Epochs.nEpochs(chknEp)<=50
                    flagl50=1;
                end
            end
            if ~flagl50
                EEGv=PSDpwelch(EEGv);
                EEGv.ProcessApplied.PSD=1;
                addlistInformation(handles,['PSD processed'])
                saveData(handles,'',['_PSD-',num2str(ss)'])
            elseif flagl50
                EEGv=PSDpwelch(EEGv);
                EEGv.ProcessApplied.PSD=1;
                addlistInformation(handles,['PSD processed'])
                disp(['ERROR: Epochs below 50. N = ',num2str(length(EEGv.dataEpoch))])
                posfix='';
                for pp=1:ss
                    posfix = strcat (posfix,num2str(length(EEGv.dataEpoch{pp})),'-');
                end
                posfix(end)=[];
                saveData(handles,'',['_PSD-',num2str(pp),'_Ep_',posfix])
            elseif isempty(epochs)
%                 warndlg('Epochs is empty!','Warning')
                disp('ERROR: Epochs is empty!')
            end
                
  
    end
    
%     lh=length(EEGv.History);
%     EEGv.History{lh+1}=ListTasks{i};

end

fprintf(['============================================', ...
    '\nProcessing completed! \n============================================\n'])
set(handles.endInfo,'String','Processing completed!')


% --------------------------------------------------------------------
function MEsaveSession_Callback(hObject, eventdata, handles)
% hObject    handle to MEsaveSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveData(handles,'','')


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in chMapComp.
function chMapComp_Callback(hObject, eventdata, handles)
% hObject    handle to chMapComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chMapComp


function EditRemComp_Callback(hObject, eventdata, handles)
% hObject    handle to EditRemComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRemComp as text
%        str2double(get(hObject,'String')) returns contents of EditRemComp as a double


% --- Executes during object creation, after setting all properties.
function EditRemComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRemComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sett=settingPlotEEG(EEGv)

% ft=5e-5;
ft=mean(abs(EEGv.data(:)))+4*std(abs(EEGv.data(:)));
fact=2;
flagSample=0;
sett=[flagSample fact ft];
EEGv.sett=sett;


function editFilename_Callback(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFilename as text
%        str2double(get(hObject,'String')) returns contents of editFilename as a double


% --- Executes during object creation, after setting all properties.
function editFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ListsTasksUp.
function ListsTasksUp_Callback(hObject, eventdata, handles)
% hObject    handle to ListsTasksUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

contents = get(handles.popupmenuTasks,'String');
sel=get(handles.ListTasks,'Value');
ListTasks = get(handles.ListTasks,'String');

if sel>1
    temp=ListTasks;
    temp={temp{1:sel-2},temp{sel},temp{sel-1},temp{sel+1:end}};
    ListTasks=temp;


    if sel>length(ListTasks)
        set(handles.ListTasks,'Value',1);
    else
        set(handles.ListTasks,'Value',sel-1);
    end
    set(handles.ListTasks,'String',ListTasks);

end


% --- Executes on button press in ListsTasksDown.
function ListsTasksDown_Callback(hObject, eventdata, handles)
% hObject    handle to ListsTasksDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

contents = get(handles.popupmenuTasks,'String');
sel=get(handles.ListTasks,'Value');
ListTasks = get(handles.ListTasks,'String');

if sel<length(ListTasks)
    temp=ListTasks;
    temp={temp{1:sel-1},temp{sel+1},temp{sel},temp{sel+2:end}};
    ListTasks=temp;


    if sel>length(ListTasks)
        set(handles.ListTasks,'Value',1);
    else
        set(handles.ListTasks,'Value',sel+1);
    end
    set(handles.ListTasks,'String',ListTasks);

end


% --- Executes on button press in Program.
function Program_Callback(hObject, eventdata, handles)
% hObject    handle to Program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Database EEGv DatabaseFile currentFile Information

set(handles.endInfo,'String','Program started...')
pause(0.1)
set(handles.listboxInformation,'String','')
set(handles.listboxInformation,'Value',1);

oldstate=get(handles.MEplots,'Checked');
set(handles.MEplots,'Checked','off')
EEGv.Props.flagPlot=0;
set(handles.MEhiddenPlots,'Checked','off')
EEGv.Props.hiddenPlots=0;

ListDatabase=get(handles.popupDatabase,'String');
handles.serial = 1;

for ii=1:length(ListDatabase)-1
    currentFile=DatabaseFile{ii};
    load(DatabaseFile{ii})
    set(handles.popupDatabase,'Value',ii+1)
    % set(handles.editFilename,'String',Database{val-1});
%     set(handles.editFilename,'String',fullfile(EEGv.pathname,EEGv.filename));
    set(handles.editFilename,'String',fullfile(Information.pathname,Information.filename));
    try
    A_run_Callback(hObject, eventdata, handles)
    catch ME
        errordlg(['Error in ',EEGv.filename,'. Line: ',num2str(ME.stack(1).line),' ',ME.stack(1).name,':', ME.message])
        disp(ME)
        addlistInformation(handles,['ERROR:',ME.stack(1).name,' Line:',num2str(ME.stack(1).line),'; ', ME.message])
        EEGv.ERROR=ME;
        saveData(handles,'Err','')
    end
    setFileRun(handles,'pop') % Revisar
    pause(0.1)
end

UpdateInterface (handles)

set(handles.MEplots,'Checked',oldstate)
set(handles.endInfo,'String','Done!')
msgbox('Operation Completed','Success')

handles.serial = 0;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listboxInformation.
function listboxInformation_Callback(hObject, eventdata, handles)
% hObject    handle to listboxInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxInformation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxInformation


% --- Executes during object creation, after setting all properties.
function listboxInformation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function database_Callback(hObject, eventdata, handles)
% hObject    handle to database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function addlistInformation(handles,text)
global EEGv

contents = cellstr(get(handles.listboxInformation,'String')) ;
if iscell(text)
    set(handles.listboxInformation,'String',{contents{:},text{:}})
    set(handles.listboxInformation,'Value',length(contents)+length(text))
    for ii=1:length(text)
        EEGv.History{length(EEGv.History)+1}=text{ii};
    end
else
    set(handles.listboxInformation,'String',{contents{:},text})
    set(handles.listboxInformation,'Value',length(contents)+1)
    EEGv.History{length(EEGv.History)+1}=text;
end

pause(0.1)


% --------------------------------------------------------------------
function MEimportFile_Callback(hObject, eventdata, handles)
% hObject    handle to MEimportFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EEG2MAT

% --------------------------------------------------------------------
function MEimportFolder_Callback(hObject, eventdata, handles)
% hObject    handle to MEimportFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EEG2MAT_M


function saveData(handles,pref,complement)

global EEGv pathnameDatasessions Database DatabaseFileList Information

filename = strcat(pref,EEGv.filename(1:end-4), complement,'.mat');

% try
%     pathnameDatasessions=EEGv.pathname;
% catch, end

if ~ischar(pathnameDatasessions)
    pathnameDatasessions='';
end

if ~isempty(pathnameDatasessions)
    if ~exist(pathnameDatasessions,'dir')
%         MEFolderDataSession_Callback([], [], handles)
%         pathnameDatasessions=EEGv.pathname; % Information.pathname;
        pathnameDatasessions=Information.pathname;
    end
    cdout=cd (pathnameDatasessions);
    cd ('..')
%     cdout=cd;
%     length(cdout)
    % strcmp(pathnameDatasessions(end-12:end-1),'Datasessions')
    if exist ('Datasessions','dir')==7
        mkdirFlag=0;
    else
        mkdirFlag=1;        
    end
    cd(cdout)
else
    mkdirFlag=1;   
end

if exist(fullfile(pathnameDatasessions,filename),'file')~=0 && strcmp(get(handles.MEplots,'Checked'),'on')

    mkdirFlag=1;
end

if mkdirFlag 
[filename, pathnameDatasessions2] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Save session',...
    fullfile(pathnameDatasessions,filename));

if isequal(filename,0)
   disp('File was not saved!')
   return
end
%     filename=fullfile(pathname,filename);    
%      warningMessage = sprintf('Warning: file does already exist:\n%s', filename);
pathnameDatasessions=pathnameDatasessions2;
end
        
% [status,msg,msgID] = mkdir('Datasessions');


EEGv.filename=filename;
Information.filename=filename;
EEGv.pathname=pathnameDatasessions;
Information.pathname=pathnameDatasessions;

File=fullfile(pathnameDatasessions,filename);
save (File,'EEGv','Information')
% set(handles.editFilename,'String',fullfile(EEGv.pathname,EEGv.filename));
set(handles.editFilename,'String',fullfile(Information.pathname,Information.filename));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Proximamente incluir en la lista de archivos
UpdateDatabaseList(handles)     % revisar se deve ir setfileRun

% content=get(handles.DatabaseList,'String');
% if iscell(content)
%     set(handles.DatabaseList,'String',{content{:},EEGv.filename(1:end-4)})
% %     set(handles.DatabaseList,'Value',length(content)+1)
%     set(handles.DatabaseList,'Value',1)
% else
%     set(handles.DatabaseList,'String',{content,EEGv.filename(1:end-4)})
% %     set(handles.DatabaseList,'Value',size(content,1)+1)
%     set(handles.DatabaseList,'Value',1)
% end
% DatabaseFileList{length(DatabaseFileList)+1}=fullfile(EEGv.pathname,EEGv.filename);

disp(['Saved file:', File])
UpdateInterface (handles)
% setFileRun(handles,'List') % Revisar NO FUNCIONA AQUI


% --- Executes on selection change in popupProc.
function popupProc_Callback(hObject, eventdata, handles)
% hObject    handle to popupProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupProc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupProc
value=get(hObject,'Value');

switch value
    
    case 1
        set(handles.uipanelPreprocessing,'Visible', 'on')
        set(handles.uipanelProcessing,'Visible', 'off')
        list={'Filter Data','CAR','ICA','Remove ICA comp','Remove Segment','ASR','Epoch','MRCP','Pause','Synchronism'};
    case 2
        set(handles.uipanelPreprocessing,'Visible', 'off')
        set(handles.uipanelProcessing,'Visible', 'on')
        list={'PSD','MRCP','Pause'};
end

set(handles.popupmenuTasks,'String',list)
set(handles.popupmenuTasks,'Value', 1)


% --- Executes during object creation, after setting all properties.
function popupProc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RemComponent.
function RemComponent_Callback(hObject, eventdata, handles)
% hObject    handle to RemComponent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

%% Removing ICA components
% fica=figure;
% plotEEG(fica,data,Fs,SetCH,[0 4],'b',''), hold on
EEGv.dataPreICA = EEGv.data; 

components = str2num ( get(handles.EditRemComp,'String') ); % components=[1 2];            
EEGv.icacomponents=components;
EEGv = pop_subcomp( EEGv, components, 0);
EEGv = eeg_checkset( EEGv );
addlistInformation(handles,['ICA components removed:',num2str(components)])
try addlistInformation(handles,['Below [%] :  ',num2str(EEGv.icapercRemComp)]), end

% eegplot( EEGv.dataPreICA(EEGv.icachansind,:,:), 'srate', EEGv.srate, 'title', 'Black = channel before rejection; red = after rejection', ...
%      'limits', [EEGv.xmin EEGv.xmax]*1000, 'data2', EEGv.data); 

% plotEEG(fica,data,Fs,SetCH,[0 4],'r','Performance EditTest. ICA')
EEGv.ProcessApplied.RemICA=1;
saveData(handles,'','_RemICA')
            

% --- Executes on button press in ViewComp.
function ViewComp_Callback(hObject, eventdata, handles)
% hObject    handle to ViewComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

comp=size(EEGv.icaweights,1);
pop_viewprops( EEGv, 0, [1:comp], {'freqrange', [2 80]}, {}, 1, 'ICLabel' )

lab=EEGv.etc.ic_classification.ICLabel.classes
class=EEGv.etc.ic_classification.ICLabel.classifications

[components,artefact]=find(EEGv.etc.ic_classification.ICLabel.classifications(:,2:end)>.4);
artefact = artefact+1;
for cc=1:length(components)
    msgcomp{cc}=strcat(['Component: ',num2str(components(cc)),' ',EEGv.etc.ic_classification.ICLabel.classes{artefact(cc)},' [%]',num2str(EEGv.etc.ic_classification.ICLabel.classifications(components(cc),artefact(cc))*100)]);
    disp(msgcomp{cc})                
end

addlistInformation(handles,{'ICA labels calculated','Artefacts:'})
addlistInformation(handles,msgcomp)
set(handles.EditRemComp,'String',num2str(components'))


% --- Executes on button press in Spectr.
function Spectr_Callback(hObject, eventdata, handles)
% hObject    handle to Spectr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv
ch=(get(handles.popupCh,'Value'));
[eje_f,mag_ss]=espectro(EEGv.data(ch,:)',EEGv.srate,1);



function percRemComp_Callback(hObject, eventdata, handles)
% hObject    handle to percRemComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percRemComp as text
%        str2double(get(hObject,'String')) returns contents of percRemComp as a double


% --- Executes during object creation, after setting all properties.
function percRemComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percRemComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MEFolderDataSession_Callback(hObject, eventdata, handles)
% hObject    handle to MEFolderDataSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathnameDatasessions

if ~ischar(pathnameDatasessions)
    pathnameDatasessions='';
end

pathnameDatasessions2 = uigetdir(pathnameDatasessions);

if isequal(pathnameDatasessions,0)
   disp('Selection canceled')
   return
end 

pathnameDatasessions=pathnameDatasessions2;
cdout=cd(pathnameDatasessions);
[status,msg,msgID] = mkdir('Datasessions');
pathnameDatasessions=fullfile(pathnameDatasessions,'Datasessions');
cd(cdout)


% --- Executes on button press in chNotch.
function chNotch_Callback(hObject, eventdata, handles)
% hObject    handle to chNotch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chNotch
global EEGv

[eje_f,mag_ss]=espectro(EEGv.data(1,:)',EEGv.srate,1);


% --------------------------------------------------------------------
function MEsaveProject_Callback(hObject, eventdata, handles)
% hObject    handle to MEsaveProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Database DatabaseFile pathnameDatasessions DatabaseFileList

[filename, pathnameDatasessions2] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Save project',...
    fullfile(pathnameDatasessions,'Database'));

if isequal(filename,0)
   disp('Selection canceled')
   return
else
    pathnameDatasessions=pathnameDatasessions2;
end

% Updating ListTasks
ListTasks=get(handles.ListTasks,'String');

File=fullfile(pathnameDatasessions,filename);
save (File,'Database','DatabaseFile','ListTasks','DatabaseFileList')
disp('Project saved')

% --------------------------------------------------------------------
function MEloadProject_Callback(hObject, eventdata, handles)
% hObject    handle to MEloadProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Database DatabaseFile pathnameDatasessions DatabaseFileList

[filename, pathnameDatasessions2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load project',...
    fullfile(pathnameDatasessions,'Database'));

if isequal(filename,0)
   disp('Selection canceled')
   return
else
    pathnameDatasessions=pathnameDatasessions2;
end

File=fullfile(pathnameDatasessions,filename);
variableInfo = who('-file', File);

if ~ismember('Database', variableInfo) 
    errordlg('Project was not found','File wrong')
    return
end
    
load (File,'Database','DatabaseFile','ListTasks')

DatabaseFileList=DatabaseFile;
set(handles.popupDatabase,'Value',1);
set(handles.popupDatabase,'String',Database);
set(handles.DatabaseList,'String',Database);
% Updating ListTasks
if ~isempty(ListTasks)
    set(handles.ListTasks,'String',ListTasks);
end


% --------------------------------------------------------------------
function MEclearDatabase_Callback(hObject, eventdata, handles)
% hObject    handle to MEclearDatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv Database DatabaseFile DatabaseFileList currentFile

Database={'Database'};
DatabaseFile={};
DatabaseFileList={};
EEGv=[];
currentFile='';

set(handles.popupDatabase,'Value',1);
set(handles.popupDatabase,'String',Database);
set(handles.DatabaseList,'String',DatabaseFileList);
set(handles.DatabaseList,'Value',1)
set(handles.properties,'String','')

set(handles.editFilename,'String','');


% --- Executes on selection change in DatabaseList.
function DatabaseList_Callback(hObject, eventdata, handles)
% hObject    handle to DatabaseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DatabaseList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DatabaseList
global DatabaseFileList 

val=get(hObject,'Value');
if val>0
    if ~isempty(DatabaseFileList)
    load(DatabaseFileList{val})
    
    % set(handles.editFilename,'String',DatabaseFileList{val});
    UpdateInterface (handles)
    setFileRun(handles,'List')
    end
end


% --- Executes during object creation, after setting all properties.
function DatabaseList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DatabaseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupCh.
function popupCh_Callback(hObject, eventdata, handles)
% hObject    handle to popupCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupCh
stop=1;


% --- Executes during object creation, after setting all properties.
function popupCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function TabPanPreproc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabPanPreproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanelPreprocessing,'Visible', 'on')
set(handles.uipanelProcessing,'Visible', 'off')
set(handles.uipanelStat,'Visible', 'off')
list={'Filter Data','CAR','ICA','Remove ICA comp','Remove Segment','ASR','Epoch','MRCP','Pause','Synchronism'};
set(handles.popupmenuTasks,'String',list)
set(handles.popupmenuTasks,'Value', 1)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TabTxtPreproc.
function TabTxtPreproc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabTxtPreproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TabPanPreproc_ButtonDownFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function TabPanProc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabPanProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipanelPreprocessing,'Visible', 'off')
set(handles.uipanelProcessing,'Visible', 'on')
set(handles.uipanelStat,'Visible', 'off')
list={'PSD','MRCP','Pause'};
set(handles.popupmenuTasks,'String',list)
set(handles.popupmenuTasks,'Value', 1)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TabTxtProc.
function TabTxtProc_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabTxtProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TabPanProc_ButtonDownFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function TabPanStat_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabPanStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanelPreprocessing,'Visible', 'off')
set(handles.uipanelProcessing,'Visible', 'off')
set(handles.uipanelStat,'Visible', 'on')


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TabTxtStat.
function TabTxtStat_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TabTxtStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TabPanStat_ButtonDownFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function currentFile=getFileRun()
global currentFile
% val=get(handles.popupDatabase,'Value');
% currentFile=DatabaseFile{val-1};
% 
% val=get(handles.DatabaseList,'Value');
% currentFile=DatabaseFile{val-1};

function setFileRun(handles,com)
global currentFile DatabaseFileList DatabaseFile
switch com
    case 'pop'
        val=get(handles.popupDatabase,'Value');
        currentFile=DatabaseFile{val-1};
    case 'List'
        val=get(handles.DatabaseList,'Value');
        currentFile=DatabaseFileList{val};
end

% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv 
pop_eegplot( EEGv, 1, 1, 1);
fa=gca;
title({EEGv.filename},'Interpreter', 'none')
x1=str2num(get(handles.PlotiSample,'String'));
x2=str2num(get(handles.PlotWindow,'String'));
axis([x1 x2 min(fa.YTick) max(fa.YTick)])
% f=figure;
% plotEEG(f,EEGv.data,EEGv.srate,EEGv.Props.SetCH,[0 4],'b','')

% --------------------------------------------------------------------
function MEPlotEEG_Callback(hObject, eventdata, handles)
% hObject    handle to MEPlotEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

x1=str2num(get(handles.PlotiSample,'String'));
x2=str2num(get(handles.PlotWindow,'String'));
y=str2num(get(handles.PlotYscale,'String'));

f=figure;
th = plotEEG(f,EEGv.data,EEGv.times/1000,EEGv.srate,EEGv.Props.SetCH,[0 4],'b','',1);
title({EEGv.filename},'Interpreter', 'none')

etc=EEGv.etc;
if isfield(etc,'clean_sample_mask')
    hold on
    plot(EEGv.times/1000,EEGv.etc.clean_sample_mask*th,'g')
end

if isfield(EEGv,'events')
    if isfield(EEGv.events,'Time_onset_Contr')
    n_events = length(EEGv.events.Time_onset_Contr);
    hold on
%     plot(EEGv.events.Time_onset_Contr(:,1),ones(n_events,1)*th+100,'*r')
%     plot(EEGv.events.Time_onset_Contr(:,2),ones(n_events,1)*th+100,'ok')
    plot([EEGv.events.Time_onset_Contr(:,1) EEGv.events.Time_onset_Contr(:,1)]',...
        [ones(n_events,1)*th ones(n_events,1)*th*2]','k')
    plot([EEGv.events.Time_onset_Contr(:,2) EEGv.events.Time_onset_Contr(:,2)]',...
        [ones(n_events,1)*th ones(n_events,1)*th*2]','--r')

%     EEGv.events.Time_onset_Contr(:,2)-EEGv.events.Time_onset_Contr(:,1);
    end
end

fa=gca;
if isempty(x1) & isempty(x2) & isempty(y)
    axis tight
else    
    
if isempty(x1)
    x1=EEGv.times(1)/1000;
end
if isempty(x2)
    x2=(EEGv.times(end)-EEGv.times(1))/1000;
end
    axis([x1 x1+x2 min(fa.YTick)-th max(fa.YTick)+th*2])
end


% --------------------------------------------------------------------
function MEPlotEEGscale_Callback(hObject, eventdata, handles)
% hObject    handle to MEPlotEEGscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv

x1=str2num(get(handles.PlotiSample,'String'));
x2=str2num(get(handles.PlotWindow,'String'));
y=str2num(get(handles.PlotYscale,'String'));

f=figure;
th = plotEEG(f,EEGv.data,EEGv.times/1000,EEGv.srate,EEGv.Props.SetCH,[0 1 y],'b','',1);
title({EEGv.filename},'Interpreter', 'none')

etc=EEGv.etc;
if isfield(etc,'clean_sample_mask')
hold on
plot(EEGv.times/1000,EEGv.etc.clean_sample_mask*th,'g')
end

if isfield(EEGv,'events')
    n_events = length(EEGv.events.Time_onset_Contr);
    hold on
%     plot(EEGv.events.Time_onset_Contr(:,1),ones(n_events,1)*th+100,'*r')
%     plot(EEGv.events.Time_onset_Contr(:,2),ones(n_events,1)*th+100,'ok')
    plot([EEGv.events.Time_onset_Contr(:,1) EEGv.events.Time_onset_Contr(:,1)]',...
        [ones(n_events,1)*th ones(n_events,1)*th*2]','k')
    plot([EEGv.events.Time_onset_Contr(:,2) EEGv.events.Time_onset_Contr(:,2)]',...
        [ones(n_events,1)*th ones(n_events,1)*th*2]','--r')

%     EEGv.events.Time_onset_Contr(:,2)-EEGv.events.Time_onset_Contr(:,1);
end
pause(0.1)
fa=gca;
if isempty(x1)
    x1=EEGv.times(1)/1000;
end
if isempty(x2)
    x2=(EEGv.times(end)-EEGv.times(1))/1000;
end
axis([x1 x1+x2 min(fa.YTick)-th max(fa.YTick)+th*2])
pause(0.1)

% --------------------------------------------------------------------
function MEPlotEEGlab_Callback(hObject, eventdata, handles)
% hObject    handle to MEPlotEEGlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv 
pop_eegplot( EEGv, 1, 1, 1);


% --------------------------------------------------------------------
function MEEEGlabOptions_Callback(hObject, eventdata, handles)
% hObject    handle to MEEEGlabOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ICAcomps_Callback(hObject, eventdata, handles)
% hObject    handle to ICAcomps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Scalp2D_Callback(hObject, eventdata, handles)
% hObject    handle to Scalp2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function TimeP2_Callback(hObject, eventdata, handles)
% hObject    handle to TimeP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeP2 as text
%        str2double(get(hObject,'String')) returns contents of TimeP2 as a double


% --- Executes during object creation, after setting all properties.
function TimeP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkTimeProcess.
function chkTimeProcess_Callback(hObject, eventdata, handles)
% hObject    handle to chkTimeProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTimeProcess

if get(handles.chkTimeProcess,'Value')
    set(handles.TimeP1,'Enable','on')
    
else
    set(handles.TimeP1,'Enable','off')
    
end

% --- Executes on button press in chkTimeProcessing.
function chkTimeProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to chkTimeProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTimeProcessing
if get(handles.chkTimeProcessing,'Value')
    
    set(handles.TimeP2,'Enable','on')
else
    
    set(handles.TimeP2,'Enable','off')
end


function epochW_Callback(hObject, eventdata, handles)
% hObject    handle to epochW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochW as text
%        str2double(get(hObject,'String')) returns contents of epochW as a double


% --- Executes during object creation, after setting all properties.
function epochW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epochS_Callback(hObject, eventdata, handles)
% hObject    handle to epochS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochS as text
%        str2double(get(hObject,'String')) returns contents of epochS as a double


% --- Executes during object creation, after setting all properties.
function epochS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotiSample_Callback(hObject, eventdata, handles)
% hObject    handle to PlotiSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotiSample as text
%        str2double(get(hObject,'String')) returns contents of PlotiSample as a double


% --- Executes during object creation, after setting all properties.
function PlotiSample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotiSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotWindow_Callback(hObject, eventdata, handles)
% hObject    handle to PlotWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotWindow as text
%        str2double(get(hObject,'String')) returns contents of PlotWindow as a double
% f=gcf;
% fa=gca;
% 
% x1=str2num(get(handles.PlotiSample,'String'));
% x2=str2num(get(handles.PlotWindow,'String'));
% axis([x1 x2 min(fa.YTick) max(fa.YTick)])

% --- Executes during object creation, after setting all properties.
function PlotWindow_CreateFcn(hObject, eventdata, handles)   
% hObject    handle to PlotWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotYscale_Callback(hObject, eventdata, handles)
% hObject    handle to PlotYscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotYscale as text
%        str2double(get(hObject,'String')) returns contents of PlotYscale as a double


% --- Executes during object creation, after setting all properties.
function PlotYscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotYscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MEExportReportFiles_Callback(hObject, eventdata, handles)
% hObject    handle to MEExportReportFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ReportData ('')


function ReportData (Datafile)
global pathname EEGv PSDfile Database DatabaseFile Information

%% Loading files
if isempty(Datafile)
    
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

end

%% 
SS=[];
rr=1;

for ff=1:length(Datafile)
    
variableInfo = who('-file', Datafile{ff});

if ~ismember('EEGv', variableInfo) 
    warndlg('Variable from session was not found','File wrong!')
    return
end

% load(Datafile{ff},'EEGv')
load(Datafile{ff})

File = EEGv.filename;
disp(['File selected: ',File])
d=1; %d-> S previous to number
sub=str2num(File(d+1:d+2)); % To obtain the subject code 
instantTest=File(d+4:d+6); % To obtain the instant code

if ~isempty(sub) && ~isempty(instantTest)     
    [Inst,nTest] = Filecodes(File,sub,instantTest,d);
    
    fileRep{rr} = File;
    
for nep=1:length(EEGv.Props.Epochs.nEpochs)
    
    
Report(rr,1) = sub;
Report(rr,2) = nTest;
Report(rr,3) = Inst;
try Report(rr,4) = EEGv.icapercRemComp; catch Report(rr,4) = nan; end
try Report(rr,5) = length(EEGv.icachansind); catch Report(rr,5) = nan; end
try Report(rr,6) = length(EEGv.icacomponents); catch Report(rr,64) = nan; end
try Report(rr,7) = EEGv.epochsize; catch Report(rr,7) = nan; end
try Report(rr,8) = EEGv.Props.Epochs.nEpochs(nep); catch Report(rr,8) = nan; end
try Report(rr,9) = EEGv.Props.Epochs.nEpochsRejected(nep); catch Report(rr,9) = nan; end
try Report(rr,10) = length(EEGv.event); catch Report(rr,10) = nan; end

try
stSamp=EEGv.TimeParam.stSamp(nep);
endSamp=EEGv.TimeParam.endSamp(nep);
Report(rr,11) = (endSamp-stSamp)/200; 
catch Report(rr,11) = nan; 
end

try Report(rr,12) = sum(~EEGv.etc.clean_sample_mask(stSamp:endSamp))/200; catch Report(rr,12) = nan; end
try Report(rr,13) = EEGv.eyeSel; catch Report(rr,13) = nan; end

try
if EEGv.eyeSel==1
    art=find(strcmp(EEGv.etc.ic_classification.ICLabel.classes,'Eye'));
else
    art=2:length(EEGv.etc.ic_classification.ICLabel.classes);
end
TotalCmp = sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2);
clear Tcmp
Tcmp(1,:) = TotalCmp(EEGv.icacomponents);
Report(rr,14:length(Tcmp)+13) = Tcmp; 
end
rr=rr+1;

end

end

end

%% Exporting Records

ReportLab{1} = 'Subject';
ReportLab{2} = 'Test';
ReportLab{3} = 'Inst';
ReportLab{4} = 'ICA TH[%]';
ReportLab{5} = 'nCH ICA';
ReportLab{6} = 'nRem Comp';
ReportLab{7} = 'Epoch Size';
ReportLab{8} = 'nEpochs';
ReportLab{9} = 'nRej. Ep.';
ReportLab{10} = 'nRem Seg';
ReportLab{11} = 'Time processed';
ReportLab{12} = 'Time rejected';
ReportLab{13} = 'Eye artifact';
ReportLab{14} = 'ICA cmps[%]';

filenameExcel=fullfile(pathname,'File summary.xlsx');

xlRange = 'C1';
xlswrite(filenameExcel,ReportLab, 'Summary',xlRange)
xlRange = 'C2';
xlswrite(filenameExcel,Report, 'Summary',xlRange)
xlRange = 'A2';
xlswrite(filenameExcel,fileRep', 'Summary',xlRange)

ReportFiles=fullfile(pathname,'ReportFiles.mat');
% save(file,'PSDband','PSDbandRel','Props','PSDan1','PSDan1Log')
save (ReportFiles,'Report','ReportLab')
disp(['File saved:',ReportFiles])
disp('Done!')


% --------------------------------------------------------------------
function PSDAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to PSDAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname EEGv PSDfile Database DatabaseFile Information

% Bandtext={'Theta','Alpha','Alpha Low','Alpha High','Beta','Beta Low',...
%     'Beta High','Gama','Teta/Beta','Teta/BetaL','Teta/BetaH'};
% PSDTypes={'Normal','Log','Regions','Log_Regions'};

% TestLabel={'V3','V4','V5','V1'};
% InstLabeltmp={'Pre','Perf','None','Pos'};
TestLabel={'V3','V4','V5'};
% InstLabeltmp={'Pre','Perf','Pos'};
InstLabeltmp={'Pre','Pos'};

% TestLabel={'Control','STRP','ST'};
% InstLabeltmp={'Baseline','Stroop','Bike','Pos'};

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple PSD files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Canceled!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

set(handles.endInfo,'String','Processing PSD Analysis...!')
pause(0.1)
SS=[];
rr=1;

InsIndex=[1 1 1]; % InsIndex=[1 1 1 1]; % Set the number of segments for each kind os test
for ff=1:length(Datafile)
    [~,File,~] = fileparts(Datafile{ff});
    d=1; % d-> S previous to number
    sub=str2num(File(d+1:d+2)); % To obtain the subject code : S01
    instantTest=File(d+4:d+6); % To obtain the instant code  : S01_Pos
    [x,~] = Filecodes(File,sub,instantTest,d);
    
    load(Datafile{ff})
    InsIndex(x) = length(EEGv.PSD.PSDband);
end

acum=0;
clear ix
for jj=2:length(InsIndex)
    % ix(jj)=InsIndex(jj-1);
    acum=acum+InsIndex(jj-1);
    ix(jj)=acum;
end

nFraInst(length(InstLabeltmp))=0; % 3 is the number of instants

for ff=1:length(Datafile)
%     if strcmp(Datafile{ff}(end-6:end),'PSD.mat')
variableInfo = who('-file', Datafile{ff});

if ~ismember('EEGv', variableInfo) 
    warndlg('Variable from session was not found','File wrong!')
    return
end

% load(Datafile{ff},'EEGv')
load(Datafile{ff})

% File = EEGv.filename;
[~,File,~] = fileparts(Datafile{ff});
disp(['File selected: ',File])
d=1; % d-> S previous to number
sub=str2num(File(d+1:d+2)); % To obtain the subject code 
instantTest=File(d+4:d+6); % To obtain the instant code

if ~isempty(sub) && ~isempty(instantTest)              
% EditTest Carol 
% Tests:
% 1. Control / 2. Stroop / 3. Stm
% Instants:
% 1. Pre - 2. stroop - 3. Bike - 4. Pós
[Inst,nTest] = Filecodes(File,sub,instantTest,d);
Datafile2{rr}=Datafile{ff};
rr=rr+1;

end

try

SS=[SS sub]; % Indices of processed subjects

if ~iscell(EEGv.PSD.PSDband)
    
PSDband{nTest,Inst}(:,:,sub)=EEGv.PSD.PSDband;               % PSD band x channel
PSDbandLog{nTest,Inst}(:,:,sub)=EEGv.PSD.PSDbandLog;         % PSD band x channel Log
PSDbandSets{nTest,Inst}(:,:,sub)=EEGv.PSD.PSDbandSets;       % PSD band x EEG regions
PSDbandLogSets{nTest,Inst}(:,:,sub)=EEGv.PSD.PSDbandLogSets; % PSD band x EEG regions Log
PX.CH{sub}{nTest,Inst}=EEGv.PSD.CHpxx;                   % Pxx samp x Epochs
% CHpxx{nTest,Inst}(:,:,sub)=EEGv.PSD.CHpxx;                   % Pxx samp x Epochs

else
    
nFraInst(Inst)=length(EEGv.PSD.PSDband);
Inst=ix(Inst);
for fraInst=1:length(EEGv.PSD.PSDband)
PSDband{nTest,Inst+fraInst}(:,:,sub)=EEGv.PSD.PSDband{fraInst};               % PSD band x channel
PSDbandLog{nTest,Inst+fraInst}(:,:,sub)=EEGv.PSD.PSDbandLog{fraInst};         % PSD band x channel Log
PSDbandSets{nTest,Inst+fraInst}(:,:,sub)=EEGv.PSD.PSDbandSets{fraInst};       % PSD band x EEG regions
PSDbandLogSets{nTest,Inst+fraInst}(:,:,sub)=EEGv.PSD.PSDbandLogSets{fraInst}; % PSD band x EEG regions Log
PX.CH{sub}{nTest,Inst+fraInst}=EEGv.PSD.CHpxx{fraInst};                   % Pxx samp x Epochs
% CHpxx{nTest,Inst}(:,:,sub)=EEGv.PSD.CHpxx;                   % Pxx samp x Epochs
end

end

% Report(rr,1) = sub;
% Report(rr,2) = nTest;
% Report(rr,3) = Inst;
% Report(rr,4) = EEGv.icapercRemComp;
% Report(rr,5) = length(EEGv.icachansind);
% Report(rr,6) = length(EEGv.icacomponents);
% Report(rr,7) = EEGv.epochsize;
% Report(rr,8) = EEGv.Props.Epochs.nEpochs;
% Report(rr,9) = EEGv.Props.Epochs.nEpochsRejected;
% Report(rr,10) = length(EEGv.event);
% 
% stSamp=EEGv.TimeParam.stSamp;
% endSamp=EEGv.TimeParam.endSamp;
% Report(rr,11) = (endSamp-stSamp)/200;
% Report(rr,12) = sum(~EEGv.etc.clean_sample_mask(stSamp:endSamp))/200;
% Report(rr,13) = EEGv.eyeSel;
% 
% TotalCmp = sum(EEGv.etc.ic_classification.ICLabel.classifications(:,art),2);
% Tcmp(1,:) = TotalCmp(components);
% Report(rr,14:length(Tcmp)+14) = Tcmp;
% 
% fileRep{rr} = File;
% rr=rr+1;

catch ME
    disp(['Error in:',File,' ',ME.message])
end

% PSDband{nTest}{bands,ch}(sub,nInst)

%     end
end

set(handles.popupCh,'String',EEGv.Props.SetCH(1,:)) 

% To delete missing subjects
SS = unique(SS);
SS2(1:sub) = true;
SS2(SS) = false;
SS = find(SS2); % To detect codes don't belonging to subjets 

PX.CH(SS)=[];

for nTest=1:size(PSDband,1)
    for nInst=1:size(PSDband,2)
        try
        PSDband{nTest,nInst}(:,:,SS)=[];
        PSDbandLog{nTest,nInst}(:,:,SS)=[];
        PSDbandSets{nTest,nInst}(:,:,SS)=[];
        PSDbandLogSets{nTest,nInst}(:,:,SS)=[];
        
        % PSD average across subjects
        PSDbandM{nTest,nInst} = mean(PSDband{nTest,nInst},3);
        PSDbandLogdM{nTest,nInst} = mean(PSDbandLog{nTest,nInst},3);
        PSDbandSetsM{nTest,nInst} = mean(PSDbandSets{nTest,nInst},3);
        PSDbandLogSetsM{nTest,nInst} = mean(PSDbandLogSets{nTest,nInst},3);
        catch ME
           stop=1; 
        end
    end
end


s=1;
for sub=1:size(PX.CH,2)
% if ~isempty(PX.CH{sub})
    for chxx=1:20
        for nTest=1:size(PSDband,1)
            for nInst=1:size(PSDband,2)      
                try
                PX.CHM{nTest,nInst}(:,chxx,s)=mean(PX.CH{sub}{nTest,nInst}{chxx},2);
                PX.CHSD{nTest,nInst}(:,chxx,s)=std(PX.CH{sub}{nTest,nInst}{chxx}');
                PX.CHmin{nTest,nInst}(:,chxx,s)=min(PX.CH{sub}{nTest,nInst}{chxx}');
                PX.CHMax{nTest,nInst}(:,chxx,s)=max(PX.CH{sub}{nTest,nInst}{chxx}');
                catch ME
                   stop=1; 
                end
            end
        end
    end
    s=s+1;
% end
end

for nTest=1:size(PSDband,1)
    for nInst=1:size(PSDband,2)  
        try
        PX.CHMsub{nTest,nInst}=mean(PX.CHM{nTest,nInst},3);
        PX.CHMSDsub{nTest,nInst}=std(PX.CHM{nTest,nInst},[],3);
        PX.CHMminsub{nTest,nInst}=min(PX.CHM{nTest,nInst},[],3);
        PX.CHMmaxsub{nTest,nInst}=max(PX.CHM{nTest,nInst},[],3);
        catch ME
           stop=1; 
        end
    end
end

%% PSD Relative between two instants
BS=1; % Baseline
Act=2;
PSDbandRel={}; PSDbandLogRel={}; PSDbandSetsRel={}; PSDbandLogSetsRel={};
for sub=1:size(PSDband{1,1},3)
    % b=1:8
%     for EditInst=1:4
    for nTest=1:size(PSDband,1)
            
        krel=[1 3]; % Difference between 2 and 1 % krel=[1 2]; % Difference between 2 and 1
        nrel=size(krel,1); % n relatives maps
        for rel=1:nrel
            try 
            if ~isempty(PSDband{nTest,krel(rel,Act)}(:,:,sub)) || ~isempty(PSDband{nTest,krel(rel,BS)}(:,:,sub))
%                 PSDbandRel{nrel}{sub}{nTest}=PSDband{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDband{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandLogRel{nrel}{sub}{nTest}=PSDbandLog{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLog{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandSetsRel{nrel}{sub}{nTest}=PSDbandSets{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandSets{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandLogSetsRel{nrel}{sub}{nTest}=PSDbandLogSets{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLogSets{sub}{nTest,krel(rel,BS)}(:,:,sub);
                
                PSDbandRel{nrel}{nTest}(:,:,sub)=(PSDband{nTest,krel(rel,Act)}(:,:,sub)-PSDband{nTest,krel(rel,BS)}(:,:,sub))./PSDband{nTest,krel(rel,BS)}(:,:,sub);
                PSDbandLogRel{nrel}{nTest}(:,:,sub)=(PSDbandLog{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLog{nTest,krel(rel,BS)}(:,:,sub))./PSDbandLog{nTest,krel(rel,BS)}(:,:,sub);
                PSDbandSetsRel{nrel}{nTest}(:,:,sub)=(PSDbandSets{nTest,krel(rel,Act)}(:,:,sub)-PSDbandSets{nTest,krel(rel,BS)}(:,:,sub))./PSDbandSets{nTest,krel(rel,BS)}(:,:,sub);
                PSDbandLogSetsRel{nrel}{nTest}(:,:,sub)=(PSDbandLogSets{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLogSets{nTest,krel(rel,BS)}(:,:,sub))./PSDbandLogSets{nTest,krel(rel,BS)}(:,:,sub);
                
                PSDbandRel{nrel}{nTest}(:,:,sub)=mean(PSDbandRel{nrel}{nTest}(:,:,sub),3);
                PSDbandLogRel{nrel}{nTest}(:,:,sub)=mean(PSDbandLogRel{nrel}{nTest}(:,:,sub),3);
                PSDbandSetsRel{nrel}{nTest}(:,:,sub)=mean(PSDbandSetsRel{nrel}{nTest}(:,:,sub),3);
                PSDbandLogSetsRel{nrel}{nTest}(:,:,sub)=mean(PSDbandLogSetsRel{nrel}{nTest}(:,:,sub),3);

            end
            
            catch ME
                stop=1;
                disp('ERROR PSD Relative!!!')
            end
        end
    end
%     end
end

%% Remove for further files

Props.SetCH={'1. F7','2. T3','3. T5','4. Fp1','5. F3','6. C3','7. P3',...
    '8. O1','9. F8','10.T4','11.T6','12.Fp2','13.F4','14.C4','15.P4',...
    '16.O2','17.Fz','18.Cz','19.Pz','20.Oz','A1','A2'}; %'FOTO','Annotations';...
temp=EEGv.Props;
if ~isfield(temp,'SetCHgr')
    SetCHgr=[1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9;...
        2,3,3,1,2,6,6,8,2,4,4,1,2,7,7,8,2,5,5,8;...
        1,0,3,1,1,2,3,0,1,0,4,1,1,2,4,0,1,2,0,0;...
        0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1,0,0,1,1];
else
    SetCHgr=EEGv.Props.SetCHgr;
end
if ~isfield(temp,'SetsLabel')
%     SetsLabel={}; k=1;
%     nCat=size(SetCHgr,1);
%     for ii=1:nCat
%         nSets{ii}=unique(SetCHgr(ii,:));
%         for jj=1:length(nSets{ii})
%             SetsLabel{k}=['G',num2str(ii),'_',num2str(nSets{ii}(jj))];
%             k=k+1;
%         end
%     end    
    SetsLabel={}; k=1;
    nCat=size(SetCHgr,1);
    for ii=1:nCat
        nSets=unique(SetCHgr(ii,:));
        nSets(find(~nSets))=[];      % To delete '0' from groups
        for jj=1:length(nSets)
            SetsLabel{k}=['G',num2str(ii),'_',num2str(nSets(jj))];
            k=k+1;
        end
    end
    Props.SetsLabel=SetsLabel;
else
    Props.SetsLabel=EEGv.PSD.SetsLabel;
end

%%


k=1;
for lab=1:length(nFraInst)
    if nFraInst(lab)<2
        InstLabel{k}=InstLabeltmp{lab};
        k=k+1;
    else
        for bb=1:nFraInst(lab)
            InstLabel{k}=strcat(InstLabeltmp{lab},num2str(bb));
            k=k+1;
        end
    end
end

Props.Bandtext=EEGv.PSD.Bandtext;
Props.TestLabel=TestLabel;
Props.InstLabel=InstLabel;
Props.PSDTypes=EEGv.PSD.PSDTypes;

Props.chaninfo=EEGv.chaninfo;
Props.chanlocs=EEGv.chanlocs;

% ReportLab{1} = 'Subject';
% ReportLab{2} = 'Test';
% ReportLab{3} = 'Inst';
% ReportLab{4} = 'ICA TH[%]';
% ReportLab{5} = 'nCH ICA';
% ReportLab{6} = 'nRem Comp';
% ReportLab{7} = 'Epoch Size';
% ReportLab{8} = 'nEpochs';
% ReportLab{9} = 'nRej. Ep.';
% ReportLab{10} = 'nRem Seg';
% ReportLab{11} = 'Time processed';
% ReportLab{12} = 'Time rejected';
% ReportLab{13} = 'Eye artifact';
% ReportLab{14} = 'ICA cmps[%]';
% 
% filenameExcel=fullfile(pathname,'File summary.xlsx');
% 
% xlRange = 'C1';
% xlswrite(filenameExcel,ReportLab, 'Summary',xlRange)
% xlRange = 'C2';
% xlswrite(filenameExcel,Report, 'Summary',xlRange)
% xlRange = 'A2';
% xlswrite(filenameExcel,fileRep', 'Summary',xlRange)

%%

PSDfile=fullfile(pathname,'PSD.mat');
% save(file,'PSDband','PSDbandRel','Props','PSDan1','PSDan1Log')
save (PSDfile,'Props','PSDband','PSDbandLog','PSDbandSets','PSDbandLogSets',...
    'PSDbandRel','PSDbandLogRel','PSDbandSetsRel','PSDbandLogSetsRel','PX','PSDbandM')
%     'PSDan1','PSDan1Log','PSDan1Sets','PSDan1LogSets')

disp(['File saved:',PSDfile])
set(handles.endInfo,'String','PSD Analysis done!')
pause(0.1)
for ii=1:length(InstLabel)
    InstLabel2{ii} = strcat(num2str(ii),'.',InstLabel{ii});
end
set(handles.popInst,'String',InstLabel2)

for ii=1:length(Props.TestLabel)
    TestLabel2{ii} = strcat(num2str(ii),'.',Props.TestLabel{ii});
end
set(handles.popTest,'String',TestLabel2)
ReportData (Datafile2)
%%

% % Tests:
% % 1. Control / 2. Stroop / 3. Stm
% % Instants:
% % 1. Pre - 2. stroop - 3. Bike - 4. Pós
% 
% % SetCH={'F7','T3','T5','Fp1','F3','C3','P3','O1','F8','T4','T6','Fp2','F4',...
% %     'C4','P4','O2','Fz','Cz','Pz','Oz','A1','A2','FOTO','Annotations';...
% %     1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9,[],[],[],[]};
% 
% Bandas de frequencia:
% 1.Theta (4–7 Hz)*
% 2.Alpha (8-12 Hz)*
% 3.Alpha low (8–10 Hz)
% 4.Alpha upper (10–12 Hz)
% 5.Beta (13–30 Hz)
% 6.Beta low (13 - 18)
% 7.Beta high (18 - 30)
% 8.Gama (30-100 Hz)
% 
% Inst=1:4;
% Test=1:3;
% bb=1:8;
% cc=1:20;
% PSDan1=[];
% for chi=1:length(cc)
%     ch=cc(chi);
%     for ii=1:length(bb)
%         band=bb(ii);
%         ksub=1;
%         for sub=1:size(PSDband,2)
%             if ~isempty(PSDband{sub})
%                 for jj=1:length(Inst)
%                     nInst=Inst(jj);
%                     for mm=1:length(Test)
%                         nTest=Test(mm);
%                         try
% %                         PSDan1{band,ch}{nInst}(ksub,nTest)=PSDband{sub}{nTest,nInst}(band,ch);
% %                         PSDan1{band,ch}(ksub,nTest,nInst)=PSDband{sub}{nTest,nInst}(band,ch);
%                         PSDan1(band,ch,ksub,nTest,nInst)=PSDband{sub}{nTest,nInst}(band,ch);
%                         PSDan1Log(band,ch,ksub,nTest,nInst)=PSDbandLog{sub}{nTest,nInst}(band,ch);
%                         PSDan1Sets(band,ch,ksub,nTest,nInst)=PSDbandSets{sub}{nTest,nInst}(band,ch);
%                         PSDan1LogSets(band,ch,ksub,nTest,nInst)=PSDbandLogSets{sub}{nTest,nInst}(band,ch);
%                         
%                         catch
% %                         PSDan1{band,ch}{nInst}(ksub,nTest)=nan;
% %                         PSDan1{band,ch}(ksub,nTest,nInst)=nan;
%                         PSDan1(band,ch,ksub,nTest,nInst)=nan;
%                         PSDan1Log(band,ch,ksub,nTest,nInst)=nan;
%                         PSDan1Sets(band,ch,ksub,nTest,nInst)=nan;
%                         PSDan1LogSets(band,ch,ksub,nTest,nInst)=nan;
%                         end
%                     end
%                 end
%                 ksub=ksub+1;
%             end
%         end
%     end
% end
% 
% PSDan1Sets=[]; PSDan1LogSets=[];
% cc=1:9;
% for chi=1:length(cc)
%     ch=cc(chi);
%     for ii=1:length(bb)
%         band=bb(ii);
%         ksub=1;
%         for sub=1:size(PSDband,2)
%             if ~isempty(PSDband{sub})
%                 for jj=1:length(Inst)
%                     nInst=Inst(jj);
%                     for mm=1:length(Test)
%                         nTest=Test(mm);
%                         try
%                         PSDan1Sets(band,ch,ksub,nTest,nInst)=PSDbandSets{sub}{nTest,nInst}(band,ch);
%                         PSDan1LogSets(band,ch,ksub,nTest,nInst)=PSDbandLogSets{sub}{nTest,nInst}(band,ch);
%                         
%                         catch
%                         PSDan1Sets(band,ch,ksub,nTest,nInst)=nan;
%                         PSDan1LogSets(band,ch,ksub,nTest,nInst)=nan;
%                         
%                         end
%                     end
%                 end
%                 ksub=ksub+1;
%             end
%         end
%     end
% end




% --------------------------------------------------------------------
function PSDMaps_Callback(hObject, eventdata, handles)
% hObject    handle to PSDMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PSDfile
%%
% Linhas
% Pre 1
% Stroop 2
% PSD relativa
% 
% Colunas
% Control
% Stroop
% Stm

% Bandas de frequencia:
% 1.Theta (4–7 Hz)*
% 2.Alpha (8-12 Hz)*
% 3.Alpha low (8–10 Hz)
% 4.Alpha upper (10–12 Hz)
% 5.Beta (13–30 Hz)
% 6.Beta low (13 - 18)
% 7.Beta high (18 - 30)
% 8.Gama (30-100 Hz)

Log=get(handles.checkLog,'Value');

switch get(handles.MEMapNorm,'Checked')
    case 'off'
        NormMap=false;
    case 'on'
        NormMap=true;
end
if ~Log
    load(PSDfile,'PSDband','Props')
else
    load(PSDfile,'PSDbandLog','Props')
    PSDband=PSDbandLog;
end

Sub = str2num(get(handles.SubEdit,'String'));
if ~isempty(Sub)
    Lsubs=length(Sub);
else
    
    if ~isempty(PSDband{1,1})
        Lsubs=size(PSDband{1,1},3);
        Sub = 1:Lsubs;
    else
        if size(PSDband,1)>=2 & ~isempty(PSDband{2,1})
            Lsubs=size(PSDband{2,1},3);
            Sub = 1:Lsubs;  
        end
    end
end
% if get(handles.SubAverage,'Value')
% % %     load(PSDfile,'PSDbandM','Props')
% % %     clear PSDband
% % %     PSDband=PSDbandM;
% %     Sub=1;
% %     Lsubs=1;
%     Lsubs=size(PSDband{1,1},3);
%     Sub = 1:Lsubs;
% elseif ~isempty(Sub)
%     Lsubs=length(Sub);
% else
%     Lsubs=size(PSDband{1,1},3);
%     Sub = 1:Lsubs;
% end

if get(handles.SubAverage,'Value')
    for nTest=1:size(PSDband,1)
        for nInst=1:size(PSDband,2)
            try
%             PSDband{nTest,nInst}(:,:,Sub)=[];                
            % PSD average across subjects
            PSDbandM{nTest,nInst} = mean(PSDband{nTest,nInst}(:,:,Sub),3);

            catch ME
               stop=1; 
               disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end
        end
    end
    Sub=1;
    Lsubs=1;
    PSDband=PSDbandM;
end

bb(1)=get(handles.B1Theta,'Value');
bb(2)=get(handles.B2Alpha,'Value');
bb(3)=get(handles.B2AlphaL,'Value');
bb(4)=get(handles.B2AlphaH,'Value');
bb(5)=get(handles.B3Beta,'Value');
bb(6)=get(handles.B3BetaL,'Value');
bb(7)=get(handles.B3BetaH,'Value');
bb(8)=get(handles.B4Gama,'Value');
bb(9)=get(handles.Bfull,'Value');
bb(10)=get(handles.RBand1,'Value');
bb(11)=get(handles.RBand2,'Value');
bb(12)=get(handles.RBand3,'Value');

bb=find(bb);

chaninfo=Props.chaninfo;
chanlocs=Props.chanlocs;

Bandtext=Props.Bandtext;
TestLabel=Props.TestLabel;
InstLabel=Props.InstLabel;

Inst=str2num(get(handles.EditInst,'String'));
Test=str2num(get(handles.EditTest,'String'));
Insts=length(Inst);
Tests=length(Test);

switch get(handles.MEMapTrasp,'Checked')
    case 'off'
        AxVert=Tests;
        AxHorz=Insts;
    case 'on'
        AxVert=Insts;
        AxHorz=Tests;
end


%% Plotting Topographical Maps (topoplot from EEGLab)
lim1(max(Test),max(Inst))=NaN;
lim1(:)=NaN;
lim2(max(Test),max(Inst))=NaN;
lim2(:)=NaN;

for ss=1:Lsubs
    sub = Sub(ss);
    for ii=1:length(bb)
        band=bb(ii);
%         if ~isempty(PSDband{sub})
        k=1;
        disp(['Plotting PSD Maps, Subj:',num2str(sub),' ',Bandtext{band}])
        f{sub}=figure;
        for tt=1:Tests
            nTest = (Test(tt));
            for jj=1:Insts
                nInst=Inst(jj);
                subplot(AxVert,AxHorz,k)
                
%                 if nTest==1 & jj==1
%                     title([strcat('Sub',num2str(sub),'_',Bandtext(band)),newline,InstLabel{Inst(jj)}],'Interpreter', 'none'), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold')
%                     title([strcat('Sub',num2str(sub),'_',Bandtext(band),' : ',InstLabel{nInst})],'Interpreter', 'none'), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold')
%                 else
%                     title(['',newline,InstLabel{nInst}]), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold','Interpreter', 'none')
%                 end
%                 title(['',newline,TestLabel{nTest}]), ylabel(InstLabel{Inst(jj)},'Visible','on','FontWeight','bold')
                try
%                     figure(f{sub})
                    topoplot( PSDband{nTest,Inst(jj)}(band,:,sub), chanlocs, 'verbose', ...
                      'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim=caxis; axis tight
%                   topoplot( PSDband{nTest,Inst(jj)}(band,:,sub), chanlocs, 'verbose', ...
%                       'off', 'style' , 'straight','shading','interp', 'chaninfo', chaninfo,'maplimits','maxmin'); lim=caxis; axis tight
                catch ME
                    disp(['Error. Subj: ',num2str(sub),'Itme:',num2str(k),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
                    if strcmp(ME.message(1:18), 'Undefined function')
                        errordlg('Must open EEGLab before!','Error')
                        return
                    end
                end

                lim=caxis;
                lim1(nTest,jj)=lim(1);
                lim2(nTest,jj)=lim(2);
                k=k+1;
                pause(.1)

            end
            
        end
        disp('Absolute magnitude PSD: ')
        disp(num2str(lim1))
%         pause(.1)
        
% Labels
    pause(.1)
    for i=1:Insts
        if i==1
            subplot(AxVert,AxHorz,i)
            if get(handles.SubAverage,'Value')
                title([Bandtext{band},newline,InstLabel{Inst(i)}],'Interpreter', 'none')
            else
                title([strcat('Sub',num2str(sub),'_',Bandtext{band}),newline,InstLabel{Inst(i)}],'Interpreter', 'none')               
            end
        else
            subplot(AxVert,AxHorz,i)
%             title(['',newline,InstLabel{i}])
            title(InstLabel{Inst(i)})
        end
        
    end

    for i=1:Tests
        subplot(AxVert,AxHorz,(i-1)*Insts+1)
        ylabel(TestLabel{Test(i)},'Visible','on','FontWeight','bold')
    end

% For colorbar without normalization
% spl=1;
% for nt=1:Tests
%     for ni=1:Insts
%         subplot(Tests,Insts,spl)    
%         colorbar % Error if after do a normalization
%         spl=spl+1;
%     end
% end

%% Vertical normalization (betwee-instants)
if NormMap
%        Normalization with baseline: (PSDbanda-R)/R*100
        if size(lim1,1)>1
%         figure(f{sub})
        mm=1;
        mlim = min(lim1,[],1);
        Mlim = max(lim2,[],1);
%         Mlim = max(lim2(:));
        for nTest=1:Tests
%             mlim = min(lim1(nTest,:));
%             Mlim = max(lim2(nTest,:));
            
            for jj=1:Insts
                try
                    mlim = min(lim1(:,jj));
                    Mlim = max(lim2(:,jj));
%                     subplot(Tests,Insts,mm), caxis([mlim Mlim])
                    subplot(AxVert,AxHorz,mm), 
                    caxis([mlim Mlim])

%                     subplot(Tests,Insts,mm), caxis([mlim(nTest) Mlim(nTest)]),
%                     subplot(Tests,Insts,mm), caxis([-Mlim Mlim]), 
                catch ME
                    disp(['Error. Subj: ',num2str(sub),ME.stack(1).name,'. Itme:',num2str(mm),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
                end
                mm=mm+1;
% %                 colorbar
%                 colorbar('Location','southoutside')
% %                 pause(0.1)
            end
%             colorbar
        end
        
        
%         % Horizontal normalization (between-tests)
%         mm=1;
%         mlim = min(lim1,[],2);
%         Mlim = max(lim2,[],2);
% 
%         for nTest=1:Tests
% %             mlim = min(lim1(:,nTest));
% %             Mlim = max(lim2(:,nTest));
%             for jj=1:Insts                
%                 try
%                     subplot(Tests,Insts,mm), caxis([mlim(jj) Mlim(jj)]),
%                 catch ME
% %                     disp(['Error. Subj: ',num2str(sub),'. Itme:',num2str(mm),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
%                 end
%                 mm=mm+1;
%             end
%         end
        
        
        end
%         end
end

spl=1;
for nt=1:Tests
    for ni=1:Insts
        subplot(Tests,Insts,spl)    
        colorbar % Error if after do a normalization
        spl=spl+1;
    end
end

    end
end


% --------------------------------------------------------------------
function PSDRelativeMaps_Callback(hObject, eventdata, handles)
% hObject    handle to PSDRelativeMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PSDfile

hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end

Log=get(handles.checkLog,'Value');
rel = 1; % Stroop - baseline;

% if ~Log
%     load(PSDfile,'PSDbandRel','Props')
% else
%     load(PSDfile,'PSDbandLogRel','Props')
%     PSDbandRel=PSDbandLogRel;
% end
if ~Log
    load(PSDfile,'PSDband','Props')
else
    load(PSDfile,'PSDbandLog','Props')
    PSDband=PSDbandLog;
end

Sub = str2num(get(handles.SubEdit,'String'));

%% PSD Relative between two instants
% if get(handles.SubAverage,'Value')
% load(PSDfile,'PSDbandRel')
% BS=1; % Baseline
% Act=2;
% PSDbandRelM={}; PSDbandLogRelM={}; PSDbandSetsRelM={}; PSDbandLogSetsRelM={};
% for sub=1:size(PSDbandRel{1,1}{1},3)
%     
%     for nTest=1:size(PSDbandRel{1,1},2)
%         
%         krel=[1 2]; % Difference between 2 and 1
%         nrel=size(krel,1); % n relatives maps
%         for rel=1:nrel
%             try 
%             if ~isempty(PSDbandRel{nrel}{nTest}(:,:,sub)) || ~isempty(PSDbandRel{nrel}{nTest}(:,:,sub))
%                 
%                 PSDbandRelM{nrel}{nTest}(:,:,sub)=mean(PSDbandRel{nrel}{nTest}(:,:,sub),3);
%                 PSDbandLogRelM{nrel}{nTest}(:,:,sub)=mean(PSDbandLogRel{nrel}{nTest}(:,:,sub),3);
%                 PSDbandSetsRelM{nrel}{nTest}(:,:,sub)=mean(PSDbandSetsRel{nrel}{nTest}(:,:,sub),3);
%                 PSDbandLogSetsRelM{nrel}{nTest}(:,:,sub)=mean(PSDbandLogSetsRel{nrel}{nTest}(:,:,sub),3);
%                 
%             end
%             
%             catch ME
%                 stop=1;
%                 disp('ERROR!!!')
%             end
%         end
%     end
% %     end
% end
% 
% end


%% PSD Relative between two instants
if get(handles.SubAverage,'Value')

% load(PSDfile)

BS=1; % Baseline
Act=2;
PSDbandRel={}; PSDbandLogRel={}; PSDbandSetsRel={}; PSDbandLogSetsRel={};
PSDbandRelM={}; PSDbandLogRelM={}; PSDbandSetsRelM={}; PSDbandLogSetsRelM={};

for sub=1:size(PSDband{1,1},3)
    % b=1:8
%     for EditInst=1:4
    for nTest=1:size(PSDband,1)
            
        krel=[1 2]; % Difference between 2 and 1
        nrel=size(krel,1); % n relatives maps
        for rel=1:nrel
            try 
            if ~isempty(PSDband{nTest,krel(rel,Act)}(:,:,sub)) || ~isempty(PSDband{nTest,krel(rel,BS)}(:,:,sub))
%                 PSDbandRel{nrel}{sub}{nTest}=PSDband{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDband{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandLogRel{nrel}{sub}{nTest}=PSDbandLog{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLog{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandSetsRel{nrel}{sub}{nTest}=PSDbandSets{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandSets{sub}{nTest,krel(rel,BS)}(:,:,sub);
%                 PSDbandLogSetsRel{nrel}{sub}{nTest}=PSDbandLogSets{sub}{nTest,krel(rel,Act)}(:,:,sub)-PSDbandLogSets{sub}{nTest,krel(rel,BS)}(:,:,sub);
                
                PSDbandRel{nrel}{nTest}(:,:,sub)=(PSDband{nTest,krel(rel,Act)}(:,:,sub)-PSDband{nTest,krel(rel,BS)}(:,:,sub))./PSDband{nTest,krel(rel,BS)}(:,:,sub);
                
                PSDbandRelM{nrel}{nTest}(:,:,sub)=mean(PSDbandRel{nrel}{nTest}(:,:,sub),3);
                
            end
            
            catch ME
                stop=1;
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end
        end
    end
%     end
end

end

%%
if get(handles.SubAverage,'Value')
%     load(PSDfile,'PSDbandM','Props')
%     clear PSDband
%     PSDbandRel{rel}=PSDbandRelM;
    Sub=1;
    Lsubs=1;
elseif ~isempty(Sub)
    Lsubs=length(Sub);
else
    Lsubs=size(PSDbandRel{rel}{1,1},3);
    Sub = 1:Lsubs;
end

bb(1)=get(handles.B1Theta,'Value');
bb(2)=get(handles.B2Alpha,'Value');
bb(3)=get(handles.B2AlphaL,'Value');
bb(4)=get(handles.B2AlphaH,'Value');
bb(5)=get(handles.B3Beta,'Value');
bb(6)=get(handles.B3BetaL,'Value');
bb(7)=get(handles.B3BetaH,'Value');
bb(8)=get(handles.B4Gama,'Value');
bb(9)=get(handles.Bfull,'Value');
bb(10)=get(handles.RBand1,'Value');
bb(11)=get(handles.RBand2,'Value');
bb(12)=get(handles.RBand3,'Value');

bb=find(bb);

nrel=length(PSDbandRel);
chanlocs=Props.chanlocs;
chaninfo=Props.chaninfo;

Bandtext=Props.Bandtext;
TestLabel=Props.TestLabel;

% Inst=str2num(get(handles.EditInst,'String'));
Test=str2num(get(handles.EditTest,'String'));
Tests=length(Test);


%%
for ss=1:Lsubs
    sub = Sub(ss);
for rel=1:nrel % Number of relative cases
    try
    disp(['Plotting Relative PSD Maps, Subj:',num2str(sub)])
    figure
    pause(.1)
    k=1;
    % Tests=3;
    lim1= ones(Tests,length(bb))*nan; lim2= ones(Tests,length(bb))*nan;

    for tt=1:Tests
        nTest = (Test(tt));
        for ii=1:length(bb)
            band=bb(ii);

        subplot(Tests,length(bb),k)
        try 
            cla
            topoplot( PSDbandRel{rel}{nTest}(band,:,sub), chanlocs, 'verbose', ...
              'off', 'style' , 'fill', 'chaninfo', chaninfo,'maplimits','maxmin'); axis tight
            lim=caxis;
            lim1(nTest,ii)=lim(1);
            lim2(nTest,ii)=lim(2);
            pause(0.1)
        catch ME
            
            disp(['Error. Subj: ',num2str(sub),ME.stack(1).name,'. Itme:',num2str(k),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
            stop=1;
        end
%         colorbars
        k=k+1;
        end
        
        disp(['Absolute magnitude PSD: ',num2str(lim1(nTest,:))])
    end
    end
    
    % Labels
    pause(.1)
    for i=1:length(bb)
        band=bb(i);
        if i==1
            subplot(Tests,length(bb),i)
            if ~get(handles.SubAverage,'Value')
                title([strcat('Sub',num2str(sub)),newline,Bandtext{band}])
            else
                title(Bandtext{band})
            end
        else
            subplot(Tests,length(bb),i)
            title(Bandtext{band})
        end
        
    end

    for i=1:Tests
        subplot(Tests,length(bb),(i-1)*length(bb)+1),ylabel(TestLabel{i},'Visible','on','FontWeight','bold')
    end
    
    
%% Normalization
norm=0;
if norm==1
% All subplots

% if size(lim1,1)>1
% 
% mm=1;
% %     mlim = min(lim1);
% %     Mlim = max(lim2);
% Mlim = max(lim2(:));
% for nTest=1:Tests
% %             mlim = min(lim1(:,nTest));
% %             Mlim = max(lim2(:,nTest));
%     for ii=1:length(bb)            
%         try
% %                 subplot(Tests,length(bb),mm), caxis([mlim(ii) Mlim(ii)]),
%             subplot(Tests,length(bb),mm), caxis([-Mlim Mlim]),
%         catch ME
% %                     disp(['Error. Subj: ',num2str(sub),'. Itme:',num2str(mm),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
%         end
%         mm=mm+1;
%     end
% end
% 
% end


% Vertical

if size(lim1,1)>1

mm=1;
mlim = min(lim1);
Mlim = max(lim2);

for nTest=1:Tests
%             mlim = min(lim1(:,nTest));
%             Mlim = max(lim2(:,nTest));
    for ii=1:length(bb)            
        try
            subplot(Tests,length(bb),mm), caxis([mlim(ii) Mlim(ii)]),
        catch ME
%                     disp(['Error. Subj: ',num2str(sub),'. Itme:',num2str(mm),'. Line: ',num2str(ME.stack(1).line),':', ME.message])
            disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
        end
        mm=mm+1;
    end
end

end

end

%% For colorbar
for cc=1:Tests*length(bb)
    subplot(Tests,length(bb),cc)
    colorbar
end

end
   
end

% (Optional) Plotting PSD vs channel (all subjects) for each band
if hiddenPlots
for band=1:8
    figure
    for sub=1:10
        for nTest=1:3            
            subplot(3,1,nTest), hold on
            try, plot(PSDbandRel{1}{sub}{nTest}(band,:)), end
        end
    end
end
end



% --------------------------------------------------------------------
function PSDLoad_Callback(hObject, eventdata, handles)
% hObject    handle to PSDLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname PSDfile

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load PSD Analysis File',pathname);

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Canceled!')
   return
end
pathname=pathname2;

PSDfile=fullfile(pathname, filename);
set(handles.editFilename,'String',PSDfile);
disp(['PSD file selected:',PSDfile])

disp('PSD loaded!')
set(handles.endInfo,'String','PSD loaded!')


load(PSDfile)
for ii=1:length(Props.InstLabel)
    InstLabel2{ii} = strcat(num2str(ii),'.',Props.InstLabel{ii});
end
set(handles.popInst,'String',InstLabel2)

for ii=1:length(Props.TestLabel)
    TestLabel2{ii} = strcat(num2str(ii),'.',Props.TestLabel{ii});
end
set(handles.popTest,'String',TestLabel2)


% --- Executes on selection change in popStats.
function popStats_Callback(hObject, eventdata, handles)
% hObject    handle to popStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popStats contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popStats
global pathname PSDfile Statfile

disp('Processing statistics...')
set(handles.endInfo,'String','Processing statistics...')
pause(.01)

PVALUE{1}={};
PVALUE{2}={};
% Inst=1:4;
% Test=1:3;
% bb=1:8; 
% bb=[1 5 6 7 2 3 4 8]; % Last frequencies order

% file='D:\Work1\EEG Analysis\Processamento Carol 10092020\Datasessions\R2_2\PSD\PSD.mat';
Reg=get(handles.checkRegions,'Value');
Log=get(handles.checkLog,'Value');

iPSDType=bin2dec(strcat(num2str(Reg),num2str(Log)));
iPSDType=iPSDType+1;
nPSDType = 4;
for iPSDType=1:nPSDType
    ccAn{iPSDType}=[];
    
switch iPSDType
    case 1
        load(PSDfile,'PSDband','Props')
%         PropsStat.SetCH=Props.SetCH;
%         cc=1:20;
%         ccAn{iPSDType}=[1 4 5 9 12 13];
    case 2
        load(PSDfile,'PSDbandLog','Props')
        PSDband=PSDbandLog;
%         PropsStat.SetCH=Props.SetCH;
%         cc=1:20;
%         ccAn{iPSDType}=[1 4 5 9 12 13];
    case 3
        load(PSDfile,'PSDbandSets','Props')
        PSDband=PSDbandSets;
%         PropsStat.SetsLabel=Props.SetsLabel;
%         cc=1:9;
%         [n1,n2]=size(PSDbandSetsRel{nrel}{sub}{nTest})
    case 4
        load(PSDfile,'PSDbandLogSets','Props')
        PSDband=PSDbandLogSets;
%         PropsStat.SetsLabel=Props.SetsLabel;
%         cc=1:9;
end

Inst=str2num(get(handles.EditInst,'String'));
Test=str2num(get(handles.EditTest,'String'));
% Insts=length(Inst);
% Tests=length(Test);

% EditInst=[1 2];
% EditTest=1:3;
% cc=1:20;

sel=get(handles.popStats,'Value');

switch sel
    
    case 1
        return
%     case 2
%         varstatName='Inst'; % Test variable, Instant fix
%         varstat=Inst;
%         Label=Props.TestLabel(Test);
%         Labeliter=Props.InstLabel(Inst);
%         LabelName='Test';
%     case 3
%         varstatName='Test'; % Instant variable, Test fix
%         varstat=Test;
%         Label=Props.InstLabel(Inst);
%         Labeliter=Props.TestLabel(Test);
%         LabelName='Inst';
    case 2
        varstatIterName='Inst'; % Test variable, Instant fix
        varstatIter=Inst;
        varstatIterLab=Props.InstLabel(Inst);
        varstatName='Test';
        varstat=Test;
        varstatLab=Props.TestLabel(Test);
        
        Props.Inst=Inst;
        Props.Test=Test;
    case 3
        varstatIterName='Test'; % Test variable, Instant fix
        varstatIter=Test;
        varstatIterLab=Props.TestLabel(Test);
        varstatName='Inst';
        varstat=Inst;
        varstatLab=Props.InstLabel(Inst);
        
        Props.Inst=Inst;
        Props.Test=Test;
%         varstatIterName='Test'; % Test variable, Instant fix
%         varstatIter=Test;
%         varstatIterLab=Props.InstLabel(Test);
%         varstatName='Inst';
%         varstat=Inst;
%         varstatLab=Props.TestLabel(Inst);
    case 4
        varstatIterName='Inst'; % Test variable, Instant fix
        varstatIter=Inst;
        varstatIterLab=Props.InstLabel(Inst);
        varstatName='Test';
        varstat=Test;
        varstatLab=Props.TestLabel(Test);
end

%%

% Tests:
% 1. Control / 2. Stroop / 3. Stm
% Instants:
% 1. Pre - 2. stroop - 3. Bike - 4. Pós

% SetCH={'F7','T3','T5','Fp1','F3','C3','P3','O1','F8','T4','T6','Fp2','F4',...
%     'C4','P4','O2','Fz','Cz','Pz','Oz','A1','A2','FOTO','Annotations';...
%     1,3,3,1,1,3,7,7,2,4,4,2,2,4,8,8,5,6,9,9,[],[],[],[]};

% Bandas de frequencia:
% 1.Theta (4–7 Hz)*
% 2.Alpha (8-12 Hz)*
% 3.Alpha low (8–10 Hz)
% 4.Alpha upper (10–12 Hz)
% 5.Beta (13–30 Hz)
% 6.Beta low (13 - 18)
% 7.Beta high (18 - 30)
% 8.Gama (30-100 Hz)

idic=1;
while isempty(PSDband{1,idic})
    idic=idic+1;
end

bb=1:size(PSDband{1,idic},1);
cc=1:size(PSDband{1,idic},2);

LB=size(PSDband{1,idic},1);
LC=size(PSDband{1,idic},2);
LS=size(PSDband{1,idic},3);

Sub = str2num(get(handles.SubEdit,'String'));

if ~isempty(Sub)
    LS=length(Sub);
else
    Sub = 1:LS;
end

PSDan1=[];
for jj=1:length(Inst)
    nInst=Inst(jj);
    for mm=1:length(Test)
        nTest=Test(mm);
        try
            PSDan1(:,:,:,nTest,nInst)=PSDband{nTest,nInst};
%             PSDan1(:,:,:,mm,jj)=PSDband{nTest,nInst};
        catch
            PSDan1(:,:,:,nTest,nInst)=ones(LB,LC,LS)*nan;
%             PSDan1(:,:,:,mm,jj)=ones(LB,LC,LS)*nan;
        end
    end
end

% % Old version
% 
% PSDan1=[];
% for chi=1:length(cc)
%     ch=cc(chi);
%     for ii=1:length(bb)
%         band=bb(ii);
%         ksub=1;
%         for sub=1:size(PSDband,2)
%             if ~isempty(PSDband{sub})
%                 for jj=1:length(Inst)
%                     nInst=Inst(jj);
%                     for mm=1:length(Test)
%                         nTest=Test(mm);
%                         try
%                         PSDan1(band,ch,ksub,nTest,nInst)=PSDband{sub}{nTest,nInst}(band,ch);
%                         
%                         catch
%                         PSDan1(band,ch,ksub,nTest,nInst)=nan;
%                         
%                         end
%                     end
%                 end
%                 ksub=ksub+1;
%             end
%         end
%     end
% end

%%

Bandtext=Props.Bandtext;
TestLabel=Props.TestLabel;
InstLabel=Props.InstLabel;
PSDTypes=Props.PSDTypes;

[nb,nc,ns,nt,ni]=size(PSDan1);

% X=PSDan1{band,ch}{nInst};
% X=squeeze(PSDan1{band,ch}(:,EditTest,nInst));

if isempty(ccAn{iPSDType}) % For sets of channels
    ccAn{iPSDType}=cc;
end

Props.ccAn=ccAn;

if sel > 1 & sel < 4 % Numbers defined by the poplist in the interface (Statistics / One-Way (Test)/.... )
%% Anova One-Way

for chi=1:length(ccAn{iPSDType})
    ch=ccAn{iPSDType}(chi);
    for ii=1:length(bb)
        band=bb(ii);
        for jj=1:length(varstatIter)
%             eval(strcat(varstatIterName,'=',num2str(varstatIter(jj)),';'));
            X=squeeze(PSDan1(band,ch,Sub,Test,varstatIter(jj)));
            % X1=squeeze(PSDan1(band,ch,:,EditTest,nInst));
            % X2=squeeze(PSDan1(band,ch,:,EditTest,2));
            try
                filenameExcel=[InstLabel{eval(strcat(varstatIterName,'(',num2str(jj),')'))}(1:3),PSDTypes{iPSDType}(1:3),Bandtext{bb(band)},'CH',num2str(ch)]; % REVISAR CASO CONTRARIO
                
                [T1,p,flag] = statistics(X,varstatLab,varstatName,0);

%                 [T1,p,flag] = statistics(X,varstatLab,Labeliter0);
                
                PVALUE{1}{iPSDType}(ii,chi,jj) = p(1);
                Flag_Normal{1}{iPSDType}(ii,chi,jj)=flag.flag_normal;
                Flag_Mc{1}{iPSDType}(ii,chi,jj)=flag.flag_Mc;
                T{1}{iPSDType}(ii,chi,jj)=T1;

%                 statsDispTables(T1,flag.flag_normal);
%                 statsTablesExcel(T1,filenameExcel,flag.flag_normal);

            catch ME
                stop=1;
                disp(['Error: ',filenameExcel])
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end

        end
    end
end

else
%% Anova Two-Way
stop=0;
for chi=1:length(ccAn{iPSDType})
    ch=ccAn{iPSDType}(chi);
    d1=0;
    for ii=1:length(bb)
        band=bb(ii);
        X2=[];
        for jj=1:length(varstatIter)
%             eval(strcat(varstatIterName,'=',num2str(varstatIter(jj)),';'));
            X2=[X2 squeeze(PSDan1(band,ch,Sub,Test,varstatIter(jj)))];
        end
            % X1=squeeze(PSDan1(band,ch,:,EditTest,nInst));
            % X2=squeeze(PSDan1(band,ch,:,EditTest,2));
            try
                filenameExcel=[InstLabel{eval(strcat(varstatIterName,'(',num2str(jj),')'))}(1:3),PSDTypes{iPSDType}(1:3),Bandtext{bb(band)},'CH',num2str(ch)]; % REVISAR CASO CONTRARIO
                
                [T1,p,flag] = statistics2(X2,varstatLab,varstatName,varstatIterLab,varstatIterName,0);
%                 try, [d1,d2]=size(PVALUE{iPSDType}(:,ch)); catch d1=0; end
                PVALUE{2}{iPSDType}(d1+1:d1+3,ch) = p(3:2:4*2)'; d1=d1+3;
                Flag_Normal{2}{iPSDType}(ii,ch) = flag.flag_normal;
                Flag_Mc{2}{iPSDType}(ii,ch) = flag.flag_Mc;
                T{2}{iPSDType}(ii,ch)=T1;
                Name{2}{iPSDType}{ii,ch} = filenameExcel;
%                 statsDispTables(T1,flag.flag_normal);
                
%                 statsTablesExcel(T1,filenameExcel,flag.flag_normal);
                
            catch ME
                stop=stop+1;
                disp(['Error: ',filenameExcel])
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end

        
    end
end


end

end

% [filename, pathname2] = uiputfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Save project',...
%     fullfile(pathname,'Stats'));
% 
% if isequal(filename,0)
%    disp('Selection canceled')
%    return
% else
%     pathname=pathname2;
% end
% 
% Statfile=fullfile(pathname,filename);

Statfile=fullfile(pathname,'Stats.mat');

save(Statfile,'PVALUE','Flag_Normal','Flag_Mc','T','Props','PSDan1')
disp('Statistics Saved')

disp('Done!')
set(handles.endInfo,'String','Done!')

% [filename, pathname2] = uiputfile( ...
%     {'*.xlsx','Excel Files (*.xlsx)';
%     '*.*',  'All files (*.*)'}, ...
%     'Save project',...
%     fullfile(pathname,'Estatistica.xlsx'));
% 
% if isequal(filename,0)
%    disp('Selection canceled')
%    return
% else
%     pathname=pathname2;
% end
% 
% filenameExcel2=fullfile(pathname,filename);


% --------------------------------------------------------------------
function StatExportStats_Callback(hObject, eventdata, handles)
% hObject    handle to StatExportStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Statfile pathname

disp('Exporting statistics...')
set(handles.endInfo,'String','Exporting statistics...')
pause(0.1)
load(Statfile)

filenameExcel2=fullfile(pathname,'Estatistica.xlsx');
% filenameExcel2='Estatistica.xlsx';
symbols = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

% ccAn = Props.ccAn;
ccAn = str2num(get(handles.ccAn,'String'));
ccAnGr = str2num(get(handles.ccAnGr,'String'));

%% Anova One-Way
% if sel > 1 & sel < 4 
if ~isempty(PVALUE{1})

d=1;
nband=size(PVALUE{1},2);
for ii=1:nband

[nbands,nch,ninst]=size(PVALUE{1}{ii});

for jj=1:ninst % Instants 
    insti=Props.Inst(jj);
% xlRange = strcat(symbols(2),num2str(d)); % B2
% xlswrite(filenameExcel2,{Props.InstLabel{1}},'Results_Anova1',xlRange)
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,{Props.InstLabel{2}},'Results_Anova1',xlRange)

% xlRange = strcat(symbols( 2*jj+nch*(jj-1) ), num2str(d));
xlRange = strcat(ExcelCell(2*jj+nch*(jj-1)), num2str(d));
xlswrite(filenameExcel2,{Props.InstLabel{insti}}, 'Results_Anova1',xlRange)
end

xlRange = strcat(symbols(1),num2str(d)); % A2
xlswrite(filenameExcel2,{Props.PSDTypes{ii}},'Results_Anova1',xlRange) % PSD Type

d=d+1;
% if ii<3
% xlRange = strcat(symbols(2),num2str(d)); % B2
% xlswrite(filenameExcel2,Props.SetCH(1,ccAn),'Results_Anova1',xlRange) % CH Label
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,Props.SetCH(1,ccAn),'Results_Anova1',xlRange) % CH Label
% else
% xlRange = strcat(symbols(2),num2str(d)); % B2
% xlswrite(filenameExcel2,Props.SetsLabel(1,ccAnGr),'Results_Anova1',xlRange) % CH Label
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,Props.SetsLabel(1,ccAnGr),'Results_Anova1',xlRange) % CH Label
% end
for jj=1:ninst % Instants 
    
if ii<3
if isempty(ccAn), ccAn=1:nch; end
% xlRange = strcat(symbols( 2*jj+nch*(jj-1) ),num2str(d));
xlRange = strcat(ExcelCell(2*jj+nch*(jj-1)), num2str(d));

xlswrite(filenameExcel2,Props.SetCH(1,ccAn),'Results_Anova1',xlRange) % CH Label
else
if isempty(ccAnGr), ccAnGr=1:nch; end
% xlRange = strcat(symbols( 2*jj+nch*(jj-1) ),num2str(d));
xlRange = strcat(ExcelCell(2*jj+nch*(jj-1)), num2str(d));

xlswrite(filenameExcel2,Props.SetsLabel(1,ccAnGr),'Results_Anova1',xlRange) % CH Label
end
end

d=d+1;

% xlRange = strcat(symbols(2),num2str(d)); % B3
% xlswrite(filenameExcel2,PVALUE{1}{ii}(:,:,1),'Results_Anova1',xlRange) % Data
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,PVALUE{1}{ii}(:,:,2),'Results_Anova1',xlRange) % Data
% 
% xlRange = strcat(symbols(1),num2str(d)); % A3
% xlswrite(filenameExcel2,Props.Bandtext','Results_Anova1',xlRange) % Band Label
% xlRange = strcat(symbols( nch+3 ),num2str(d));
% xlswrite(filenameExcel2,Props.Bandtext','Results_Anova1',xlRange) % Band Label

for jj=1:ninst % Instants 
    ninst=Props.Inst(jj);
% xlRange = strcat(symbols( 2*jj+nch*(jj-1) ),num2str(d));
xlRange = strcat(ExcelCell(2*jj+nch*(jj-1)), num2str(d));

xlswrite(filenameExcel2,PVALUE{1}{ii}(:,:,jj),'Results_Anova1',xlRange) % Data

% xlRange = strcat(symbols( 2*jj+nch*(jj-1)-1 ),num2str(d)); % A3
xlRange = strcat(ExcelCell(2*jj+nch*(jj-1)-1), num2str(d));

xlswrite(filenameExcel2,Props.Bandtext','Results_Anova1',xlRange) % Band Label
end

d=d+nbands+4;

end

end

%% Anova Two-Way
if ~isempty(PVALUE{2})  

d=1;
nband=size(PVALUE{2},2);
for ii=1:nband

[nbands,nch,ninst]=size(PVALUE{2}{ii});

xlRange = strcat(symbols(1),num2str(d)); % A2
xlswrite(filenameExcel2,{Props.PSDTypes{ii}},'Results_Anova2',xlRange) % PSD Type

d=d+1;
if ii<3
if isempty(ccAn), ccAn=1:nch; end
xlRange = strcat(symbols(2),num2str(d)); % B2
xlswrite(filenameExcel2,Props.SetCH(1,ccAn),'Results_Anova2',xlRange) % CH Label
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,Props.SetCH(1,ccAn{ii}),'Results_Anova2',xlRange) % CH Label
else
if isempty(ccAnGr), ccAnGr=1:nch; end
xlRange = strcat(symbols(2),num2str(d)); % B2
xlswrite(filenameExcel2,Props.SetsLabel(1,ccAnGr),'Results_Anova2',xlRange) % CH Label
% xlRange = strcat(symbols( nch+4 ),num2str(d));
% xlswrite(filenameExcel2,Props.SetsLabel(1,ccAn{ii}),'Results_Anova2',xlRange) % CH Label
end

d=d+1;
xlRange = strcat(symbols(2),num2str(d)); % B3
xlswrite(filenameExcel2,PVALUE{2}{ii}(:,:,1),'Results_Anova2',xlRange) % Data

for jj=1:length(Props.Bandtext)
xlRange = strcat(symbols(1),num2str(d+(jj-1)*3)); % A2
xlswrite(filenameExcel2,{Props.Bandtext{jj}},'Results_Anova2',xlRange) % Band Label
end

d=d+nbands+4;

end

end

disp('Done!')
set(handles.endInfo,'String','Done!')


% --------------------------------------------------------------------
function StatExportStats2_Callback(hObject, eventdata, handles)
% hObject    handle to StatExportStats2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Statfile pathname

disp('Exporting statistics...')
set(handles.endInfo,'String','Exporting statistics...')
pause(0.1)
load(Statfile)

filenameExcel2=fullfile(pathname,'Estatistica2.xlsx');

% ccAn = Props.ccAn;
ccAn = str2num(get(handles.ccAn,'String'));
ccAnGr = str2num(get(handles.ccAnGr,'String'));

%% Anova One-Way / REVISAR TWO-WAY
% if sel > 1 & sel < 4 
for anX=1:2
    
if ~isempty(PVALUE{anX})

d=1;
nPSDType=size(T{anX},2);
for iType=1:nPSDType

[nbb,nch,ninst]=size(PVALUE{anX}{iType});
nbb=nbb/3;

for inst=1:ninst % Instants 
    Cell = ExcelCell(2*inst+(nch+1)*(inst-1));
    xlRange = strcat(Cell, num2str(d));
    xlswrite(filenameExcel2,{Props.InstLabel{inst}}, 'R2_Anova1',xlRange)
end

Cell = ExcelCell(1);
xlRange = strcat(Cell,num2str(d)); % A2
xlswrite(filenameExcel2,{Props.PSDTypes{iType}},'R2_Anova1',xlRange) % PSD Type

d=d+1;

for inst=1:ninst % Instants 
    Cell = ExcelCell(2*inst+(nch+1)*(inst-1)+1);    
    if iType<3
        if isempty(ccAn), ccAn=1:nch; end
        xlRange = strcat(Cell,num2str(d));
        xlswrite(filenameExcel2,Props.SetCH(1,ccAn),'R2_Anova1',xlRange) % CH Label
    else
        if isempty(ccAnGr), ccAnGr=1:nch; end
        xlRange = strcat(Cell,num2str(d));
        xlswrite(filenameExcel2,Props.SetsLabel(1,ccAnGr),'R2_Anova1',xlRange) % CH Label
    end
end

d=d+1;
dt=d;

EN2 = cell(nbb*3,nch);
[EN2{:}]=deal('N'); % Matriz with empty values (N)

for inst=1:ninst % Instants 
    d=dt;

    Cell = ExcelCell(2*inst+(nch+1)*(inst-1)+1);
    xlRange = strcat(Cell,num2str(d));
    xlswrite(filenameExcel2,EN2,'R2_Anova1',xlRange) % Empty matrix

    clear Bandtext
    Bcase={};
    for iband=1:nbb%/3  %OJO ADICIONÉ 1/3
        Bandtext{(iband-1)*3+1,1} = Props.Bandtext{iband};
        Bcase = [Bcase; {'1x2';'1x3';'2x3'}];        % Cases for multcompare
    end
    Cell = ExcelCell(2*inst+(nch+1)*(inst-1)-1);
    xlRange = strcat(Cell,num2str(d)); % A3
    xlswrite(filenameExcel2,Bandtext,'R2_Anova1',xlRange) % Band Labels

    Cell = ExcelCell(2*inst+(nch+1)*(inst-1));
    xlRange = strcat(Cell,num2str(d)); % A3
    xlswrite(filenameExcel2,Bcase,'R2_Anova1',xlRange) % Case Labels

    for iband=1:nbb
        for chi=1:nch
            Cell = ExcelCell(2*inst+(nch+1)*(inst-1)+(chi-1)+1);
            xlRange = strcat(Cell,num2str(d));
            if PVALUE{anX}{iType}(iband,chi,inst)<=0.05 % IF P<0.05
            if Flag_Normal{anX}{iType}(iband,chi,inst)
                xlswrite(filenameExcel2,table2cell(T{anX}{iType}(iband,chi,inst).tblMultC{1}([1 2 4],5)),'R2_Anova1',xlRange) % Data when normal
            else
                xlswrite(filenameExcel2,table2cell(T{anX}{iType}(iband,chi,inst).tblMultC{1}(:,6)),'R2_Anova1',xlRange) % Data when non-normal
            end
            end
        end
        d = d+3;
    end

end

d=d+4;

end

end

end


disp('Done!')
set(handles.endInfo,'String','Done!')


% --- Executes during object creation, after setting all properties.
function popStats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StatDetails.
function StatDetails_Callback(hObject, eventdata, handles)
% hObject    handle to StatDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EEGv Statfile

Bandtext={'Theta','Alpha','Alpha Low','Alpha High','Beta','Beta Low','Beta High','Gama'};
% TestLabel={'Control','STRP','ST'};
% InstLabel={'Pre','Stroop','Bike','Pos'};
TestLabel={'V3','V4','V5','V1'};
InstLabeltmp={'Pre','Perf','None','Pos'};
PSDTypes={'Normal','Log','Regions','Log_Regions'};

anX=1;

% ch=[1 4 5 9 12 13];
% set(handles.popupCh,'String',EEGv.Props.SetCH(1,ch));
% ch=(get(handles.popupCh,'Value'));

Inst=str2num(get(handles.EditInst,'String'));
Test=str2num(get(handles.EditTest,'String'));

bb(1)=get(handles.B1Theta,'Value');
bb(2)=get(handles.B2Alpha,'Value');
bb(3)=get(handles.B2AlphaL,'Value');
bb(4)=get(handles.B2AlphaH,'Value');
bb(5)=get(handles.B3Beta,'Value');
bb(6)=get(handles.B3BetaL,'Value');
bb(7)=get(handles.B3BetaH,'Value');
bb(8)=get(handles.B4Gama,'Value');
bb(9)=get(handles.Bfull,'Value');
bb(10)=get(handles.RBand1,'Value');
bb(11)=get(handles.RBand2,'Value');
bb(12)=get(handles.RBand3,'Value');
% bb(9:12)=1; % Additional ratio bands

bb=find(bb);

Reg=get(handles.checkRegions,'Value');
Log=get(handles.checkLog,'Value');
iPSDType=bin2dec(strcat(num2str(Reg),num2str(Log)));
iPSDType=iPSDType+1;

if iPSDType <= 2
    ch = str2num(get(handles.ccAn,'String'));
else
    ch = str2num(get(handles.ccAnGr,'String'));
end
if isempty(ch)
    warndlg('Please add a channel!','Warning')
    return; 
end

load(Statfile,'Flag_Normal','T')

T1=T{anX}{iPSDType}(bb(1),ch(1),Inst(1));
flag_normal=Flag_Normal{anX}{iPSDType}(bb(1),ch(1),Inst(1));
% filenameExcel=[InstLabel{Inst(1)}(1:3),PSDTypes{iPSDType}(1:3),Bandtext{bb(1)},'CH',num2str(ch)];
% 
% DescriptiveTab=T1.DescriptiveTab;
% tblX=T1.tblX;
% tblSW=T1.tblSW;
% tblMc=T1.tblMc;
% tblEps=T1.tblEps;
% ranovatbl=T1.ranovatbl;
% % tblAnn=T1.tblAnn;
% tblMultC=T1.tblMultC;   
% tblKW=T1.tblKW;
statsDispTables(T1,flag_normal);
% statsTablesExcel(T1,filenameExcel,flag_normal);


function statsDispTables(T1,flag_normal)

disp('Data from tests......................................................')
disp(T1.tblX)
disp('Descriptive statistic................................................')
disp(T1.DescriptiveTab)
disp('Shapiro-Wilk.........................................................')
disp(T1.tblSW)

if flag_normal
    disp('Normality assumed')
    disp('Test de Mauchly..................................................')
    disp(T1.tblMc)
    if T1.tblMc.pValue<0.05, disp('Greenhouse-Geisser'), end
    disp('Epsilon..........................................................')
    disp(T1.tblEps)
    disp('Repeated measures analysis of variance...........................')
    disp(T1.ranovatbl)
%         disp('Repeated measures analysis of variance: Expanded details')
%         disp(T1.tblAnn)
    disp('Multiple comparison between-groups...............................')
    disp(T1.tblMultC)

else
    disp('Kruskal-Wallis...................................................')
    disp(T1.tblKW)
    disp('Multiple comparison between-groups...............................')
    for jj=1:length((T1.tblMultC))
        disp(T1.tblMultC{jj})
    end

end


% --------------------------------------------------------------------
function StatExportTables_Callback(hObject, eventdata, handles)
% hObject    handle to StatExportTables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Statfile pathname

disp('Exporting Tables...')
set(handles.endInfo,'String','Exporting statistics...')
pause(0.1)
load(Statfile)

filenameExcel2=fullfile(pathname,'Estatistica.xlsx');
   
Bandtext=Props.Bandtext;
TestLabel=Props.TestLabel;
InstLabel=Props.InstLabel;
PSDTypes=Props.PSDTypes;

% X=PSDan1{band,ch}{nInst};
% X=squeeze(PSDan1{band,ch}(:,EditTest,nInst));

% nTypes=size(PVALUE{1},2); % Combination of regions and log
% ccAn = str2num(get(handles.ccAn,'String'));
% ccAnGr = str2num(get(handles.ccAnGr,'String'));

bb(1)=get(handles.B1Theta,'Value');
bb(2)=get(handles.B2Alpha,'Value');
bb(3)=get(handles.B2AlphaL,'Value');
bb(4)=get(handles.B2AlphaH,'Value');
bb(5)=get(handles.B3Beta,'Value');
bb(6)=get(handles.B3BetaL,'Value');
bb(7)=get(handles.B3BetaH,'Value');
bb(8)=get(handles.B4Gama,'Value');
bb(9)=get(handles.Bfull,'Value');
bb(10)=get(handles.RBand1,'Value');
bb(11)=get(handles.RBand2,'Value');
bb(12)=get(handles.RBand3,'Value');
% bb(9:12)=1; % Additional ratio bands

bb=find(bb);

Reg=get(handles.checkRegions,'Value');
Log=get(handles.checkLog,'Value');
iType=bin2dec(strcat(num2str(Reg),num2str(Log)));
iType=iType+1;

if iType <= 2
    ccAn = str2num(get(handles.ccAn,'String'));
else
    ccAn = str2num(get(handles.ccAnGr,'String'));
end

Inst=str2num(get(handles.EditInst,'String'));

%% Anova One-Way / Two-Way
anov=[];
if ~isempty(PVALUE{1})
    anov=[anov 1];
end
if ~isempty(PVALUE{2})
    anov=[anov 2];
end
for ani=1:length(anov)
    anX=anov(ani);
    
[nbands,nch,ninst]=size(PVALUE{anX}{iType});


if isempty(ccAn), ccAn=1:nch; end

for chi=1:length(ccAn)
    ch = ccAn(chi);
    for ii=1:length(bb)
        band=bb(ii);
        for jj=1:length(Inst)
            inst=Inst(jj);
            try
                filenameExcel=[InstLabel{inst}(1:3),...
                    PSDTypes{iType}(1:3),Bandtext{band},'CH',num2str(ch)]; 
                
                flag.flag_normal = Flag_Normal{anX}{iType}(band,ch,inst);
                T1 = T{anX}{iType}(band,ch,inst);

                statsTablesExcel(T1,filenameExcel,flag.flag_normal);
                
            catch ME
                stop=1;
                disp(['ERROR IN TABLES TO EXCEL!!: ',filenameExcel])
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end

        end
    end
end

end

disp('Done!')
set(handles.endInfo,'String','Done!')


function StatExportFullTables(handles)
global Statfile pathname

disp('Exporting statistics...')
set(handles.endInfo,'String','Exporting statistics...')
pause(0.1)
load(Statfile)

filenameExcel2=fullfile(pathname,'Estatistica.xlsx');
   
Bandtext=Props.Bandtext;
TestLabel=Props.TestLabel;
InstLabel=Props.InstLabel;
PSDTypes=Props.PSDTypes;

% X=PSDan1{band,ch}{nInst};
% X=squeeze(PSDan1{band,ch}(:,EditTest,nInst));

nTypes=size(PVALUE{1},2); % Combination of regions and log
ccAn = str2num(get(handles.ccAn,'String'));
ccAnGr = str2num(get(handles.ccAnGr,'String'));

bb(1)=get(handles.B1Theta,'Value');
bb(2)=get(handles.B2Alpha,'Value');
bb(3)=get(handles.B2AlphaL,'Value');
bb(4)=get(handles.B2AlphaH,'Value');
bb(5)=get(handles.B3Beta,'Value');
bb(6)=get(handles.B3BetaL,'Value');
bb(7)=get(handles.B3BetaH,'Value');
bb(8)=get(handles.B4Gama,'Value');
bb(9)=get(handles.Bfull,'Value');
bb(10)=get(handles.RBand1,'Value');
bb(11)=get(handles.RBand2,'Value');
bb(12)=get(handles.RBand3,'Value');
% bb(9:12)=1; % Additional ratio bands

bb=find(bb);
%% Anova One-Way / Two-Way
for anX=1:2
    
for iType=1:nTypes
if ~isempty(PVALUE{anX})

[nbands,nch,ninst]=size(PVALUE{anX}{iType});
if isempty(ccAn), ccAn=1:nch; end

for chi=1:length(ccAn)
    ch=ccAn(chi);
    for ii=1:length(bb)
        band=bb(ii);
        for jj=1:ninst
            inst=ninst(jj);
            try
                filenameExcel=[InstLabel{inst}(1:3)...
                    ,PSDTypes{iType}(1:3),Bandtext{band},'CH',num2str(ch)]; 
                
                flag.flag_normal = Flag_Normal{anX}{iType}(band,ch,inst);
                T1 = T{anX}{iType}(band,ch,inst);
                
                statsTablesExcel(T1,filenameExcel,flag.flag_normal);

            catch ME
                stop=1;
                disp(['ERROR IN TABLES TO EXCEL!!: ',filenameExcel])
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end

        end
    end
end

end
end

end

disp('Done!')
set(handles.endInfo,'String','Done!')


function statsTablesExcel(T1,tabName,flag_normal)
%% Export tables to Excel
global pathname
filenameExcel=fullfile(pathname,'Tables.xlsx');

xlRange = 'A1'; d=0;
xlswrite(filenameExcel,{'Data'},tabName,xlRange)
% xlRange = 'B3';
% xlswrite('Tables',T1.tblX.Properties.RowNames,tabName,xlRange)
xlRange = 'B3';
xlswrite(filenameExcel,table2cell(T1.tblX(:,1)),tabName,xlRange)
xlRange = 'B2';
xlswrite(filenameExcel,{T1.tblX.Properties.VariableNames{1}},tabName,xlRange)
xlRange = 'C3';
xlswrite(filenameExcel,T1.X,tabName,xlRange)
xlRange = 'C2';
xlswrite(filenameExcel,T1.DescriptiveTab.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblX),1); d=dl+3;

xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Descriptive statistic'},tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,T1.DescriptiveTab.Properties.RowNames,tabName,xlRange)
xlRange = strcat('C',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.DescriptiveTab),tabName,xlRange)
xlRange = strcat('C',num2str(d+2));
xlswrite(filenameExcel,T1.DescriptiveTab.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.DescriptiveTab),1); d=d+dl+3;

% d=14; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Shapiro-Wilk'},tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,T1.tblSW.Properties.RowNames,tabName,xlRange)
xlRange = strcat('C',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.tblSW),tabName,xlRange)
xlRange = strcat('C',num2str(d+2));
xlswrite(filenameExcel,T1.tblSW.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblSW),1); d=d+dl+3;

if flag_normal

% d=14;
xlRange = strcat('H',num2str(d+1));
xlswrite(filenameExcel,{'Normality assumed'},tabName,xlRange)

% d=20; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Test de Mauchly'},tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.tblMc),tabName,xlRange)
xlRange = strcat('B',num2str(d+2));
xlswrite(filenameExcel,T1.tblMc.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblMc),1); d=d+dl+3;

if T1.tblMc.pValue<0.05
% d=20;
xlRange = strcat('H',num2str(d+1));
xlswrite(filenameExcel,{'Greenhouse-Geisser'},tabName,xlRange) 
end

% d=24; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Epsilon'},tabName,xlRange)
% xlRange = strcat('B',num2str(d+3));
% xlswrite(filenameExcel,T1.tblEps.Properties.RowNames,tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.tblEps),tabName,xlRange)
xlRange = strcat('B',num2str(d+2));
xlswrite(filenameExcel,T1.tblEps.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblEps),1); d=d+dl+3;

% d=28; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Repeated measures analysis of variance'},tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,T1.ranovatbl.Properties.RowNames,tabName,xlRange)
xlRange = strcat('C',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.ranovatbl),tabName,xlRange)
xlRange = strcat('C',num2str(d+2));
xlswrite(filenameExcel,T1.ranovatbl.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.ranovatbl),1); d=d+dl+3;

else
    
% d=20; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Kruskal-Wallis'},tabName,xlRange)
% xlRange = strcat('B',num2str(d+3));
% xlswrite(filenameExcel,T1.tblKW.Properties.RowNames,tabName,xlRange)
xlRange = strcat('C',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.tblKW),tabName,xlRange)
xlRange = strcat('C',num2str(d+2));
xlswrite(filenameExcel,T1.tblKW.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblKW),1); d=d+dl+3;

end

for jj=1:length(T1.tblMultC)
    
% d=33; 
xlRange = strcat('A',num2str(d+1));
xlswrite(filenameExcel,{'Multiple comparison between-groups'},tabName,xlRange)
% xlRange = strcat('B',num2str(d+3));
% xlswrite(filenameExcel,T1.tblMultC.Properties.RowNames,tabName,xlRange)
xlRange = strcat('B',num2str(d+3));
xlswrite(filenameExcel,table2cell(T1.tblMultC{jj}),tabName,xlRange)
xlRange = strcat('B',num2str(d+2));
xlswrite(filenameExcel,T1.tblMultC{jj}.Properties.VariableNames,tabName,xlRange)
dl=size(table2cell(T1.tblMultC{jj}),1); d=d+dl+3;

end

% d=33; dl=size(table2cell(T1.tblMultC{1}),1); d=d+dl+3;
% xlRange = strcat('A',num2str(d+1));
% xlswrite(filenameExcel,{'Multiple comparison between-groups'},tabName,xlRange)
% % xlRange = strcat('B',num2str(d+3));
% % xlswrite(filenameExcel,T1.tblMultC.Properties.RowNames,tabName,xlRange)
% xlRange = strcat('B',num2str(d+3));
% xlswrite(filenameExcel,table2cell(T1.tblMultC{1}),tabName,xlRange)
% xlRange = strcat('B',num2str(d+2));
% xlswrite(filenameExcel,T1.tblMultC{1}.Properties.VariableNames,tabName,xlRange)
% % [PVALUE(:,:,1) PVALUE(:,:,2)]


% --------------------------------------------------------------------
function StatsLoad_Callback(hObject, eventdata, handles)
% hObject    handle to StatsLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Statfile

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load Stat File',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Statfile=fullfile(pathname, filename);
set(handles.editFilename,'String',Statfile);
disp(['Stats file selected:',Statfile])

load(Statfile)
for ii=1:length(Props.InstLabel)
    InstLabel2{ii} = strcat(num2str(ii),'.',Props.InstLabel{ii});
end
set(handles.popInst,'String',InstLabel2)

for ii=1:length(Props.TestLabel)
    TestLabel2{ii} = strcat(num2str(ii),'.',Props.TestLabel{ii});
end
set(handles.popTest,'String',TestLabel2)
disp('Stats Loaded!')


% --- Executes on button press in B1Theta.
function B1Theta_Callback(hObject, eventdata, handles)
% hObject    handle to B1Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B1Theta


% --- Executes on button press in B2Alpha.
function B2Alpha_Callback(hObject, eventdata, handles)
% hObject    handle to B2Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B2Alpha


% --- Executes on button press in B2AlphaL.
function B2AlphaL_Callback(hObject, eventdata, handles)
% hObject    handle to B2AlphaL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B2AlphaL


% --- Executes on button press in B2AlphaH.
function B2AlphaH_Callback(hObject, eventdata, handles)
% hObject    handle to B2AlphaH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B2AlphaH


% --- Executes on button press in B3Beta.
function B3Beta_Callback(hObject, eventdata, handles)
% hObject    handle to B3Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B3Beta


% --- Executes on button press in B3BetaL.
function B3BetaL_Callback(hObject, eventdata, handles)
% hObject    handle to B3BetaL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B3BetaL


% --- Executes on button press in B4Gama.
function B4Gama_Callback(hObject, eventdata, handles)
% hObject    handle to B4Gama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B4Gama


% --- Executes on button press in B3BetaH.
function B3BetaH_Callback(hObject, eventdata, handles)
% hObject    handle to B3BetaH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of B3BetaH


% --- Executes on selection change in popInst.
function popInst_Callback(hObject, eventdata, handles)
% hObject    handle to popInst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popInst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popInst


% --- Executes during object creation, after setting all properties.
function popInst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popInst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popTest.
function popTest_Callback(hObject, eventdata, handles)
% hObject    handle to popTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTest


% --- Executes during object creation, after setting all properties.
function popTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditTest_Callback(hObject, eventdata, handles)
% hObject    handle to EditTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTest as text
%        str2double(get(hObject,'String')) returns contents of EditTest as a double


% --- Executes during object creation, after setting all properties.
function EditTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditInst_Callback(hObject, eventdata, handles)
% hObject    handle to EditInst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditInst as text
%        str2double(get(hObject,'String')) returns contents of EditInst as a double


% --- Executes during object creation, after setting all properties.
function EditInst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditInst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkLog.
function checkLog_Callback(hObject, eventdata, handles)
% hObject    handle to checkLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkLog


% --- Executes on button press in checkRegions.
function checkRegions_Callback(hObject, eventdata, handles)
% hObject    handle to checkRegions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkRegions
global EEGv Statfile

try
load (Statfile,'Props')
if get(hObject,'Value')
    set(handles.popupCh,'String',Props.SetsLabel);
else
    ch=[1 4 5 9 12 13];
    set(handles.popupCh,'String',Props.SetCH(1,ch));
end

end


function ICAch_Callback(hObject, eventdata, handles)
% hObject    handle to ICAch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ICAch as text
%        str2double(get(hObject,'String')) returns contents of ICAch as a double


% --- Executes during object creation, after setting all properties.
function ICAch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICAch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 
% % --- Executes on selection change in popupmenu19.
% function popupmenu19_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu19 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --------------------------------------------------------------------
function MEUpdateInt_Callback(hObject, eventdata, handles)
% hObject    handle to MEUpdateInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateInterface (handles)


function ccAn_Callback(hObject, eventdata, handles)
% hObject    handle to ccAn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ccAn as text
%        str2double(get(hObject,'String')) returns contents of ccAn as a double


% --- Executes during object creation, after setting all properties.
function ccAn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ccAn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccAnGr_Callback(hObject, eventdata, handles)
% hObject    handle to ccAnGr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ccAnGr as text
%        str2double(get(hObject,'String')) returns contents of ccAnGr as a double


% --- Executes during object creation, after setting all properties.
function ccAnGr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ccAnGr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RBand1.
function RBand1_Callback(hObject, eventdata, handles)
% hObject    handle to RBand1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RBand1


% --- Executes on button press in RBand2.
function RBand2_Callback(hObject, eventdata, handles)
% hObject    handle to RBand2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RBand2


% --- Executes on button press in RBand3.
function RBand3_Callback(hObject, eventdata, handles)
% hObject    handle to RBand3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RBand3


% --- Executes on button press in radiobuttonAll.
function radiobuttonAll_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonAll
if get(handles.radiobuttonAll,'Value')
    set(handles.radiobuttonNone,'Value',0)
    set(handles.B1Theta,'Value',1);
    set(handles.B2Alpha,'Value',1);
    set(handles.B2AlphaL,'Value',1);
    set(handles.B2AlphaH,'Value',1);
    set(handles.B3Beta,'Value',1);
    set(handles.B3BetaL,'Value',1);
    set(handles.B3BetaH,'Value',1);
    set(handles.B4Gama,'Value',1);
    set(handles.Bfull,'Value',1);
    set(handles.RBand1,'Value',1);
    set(handles.RBand2,'Value',1);
    set(handles.RBand3,'Value',1);
else
%     set(handles.radiobuttonNone,'Value',1)
end

% --- Executes on button press in radiobuttonNone.
function radiobuttonNone_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonNone
if get(handles.radiobuttonNone,'Value')
    set(handles.radiobuttonAll,'Value',0)
    set(handles.B1Theta,'Value',0);
    set(handles.B2Alpha,'Value',0);
    set(handles.B2AlphaL,'Value',0);
    set(handles.B2AlphaH,'Value',0);
    set(handles.B3Beta,'Value',0);
    set(handles.B3BetaL,'Value',0);
    set(handles.B3BetaH,'Value',0);
    set(handles.B4Gama,'Value',0);
    set(handles.Bfull,'Value',0);
    set(handles.RBand1,'Value',0);
    set(handles.RBand2,'Value',0);
    set(handles.RBand3,'Value',0);
else
%     set(handles.radiobuttonNone,'Value',1)
end


% --------------------------------------------------------------------
function MEICAEyes_Callback(hObject, eventdata, handles)
% hObject    handle to MEICAEyes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.MEICAEyes,'Checked'),'on')
    set(handles.MEICAEyes,'Checked','off')
else
    set(handles.MEICAEyes,'Checked','on')
end


% --- Executes on button press in Bfull.
function Bfull_Callback(hObject, eventdata, handles)
% hObject    handle to Bfull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Bfull


function SubEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SubEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubEdit as text
%        str2double(get(hObject,'String')) returns contents of SubEdit as a double


% --- Executes during object creation, after setting all properties.
function SubEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SubAverage.
function SubAverage_Callback(hObject, eventdata, handles)
% hObject    handle to SubAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SubAverage


% --------------------------------------------------------------------
function MEMapNorm_Callback(hObject, eventdata, handles)
% hObject    handle to MEMapNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.MEMapNorm,'Checked'),'on')
    set(handles.MEMapNorm,'Checked','off')
else
    set(handles.MEMapNorm,'Checked','on')
end

% --------------------------------------------------------------------
function MEMapTrasp_Callback(hObject, eventdata, handles)
% hObject    handle to MEMapTrasp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.MEMapTrasp,'Checked'),'on')
    set(handles.MEMapTrasp,'Checked','off')
else
    set(handles.MEMapTrasp,'Checked','on')
end


% --------------------------------------------------------------------
function MEImport_Event_Callback(hObject, eventdata, handles)
% hObject    handle to MEImport_Event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global pathname Information
% 
% if ~handles.serial % Crear valor 0. Pode dar erro.
%     answ = questdlg('Did you choose the channel containing events?','Processing - ERP');
% else
%     answ = 'Yes';
% end
% if strcmp(answ,'Yes')
%     
% currentFile = getFileRun();
% if isempty(currentFile)
%    errordlg('Please, load a file','Error') 
%    return
% end
% 
% if ~ischar(pathname)
%     pathname='';
% end
% 
% set(handles.endInfo,'String','Importing events ...')
% 
% if handles.serial == 1
% % EMGEventstoMat % Script to detect events in EMG/Torque signals
% % 
% % Time_onset_Contr = Res_Events{Sub,ktest}{2};
% % Time_offset_Contr = Res_Events{Sub,ktest}{3};
% end
% %% Adding events into the EEGv Session
% % for l=1:N_arquivos
% try
%     load(currentFile)
% catch
%    errordlg('Error loading session file','Error') 
%    return
% end
% 
% MESynchronism_Callback(hObject, eventdata, handles)
% 
% % To avoid contractions with stimuli
% indEstim = find(diff(Time_onset_Contr(:,1))<2.5); % 2.5 s between onset contractions
% 
% Time_onset_Contr_Stim = Time_onset_Contr(indEstim-1,:);
% Time_onset_Contr_Stim2 = Time_onset_Contr(indEstim,:);
% Time_onset_Contr([indEstim; indEstim-1],:)=[];
% 
% % figure,
% % plot(EEGv.times/1000,EEGv.data(1,:))
% % hold on
% % plot(Time_onset_Contr,[1 1]*200,'k')
% % plot(Time_onset_Contr_Stim,[1 1]*220,'r')
% % plot(Time_onset_Contr_Stim2,[1 1]*220,'*b')
% 
% 
% EEGv.events.Time_onset_Contr = Time_onset_Contr;
% EEGv.events.Time_onset_Contr_Stim = Time_onset_Contr_Stim;
% EEGv.events.Time_onset_Contr_Stim2 = Time_onset_Contr_Stim2;
% 
% 
% figure
% ax1 = subplot(211);
% plot(datafull(:,1),datafull(:,indCH)), axis tight
% hold on
% plot(Time_onset_Contr,[1 1]*50,'k')
% plot(Time_onset_Contr_Stim,[1 1]*50,'r')
% plot(Time_onset_Contr_Stim2,[1 1]*50,'b')
% legend({'Torque','Contractions'})
% ax2 = subplot(212);
% plot(EEGv.times/1000,EEGv.data(1,:)), axis tight
% hold on
% plot(Time_onset_Contr,[1 1]*200,'k')
% plot(Time_onset_Contr_Stim,[1 1]*220,'r')
% plot(Time_onset_Contr_Stim2,[1 1]*220,'b')
% legend({'EEG','Contractions'})
% xlabel('Seconds [s]')
% 
% linkaxes([ax1 ax2],'x')
% 
% % 
% % hold on
% % plot(EEGv.events.Time_onset_Contr(:,1),ones(n_events,1)*th+100,'*r')
% % plot(EEGv.events.Time_onset_Contr(:,2),ones(n_events,1)*th+100,'ok')
% % % EEGv.events.Time_onset_Contr(:,2)-EEGv.events.Time_onset_Contr(:,1);
% 
% EEGv = eeg_checkset( EEGv );
% 
% addlistInformation(handles,'Events imported')
% saveData(handles,'','')
% set(handles.endInfo,'String','Events imported!')
% 
% % end
% 
% end

global pathname Information

hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end
flagPlot=get(handles.MEplots,'Checked');
switch flagPlot
    case 'off'
        flagPlot=false;
    case 'on'
        flagPlot=true;
end

answ = questdlg('Did you choose the channel containing events?','Processing - ERP');
if strcmp(answ,'Yes')
    
currentFile = getFileRun();
if isempty(currentFile)
   errordlg('Please, load a file','Error') 
   return
end

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','Importing events ...')

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load EMG file including Events',pathname);

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
variableInfo = who('-file',Datafile);
if ~ismember('datafull', variableInfo)
    return
end
load(Datafile,'EMG_0','datafull','DataInformation','Fs','marks')

%% Detect Torque channels
lch=length(DataInformation);
flag=false;
indCH=[];

flagerror=0;
S_source = get(handles.Event_source,'String');
S_source = S_source{get(handles.Event_source,'Value')};

for i=1:lch
    try
    flag=strcmp(DataInformation{i},S_source);
    if flag
        indCH = [indCH i];
%     else
%         flag=true;
    end
    catch
        warndlg([S_source,' channel can not be detected'],'Warning') 
        return
    end
end

if isempty(indCH)
    warndlg({[S_source,' channel is missing!: F',filename]}','Warning!')
    return
end

%% To extract the pulses received into the EMG equipment
ind = find(datafull(:,2)<-200);
ind2 = diff(EMG_0);
ind3 = find(ind2~=1);
EMG_02 = [EMG_0(1); ind(ind3+1)]; % Containing all the pulses from the EMG equipment
EMG_02 = (EMG_02 - EMG_02(1))/Fs;

datafull = datafull(EMG_0(1):end,:);
datafull(:,1) = datafull(:,1)-datafull(1,1);
try, marks = marks - EMG_0(1); end % Revisar se esta variável está no arquivo

% tbase = [5 10]*Fs + EMG_0(1); % Revisar corte de sincronismo
% v = datafull(:,indCH);
% 
% figure; hold on;
% 
% if strcmp(S_source,'EMG VL')
%     indCH = indCH(1);
%     v=EMGFilter(datafull(:,indCH),Fs,0); % flag=0 to dont pictures
%         
%     [trms,vrms]=RMSvalue(abs(v),Fs,100,30);
%     [~,a] = min(abs(trms-tbase(1)/Fs));
%     [~,b] = min(abs(trms-tbase(2)/Fs));
%     tbase=[a b];
%     
%     plot(datafull(:,1),datafull(:,indCH),'c')
%     plot(datafull(:,1),v)
%     plot(trms,vrms,'r')
%     v=vrms; clear vrms
% 
%     baseline = mean(v(tbase(1):tbase(2)));
%     baselineSTD = std(v(tbase(1):tbase(2)));
% 
%     TH = baseline+baselineSTD*30;
% 
%     syncPulse1 = zeros(1,length(v));
%     syncPulse1 (find(v>TH))=1;
%     plot(trms,syncPulse*1000,'g')
% 
% elseif strcmp(S_source,'Torque')
%     
%     baseline = mean(v(tbase(1):tbase(2)));
%     baselineSTD = std(v(tbase(1):tbase(2)));
% 
%     % TH = baseline+baselineSTD*10;
%     TH = baseline+2; % Adding 2 Nm
% 
%     syncPulse2 = zeros(1,length(v));
%     syncPulse2 (find(v>TH))=1;
%     plot(datafull(:,1),syncPulse*3000,'--g')
%     plot(datafull(:,1),datafull(:,indCH)*10,'--k')
% end
tbase = [5 10];

AddTH = [30 0]; % where Threhold is baselineMean+baselineSTD*AddTH(1)+AddTH(2);
indCH = indCH(1);
[txtEMG,indEMG] = getEMGch (DataInformation);
vEMG=EMGFilter(datafull(:,indEMG(1)),Fs,0); % flag=0 to dont pictures
[trms,vrms]=RMSvalue(abs(vEMG),Fs,100,30);
Time_onset_Contr1 = Onset_Contraction(vrms,trms,tbase,AddTH);

AddTH = [0 4]; % where Threhold is baselineMean+baselineSTD*AddTH(1)+AddTH(2);
[txtTorque,indTorque] = getTorquech (DataInformation);
vTorque = datafull(:,indTorque);
time = datafull(:,1);
Time_onset_Contr2 = Onset_Contraction(vTorque,time,tbase,AddTH);

if hiddenPlots
figure, hold on
plot(datafull(:,1),vEMG,'c')
plot(trms,vrms,'r')
plot(time,datafull(:,indTorque),'b')
plot([Time_onset_Contr1(:,1) Time_onset_Contr1(:,1)],[200 0],'k')
plot([Time_onset_Contr1(:,1) Time_onset_Contr1(:,2)],[200 200],'k')
plot([Time_onset_Contr1(:,2) Time_onset_Contr1(:,2)],[200 0],'r','LineWidth',2)
% plot([Time_onset_Contr2(:,1) Time_onset_Contr2(:,1)],[50 0],'k')
% plot([Time_onset_Contr2(:,1) Time_onset_Contr2(:,2)],[50 50],'k')
% plot([Time_onset_Contr2(:,2) Time_onset_Contr2(:,2)],[50 0],'r','LineWidth',2)
%%%
end

clear vEMG vTorque trms vrms time

if strcmp(S_source,'Torque')    
    Time_onset_Contr = Time_onset_Contr2;
elseif strcmp(S_source,'EMG VL')
    Time_onset_Contr = Time_onset_Contr1;
end
    
    

% if strcmp(S_source,'Torque')    
%     Time_onset_Contr(1:length(onset_Contr),1) = datafull(onset_Contr,1);
%     Time_onset_Contr(1:length(offset_Contr),2) = datafull(offset_Contr,1);
%     Time_offset_Contr(1:length(offset_Contr),2) = datafull(offset_Contr,1);
% % Time_onset_Contr = Time_onset_Contr-datafull(EMG_0,1);
% elseif strcmp(S_source,'EMG VL')
%     Time_onset_Contr(1:length(onset_Contr),1) = trms(1,onset_Contr);
%     Time_onset_Contr(1:length(offset_Contr),2) = trms(1,offset_Contr);
%     Time_offset_Contr(1:length(offset_Contr),2) = trms(1,offset_Contr);
% end


%% Adding events into the EEGv Session


% % To avoid contractions with stimuli
% indEstim = find(diff(Time_onset_Contr2(:,1))<2.5); % 4 s between onset contractions
% 
% [~,indEstim] = min(abs(Time_onset_Contr(:,1)-Time_onset_Contr2(indEstim,1)')); % Time is detected between torque and EMG
% 
% Time_onset_Contr_Stim = Time_onset_Contr(indEstim-1,:); % Onset of false pulse
% Time_onset_Contr_Stim2 = Time_onset_Contr(indEstim,:); % Offset of false pulse
% Time_onset_Contr([indEstim; indEstim-1],:)=[];
% 
% indFalsePulse = find((Time_onset_Contr2(:,2)-Time_onset_Contr2(:,1))<0.5); % contractions lower than 1 s
% Time_onset_Contr_FalseP = Time_onset_Contr(indFalsePulse,:); % To avoid false short pulses
% Time_onset_Contr(indFalsePulse,:)=[];

% Diference between onsets
indFalsePulse = find(diff(Time_onset_Contr2(:,1))<0.5); % contractions lower than 1 s
Time_onset_Contr_FalseP1 = Time_onset_Contr2(indFalsePulse,:); % To avoid false short pulses
Time_onset_Contr2(indFalsePulse,:)=[];
% Diference between offsets
indFalsePulse = find(diff(Time_onset_Contr2(:,2))<0.5); % contractions lower than 1 s
Time_onset_Contr_FalseP2 = Time_onset_Contr2(indFalsePulse,:); % To avoid false short pulses
Time_onset_Contr2(indFalsePulse,:)=[];

% Stimuli to avoid for analysis
% try, load('D:\Work\Luana EEG\1 Arquivos EMG\08_V5_DEtds_filtered_Peaks.mat','marks'), end
timeStim = datafull(marks,1);
[~,indEstim] = min(abs(Time_onset_Contr2(:,1)-timeStim')); % Stim
Time_onset_Contr_Stim = Time_onset_Contr2(indEstim,:); % Onset of Stim pulses
Time_onset_Contr2(indEstim,:)=[];

% Diference between offset-onset
indFalsePulse = find((Time_onset_Contr2(:,2)-Time_onset_Contr2(:,1))<1); % contractions lower than 1 s
Time_onset_Contr_FalseP3 = Time_onset_Contr2(indFalsePulse,:); % To avoid false short pulses
Time_onset_Contr2(indFalsePulse,:)=[];

[~,indOnset] = min(abs(Time_onset_Contr1(:,1)-Time_onset_Contr2(:,1)')); % Time is detected between torque and EMG
Time_onset_Contr = Time_onset_Contr1(indOnset,:);

% figure,
% plot(EEGv.times/1000,EEGv.data(1,:))
% hold on
% plot(Time_onset_Contr,[1 1]*200,'k')
% plot(Time_onset_Contr_Stim,[1 1]*220,'r')
% plot(Time_onset_Contr_Stim2,[1 1]*220,'*b')

try
    load(currentFile)
catch
   errordlg('Error loading session file','Error') 
   return
end

EEGv.events.EMG_0 = EMG_0;
EEGv.events.Time_onset_Contr = Time_onset_Contr;
EEGv.events.Time_onset_Contr_Stim = Time_onset_Contr_Stim;
EEGv.events.Time_onset_Contr_False1 = Time_onset_Contr_FalseP1;
EEGv.events.Time_onset_Contr_False2 = Time_onset_Contr_FalseP1;


%%

clear EP_rest EP
ind_rem = [];
for ch=3
    lulu = 1;
for ll = 2:length(Time_onset_Contr)
    ii = round(Time_onset_Contr(ll-1,2)*Fs); % Offset (i-1)
    jj = round(Time_onset_Contr(ll,1)*Fs); % Onset (i)
    kk = round(Time_onset_Contr(ll,2)*Fs); % Offset (i)
%     EP_rest{ch-2}(1:jj-ii+1,ll-1) = datafull(ii:jj,ch);
    
    if isempty( find(datafull(jj-1500:jj-500,ch)>3) )
        EP_rest{ch-2}(1:3001,lulu) = datafull(jj-2000:jj+1000,ch);
        EP_rest_Ind(1:2,lulu) = [jj-2000,jj+1000];
        EP{ch-2}(1:kk-jj+1,lulu) = datafull(jj:kk,ch);
        EP_Ind(1:2,lulu) = [jj-2000,jj+1000];
        lulu=lulu+1;
    else
        ind_rem = [ind_rem ll];
    end

end
end

Time_onset_Contr_FalseP4 = Time_onset_Contr(ind_rem,:); % To avoid false short pulses
Time_onset_Contr(ind_rem,:)=[];

inn = find(EP_rest{1}(:)==0);
EP_rest{1}(inn)=NaN;
inn = find(EP{1}(:)==0);
EP{1}(inn)=NaN;
clear inn

if flagPlot
    
figure;
subplot(121), plot(EP_rest{1, 1})
% figure;plot(EP{1, 2})
a1 = gca;
H1 = get(a1, 'Children');
set(H1, 'ButtonDownFcn', {@LineSelected, H1})

subplot(122), plot(EP{1, 1})
% figure;plot(EP{1, 2})
a2 = gca;
H2 = get(a2, 'Children');
set(H2, 'ButtonDownFcn', {@LineSelected, H2})

end

% nline = 839;
% figure, plot(datafull(EP_rest_Ind(1,nline):EP_rest_Ind(2,nline),3))

%%
if hiddenPlots

MM = max(datafull(:,indCH))*1.1;
MM2 = max(EEGv.data(1,:))*1.1;
figure
ax1 = subplot(211);
plot(datafull(:,1),datafull(:,indCH)), axis tight
hold on
plot(Time_onset_Contr,[1 1]*MM,'k')
try, plot(Time_onset_Contr_FalseP1,[1 1]*MM,'r','LineWidth',10), end
try, plot(Time_onset_Contr_FalseP2,[1 1]*MM,'b','LineWidth',10), end
try, plot(Time_onset_Contr_FalseP4,[1 1]*MM,'k','LineWidth',10), end
try, plot(Time_onset_Contr_Stim,[1 1]*MM,'g','LineWidth',10), end
legend({S_source,'Contractions'})
axis([0 60 0 MM])

ax2 = subplot(212);
plot(EEGv.times/1000,EEGv.data(1,:)), axis tight
hold on
plot(Time_onset_Contr,[1 1]*MM2,'k')
try, plot(Time_onset_Contr_FalseP1,[1 1]*MM2,'r','LineWidth',10), end
try, plot(Time_onset_Contr_FalseP2,[1 1]*MM2,'b','LineWidth',10), end
try, plot(Time_onset_Contr_FalseP4,[1 1]*MM2,'k','LineWidth',10), end
try, plot(Time_onset_Contr_Stim,[1 1]*MM2,'g','LineWidth',10), end

legend({'EEG','Contractions'})
xlabel('Seconds [s]')

linkaxes([ax1 ax2],'x')

end
% MM = max(datafull(:,indTorque))*1.1;
% MM2 = max(EEGv.data(1,:))*1.1;
% figure
% ax1 = subplot(211);
% plot(datafull(:,1),datafull(:,indTorque)), axis tight
% hold on
% plot(Time_onset_Contr,[1 1]*MM,'k')
% plot(Time_onset_Contr_Stim,[1 1]*MM,'r')
% plot(Time_onset_Contr_Stim2,[1 1]*MM,'b')
% legend({'Torque','Contractions'})
% ax2 = subplot(212);
% plot(EEGv.times/1000,EEGv.data(1,:)), axis tight
% hold on
% plot(Time_onset_Contr,[1 1]*MM2,'k')
% plot(Time_onset_Contr_Stim,[1 1]*MM2,'r')
% plot(Time_onset_Contr_Stim2,[1 1]*MM2,'b')
% legend({'EEG','Contractions'})
% xlabel('Seconds [s]')
% 
% linkaxes([ax1 ax2],'x')
% 
% hold on
% plot(EEGv.events.Time_onset_Contr(:,1),ones(n_events,1)*th+100,'*r')
% plot(EEGv.events.Time_onset_Contr(:,2),ones(n_events,1)*th+100,'ok')
% % EEGv.events.Time_onset_Contr(:,2)-EEGv.events.Time_onset_Contr(:,1);
clear datafull
EEGv = eeg_checkset( EEGv );

addlistInformation(handles,'Events imported')
saveData(handles,'','_E')
set(handles.endInfo,'String','Events imported!')

% 
% figure, plot(EEGv.times/1000, sync), title('Synchronism'), xlabel('Seconds [s]')
%     EEGv.data = EEGv.data(:,EEG_0:end);
%     EEGv.times = (EEGv.times(EEG_0:end) - EEGv.times(EEG_0));
end

% function smallTest
% axes('NextPlot', 'add')
% H(1) = plot(1:10, rand(1, 10), 'r');
% H(2) = plot(1:10, rand(1, 10), 'b');
% set(H, 'ButtonDownFcn', {@LineSelected, H})

function LineSelected(ObjectH, EventData, H)
set(ObjectH, 'LineWidth', 2.5);
set(H(H ~= ObjectH), 'LineWidth', 0.5);
EventData.Source.SeriesIndex

function Time_onset_Contr = Onset_Contraction(v,time,tbase,AddTH)
    
[~,a] = min(abs(time-tbase(1)));
[~,b] = min(abs(time-tbase(2)));
tbase=[a b];
    
baselineMn = mean(v(tbase(1):tbase(2)));
baselineSTD = std(v(tbase(1):tbase(2)));

TH = baselineMn+baselineSTD*AddTH(1)+AddTH(2);

syncPulse = zeros(1,length(v));
syncPulse (find(v>TH))=1;
    
% To find samples for the events
syncPulseDiff = diff(syncPulse);
onset_Contr = find(syncPulseDiff==1);
offset_Contr = find(syncPulseDiff==-1);

% To find times for the events
Time_onset_Contr(1:length(onset_Contr),1) = time(onset_Contr);
Time_onset_Contr(1:length(offset_Contr),2) = time(offset_Contr);
Time_offset_Contr(1:length(offset_Contr),2) = time(offset_Contr);
    
% To remove last sample if a zero value
Time_onset_Contr (find (Time_onset_Contr(:,1)==0),:) = [];
Time_offset_Contr (find (Time_offset_Contr(:,2)==0),:) = [];


function [txtTorque,indTorque] = getTorquech (DataInformation)
%% Detect Torque channel
txtTorque=[];
indTorque=length(DataInformation);
flag=false;
while ~flag
    flag=strcmp(DataInformation{indTorque},'Torque');
    flag2=strcmp(DataInformation{indTorque},'torque');
    flag = flag | flag2;
    if ~flag
        indTorque=indTorque-1;
%     else
%         flag=true;
    end
end

if isempty(indTorque)
    warndlg('Torque channel can not be detected','Warning') 
end


function [txtEMG,indEMG] = getEMGch (DataInformation)
%% Detect EMG channels
lch=length(DataInformation);
flag=false;
indEMG=[];
txtEMG={};

flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1:3),'EMG');
    if flag
        indEMG=[indEMG i];
        txtEMG=[txtEMG DataInformation{i}];
%     else
%         flag=true;
    end
    catch
        warndlg('EMG channels can not be detected','Warning') 
    end
end


% --------------------------------------------------------------------
function MESynchronism_Callback(hObject, eventdata, handles)
% hObject    handle to MESynchronism (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Information

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','Processing synchronization ...')

if ~handles.serial
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load EEG data with synchronism (after import PLG file)',pathname);

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);

load(Datafile,'sync')

else
    currentFile = getFileRun();
    if isempty(currentFile)
       errordlg('Please, load a file','Error') 
       return
    end
    load(currentFile)
end
%% Brainnet

EEG_0 = find(sync);

if ~isempty(EEG_0)

EEG_0 = EEG_0(1);

%% Adding events into the EEGv Session

currentFile = getFileRun();
if isempty(currentFile)
   errordlg('Please, load a file','Error') 
   return
end
try
    load(currentFile)
catch
   errordlg('Error loading session file','Error') 
   return
end

flagSync=1;
ProcessApplied=EEGv.ProcessApplied;
if (isfield(ProcessApplied,'Sync') && ~EEGv.ProcessApplied.Sync)

    flagSync=questdlg('Do you want to calculate again?','Synchronism','Yes','No','No');
    if strcmp(flagSync,'No')
        flagSync=0;
    end

end

if ~flagSync
    return
end

EEGv.data = EEGv.data(:,EEG_0:end);
EEGv.times = (EEGv.times(EEG_0:end)-EEGv.times(EEG_0));
EEGv.TimeParam.Timetest = EEGv.times(end)/1000;

EEGv = eeg_checkset( EEGv );

EEGv.ProcessApplied.Sync=1;
addlistInformation(handles,'Synchronization applied')
saveData(handles,'','')
set(handles.endInfo,'String','Synchronization applied!')

    fprintf(['============================================', ...
    '\nSyncronism recognized! \n============================================\n'])
else
    fprintf(['============================================', ...
    '\nSyncronism unrecognized! \n============================================\n'])
end

% --------------------------------------------------------------------
function ME_MRCP_Callback(hObject, eventdata, handles)
% hObject    handle to ME_MRCP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.endInfo,'String','Processing MRCP...')

currentFile = getFileRun();
if isempty(currentFile)
   errordlg('Please, load a file','Error') 
   return
end
try
    load(currentFile)
catch
   errordlg('Error loading session file','Error') 
   return
end

fprintf(['============================================', ...
    '\nMRCP processing... \n============================================\n'])


MRCP_ep = MRCP(EEGv,handles);

fprintf(['============================================', ...
    '\nMRCP completed! \n============================================\n'])


set(handles.endInfo,'String','MRCP completed!')
% addlistInformation(handles,'MRCP applied')
% saveData(handles,'','_MRCP')

function MRCP_ep = MRCP2(EEGv,handles)
Max_N_epochs = 0; % Number of epochs for average. All divisions have the same N. 0 to consider all epochs.

Fs = EEGv.srate;
tinst = [-1.5 -0.5; -.4 -0.1;  -0.1 0; 0 0.5; 0 1.5]; % Segments for processing MRCP
tinstLabels = {'-1.5 to -0.5','-0.4 to -0.1','-0.1 to 0','0 to 0.5' ,'0 to 1.5'};
tep = [-2 1.5]; % Full MRCP segment - Paramters updated 23/03/2023
t_tep = tep(1):1/Fs:tep(2);

samp_range = tep*Fs;
parameters.time_instants = tinst;
parameters.tinstLabels = tinstLabels;
parameters.time_range = tep;

Sinst = tinst*Fs; % Segments for processing MRCP

EEG = EEGv.data;
tEEG = EEGv.times*0.001;

clear Samp_onset_Contr

if ~isfield(EEGv,'events')
    errordlg('Synchronized events were not found!', 'ERROR')
    return 
end
n_events = size(EEGv.events.Time_onset_Contr,1); % Number of events (Init contract)

for j=1:size(EEGv.events.Time_onset_Contr,1)
    for k=1:size(EEGv.events.Time_onset_Contr,2)
        [m,ind] = min (abs(tEEG-EEGv.events.Time_onset_Contr(j,k))); %% To relate time with samples of the events
        Samp_onset_Contr(j,k)=ind;
    end
end

    
Times_DivisionsSTR = get(handles.Times_Divisions,'String');
indspc = findstr(get(handles.Times_Divisions,'String'),' ');
Times_DivisionsSTR = get(handles.Times_Divisions,'String');
% Times_Divisions = str2num(Times_DivisionsSTR)/100*EEGv.TimeParam.Timetest;
Times_Divisions = str2num(Times_DivisionsSTR)/100*length(EEGv.times)/Fs;
Samp_Divisions = round(Times_Divisions*Fs);
Div = length(Times_Divisions);

% indspc = findstr(get(handles.Times_Divisions,'String'),' ');
i_1=1;
for ispc = 1:length(indspc)
    Times_Divisions_Label(ispc) = {Times_DivisionsSTR(i_1:indspc(ispc)-1)};
    i_1=indspc(ispc)+1;
end
Times_Divisions_Label(ispc+1) = {Times_DivisionsSTR(i_1:end)};
% Times_Divisions_Label = {'25%','50%','75%','100%'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grupo X Subj X Visit X (20CH/Region) X (n_Ep/Segm_MRCP) X Div_Test
% Média de sujeitos
% Média de epocas
% Médica de canais?

% Grupo X Visit X Div X CH/Regiao

index = [6	11	16	2 7 ...
    12	17	22	10	15 ...
    20	4	9	14	19 ...
    24	8	13	18	23 ...
    ]; % indices for each channel according to the localization on the scalp

parameters.CH_index =index;

times = [];

Si = 1; % First sample of segments
for div = 1:Div % Cycles for segmentation of test
    SampDivf = Samp_Divisions(div); % Samples to segment the test
    
    Sf = find (Samp_onset_Contr(:,2) < SampDivf); % Last sample of segment
    Sf = Sf(end);

disp(['DIVISION: ',num2str(div),' of ',num2str(Div)])

[events_s,events_e] = flagEventFnc(EEGv,handles,Si); % To detect events within rejected segments

discard = 0;

% figure, hold on

for ch = 1:20 % Cycles for channels
MRCP_ep=[];

clear MRCP

try
% for ii=1:length(Samp_onset_Contr)
for ii=Si:Sf
    
    a = Samp_onset_Contr(ii)+samp_range(1);
    b = Samp_onset_Contr(ii)+samp_range(2);
    
    % Avoid segments removed with previous analysis
    if EEGv.ProcessApplied.RemSeg
%         flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(stSamp:stSamp+epochsize-1),1));
        flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(a:b)));
        [m,ind]=min(abs(events_s-Si));

    else
        flagevent=false;
    end
    
    if ~flagevent % Only when segment is able to be analyzed
    
        MRCP_ep = [MRCP_ep; EEG(ch,a:b)];       % Full epoch
        if ch == 18
            plot(t_tep,EEG(ch,a:b))
        end

    else
%         plot(t_tep,EEG(ch,a:b))
%         times = [times; tEEG(a:b)];
        discard=discard+1;
    end
end

catch ME
    disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
end

nEp(div) = size(MRCP_ep,1);

[m,k]=size(MRCP_ep);
MRCP_Div_Ch_ep{div}(ch,:,:)=reshape(MRCP_ep(:,:),[m k])';

end

Si = Sf+1;

end % Div

parameters.nEpochs = nEp;
parameters.nDivisionsTest = Div;

currentFile = getFileRun();
currentFile = strcat(currentFile(1:end-4),'_MRCP2_Div',num2str(Div),'_E_ ',num2str(nEp),'.mat');

save (currentFile,'MRCP_Div_Ch_ep','parameters')
% save (currentFile,'MRCP_Ch_ep','MRCP_Ch_ep1','MRCP_Ch_ep2','MRCP_Ch_ep3','MRCP_Ch_ep4')

function MRCP_ep = MRCP(EEGv,handles)

Max_N_epochs = 0; % Number of epochs for average. All divisions have the same N. 0 to consider all epochs.

Fs = EEGv.srate;
tinst = [-1.5 -0.5; -.4 -0.1;  -0.1 0; 0 0.5; 0 1.5]; % Segments for processing MRCP
tinstLabels = {'-1.5 to -0.5','-0.4 to -0.1','-0.1 to 0','0 to 0.5' ,'0 to 1.5'};
% tep = [-2 0.5]*Fs; % Full MRCP segment 
tep = [-2 1.5]; % Full MRCP segment - Paramters updated 23/03/2023
tBaseLine = [-1.75 -1.25];

samp_range = tep*Fs;
parameters.time_instants = tinst;
parameters.tinstLabels = tinstLabels;
parameters.time_range = tep;
parameters.time_BaseLine = tBaseLine;

Sinst = tinst*Fs; % Segments for processing MRCP

EEG = EEGv.data;
tEEG = EEGv.times*0.001;


hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end
flagPlot=get(handles.MEplots,'Checked');
switch flagPlot
    case 'off'
        flagPlot=false;
    case 'on'
        flagPlot=true;
end

clear Samp_onset_Contr

if ~isfield(EEGv,'events')
    errordlg('Synchronized events were not found!', 'ERROR')
    return 
end
n_events = size(EEGv.events.Time_onset_Contr,1); % Number of events (Init contract)

for j=1:size(EEGv.events.Time_onset_Contr,1)
    for k=1:size(EEGv.events.Time_onset_Contr,2)
        if EEGv.events.Time_onset_Contr(j,k)>0
        [m,ind] = min (abs(tEEG-EEGv.events.Time_onset_Contr(j,k))); %% To relate time with samples of the events
        Samp_onset_Contr(j,k)=ind;
        end
    end
end

% clear EP_rest EP
% ind_rem = [];
% for ch=3
%     lulu = 1;
% for ll = 2:length(Time_onset_Contr)
%     ii = round(Time_onset_Contr(ll-1,2)*Fs); % Offset (i-1)
%     jj = round(Time_onset_Contr(ll,1)*Fs); % Onset (i)
%     kk = round(Time_onset_Contr(ll,2)*Fs); % Offset (i)
% %     EP_rest{ch-2}(1:jj-ii+1,ll-1) = datafull(ii:jj,ch);
%     
%     if isempty( find(datafull(jj-1500:jj-500,ch)>3) )
%         EP_rest{ch-2}(1:3001,lulu) = datafull(jj-2000:jj+1000,ch);
%         EP_rest_Ind(1:2,lulu) = [jj-2000,jj+1000];
%         EP{ch-2}(1:kk-jj+1,lulu) = datafull(jj:kk,ch);
%         EP_Ind(1:2,lulu) = [jj-2000,jj+1000];
%         lulu=lulu+1;
%     else
%         ind_rem = [ind_rem ll];
%     end
% 
% end
% end

%%
try
    
Times_DivisionsSTR = get(handles.Times_Divisions,'String');
indspc = findstr(get(handles.Times_Divisions,'String'),' ');
Times_DivisionsSTR = get(handles.Times_Divisions,'String');
% Times_Divisions = str2num(Times_DivisionsSTR)/100*EEGv.TimeParam.Timetest;
Times_Divisions = str2num(Times_DivisionsSTR)/100*length(EEGv.times)/Fs;
Samp_Divisions = round(Times_Divisions*Fs);
Div = length(Times_Divisions);

% indspc = findstr(get(handles.Times_Divisions,'String'),' ');
i_1=1;
for ispc = 1:length(indspc)
    Times_Divisions_Label(ispc) = {Times_DivisionsSTR(i_1:indspc(ispc)-1)};
    i_1=indspc(ispc)+1;
end
Times_Divisions_Label(ispc+1) = {Times_DivisionsSTR(i_1:end)};
% Times_Divisions_Label = {'25%','50%','75%','100%'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grupo X Subj X Visit X (20CH/Region) X (n_Ep/Segm_MRCP) X Div_Test
% Média de sujeitos
% Média de epocas
% Médica de canais?

% Grupo X Visit X Div X CH/Regiao

index = [6	11	16	2 7 ...
    12	17	22	10	15 ...
    20	4	9	14	19 ...
    24	8	13	18	23 ...
    ]; % indices for each channel according to the localization on the scalp

parameters.CH_index =index;

Si = 1; % First sample of segments
for div = 1:Div % Cycles for segmentation of test
    SampDivf = Samp_Divisions(div); % Samples to segment the test
    
    Sf = find (Samp_onset_Contr(:,2) < SampDivf); % Last sample of segment
    Sf = Sf(end);

disp(['DIVISION: ',num2str(div),' of ',num2str(Div)])



[events_s,events_e] = flagEventFnc(EEGv,handles,Si); % To detect events within rejected segments

discard = 0;

for ch = 1:20 % Cycles for channels
MRCP_ep=[];
l1 = Sinst(1,2)-Sinst(1,1)+1; % Samples for each MRCP segment
l2 = Sinst(2,2)-Sinst(2,1)+1;
l3 = Sinst(3,2)-Sinst(3,1)+1;
l4 = Sinst(4,2)-Sinst(4,1)+1;

clear MRCP

try
% for ii=1:length(Samp_onset_Contr)
for ii=Si:Sf
    
    a = Samp_onset_Contr(ii)+samp_range(1);
    b = Samp_onset_Contr(ii)+samp_range(2);
    
    % Avoid segments removed with previous analysis
    if EEGv.ProcessApplied.RemSeg
%         flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(stSamp:stSamp+epochsize-1),1));
        flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(a:b)));
        [m,ind]=min(abs(events_s-Si));
    else
        flagevent=false;
    end
    
    if ~flagevent % Only when segment is able to be analyzed
    
    MRCP_ep = [MRCP_ep; EEG(ch,a:b)];       % Full epoch
%     MRCP{1}(ii,1:l1) = EEG(ch,Samp_onset_Contr(ii)+Sinst(1,1):Samp_onset_Contr(ii)+Sinst(1,2)); % -1    0.5
%     MRCP{2}(ii,1:l2) = EEG(ch,Samp_onset_Contr(ii)+Sinst(2,1):Samp_onset_Contr(ii)+Sinst(2,2)); % -0.4 -0.1
%     MRCP{3}(ii,1:l3) = EEG(ch,Samp_onset_Contr(ii)+Sinst(3,1):Samp_onset_Contr(ii)+Sinst(3,2)); % -0.1  0
%     MRCP{4}(ii,1:l4) = EEG(ch,Samp_onset_Contr(ii)+Sinst(4,1):Samp_onset_Contr(ii)+Sinst(4,2)); %  0    0.5
    
%     MRCP_Ch_ep{div}(ch,:,ii) = EEG(ch,Samp_onset_Contr(ii)+samp_range(1):Samp_onset_Contr(ii)+samp_range(2));                  % Full epoch
%     MRCP_Ch_ep1{div}(ch,:,ii) = EEG(ch,Samp_onset_Contr(ii)+Sinst(1,1):Samp_onset_Contr(ii)+Sinst(1,2)); % -1    0.5
%     MRCP_Ch_ep2{div}(ch,:,ii) = EEG(ch,Samp_onset_Contr(ii)+Sinst(2,1):Samp_onset_Contr(ii)+Sinst(2,2)); % -0.4 -0.1
%     MRCP_Ch_ep3{div}(ch,:,ii) = EEG(ch,Samp_onset_Contr(ii)+Sinst(3,1):Samp_onset_Contr(ii)+Sinst(3,2)); % -0.1  0
%     MRCP_Ch_ep4{div}(ch,:,ii) = EEG(ch,Samp_onset_Contr(ii)+Sinst(4,1):Samp_onset_Contr(ii)+Sinst(4,2)); %  0    0.5
    
    else
        discard=discard+1;
    end
end

catch ME
    stop=1
    disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
end

% Full Epoch
% MRCP_ep{div}{ch} = MRCP_ep; % All epochs per segment

if Max_N_epochs>0
if size(MRCP_ep,1)>Max_N_epochs
    MRCP_ep = MRCP_ep(end-Max_N_epochs+1:end,:);
else
    disp('WARNING: MINIMUN NUMBER OF EPOCHS WAS NOT ACHIEVED') 
end
end

MRCP_ep_FullCH{div}(ch,:,:) = MRCP_ep; % Variable Saved

%% Conditioning: Baseline removal and detrend
try
MRCP_ep = detrend(MRCP_ep','linear')';
catch
   stop=1; 
end
% rng default;  % For reproducibility
% y = exprnd(5,100,1);
mddd = bootstrp(45,@mean,MRCP_ep);
data_ep_Mean = mean(mddd,1);
baseline = mean(data_ep_Mean(:,(tBaseLine(1)-tep(1))*Fs:(tBaseLine(2)-tep(1))*Fs)); % 0.25 - 0.75
MRCP_ep_Mean{div}(ch,:) = data_ep_Mean-baseline; % Mean for all epochs. Variable Saved
clear mddd


%%
% MRCP_ep_SD{div}(ch,:) = std(MRCP_ep);
% MRCP_ep_min{div}(ch,:) = min(MRCP_ep);
% MRCP_ep_max{div}(ch,:) = max(MRCP_ep);

% Mean for each segments
MRCP1_Mean2{div}(ch) = mean(MRCP_ep_Mean{div}(ch,(tinst(1,1)-tep(1))*Fs+1:(tinst(1,2)-tep(1))*Fs)); % -1.5 to 0.5 %mean (MRCP{1}(:)); % Mean for all epochs
% 0.5 s were added before due to segment begins in -2 s
MRCP2_Mean2{div}(ch) = mean(MRCP_ep_Mean{div}(ch,(tinst(2,1)-tep(1))*Fs+1:(tinst(2,2)-tep(1))*Fs)); % -0.4 to -0.1
MRCP3_Mean2{div}(ch) = mean(MRCP_ep_Mean{div}(ch,(tinst(3,1)-tep(1))*Fs+1:(tinst(3,2)-tep(1))*Fs)); % -0.1 to 0
MRCP4_Mean2{div}(ch) = mean(MRCP_ep_Mean{div}(ch,(tinst(4,1)-tep(1))*Fs+1:(tinst(4,2)-tep(1))*Fs)); % 0 to 0.5

end

nEp(div) = size(MRCP_ep,1);
disp(['Number of Epochs for',EEGv.filename(1:end-4),' - ',Times_Divisions_Label{div},'%: ',num2str(size(MRCP_ep,1))])
disp(['EPOCHS REJECTED (RemSeg): ',num2str(discard),])



% To save data for epochs
% save ('S13_DES_V5_EP','MRCP_Ch_ep','MRCP_Ch_ep1','MRCP_Ch_ep2','MRCP_Ch_ep3','MRCP_Ch_ep4')

%% Graphics for each programmed division

% flagGraph = 1; % To hide (0) or show (1) figures

if flagPlot

% Plot_MRCP(MRCP_Ch_ep_M{1},20,Fs,samp_range,SetCH)
% SetCH = EEGv.Props.SetCH;
% nCH = size(MRCP_ep_Mean{div},1);
% Plot_MRCP(MRCP_ep_FullCH{div},[],Fs,[],[]) % Call the plot of MRCP
switch get(handles.MEMapNorm,'Checked')
    case 'off'
        NormF=false;
    case 'on'
        NormF=true;
end
Plot_MRCP(MRCP_ep_Mean{div},[],Fs,[],[],parameters,NormF) % Call the plot of MRCP

%% Old way to plot MRCP
% figure, % Figure for time series for epochs
% set(gcf, 'WindowState', 'maximized');
% 
% for ch = 1:20
%         
% t2 = (samp_range(1):1:samp_range(2))/Fs;
% tc1 = (tinst(1,1):1/Fs:tinst(1,2));
% tc2 = (tinst(2,1):1/Fs:tinst(2,2));
% tc3 = (tinst(3,1):1/Fs:tinst(3,2));
% 
% % figure; hold on
% % plot(t2,MRCP_ep_Mean(ch,:)','r')
% 
%  
% ax{ch} = subplot(5,5,index(ch));
% % subplot(131), hold on, axis tight
% % % plot(t2,MRCP_ep'), alpha 0.1
% hold on
% plot(t2,MRCP_ep_Mean{div}(ch,:)','b')
% plot([tinst(:,1) tinst(:,1)],[max(MRCP_ep_Mean{div}(ch,:)) min(MRCP_ep_Mean{div}(ch,:))],'--k')
% plot([tinst(:,2) tinst(:,2)],[max(MRCP_ep_Mean{div}(ch,:)) min(MRCP_ep_Mean{div}(ch,:))],'-r')
% 
% h = bar([tinst(:,1):0.01:tinst(:,2)],ones(length(tinst(:,1):0.01:tinst(:,2)),1)*max(MRCP_ep_Mean{div}(ch,:)),1,'k','EdgeColor','none');alpha(0.1)
% h = bar([tinst(:,1):0.01:tinst(:,2)],ones(length(tinst(:,1):0.01:tinst(:,2)),1)*min(MRCP_ep_Mean{div}(ch,:)),1,'k','EdgeColor','none');alpha(0.1)
% h = bar([tinst(2,1):0.01:tinst(4,2)],ones(length(tinst(2,1):0.01:tinst(4,2)),1)*max(MRCP_ep_Mean{div}(ch,:)),1,'k','EdgeColor','none');alpha(0.1)
% h = bar([tinst(2,1):0.01:tinst(4,2)],ones(length(tinst(2,1):0.01:tinst(4,2)),1)*min(MRCP_ep_Mean{div}(ch,:)),1,'k','EdgeColor','none');alpha(0.1)
% % title(['Average epochs. ',EEGv.Props.SetCH(ch)])
% title([SetCH(ch)])
% % title([EEGv.Props.SetCH(ch)])
% % xlabel('Time [s]')
% 
% % figure, 
% % subplot(121), hold on, axis tight
% % shadeSD(t2,MRCP_ep_Mean{div}(ch,:)-MRCP_ep_SD{div}(ch,:),MRCP_ep_Mean{div}(ch,:)+MRCP_ep_SD{div}(ch,:),MRCP_ep_Mean{div}(ch,:),'r','-')
% % plot([tinst(:,1) tinst(:,1)],[max(MRCP_ep_Mean(ch,:)) min(MRCP_ep_Mean(ch,:))],'--k')
% % plot([tinst(:,2) tinst(:,2)],[max(MRCP_ep_Mean(ch,:)) min(MRCP_ep_Mean(ch,:))],'-r')
% % title('Epochs [+- SD]')
% % subplot(122), hold on, axis tight
% % shadeSD(t2,MRCP_ep_min{div}(ch,:),MRCP_ep_max{div}(ch,:),MRCP_ep_Mean{div}(ch,:),'k','-')
% % plot([tinst(:,1) tinst(:,1)],[max(MRCP_ep_max{div}(ch,:)) min(MRCP_ep_min{div}(ch,:))],'--k')
% % plot([tinst(:,2) tinst(:,2)],[max(MRCP_ep_max{div}(ch,:)) min(MRCP_ep_min{div}(ch,:))],'-r')
% % title('Epochs [Min Max]')
% 
% end

%%

% figure
% subplot(131)
% plot(tc1,MRCP1_Mean)
% % plot(MRCP{1}')
% subplot(132)
% plot(tc2,MRCP2_Mean)
% % plot(MRCP{2}')
% xlabel('Time [s]')
% title(strcat('EEG Channel: ',num2str(ch)))
% subplot(133)
% plot(tc3,MRCP3_Mean)
% % plot(MRCP{3}')
% 
% linkaxes([ax{1} ax{2} ax{3} ax{4} ax{5} ax{6} ax{7} ax{8} ax{9} ax{10} ...
%     ax{11} ax{12} ax{13} ax{14} ax{15} ax{16} ax{17} ax{18} ax{19} ax{20}],'x')

end
Si = Sf+1;


end % Div

parameters.nEpochs = nEp;
parameters.nDivisionsTest = Div;

currentFile = getFileRun();
currentFile = strcat(currentFile(1:end-4),'_MRCP_Div',num2str(Div),'_E_ ',num2str(nEp),'.mat');

% filename = EEGv.filename;
% pathname = EEGv.pathname;
% currentFile=fullfile(pathname,filename);

save (currentFile,'MRCP_ep_FullCH','MRCP_ep_Mean','parameters')
% save (currentFile,'MRCP_Ch_ep','MRCP_Ch_ep1','MRCP_Ch_ep2','MRCP_Ch_ep3','MRCP_Ch_ep4')

%% Topology maps
% flagGraph = hiddenPlots; % To hide (0) or show (1) figures

% if flagPlot && flagGraph
if hiddenPlots
    
S=1;
chaninfo=EEGv.chaninfo;
chanlocs=EEGv.chanlocs;

figure,
set(gcf, 'WindowState', 'maximized');

plotTitle=1;
for div = 1:Div    

subplot(Div,4,1+(div-1)*Div) 
topoplot( MRCP1_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim1(div,:)=caxis; axis tight
if plotTitle, title(tinstLabels{1}),end
ylabel(Times_Divisions_Label(div))
% colorbar('Location','southoutside')
colorbar('Location','eastoutside')

subplot(Div,4,2+(div-1)*Div)
topoplot( MRCP2_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim2(div,:)=caxis; axis tight
if plotTitle, title(tinstLabels{2}),end
colorbar('Location','eastoutside')

subplot(Div,4,3+(div-1)*Div)
topoplot( MRCP3_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim3(div,:)=caxis; axis tight
if plotTitle, title(tinstLabels{3}),end
colorbar('Location','eastoutside')

subplot(Div,4,4+(div-1)*Div)
topoplot( MRCP4_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim4(div,:)=caxis; axis tight
if plotTitle, title(tinstLabels{4}),end
colorbar('Location','eastoutside')

plotTitle=0;

end

% % mLim = min([lim1 lim2 lim3 lim4]);
% % MLim = max([lim1 lim2 lim3 lim4]);
mLim = min([lim1 lim2 lim3 lim4]'); % Using normalization for each row
MLim = max([lim1 lim2 lim3 lim4]'); % Using normalization for each row
% mLim = min(mLim); % Using normalization for all the plots
% MLim = max(MLim); % Using normalization for all the plots

% subplot(Div,4,1+(div-1)*Div),caxis([mLim MLim])
% subplot(Div,4,2+(div-1)*Div),caxis([mLim MLim])
% subplot(Div,4,3+(div-1)*Div),caxis([mLim MLim])
% subplot(Div,4,4+(div-1)*Div),caxis([mLim MLim])


plotTitle=1;

figure
set(gcf, 'WindowState', 'maximized');

for div = 1:Div

subplot(Div,4,1+(div-1)*Div)
topoplot( MRCP1_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); caxis([mLim(1) MLim(1)])
if plotTitle, title(tinstLabels{1}),end
colorbar('Location','eastoutside')

subplot(Div,4,2+(div-1)*Div)
topoplot( MRCP2_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); caxis([mLim(2) MLim(2)])
if plotTitle, title(tinstLabels{2}),end
colorbar('Location','eastoutside')

subplot(Div,4,3+(div-1)*Div)
topoplot( MRCP3_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); caxis([mLim(3) MLim(3)])
if plotTitle, title(tinstLabels{3}),end
colorbar('Location','eastoutside')

subplot(Div,4,4+(div-1)*Div)
topoplot( MRCP4_Mean2{div}, chanlocs, 'verbose', ...
    'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); caxis([mLim(4) MLim(4)])
if plotTitle, title(tinstLabels{4}),end
colorbar('Location','eastoutside')


plotTitle=0;

end

end

catch ME
    stop=1
    disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
%     disp(ME.stack.name)
%     disp(ME.stack.line)
end

% --------------------------------------------------------------------
function ME_MRCP_MEAN_Callback(hObject, eventdata, handles)
% hObject    handle to ME_MRCP_MEAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.endInfo,'String','Processing MRCP Mean...')
Fs = 600;

flagPlot=get(handles.MEplots,'Checked');
switch flagPlot
    case 'off'
        flagPlot=false;
    case 'on'
        flagPlot=true;
end

global pathname Information

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','...')

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple session files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

fprintf(['============================================', ...
    '\nMRCP Mean processing... \n============================================\n'])


for ff=1:length(Datafile)
    
variableInfo = who('-file', Datafile{ff});

% if ~ismember('EEGv', variableInfo) 
%     warndlg('Variable from session was not found','File wrong!')
%     return
% end

load(Datafile{ff})
disp(['Session loaded: ', filename{ff}])


% % MRCP_Ch_ep_Full{suj} = MRCP(EEGv,handles);
% MRCPsubj{ff} = MRCP_ep_FullCH;
MRCPsubj{ff} = MRCP_ep_Mean;


end
fprintf(['============================================', ...
    '\nMRCP Files Loaded! \n============================================\n'])

% MRCP_ep_FullCH{div}(ch,ep,samp)
tinst = parameters.time_instants;
tep = parameters.time_range;

for div = 1:length(MRCPsubj{1})
    MRCP_M_Excel{div} = [];
    for ch=1:size(MRCPsubj{1}{1},1)
        for s = 1 : length(MRCPsubj)
            clear data_ep 
            try
%             data_ep(:,:) = MRCPsubj{s}{div}(ch,:,:);
%             MRCP_Ch_ep_Msuj{div}(ch,s,:) = mean(data_ep(:,:),1);
            % data_ep(:,:) = MRCPsubj{s}{div}(ch,:);
            % MRCP_Ch_ep_Msuj{div}(ch,s,:) = mean(data_ep(:,:),1);
            MRCP_Ch_ep_Msuj{div}(ch,s,:) = MRCPsubj{s}{div}(ch,:);
            MRCP_Ch_ep_MsujP{div}(ch,s,1) = mean(MRCP_Ch_ep_Msuj{div}(ch,s,((tinst(1,1)-tep(1))*Fs+1:(tinst(1,2)-tep(1))*Fs)));
            MRCP_Ch_ep_MsujP{div}(ch,s,2) = mean(MRCP_Ch_ep_Msuj{div}(ch,s,((tinst(2,1)-tep(1))*Fs+1:(tinst(2,2)-tep(1))*Fs)));
            MRCP_Ch_ep_MsujP{div}(ch,s,3) = mean(MRCP_Ch_ep_Msuj{div}(ch,s,((tinst(3,1)-tep(1))*Fs+1:(tinst(3,2)-tep(1))*Fs)));
            MRCP_Ch_ep_MsujP{div}(ch,s,4) = mean(MRCP_Ch_ep_Msuj{div}(ch,s,((tinst(4,1)-tep(1))*Fs+1:(tinst(4,2)-tep(1))*Fs)));
            
            
            catch ME
                stop=1;
                disp(['ERROR in ',ME.stack(1).name,'. Line: ',num2str(ME.stack(1).line),' => ', ME.message])
            end
        end
        ddd(:,:) = MRCP_Ch_ep_MsujP{div}(ch,:,:);
        datamean{div}(ch,:) = mean (MRCP_Ch_ep_Msuj{div}(ch,:,:));
        MRCP_M_Excel{div} = [MRCP_M_Excel{div}; ddd];
        clear ddd
    end
    fprintf(['============================================', ...
        '\nDiv',num2str(div),' - Seg:1 - Subject X Channel\n'])
    A(:,:)=MRCP_Ch_ep_MsujP{div}(:,:,1);
    disp(A')
    fprintf(['============================================', ...
        '\nDiv',num2str(div),' - Seg:2 - Subject X Channel\n'])
    A(:,:)=MRCP_Ch_ep_MsujP{div}(:,:,2);
    disp(A')
    fprintf(['============================================', ...
        '\nDiv',num2str(div),' - Seg:3 - Subject X Channel\n'])
    A(:,:)=MRCP_Ch_ep_MsujP{div}(:,:,1);
    disp(A')
    fprintf(['============================================', ...
        '\nDiv',num2str(div),' - Seg:4 - Subject X Channel\n'])
    A(:,:)=MRCP_Ch_ep_MsujP{div}(:,:,1);
    disp(A')
    fprintf(['============================================\n'])
end

clear A

fprintf(['============================================', ...
    '\nMRCP Mean completed! \n============================================\n'])

% SetCH={'1. F7','2. T3','3. T5','4. Fp1','5. F3','6. C3','7. P3',...
%     '8. O1','9. F8','10.T4','11.T6','12.Fp2','13.F4','14.C4','15.P4',...
%     '16.O2','17.Fz','18.Cz','19.Pz','20.Oz','A1','A2'}; %'FOTO','Annotations';...

% tep = [-1.5 0.5]*Fs; % Full MRCP segment

switch get(handles.MEMapNorm,'Checked')
    case 'off'
        NormF=false;
    case 'on'
        NormF=true;
end

if flagPlot
    for div=1:length(MRCPsubj{1})
        Plot_MRCP(datamean{div},[],Fs,[],[],parameters,NormF)
    end
end
% MRCP_ep = MRCP(EEGv,handles);

save (fullfile(pathname, 'MRCP_Mean.mat'),'MRCP_Ch_ep_Msuj','MRCP_Ch_ep_MsujP','MRCP_M_Excel','parameters')

set(handles.endInfo,'String','MRCP completed!')
% addlistInformation(handles,'MRCP applied')
% saveData(handles,'','_MRCP')

% --------------------------------------------------------------------
function ME_MRCPplot_Callback(hObject, eventdata, handles)
% hObject    handle to ME_MRCPplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname Information

if ~ischar(pathname)
    pathname='';
end

set(handles.endInfo,'String','...')

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple session files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
   return
end
pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for ff=1:length(Datafile)
    
load(Datafile{ff})
disp(['File loaded: ', filename{ff}])

Fs = 600;
% nCH = size(MRCP_Ch_ep_Msuj{1},1);
% for div=1:length(MRCP_Ch_ep_Msuj)
%     Plot_MRCP(MRCP_Ch_ep_Msuj{div},[],Fs,[],[])
% end

if exist('MRCP_Ch_ep_Msuj','var')
    for div = 1:length(MRCP_Ch_ep_Msuj)
        for ch=1:size(MRCP_Ch_ep_Msuj{1},1)
            datamean{div}(ch,:) = mean (MRCP_Ch_ep_Msuj{div}(ch,:,:));
        end
    end
else
    
% MRCP_ep_FullCH{div}(ch,ep,samp)
if exist('MRCP_ep_FullCH','var')
    for div = 1:length(MRCP_ep_FullCH)
        for ch=1:size(MRCP_ep_FullCH{1},1)
            datamean{div}(ch,:) = mean (MRCP_ep_FullCH{div}(ch,:,:));
        end
    end
end
end

switch get(handles.MEMapNorm,'Checked')
    case 'off'
        NormF=false;
    case 'on'
        NormF=true;
end
for div=1:length(datamean)
    Plot_MRCP(datamean{div},[],Fs,[],[],parameters,NormF)
end
pause(0.001)
clear datamean
end

% --------------------------------------------------------------------
function ME_ERP_Callback(hObject, eventdata, handles)
% hObject    handle to ME_ERP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ScalpMaps()

nInst=Inst(jj);
subplot(AxVert,AxHorz,k)

%                 if nTest==1 & jj==1
%                     title([strcat('Sub',num2str(sub),'_',Bandtext(band)),newline,InstLabel{Inst(jj)}],'Interpreter', 'none'), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold')
%                     title([strcat('Sub',num2str(sub),'_',Bandtext(band),' : ',InstLabel{nInst})],'Interpreter', 'none'), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold')
%                 else
%                     title(['',newline,InstLabel{nInst}]), ylabel(TestLabel{nTest},'Visible','on','FontWeight','bold','Interpreter', 'none')
%                 end
%                 title(['',newline,TestLabel{nTest}]), ylabel(InstLabel{Inst(jj)},'Visible','on','FontWeight','bold')
try
%                     figure(f{sub})
    topoplot( PSDband{nTest,Inst(jj)}(band,:,sub), chanlocs, 'verbose', ...
      'off', 'style' , 'straight', 'electrodes','off','chaninfo', chaninfo,'maplimits','maxmin'); lim=caxis; axis tight
%                   topoplot( PSDband{nTest,Inst(jj)}(band,:,sub), chanlocs, 'verbose', ...
%                       'off', 'style' , 'straight','shading','interp', 'chaninfo', chaninfo,'maplimits','maxmin'); lim=caxis; axis tight
catch ME
    disp(['ERROR Subj: ',num2str(sub),'Item:',num2str(k),ME.stack(1).name,' Line: ',num2str(ME.stack(1).line),':', ME.message])
    if strcmp(ME.message(1:18), 'Undefined function')
        errordlg('Must open EEGLab before!','Error')
        return
    end
end

lim=caxis;
lim1(nTest,jj)=lim(1);
lim2(nTest,jj)=lim(2);
k=k+1;
pause(.1)


function [trms,Frms] = RMSvalue (sig,Fs,w,shiftw)

% Initial conditions
l=length(sig);
i=1;
j=1;
NumW=round(l/shiftw);
Frms=[];

%%
for i=1:NumW
    if j+(w-1)<=length(sig)
        sigw=sig(j:j+(w-1),:); % Extract data of the window from the signal

        % Root Mean Square RMS                          
        Frms=[Frms; rms(sigw)]; % Concatenate the values from the windows

        j=j+shiftw;
    else
        disp('This window has been discarded due to it is shorter than the selected size');
    end
        
end

trms=[floor(w/2):shiftw:l-w/2]/Fs;


function dataf=EMGFilter(data,Fs,flag)
%     'D:\Work1\EMG Analysis\Fadiga\Interfaz V2\Dados John\EMG Delsys Pós\Alta densidade\Sujeitos\RMS\EJD_Lorena_Plot_and_Store_Rep_1.38._filtered_RMS_MVC.mat'

Nchannel=size(data,2);

try 
clear dataf 
for ch=1:Nchannel
% %     espectro(data(:,ch),Fs,1);
    n=2;
    cut=25;
    [z,p,k] = butter(n,cut/(Fs/2),'high');
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,data(:,ch));
%     espectro(dataf(:,ch),Fs,1);

    n=10;
    cut=300;
    [z,p,k] = butter(n,cut/(Fs/2));
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,dataf(:,ch));
%     espectro(dataf(:,ch),Fs,flag);

    n=1;
    cut=[58 62];
    [z,p,k] = butter(n,cut/(Fs/2),'stop');
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,dataf(:,ch));
    espectro(dataf(:,ch),Fs,flag);
end


    
for ch=1:Nchannel
    dataf(:,ch)=dataf(:,ch)-mean(dataf(:,ch));
end

clear data
 

catch
    disp(['Error in filtering. Subject '])%,num2str(sub),', Rep: ',TT])
end


function percConserveComp_Callback(hObject, eventdata, handles)
% hObject    handle to percConserveComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percConserveComp as text
%        str2double(get(hObject,'String')) returns contents of percConserveComp as a double


% --- Executes during object creation, after setting all properties.
function percConserveComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percConserveComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ME_View_Synchronism_Callback(hObject, eventdata, handles)
% hObject    handle to ME_View_Synchronism (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Properties_Listbox.
function Properties_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Properties_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Properties_Listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Properties_Listbox


% --- Executes during object creation, after setting all properties.
function Properties_Listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Properties_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Times_Divisions_Callback(hObject, eventdata, handles)
% hObject    handle to Times_Divisions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Times_Divisions as text
%        str2double(get(hObject,'String')) returns contents of Times_Divisions as a double


% --- Executes during object creation, after setting all properties.
function Times_Divisions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Times_Divisions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Event_source.
function Event_source_Callback(hObject, eventdata, handles)
% hObject    handle to Event_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Event_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Event_source


% --- Executes during object creation, after setting all properties.
function Event_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Event_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [events_s,events_e] = flagEventFnc(EEGv,handles,stSamp)

hiddenPlots=get(handles.MEhiddenPlots,'Checked');
switch hiddenPlots
    case 'off'
        hiddenPlots=false;
    case 'on'
        hiddenPlots=true;
end

% IF EVENT IS EMPTY
if EEGv.ProcessApplied.RemSeg
%     retain_intervals = reshape(find(diff([EEGv.etc.clean_sample_mask])),2,[])';
%     events_s=retain_intervals(:,1);
%     events_e=retain_intervals(:,2);
    
    retain_intervals=find(diff([EEGv.etc.clean_sample_mask]));
    events_s=find(diff([EEGv.etc.clean_sample_mask])<0); % Start of clean segment
    events_e=find(diff([EEGv.etc.clean_sample_mask])>0); % End of clean segment
    if EEGv.etc.clean_sample_mask(1)==0 % When sart with a rejected segment
        events_s=[1 events_s];
    end
    if EEGv.etc.clean_sample_mask(end)==0 % When sart with a rejected segment
        events_e=[events_e length(EEGv.etc.clean_sample_mask)];
    end
%     if rem(length(retain_intervals),2), retain_intervals=retain_intervals(1:end-1); end
%     events_s=retain_intervals(1:2:end); % Start of clean segment
%     events_e=retain_intervals(2:2:end); % End of clean segment
    Clean_Segments=(events_s(2:end)-events_e(1:end-1))/EEGv.srate;
    [m,ind1]=min(abs(events_s-stSamp));
    
    if hiddenPlots
        figure, hold on
        plot(EEGv.times/1000,~EEGv.etc.clean_sample_mask*100,'r') 
        plot(EEGv.times/1000,abs(EEGv.data'),'b')
        plot(EEGv.times/1000,~EEGv.etc.clean_sample_mask*100,'r') 
        xlabel('Seconds [s]'), ylabel('Amplitude [V]'), legend ({'EEG','Removed Segments'})
%         axis([EEGv.times(end)/1000-epochsize/Fs EEGv.times(end)/1000 0 200])
    end
%     if ~isempty(EEGv.event)
% 
%     events_s=round([EEGv.event.latency]);
%     events_e=round(events_s+[EEGv.event.duration]);
%     events=zeros(size(data,1),1);
%     events1=zeros(size(data,1),1);
%     for i=1:length(events_s)
%         events(events_s(i):events_e(i))=events_s(i):events_e(i);
%         events1(events_s(i):events_e(i))=1;
%     end
%     if hiddenPlots
%     figure, plot(data(:,1))
%     hold on, plot(events1*max(data(:,1)))
%     title('Segments removed')
%     end
%     
%     else
%         events_s=[]; events_e=[];
%     end
else
    events_s=[]; events_e=[];
end
