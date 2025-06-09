%% Denis' Function
% calibration_set(channels,T,Trials): Es usado para calibrar el m�todo, y debe tener segmentos de 1 s a 5 s libres de artefactos, sumando aproximadamente 1 min. T es el periodo, Trials se refiera a cada segmento.
% 
% X_trials_offline(channels,T,Trials): Segmentos de 1 s a 5 s que deseados para procesar.
% 
% Fs: Frecuencia de muestreo.
% 
% ASR_method: indique "PCA" o "PGA". PCA se corresponde con ASR, y PGA con rASR (Modified ASR based on Riemannian geometry)
% 
% covariance_mean: indique "covariance_mean" usando PCA.
% 
% [data_ASR_offline] = ASR_filter(calibration_set,X_trials_offline,Fs,K,ASR_method,covariance_mean);

global pathname
%% Initial conditions

clear X_trials_offline iTimes epoch epochF epochF1 epochF2 data_ASR_offline1 data_ASR_offline2

% data=data(:,1:20);
% if max(max(abs(data)))>100
%     data=data*1e-6;
% end
% [Nsamples,Nchannels] =size(data);
% 
% % Props.TimeParam.epochsize=epochsize;
% % Props.TimeParam.slidew=slidew;
% % Props.TimeParam.stSamp=stSamp;
% % Props.TimeParam.endSamp=endSamp;
% % Props.Channels=SetCH;
% ft=5e-5;
% sett=[0 2 ft];
% 
% figure,ax=gca;
% plotEEG(ax,data,Fs,SetCH,sett)
% title(ax,'Performance Test. No filtered')
% 
% data=Filtering(Props,data,0);
% % data = CAR_Filter(data);
% 
% figure,ax=gca;
% plotEEG(ax,data,Fs,SetCH,sett)
% title(ax,'Performance Test Filtered')


iSamp=1;
num_epoch=0;

while iSamp<size(data,1)-epochsize
    num_epoch=num_epoch+1;
    iTimes{num_epoch}=iSamp:iSamp+epochsize-1;
    epoch{num_epoch}=data(iTimes{num_epoch},:); 
    epoch{num_epoch}=epoch{num_epoch}-mean(epoch{num_epoch},1);
    
    X_trials_offline(:,:,num_epoch) = epoch{num_epoch}';
    
    iSamp = iSamp + epochsize;   
end


%% calibration_set

if exist('calibration_set','var')    
    button = questdlg('For a new calibration?','Select to continue','No'); 
else
    button='Yes';
end

if strcmp(button,'Yes')

if ~ischar(pathname)
    pathname='';
end

[filenameCal, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select the Calibration Data',pathname);

if isequal(filenameCal,0)
    disp('Selection canceled')
    return
else
    DatafileCal=fullfile(pathname, filenameCal);
    disp(['You Selected:', filenameCal])

    clear F
    dataBK=data;

    load(DatafileCal)
    if exist('F','var')
        F=F(1:20,:)';
    else
        F=data(:,1:20);
        clear datafull
    end
    if max(max(abs(F)))>100
        F=F*1e-6;
    end

    % F=Filtering(Props,F,0);
    % % Passa-baixa
    % n=8;
    % cut=8;
    % [z,p,k] = butter(n,cut/(Fs/2));
    % [b,a] = zp2tf(z,p,k);
    % %     figure,freqz(b,a,100)
    % F = filtfilt(b,a,F);
end


%%
figure,ax=gca;
plotEEG(ax,F(1:end,:),Fs,SetCH,[0 5 1e-4])
title(ax,'Calibration data: Select key "c" until cancel')

totalTime=0;
key=0;
kk=1;
Xclean={};
while key~=99
    zoom on
    pause()    
    [x,y,key]=ginput(2);
    key=key(end);
    disp(key)    
    if ~isempty(key) && key~=99
        x=round(x);
        Xclean{kk}=[x'*Fs diff(x)];
        totalTime=totalTime+Xclean{kk}(3);
        disp(['Calibration time: ',num2str(totalTime),' s'])
        kk=kk+1;
    end    
        
end
disp(['Calibration time: ',datestr(seconds(totalTime),'HH:MM:SS')])
%%
clear epochCal epochF1 epochF2

if ~isempty(Xclean)
    calibration_set=[];
    num_epoch=1;
    for ii=1:length(Xclean)

        s1=Xclean{ii}(1);
        s2=Xclean{ii}(2);
        while s1<s2-epochsize

            iTimes{num_epoch}=s1:s1+epochsize-1;
            epochCal{num_epoch}=F(iTimes{num_epoch},:); 
%             epochCal{num_epoch}=epochCal{num_epoch}-mean(epochCal{num_epoch},1);

            calibration_set(:,:,num_epoch) = epochCal{num_epoch}';
            num_epoch=num_epoch+1;
            s1 = s1 + epochsize;   
        end
    end

else
    calibration_set=[];
    warndlg('Calibration data is empty!','Warning!')
end

end
%% ASR function

k=5; % 7
[data_ASR_offline1] = ASR_filter(calibration_set, X_trials_offline,Fs,k,'PCA','mean_covariance');
[data_ASR_offline2] = ASR_filter(calibration_set, X_trials_offline,Fs,k,'PGA','');
Props.Process.ASR=1;


%% Plot EEG Channels

concatCal = [];
for ii=1:size(calibration_set,3)
   concatCal = [concatCal calibration_set(:,:,ii)];
end

concatEpoch = [];
for ii=1:size(X_trials_offline,3)
   concatEpoch = [concatEpoch X_trials_offline(:,:,ii)];
end

concatEpoch1 = [];
for ii=1:size(data_ASR_offline1,3)
   epochF1{ii}= data_ASR_offline1(:,:,ii);    
   concatEpoch1 = [concatEpoch1 epochF1{ii}];
end

concatEpoch2=[];
for ii=1:size(data_ASR_offline2,3)
   epochF2{ii}= data_ASR_offline2(:,:,ii);    
   concatEpoch2 = [concatEpoch2 epochF2{ii}];
end

%%
% settings
ft=5e-5;
sett=[0 5];

% figure,ax=gca;
% plotEEG(ax,concatCal',Fs,SetCH,sett)
% title(ax,'Calibration')
fasr=figure;
% subplot(121),ax=gca;
plotEEG(fasr,concatEpoch',Fs,SetCH,sett,'k')
% title(ax,'Before ASR')
% subplot(122),
% ax=gca;
hold on
plotEEG(fasr,concatEpoch1',Fs,SetCH,sett,'r')
title(['Filtered PCA k=',num2str(k)])

fasr2=figure;
% subplot(121),ax=gca;
plotEEG(fasr2,concatEpoch',Fs,SetCH,sett,'k')
% title(ax,'Before ASR')
% subplot(122),
% ax=gca;
hold on
plotEEG(fasr2,concatEpoch2',Fs,SetCH,sett,'r')
title(['Filtered PGA k=',num2str(k)])

% Res=concatEpoch-concatEpoch1;

% save ASR_filter4 calibration_set X_trials_offline Props data_ASR_offline1...
%     data_ASR_offline2


%%
% Perguntas:
% Los artefactos que la funci�n remueve, como parpadeo, movimiento de los ojos, solo aparecen en los canales frontales?
% 
% O, todos los artefactos deben aparecer en todos os canales?
% 
% Etapas:
% 
% 1. Proje��o de dados: A1, A2 s�o utilizados para re-reference SSP (signal-space projection). SSP acho que � um tipo de ICA.
% 
% 2. Remo��o de offset usando linha de tend�ncia-Detrend 
% - Antes de calcular PSD removo a m�dia do sinal (DC)
% 
% 3. Filtro passa-alta com 1.5Hz (cambiar para 0.1 Hz)
% 
% - Definido por inspe��o visual
% - Sugere-se n�o aplicar filtro de 60Hz se aplicou passa baixa 30 Hz
% 
% 4.1 Detec��o de piscar de olhos (canais Fp1, Fp2, F7, F8) a partir do SSP
%  - Sele��o de um n�mero X de componentes at� acumular entre 50 e 60% de informa��o (crit�rio usado sem inspe��o do sinal, ainda) 
% 
% 4.2 Fun��o de remo��o de ru�dos PCA - Denis
% 
% 4.3 Filtro CAR
% 
% 5. Divis�o de �pocas (1 segundo, overlapping 50%)
% 
% 6.Selecionamos um tempo pr�-determinado para an�lise (�ltimos 4 min de cada condi��o)
% 
% 7. Extra��o das bandas de frequ�ncia do sinal, de cada �poca, para cada banda
% 
% 8. C�lculo do PSD usando Weltch com uma janela hamming (antes remove m�dia do sinal-DC)
% 
% 9. C�lculo da m�dia do PSD de todas as �pocas por sujeito / banda. Resultados dados em valores logar�tmicos
% 
% 
% Fun��o ASR
% PCA
% 
% Matriz de covarian�� - Espa��: analisa componentes principales.
% 
% Componentes com varia��es 2 X baseline s�o removidas.
% 
