% Separa Pre do Controle
%% Serial
global pathname
if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)

   disp('Selection canceled')
else
    
   
oldFolder = cd(pathname);
ldir=dir ('*.mat');  % Leitura de arquivos com extensão mat
cd(oldFolder);

name={ldir.name};
name=name';
% name([1:2])=[];

%% Initial conditions
PSDFull=[]; PSDFullM=[];

for ifile=1:length(name)

Datafile=fullfile(pathname, name{ifile});
load(Datafile)
try
if strcmp(name{ifile}(5:15),'pre_control')
    EEGvtemp = EEGv;
    Fs=EEGv.Fs;     % Sampling frequency
    etr=20*Fs;      % Final segment discarded: 20 s
    tp=4*60*Fs;     % Time for processing

    t10=60*10*Fs;   % 10mins*60sec*Fs

%     % Stroop
%     [Nelectrodes,Nsamples] =size(EEGv.data);
%     endSamp=Nsamples-etr;
%     stSamp=endSamp-tp;
%     
%     filename=strcat(name{ifile}(1:3),'_stroop_control_Raw.mat');
%     Datafile=fullfile(pathname,filename);
%     EEGv.filename=filename;
%     Information.filename=filename;
%     EEGv.TimeParam.stSamp=stSamp;
%     EEGv.TimeParam.endSamp=endSamp;
%     save(Datafile,'EEGv','Information')
%     disp(['File saved: ', filename])
    
    % Pre
%     EEGv.data=EEGvtemp.data(:,1:t10);
    EEGv.times=EEGv.times(1:t10);
    EEGv.pnts=t10;

    endSamp=t10;
    stSamp=endSamp-tp;    
    
    filename=strcat(name{ifile}(1:3),'_pre_control_Raw.mat');
    Datafile=fullfile(pathname,filename);
    EEGv.filename=filename;
    Information.filename=filename;
    EEGv.TimeParam.stSamp=stSamp;
    EEGv.TimeParam.endSamp=endSamp;
    save(Datafile,'EEGv','Information')
    disp(['File saved: ', filename])
end

catch
    
end


end

end