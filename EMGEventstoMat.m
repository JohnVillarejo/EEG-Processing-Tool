% function EMGEventstoMat()
global pathname Information
clear Res_Events

Flag_fig = 0;

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple Data files',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
%    set(handles.endInfo,'String','')
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

load(Datafile{ff},'EMG_0','datafull','DataInformation','Fs')

Sub = str2num(filename{ff}(1:2));
ktest = str2num(filename{ff}(5));

%% Detect Event channel
S_source ='EMG VL';
lch=length(DataInformation);
flag=false;
indCH=[];

flagerror=0;
% S_source = get(handles.Event_source,'String');
% S_source = S_source{get(handles.Event_source,'Value')};

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

%%
% datafull = datafull(EMG_0:end,:);
% datafull(:,1) = datafull(:,1)-datafull(1,1);

Res_Events{Sub,ktest}{1} = EMG_0(1);

tbase = [5000 10000] + EMG_0(1);
v = datafull(:,indCH);

if Flag_fig, figure; hold on; end

if strcmp(S_source,'EMG VL')
    indCH = indCH(1);
    v=EMGFilter(datafull(:,indCH),Fs,0); % flag=0 to dont pictures
        
    [trms,vrms]=RMSvalue(abs(v),Fs,100,30);
    [~,a] = min(abs(trms-tbase(1)/Fs));
    [~,b] = min(abs(trms-tbase(2)/Fs));
    tbase=[a b];
    
    if Flag_fig
    plot(datafull(:,1),datafull(:,indCH),'c')
    plot(datafull(:,1),v)
    plot(trms,vrms,'r')
    end
    v=vrms; clear vrms

    baseline = mean(v(tbase(1):tbase(2)));
    baselineSTD = std(v(tbase(1):tbase(2)));

    TH = baseline+baselineSTD*30;

    syncPulse = zeros(1,length(v));
    syncPulse (find(v>TH))=1;
    if Flag_fig, plot(trms,syncPulse*1000,'g'), end

elseif strcmp(S_source,'Torque')
    
    baseline = mean(v(tbase(1):tbase(2)));
    baselineSTD = std(v(tbase(1):tbase(2)));

    % TH = baseline+baselineSTD*10;
    TH = baseline+2; % Adding 2 Nm

    syncPulse = zeros(1,length(v));
    syncPulse (find(v>TH))=1;
    if Flag_fig
    plot(datafull(:,1),syncPulse*3000,'--r')
    plot(datafull(:,1),datafull(:,2)*10,'--k')
    end
end

title(strcat('Subject: ',num2str(Sub),' - ',num2str(ktest)))

% To find samples for the events
syncPulseDiff = diff(syncPulse);
onset_Contr = find(syncPulseDiff==1);
offset_Contr = find(syncPulseDiff==-1);
% To find times for the events
Time_onset_Contr(1:length(onset_Contr),1) = datafull(onset_Contr,1);
Time_offset_Contr(1:length(offset_Contr),2) = datafull(offset_Contr,1);
Time_onset_Contr = Time_onset_Contr-datafull(EMG_0(1),1);

% To remove last sample if a zero value
Time_onset_Contr (find (Time_onset_Contr(:,1)==0),:) = [];
Time_offset_Contr (find (Time_offset_Contr(:,2)==0),:) = [];

Res_Events{Sub,ktest}{2} = Time_onset_Contr;
Res_Events{Sub,ktest}{3} = Time_offset_Contr;

end
