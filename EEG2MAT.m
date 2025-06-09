global pathname

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.PLG','PLG Files (*.PLG)';
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

for ff=1:length(Datafile)
    
    cuts=[];    
    [data,Fs,EEGchannels]=open_file(Datafile{ff});
    disp(['You Selected:', filename{ff}])
    
    sync=data(end,:);
    data=data(1:end-1,:);   
    t=(1:1:size(data,2))/Fs;

    Datafilei=fullfile(pathname,strcat(filename{ff}(1:end-4),'.mat'));
    save(Datafilei,'data','Fs','EEGchannels','t','sync')
    disp(['Saved: ',Datafilei])

end
