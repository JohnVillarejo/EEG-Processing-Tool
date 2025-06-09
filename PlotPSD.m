% function PlotPSD
% %%
% % load(PSDfile,'PSDbandLog','Props')
% % PSDband=PSDbandLog;
% for sub=1:12
% % ch=[1 4 5 9 12 13];
% ch=[5 13 17];
% % ch=[15 17 18 19];
% chLabel=mat2cell(ch,1,ones(1,length(ch)));
% c1=1;
% c2=4;
% test=3;
% inst=2;
% try
%     
% m=min(min([PSDband{sub}{1,inst}(c1:c2,ch) PSDband{sub}{2,inst}(c1:c2,ch) PSDband{sub}{3,inst}(c1:c2,ch)]));
% M=max(max([PSDband{sub}{1,inst}(c1:c2,ch) PSDband{sub}{2,inst}(c1:c2,ch) PSDband{sub}{3,inst}(c1:c2,ch)]));
% 
% figure
% subplot(131)
% plot(PSDband{sub}{1,inst}(c1:c2,ch)), title(['Control: ',num2str(sub)]), xlabel('Bands') %xticklabels(Props.Bandtext(c1:c2))
% axis([c1 c2 m M]), legend(string(chLabel))
% subplot(132)
% plot(PSDband{sub}{2,inst}(c1:c2,ch)), title('Stroop'), xlabel('Bands') %xticklabels(Props.Bandtext(c1:c2))
% axis([c1 c2 m M]), legend(string(chLabel))
% subplot(133)
% plot(PSDband{sub}{3,inst}(c1:c2,ch)), title('ST'), xlabel('Bands') %xticklabels(Props.Bandtext(c1:c2))
% axis([c1 c2 m M]), legend(string(chLabel))
% 
% end
% 
% end


%%

global PSDfile
load(PSDfile,'PX','Props')
% PSDband=PSDbandLog;
CHM=PX.CHM;
CHSD=PX.CHSD;
CHmin=PX.CHmin;
CHMax=PX.CHMax;

CHMsub=PX.CHMsub;
CHMSDsub=PX.CHMSDsub;
CHminsub=PX.CHMminsub;
CHMmaxsub=PX.CHMmaxsub;

% ch=[1 4 5 9 12 13];
ch=[5 13 17];
ch=[5 6 7 13 14 15 17 18 19];
% ch=1:20;
chLabel=mat2cell(ch,1,ones(1,length(ch)));
c1=4;
c2=7;
Test=[1 2 3];
Inst=[1 2];
Inst=str2num(get(handles.EditInst,'String'));
Test=str2num(get(handles.EditTest,'String'));
Insts=length(Inst);
Tests=length(Test);

for ii=1:length(Inst)
    nInst=Inst(ii);

for sub=1:size(CHM{1,1},3)

figure

CH=length(ch);
k=1;

% for jj=1:length(Tests)
for tt=1:Tests
    nTest = (Test(tt));
for chi=1:CH
    chx=ch(chi);

    data = CHM{nTest,nInst}(c1:c2,chx,sub)';
    SD = CHSD{nTest,nInst}(c1:c2,chx,sub)';
    subplot(Tests,CH,k)
    shadeSD([c1:c2],data-SD,data+SD,data,'b','-')
%     plot([c1:c2],CHMax{nTest,nInst}(c1:c2,chx,sub),'.-k')
%     plot([c1:c2],CHmin{nTest,nInst}(c1:c2,chx,sub),'.-k')
    title(['CH: ',num2str(chx)])
    if k>CH*2, xlabel('Frequency [Hz]'), end
    if k==CH*(nTest-1)+1, ylabel(Props.TestLabel{nTest}), end
    % axis([c1 c2 m M]), legend(string(chxLabel))
    k=k+1;
end
end


end

%% For average subjects
figure

CH=length(ch);
k=1;

for tt=1:Tests
    nTest = (Test(tt));

for chi=1:CH
    chx=ch(chi);

    data = CHMsub(c1:c2,chx)';
    SD = CHMSDsub(c1:c2,chx)';
    subplot(Tests,CH,k)
    shadeSD([c1:c2],data-SD,data+SD,data,'b','-')
    plot([c1:c2],CHMsubmin(c1:c2,chx),'k')
    plot([c1:c2],CHMsubMax(c1:c2,chx),'k')
    title(['CH: ',num2str(chx)])
    if k>CH*2, xlabel('Frequency [Hz]'), end
    if k==CH*(nTest-1)+1, ylabel(Props.TestLabel{nTest}), end
    % axis([c1 c2 m M]), legend(string(chxLabel))
    k=k+1;
end

end

end

%% All channels 
k=1;
figure
for tt=1:Tests
    nTest = (Test(tt));
    for ii=1:length(Inst)
        nInst=Inst(ii);
%         for chi=1:CH
            chx=ch(chi);
            subplot(Tests,length(Inst),k), hold on
            data = CHM{nTest,nInst}(c1:c2,:,sub)';
            LineList{k} = plot([c1:c2],data);
            set(LineList{k}, 'ButtonDownFcn', {@myLineCallback, LineList{k}, Props.SetCH},'UserData', []);
            xlabel('Frequency [Hz]')
            ylabel('PSD')
            if k==nInst
                title(Props.InstLabel{nInst})
            end
            if k==nInst
                title(Props.InstLabel{nInst})
            end
%         end
        k=k+1;
    end
end


% waitfor(LineList, 'UserData')
% curwell = get(LineList, 'UserData');
   
