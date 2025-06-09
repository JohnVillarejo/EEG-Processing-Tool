global pathname

if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)
   disp('Selection canceled')
   return
end 

oldFolder = cd(pathname);
ldir=dir ('*.PLG');  % Leitura de arquivos com extensão PLG
cd(oldFolder);

name={ldir.name};
name=name';

for ifile=1:length(name)

    Datafile=fullfile(pathname, name{ifile});
    disp(['You Selected:', name{ifile}])

    cuts=[];    
    [data,Fs,EEGchannels]=open_file(Datafile);

    sync=data(end,:);
    data=data(1:end-1,:);   
    t=(1:1:size(data,2))/Fs;

    Datafile=fullfile(pathname,strcat(name{ifile}(1:end-4),'.mat'));
    save(Datafile,'data','Fs','EEGchannels','t','sync')
    disp(['Saved: ',Datafile])

end

