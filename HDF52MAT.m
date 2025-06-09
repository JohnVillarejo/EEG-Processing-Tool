global pathname

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.hdf5','MAT Files (*.hdf5)';
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

%%
for ff=1:length(Datafile)
    sync=[]; clear EEGchannels data
    clear EEGchannels
    datastruct = ghdf5fileimport(Datafile{ff});
%     disp(['File imported: ',Datafile{ff}])
    disp(['You Selected:', filename{ff}])
    
    data = datastruct.RawData.Samples;
    try, sync = datastruct.AsynchronData.Time; end
    
    Fs = datastruct.RawData.AcquisitionTaskDescription.SamplingFrequency;
    [a,b]=size(datastruct.RawData.AcquisitionTaskDescription.ChannelProperties.ChannelProperties);
    for ii=1:b
    EEGchannels{ii} = [datastruct.RawData.AcquisitionTaskDescription.ChannelProperties.ChannelProperties(ii).ChannelName];
    end
            
%     sync=data(end,:);
%     data=data(1:end-1,:);   
    % t=(1:1:size(data,2))/Fs;

    Datafilei=fullfile(pathname,strcat(filename{ff}(1:end-4),'.mat'));
    save(Datafilei,'data','Fs','EEGchannels','sync')
    disp(['Saved: ',Datafilei])

end

