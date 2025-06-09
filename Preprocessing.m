% Filters_Bands % This is not more used
% Pre_processing
% dataf=Filtering(EEG.ProcessApplied,data,0);
% Initial conditions 

try
% Low-pass 30 Hz
if EEGv.TaskProcess.LP
    n=2;
%     cut=30;
    cut=str2num(get(handles.Filterlp,'String'));
    [z,p,k] = butter(n,cut/(Fs/2));
%     [z,p,k] = cheby2(24,100,30/(Fs/2));
    [b,a] = zp2tf(z,p,k);
%     figure,freqz(b,a,100)
    data(:,1:EEGv.Nchannels) = filtfilt(b,a,data(:,1:EEGv.Nchannels));    
    EEGv.ProcessApplied.HP=1;
    LPf.n = n;
    LPf.cut = cut;
end

catch
    stop=1;
end

if EEGv.TaskProcess.HP
    % High-pass 0.5 Hz
    n=2; % n=2 for cut = 0.01 Hz
    cut=0.5; % 1;
    cut=str2num(get(handles.Filterhp,'String'));
    [z,p,k] = butter(n,cut/(Fs/2),'high');
%     [z,p,k] = cheby2(24,60,1/(Fs/2),'high');
    [b,a] = zp2tf(z,p,k);
%     figure,freqz(b,a,100)
    data(:,1:EEGv.Nchannels) = filtfilt(b,a,data(:,1:EEGv.Nchannels));

    % % Passa-alta 3
    % n=10;
    % cut=3;
    % [z,p,k] = butter(n,cut/(Fs/2),'high');
    % [b,a] = zp2tf(z,p,k);
    % figure,freqz(b,a,100)
    % data = filtfilt(b,a,data);
    EEGv.ProcessApplied.LP=1;
    HPf.n = n;
    HPf.cut = cut;
end

if EEGv.TaskProcess.Notch
    % Filter Notch
    for ch=1:Nelectrodes
        data(:,ch) = NotchFilter(data(:,ch));
    end
end
    
if EEGv.TaskProcess.Detrend
    % Detrend
    data(:,1:EEGv.Nchannels)=detrend(data(:,1:EEGv.Nchannels));

    % Detrend per epoch
    % dataD2=[];epp=1;
    % while epp<Nsamples-epochsize+1
    %     dataD2=[dataD2; detrend(data(epp:epp+epochsize-1,:),0)];
    %     epp = epp + epochsize;   
    % end
    % figure,ax=gca;plotEEG(ax,dataD2(1:122400,:),Fs,SetCH,[0 2 1e-4])
    EEGv.ProcessApplied.Detrend=1;
end


if hiddenPlots
    % Spectral Frequency
    [eje_f,mag_ss]=espectro(data(:,1:EEGv.Nchannels),Fs,1);
end
