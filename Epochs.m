%% Epochs
% Apply all filters before this section

%% Identification of file with events
% ================================
% nfileEvents
% 1 -> pre control: 40 m        6-10 s
% 2 -> pre st: 10 m             last 4 min
% 3 -> pre stroop: 10 m         last 4 min
% 4 -> stroop control: 40 m     last 4 min
% 5 -> stroop st: X             last 4 min
% 6 -> stroop stroop: X         last 4 min


% %% Initial conditions
% 
% % [Nsamples,Nchannels] =size(data);
% if get(handles.chkTimeProcess,'Value')
%     st_t=str2num(get(handles.TimeP1,'String'));
%     end_t=str2num(get(handles.TimeP2,'String'));
%     
%     
% %% Times for processing
% etr=20*Fs; % time discarded: 20 s
% tp=4*60*Fs; % Time for processing: 4 min
% 
% for ss=1:length(st_t)
% 
% if st_t(ss)>=0
% 
% stSamp(ss) = st_t(ss)*60*Fs + etr; % First sample for processing
% endSamp(ss) = stSamp(ss) + tp; % Last sample for processing
% 
% else
% 
% endSamp(ss) = Nsamples - etr; % Last sample for processing
% stSamp(ss) = endSamp(ss) - tp; % First sample for processing
%     
% end
% 
% end
% 
% else
%     stSamp=EEGv.TimeParam.stSamp;
%     endSamp=EEGv.TimeParam.endSamp;
% end

% for ss=1:length(stSamp)

iSamp=1;
num_epoch=0;
            
epochs={};
dataEpoch=[];
remEvt=1; % To select epochs by avoiding blinks or removing full epochs: 1: Remove Blinks or 0: full epochs
k=0;jj=0;kk=0;
epRej={};

blinkSamp=[];
tblink=1;
Clean_Segments=[];
% slidew=round(epochsize/2);

% for i=1:length(EEGv.event)
%     if strcmp(EEGv.event(1).type,'boundary')
%         si=round(EEGv.event(1).latency);
%         se=si+EEGv.event(1).duration;
%         EEGv.dataPosRemSeg(:,si:se)=NaN;
%     end
% end
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
    Clean_Segments=(events_s(2:end)-events_e(1:end-1))/Fs;
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

if hiddenPlots,figure, hold on, end


while stSamp < endSamp-epochsize
    kk=kk+1;
%     try
%     diffSamp = events_s-stSamp;
%     ind=find(abs(diffSamp)<epochsize); % event around the epoch
%     ind=find(diffSamp<epochsize & diffSamp>0); % blink into the epoch

    
%     [m,ind]=min(abs(events_s-stSamp));
%     flagevent=(events_e(ind) > stSamp && stSamp > events_s(ind)) % start inside event
%     if stSamp > events_s(ind), ind=ind+1; end % Start after detected event
%     if ~flagevent && stSamp+epochsize > events_s(ind) % nex event is close
%         flagevent=true
%     end

%     [flagevent,ind]=detectEvent(stSamp,events_s,events_e,epochsize);
    
    if EEGv.ProcessApplied.RemSeg
%         flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(stSamp:stSamp+epochsize-1),1));
        flagevent=~isempty(find(~EEGv.etc.clean_sample_mask(stSamp:stSamp+epochsize-1)));
        [m,ind]=min(abs(events_s-stSamp));
    else
        flagevent=false;
    end
    
    if flagevent
        jj=jj+1;
%         events_s(ind)=stSamp;
%         ind=ind(1); %Not necessary
        try
        if hiddenPlots
            plot(stSamp,1,'or'), plot(stSamp+epochsize-1,1,'*r'), plot([events_s(ind) events_e(ind)],[1 1],'k') % To plot time of rejected events
            xlabel('Samples'), title('Removed segments'), %legend({'Initial sample','Semengt'})
        end 
        end
        
        if remEvt
            stSamp2=events_e(ind)+tblink; % Consider epoch after blink
        else
            stSamp2 = stSamp + slidew; % Full epoch discarded (overlapping)
        end
        
%         if stSamp+epochsize < endSamp
        if stSamp2 < endSamp
            try, epRej{jj}=data(stSamp:stSamp2,:); % Rejected segment plus the next epoch
            catch
                stop=1;
            end
%             [pxxRej{jj}] = pwelch(epRej{jj},[],[],[],Fs);
        else
            epRej{jj}=data(stSamp:endSamp,:); % Rejected segment plus the next epoch
        end
        
        stSamp=stSamp2;
        
        try
            events_s(1:ind)=[];
            events_e(1:ind)=[];
        end
        
    else
        k=k+1;
        iTimes{k}=stSamp:stSamp+epochsize-1;
        epochs{k}=data(iTimes{k},:); 

        epochs{k}=epochs{k}-mean(epochs{k},1);
        dataEpoch(:,:,k) = epochs{k}';
        
%         [pxx{k},f] = pwelch(epochs{k},hamming(epochsize),1,[],Fs);

        if hiddenPlots
            plot(stSamp,0,'ob') % To plot time of accepted events
            plot(stSamp+epochsize-1,0,'*b') % To plot time of accepted events
            plot([stSamp stSamp+epochsize-1],[0 0],'b') % To plot time of accepted events
            %legend({'Removed','Semengt','Accepted'})
        end 
        stSamp = stSamp + slidew;   
    end
%     catch ME
%         errordlg(['Error in line: ',num2str(ME.stack(1).line),' ',ME.stack(1).name,':', ME.message])
%     end
       
end


% EEGv.Props.Epochs.remEpochsEvents=remEvt;
% EEGv.Props.Epochs.nEpochs=k;
% EEGv.Props.Epochs.nEpochsRejected=jj;
% EEGv.Props.Epochs.Totaltime = datestr(seconds(length(epochs)*epochsize/Fs),'HH:MM:SS');
% 
% EEGv.Props.Process.OffsetRem=1;

if hiddenPlots
    % Plot of epochs by channel
    figure, hold on
    for i=1:length(epochs)
        plot(epochs{i}(:,2))
    end
    xlabel('Samples'), ylabel('Amplitude [V]'), title('Processed segments')
    % Plot of rejected segment plus next epoch
    figure, hold on
    for i=1:length(epRej)
        plot(epRej{i}(:,2))
    end
    xlabel('Samples'), ylabel('Amplitude [V]'), title('Removed segments')
end

if length(epochs)<50 & EEGv.ProcessApplied.RemSeg
%     E1=(events_s(2:end)-events_e(1:end-1))/Fs;
    figure;
    subplot(211), histogram(Clean_Segments);
    ylabel('Frequency'), xlabel('Continuos segments [s]'),title([EEGv.setname,'. Epochs:',num2str(length(epochs)),newline,'Total time'],'Interpreter', 'none')
    subplot(212), histogram(Clean_Segments(ind1:end));
    ylabel('Frequency'), xlabel('Clean segments [s]'),title('Processed time')
end

% end


function [flagevent,ind] = detectEvent(stSamp,events_s,events_e,epochsize)
flagevent=false;
ind=[];
if ~isempty(events_s)
    
[m,ind]=min(abs(events_s-stSamp));
flagevent=(events_e(ind) > stSamp && stSamp > events_s(ind)); % start inside event

if ~flagevent
    if stSamp > events_s(ind) && ind+1<length(events_s), ind=ind+1; end % Incremented when starts after detected event
    if stSamp+epochsize > events_s(ind) % nex event is close
        flagevent=true;
    end
end

end

end