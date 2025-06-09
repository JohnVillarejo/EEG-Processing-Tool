function Plot_MRCP(data_ep_Mean,nCH,Fs,tep,SetCH,parameters,normF)
% MRCP_ep_Mean{div}(ch,:)
SetCH={'1. F7','2. T3','3. T5','4. Fp1','5. F3','6. C3','7. P3',...
    '8. O1','9. F8','10.T4','11.T6','12.Fp2','13.F4','14.C4','15.P4',...
    '16.O2','17.Fz','18.Cz','19.Pz','20.Oz','A1','A2'}; %'FOTO','Annotations';...

if ~isempty(parameters)
    index = parameters.CH_index;
    tinst = parameters.time_instants;
    tinstLabels = parameters.tinstLabels;
    tep = parameters.time_range;

else
    
index = [6	11	16	2 7 ...
    12	17	22	10	15 ...
    20	4	9	14	19 ...
    24	8	13	18	23 ...
    ]; % indices for each channel according to the localization on the scalp

tinst = [-1.5 -0.5; -.4 -0.1;  -0.1 0; 0 1.5]; % Segments for processing MRCP
tinstLabels = {'-1.5 to -0.5','-0.4 to -0.1','-0.1 to 0','0 to 1.5'};
tep = [-1.5 1.5]; % Full MRCP segment (Paramters updated 23/03/2023

end

% limm = -20;
% limM = 20;


figure, % Figure for time series for epochs
set(gcf, 'WindowState', 'maximized');

nCH = size(data_ep_Mean,1);
try
for ch = 1:nCH
        
if normF
    limM = max(data_ep_Mean(:));
    limm = min(data_ep_Mean(:));
else
    limm = min(data_ep_Mean(ch,:));
    limM = max(data_ep_Mean(ch,:));
end

% ddd(:,:) = data_ep(ch,:,:);
% ddd = detrend(ddd','linear')';
% % rng default;  % For reproducibility
% % y = exprnd(5,100,1);
% mddd = bootstrp(45,@mean,ddd);
% data_ep_Mean = mean(mddd,1);
% baseline = mean(data_ep_Mean(:,1:0.5*Fs));
% data_ep_Mean = data_ep_Mean-baseline;
% data_ep_SD = std(ddd);
% clear mddd

t2 = (tep(1):1/Fs:tep(2));
tc1 = (tinst(1,1):1/Fs:tinst(1,2));
tc2 = (tinst(2,1):1/Fs:tinst(2,2));
tc3 = (tinst(3,1):1/Fs:tinst(3,2));

% figure; hold on
% plot(t2,MRCP_ep_Mean(ch,:)','r')

 
ax{ch} = subplot(5,5,index(ch));
% subplot(131), hold on, axis tight
% % plot(t2,MRCP_ep'), alpha 0.1
hold on

% To show SD shade
% shadeSD(t2,data_ep_Mean-data_ep_SD,data_ep_Mean+data_ep_SD,data_ep_Mean,'r','-')
%% LP filter
% n=2;
% %     cut=30;
%     cut=15;
%     [z,p,k] = butter(n,cut/(Fs/2));
% %     [z,p,k] = cheby2(24,100,30/(Fs/2));
%     [b,a] = zp2tf(z,p,k);
% %     figure,freqz(b,a,100)
%     data_ep_Mean2 = filtfilt(b,a,data_ep_Mean);    
    
%%
plot(t2,data_ep_Mean(ch,:)','b')
% axis tight

plot([tinst(:,2) tinst(:,2)],[limm limM],'-k')
plot([tinst(:,1) tinst(:,1)],[limm limM],'-k')

h = bar([tinst(1,1):0.01:tinst(1,2)],ones(length(tinst(1,1):0.01:tinst(1,2)),1)*limM,1,'k','EdgeColor','none');alpha(0.1)
h = bar([tinst(1,1):0.01:tinst(1,2)],ones(length(tinst(1,1):0.01:tinst(1,2)),1)*limm,1,'k','EdgeColor','none');alpha(0.1)
h = bar([tinst(2,1):0.01:tinst(2,2)],ones(length(tinst(2,1):0.01:tinst(2,2)),1)*limM,1,'r','EdgeColor','none');alpha(0.1)
h = bar([tinst(2,1):0.01:tinst(2,2)],ones(length(tinst(2,1):0.01:tinst(2,2)),1)*limm,1,'r','EdgeColor','none');alpha(0.1)
h = bar([tinst(3,1):0.01:tinst(3,2)],ones(length(tinst(3,1):0.01:tinst(3,2)),1)*limM,1,'g','EdgeColor','none');alpha(0.1)
h = bar([tinst(3,1):0.01:tinst(3,2)],ones(length(tinst(3,1):0.01:tinst(3,2)),1)*limm,1,'g','EdgeColor','none');alpha(0.1)

% h = bar([tinst(2,1):0.01:tinst(4,2)],ones(length(tinst(2,1):0.01:tinst(4,2)),1)*limM,1,'k','EdgeColor','none');alpha(0.1)
% h = bar([tinst(2,1):0.01:tinst(4,2)],ones(length(tinst(2,1):0.01:tinst(4,2)),1)*limm,1,'b','EdgeColor','none');alpha(0.1)

% To adjust axis
axis([t2(1) t2(end) limm limM])

% axis([t2(1) t2(end) limm limM])

% title(['Average epochs. ',EEGv.Props.SetCH(ch)])
try, title([SetCH(ch)]), end
% xlabel('Time [s]')

% figure, 
% subplot(121), hold on, axis tight
% shadeSD(t2,data_ep_Mean-MRCP_ep_SD(ch,:),data_ep_Mean+MRCP_ep_SD(ch,:),data_ep_Mean,'r','-')
% plot([tinst(:,1) tinst(:,1)],[max(data_ep_Mean) min(data_ep_Mean)],'--k')
% plot([tinst(:,2) tinst(:,2)],[max(data_ep_Mean) min(data_ep_Mean)],'-r')
% title('Epochs [+- SD]')
% subplot(122), hold on, axis tight
% shadeSD(t2,MRCP_ep_min(ch,:),MRCP_ep_max(ch,:),data_ep_Mean,'k','-')
% plot([tinst(:,1) tinst(:,1)],[max(MRCP_ep_max(ch,:)) min(MRCP_ep_min(ch,:))],'--k')
% plot([tinst(:,2) tinst(:,2)],[max(MRCP_ep_max(ch,:)) min(MRCP_ep_min(ch,:))],'-r')
% title('Epochs [Min Max]')

end
catch ME
    stop=1;
    disp(['Error in ',ME.stack(1).name,': line ', num2str(ME.stack(1).line)])
end
%%

% figure
% subplot(131)
% plot(tc1,MRCP1_Mean)
% % plot(MRCP{1}')
% subplot(132)
% plot(tc2,MRCP2_Mean)
% % plot(MRCP{2}')
% xlabel('Time [s]')
% title(strcat('EEG Channel: ',num2str(ch)))
% subplot(133)
% plot(tc3,MRCP3_Mean)
% % plot(MRCP{3}')




linkaxes([ax{1} ax{2} ax{3} ax{4} ax{5} ax{6} ax{7} ax{8} ax{9} ax{10} ...
    ax{11} ax{12} ax{13} ax{14} ax{15} ax{16} ax{17} ax{18} ax{19} ax{20}],'x')

% axis tight