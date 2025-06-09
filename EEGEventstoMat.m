global pathname Datafile

%% EEG

if ~ischar(pathname)
    pathname='';
end
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.txt)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple TXT files',pathname,'MultiSelect','on');

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
data2=[];
for ff=1:length(Datafile)
    
    disp(['File Selected:', filename{ff}])
    load(Datafile{ff});
    
    Sub = str2num(filename{ff}(1:2));
    ktest = str2num(filename{ff}(end-4));

    EEG_0 = find(sync);

    if ~isempty(EEG_0)
        Res_Events{Sub,ktest}{2,1} = EEG_0(1);
%     EEG_0 = EEG_0(1);
    else
       disp(['Sync time saved:', filename{ff}])
    end
    
end
