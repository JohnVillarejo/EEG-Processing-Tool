function EEGv=PSDpwelchBK(EEGv)

epochs = EEGv.dataEpoch;
epochsize=EEGv.epochsize;
Fs=EEGv.Fs;
SetCH=EEGv.Props.SetCH;
SetCHgr=EEGv.Props.SetCHgr;
%%
% % Alternatives for pwelch
% Nx = size(EEGv.data,2);
% nsc = floor(floor(Nx/Fs));
% nov = floor(nsc/2);
% nff = max(256,2^nextpow2(nsc));
% [pxx0,f2] = pwelch(EEGv.data,hamming(nsc),nov,nff,Fs);

%[pxx,f,pxxc] = pwelch(epoch{ep}(:,1),[],[],[],Fs,'ConfidenceLevel',0.95); % title('Welch Estimate with 95%-Confidence Bounds')

% % 1.
% for k=1:length(epochs)
%     [pxx1{k},f] = pwelch(epochs{k},hamming(epochsize),[],[],Fs); 
%     pxxLog1{k}=pow2db(pxx1{k});
% end
% % 2.
% for k=1:length(epochs)
%     [pxx2{k},f] = pwelch(epochs{k},hamming(epochsize),1,[],Fs); 
%     pxxLog2{k}=pow2db(pxx2{k});
% end
% 3.
[nm,~]=size(epochs{1}); %numero de muestras 
% Nfreq=round(nm/2);
for k=1:length(epochs)
    temp=fft(epochs{k});
    temp = temp(1:nm/2+1,:);
    temp(2:end-1,:)=2*temp(2:end-1,:);
    pxx{k} = 1/(nm*Fs)*abs(temp).^2;
    pxxLog{k}=pow2db(pxx{k});
end
delta=Fs/nm; 
f= 0:delta:Fs/2; 
% 4.
% pxx4=psd(spectrum.periodogram,epochs{1},'Fs',Fs,'NFFT',nm);
% figure, plot(psd(spectrum.periodogram,epochs{1}(:,1),'Fs',Fs,'NFFT',nm));

% figure, hold on
% plot(f,pxx1{1}(:,1)),plot(f,pxx2{1}(:,1)), plot(f3,pxx3{1}(:,1))
% figure, hold on
% plot(f,pxxLog1{1}(:,1)),plot(f,pxxLog2{1}(:,1)), plot(f3,pxxLog3{1}(:,1)), plot(f3,pxxLog3{1}(:,1))

% [pxx,f] = pwelch(EEGv.data,hamming(200*2),100,[],Fs); 
% pxxLog{k}=pow2db(pxx{k});

% plot(f,10*log10(pxx{k})) % PSD(dB/Hz)/Magnitude(dB) plot(f,pow2db(pxx)) Power (dB)

%%
% nSets=unique(cell2mat(SetCH(2,:)));
% FreqBands=[4 7; 8 12; 8 10; 10 12; 13 30; 13 18; 18 30; 30 Fs/2];
FreqBands=[4 7; 8 12; 8 10; 10 12; 13 30; 13 18; 18 30; 30 Fs/2; 4 30]; % Relative 4:30 para normalizar
% FreqBands=[4 7; 13 30; 13 21; 21 30; 8 12; 8 10; 10 12; 30 Fs/2];
Nbands=size(FreqBands,1);
nEp=length(epochs);
CH=1:20;

CHpxx={};
clear Mpxx PSDband
for j=1:length(CH)
    ch=CH(j); 

    chpxx=[];
    for ep=1:nEp
        chpxx=[chpxx pxx{ep}(:,ch)]; % PSD samp x epoch
    end
    chpxx(find(chpxx==-Inf))=nan;
    CHpxx{ch}=chpxx;
    [m,tiAll]=min(abs(f-FreqBands(end,1))); % Index for low Band border 
    [m,tfAll]=min(abs(f-FreqBands(end,2))); % Index for high Band border 
    Mpxx(:,ch)=nanmean(chpxx,2); % PSDmean samp x ch : mean(epochs)
%     Mpxx(1:end-1,ch)=Mpxx(1:end-1,ch)/mean(Mpxx(tiAll:tfAll,ch)); % Normalization
    for bands=1:Nbands
        [m,ti]=min(abs(f-FreqBands(bands,1))); % Index for low Band border 
        [m,tf]=min(abs(f-FreqBands(bands,2))); % Index for high Band border 
%         PSDband(bands,ch)=mean(Mpxx(ti:tf,ch))/mean(Mpxx(tiAll:tfAll,ch)); 
        PSDband(bands,ch)=mean(Mpxx(ti:tf,ch)); 
%         PSDbandLog(bands,ch)=mean(Mpxx(ti:tf,ch)); 
%         figure, plot(f(ti:tf),Mpxx(ti:tf,ch))
    end
    PSDband(1:end-1,ch)=PSDband(1:end-1,ch)/mean(Mpxx(tiAll:tfAll,ch)); % Normalization
end

PSDband(Nbands+1,:)=PSDband(1,:)./PSDband(5,:); % Teta/Beta 
PSDband(Nbands+2,:)=PSDband(1,:)./PSDband(6,:); % Teta/BetaL 
PSDband(Nbands+3,:)=PSDband(1,:)./PSDband(7,:); % Teta/BetaH

k=1;
for ii=1:size(SetCHgr,1)
    nSets=unique(SetCHgr(ii,:)); % To find the grops
    nSets(find(~nSets))=[];      % To delete '0' from groups
    for sch=1:length(nSets)
        is=find(SetCHgr(ii,:)==sch);
        temp=[];
        for j=1:length(is)
            temp(:,j)=[PSDband(:,is(j))];
        end
        PSDbandSets(:,k)=mean(temp,2);
        k=k+1;
    end
end

PSDbandSets(Nbands+1,:)=PSDbandSets(1,:)./PSDbandSets(5,:); % Teta/Beta 
PSDbandSets(Nbands+2,:)=PSDbandSets(1,:)./PSDbandSets(6,:); % Teta/BetaL 
PSDbandSets(Nbands+3,:)=PSDbandSets(1,:)./PSDbandSets(7,:); % Teta/BetaH

% for sch=1:length(nSets)
%     is=find(cell2mat(SetCH(2,:))==sch);
%     temp=[];
%     for j=1:length(is)
%         temp(:,j)=[PSDband(:,is(j))];
%     end
%     PSDbandSets(:,sch)=mean(temp,2);
% end

%% Log

CHpxxL={};
clear MpxxL
for j=1:length(CH)
    ch=CH(j); 

    chpxxL=[];
    for ep=1:nEp
        chpxxL=[chpxxL pxxLog{ep}(:,ch)]; % PSD samp x epoch
    end
    chpxxL(find(chpxxL==-Inf))=nan;
    CHpxxL{ch}=chpxxL;
    [m,tiAll]=min(abs(f-FreqBands(end,1))); % Index for low Band border 
    [m,tfAll]=min(abs(f-FreqBands(end,2))); % Index for high Band border 
    MpxxL(:,ch)=nanmean(chpxxL,2); % PDSmean samp x ch : mean(epochs)
%     MpxxL(1:end-1,ch)=MpxxL(1:end-1,ch)/mean(MpxxL(tiAll:tfAll,ch)); % Normalization
    for bands=1:8
        [m,ti]=min(abs(f-FreqBands(bands,1))); % Index for low Band border 
        [m,tf]=min(abs(f-FreqBands(bands,2))); % Index for high Band border 
        
%         PSDband(bands,ch)=mean(Mpxx(ti:tf,ch)); 
%         PSDbandLog(bands,ch)=mean(MpxxL(ti:tf,ch))/mean(MpxxL(tiAll:tfAll,ch)); 
        PSDbandLog(bands,ch)=mean(MpxxL(ti:tf,ch)); 
%         figure, plot(f(ti:tf),Mpxx(ti:tf,ch))
    end
    PSDbandLog(1:end-1,ch)=PSDbandLog(1:end-1,ch)/mean(MpxxL(tiAll:tfAll,ch)); % Normalization
end

PSDbandLog(Nbands+1,:)=PSDbandLog(1,:)./PSDbandLog(5,:); % Teta/Beta 
PSDbandLog(Nbands+2,:)=PSDbandLog(1,:)./PSDbandLog(6,:); % Teta/BetaL 
PSDbandLog(Nbands+3,:)=PSDbandLog(1,:)./PSDbandLog(7,:); % Teta/BetaH

k=1;
for ii=1:size(SetCHgr,1)
    nSets=unique(SetCHgr(ii,:)); % To find the grops
    nSets(find(~nSets))=[];      % To delete '0' from groups
    for sch=1:length(nSets)
        is=find(SetCHgr(ii,:)==sch);
        temp=[];
        for j=1:length(is)
            temp(:,j)=[PSDbandLog(:,is(j))];
        end
        PSDbandLogSets(:,k)=mean(temp,2);
        k=k+1;
    end
end

PSDbandLogSets(Nbands+1,:)=PSDbandLogSets(1,:)./PSDbandLogSets(5,:); % Teta/Beta 
PSDbandLogSets(Nbands+2,:)=PSDbandLogSets(1,:)./PSDbandLogSets(6,:); % Teta/BetaL 
PSDbandLogSets(Nbands+3,:)=PSDbandLogSets(1,:)./PSDbandLogSets(7,:); % Teta/BetaH

% for sch=1:length(nSets)
%     is=find(cell2mat(SetCH(2,:))==sch);
% 
%     temp=[];
%     for j=1:length(is)
%         temp(:,j)=[PSDbandLog(:,is(j))];
%     end
%     PSDbandLogSets(:,sch)=mean(temp,2);
% 
% end
%%
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

EEGv.PSD.pxx=pxx;                       % PSD samp x epochs
% EEGv.PSD.pxxLog=pxxLog;                 % PSD samp x epochs
EEGv.PSD.CHpxx=CHpxx;                   % PSD samp x channel

EEGv.PSD.PSDband=PSDband;               % PSD band x channel
EEGv.PSD.PSDbandLog=PSDbandLog;         % PSD band x channel Log
EEGv.PSD.PSDbandSets=PSDbandSets;       % PSD band x EEG regions
EEGv.PSD.PSDbandLogSets=PSDbandLogSets; % PSD band x EEG regions Log

EEGv.PSD.Bandtext={'Theta','Alpha','Alpha Low','Alpha High','Beta','Beta Low',...
    'Beta High','Gama','4-30Hz','Teta/Beta','Teta/BetaL','Teta/BetaH'};
EEGv.PSD.PSDTypes={'Normal','Log','Regions','Log_Regions'};
EEGv.PSD.SetsLabel=SetsLabel;

% Props.File=File;
% Props.Subject=sub;
% Props.Test=test;
% Props.Instance=instantTest;

% SubFile=fullfile(pathname,strcat(num2str(sub,'%02.f'),test,'_',TypeTest,'.mat'));

% save(SubFile,'iTimes', 'epochs', 'epRej', 'pxx', 'pxxRej', 'f', 'Props')