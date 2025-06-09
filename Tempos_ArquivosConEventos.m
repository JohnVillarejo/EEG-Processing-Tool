%% Usado para enviar os dados de tempo aos colaboradores da Italia

global pathname

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.MAT','MAT Files (*.MAT)'
    '*.PLG','MAT Files (*.PLG)';
    '*.*',  'All files (*.*)'}, ...
    'Select multiple PLG files',pathname,'MultiSelect','on');

if isequal(filename,0)

   disp('Selection canceled')
   return
end
pathname=pathname2;

Datafile=strcat(pathname,filename);

if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end
clear Times  
for ff=1:length(Datafile)
    
    load(Datafile{ff})
%     Time_onset_Contr = EEGv.events.Time_onset_Contr(:,1) +EEGv.events.EEG_0(1)/EEGv.srate;
%     Samp_onset_Contr_FullFile = Time_onset_Contr*EEGv.srate;
%     Times = [Samp_onset_Contr_FullFile Time_onset_Contr];


EEG_0 = EEGv.events.EEG_0;

Time_onset_Contr = EEGv.events.Time_onset_Contr(:,1) + EEG_0(1)/EEGv.srate;
Samp_onset_Contr = Time_onset_Contr*EEGv.srate;
Times{ff,1} = [Samp_onset_Contr, Time_onset_Contr];

Times{ff,2} = length(EEG_0);
Times{ff,3} = filename{ff};

end


save ('TimesforEvents','Times','Datafile')