global pathname EEGv Database DatabaseFile Information

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load session',pathname,'MultiSelect','on');

if isequal(filename,0)
   
   disp('Selection canceled')
   set(handles.endInfo,'String','Done!')
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
    
variableInfo = who('-file', Datafile{ff});

if ~ismember('EEGv', variableInfo) 
    warndlg('Variable from session was not found','File wrong!')
    return
end

% load(Datafile{ff},'EEGv')
load(Datafile{ff})

File=EEGv.filename;
disp(['File selected: ',File])
d=1; %d-> S previous to number
sub=str2num(File(d+1:d+2)); % To obtain the subject code 
instantTest=File(d+4:d+6); % To obtain the instant code

if ~isempty(sub) && ~isempty(instantTest)              % Test Carol

    switch instantTest % To detect the type of instantTest
        case 'pre'      %(4:6)
            Inst=1;      
            TypeTest=File(d+8:d+10);
        case 'pos'
            Inst=2;    
            TypeTest=File(d+8:d+10); 
        case 'bik'
            Inst=3;        
            TypeTest=File(d+9:d+11); 
            di=3*60*Fs; % Initial delay, to remove from 3th minute
    %         data=data(di:end,:);
        case 'str'
            Inst=4;
            TypeTest=File(d+11:d+13);
        otherwise
            Inst=0;
            TypeTest=0;
    end


    switch TypeTest % To detect the test
        case 'con' % control
            nTest=1;
        case 'str' % stroop
            nTest=2;
        case 'stm' % stm
            nTest=3;    
        case 'st_' % stm
            nTest=3; 
        case 'st.' % stm
            nTest=3; 
        otherwise 
            nTest=0;
    end

end


PSD{sub,nTest}{Inst}=cell2mat(EEGv.PSD.PSDband);
% PSDband{nTest}{bands,ch}(sub,nTest)

end

% Tests:
% 1. Control / 2. Stroop / 3. Stm
% Instants:
% 1. Pre - 3. Bike - 4. stroop - 2. Pós


%%
for sub=1:10
    % b=1:8
    for nTest=1:3
        try  
        PSDrel{sub,nTest}=PSD{sub,nTest}{4}-PSD{sub,nTest}{1};
        end
    end
end

%%
% ex:
% Linhas
% Pre 1
% Stroop 4
% PSD relativa
% 
% Colunas
% Control
% Stroop
% Stm

% Bandas de frequencia:
% 1.Theta (4–7 Hz)*
% 2.Beta (13–30 Hz)
% 3.Beta low (13 - 18)
% 4.Beta high (18 - 30)
% 5.Alpha (8-12 Hz)*
% 6.Alpha low (8–10 Hz)
% 7.Alpha upper (10–12 Hz)
% 8.Gama (30-100 Hz)





for sub=1:size(PSD,1)
    if isempty(PSD{sub})
        continue
    end
for band=1:4:5
switch band
case 1
    Bandtext='Theta';
case 2
    Bandtext='Beta';
case 3
    Bandtext='Beta Low';
case 4
    Bandtext='Beta High';
case 5 
    Bandtext='Alpha';
case 6
    Bandtext='Alpha Low';
case 7
    Bandtext='Alpha High';
case 8
    Bandtext='Gama';
end

    figure,

    nTest=1;
    subplot(331), title(['',newline,'Control']), ylabel('Pre','Visible','on','FontWeight','bold')
    try, topoplot( PSD{sub,nTest}{1}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(334), ylabel('Stroop','Visible','on','FontWeight','bold')
    try, topoplot( PSD{sub,nTest}{4}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(337), ylabel('PSD relative','Visible','on','FontWeight','bold')
    try, topoplot( PSDrel{sub,nTest}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end

    nTest=2;
    subplot(332), title(['Sub:',num2str(sub),' - ',Bandtext,newline,'STRP']), 
    try, topoplot( PSD{sub,nTest}{1}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(335), % title('Stroop')
    try, topoplot( PSD{sub,nTest}{4}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(338), % title('PSD relative')
    try, topoplot( PSDrel{sub,nTest}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end

    nTest=3;
    subplot(333), title(['',newline,'ST']), 
    try, topoplot( PSD{sub,nTest}{1}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(336), % title('Stroop')
    try, topoplot( PSD{sub,nTest}{4}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end
    subplot(339), % title('PSD relative')
    try, topoplot( PSDrel{sub,nTest}(band,:), EEGv.chanlocs, 'verbose', ...
          'off', 'style' , 'fill', 'chaninfo', EEGv.chaninfo); end

end
end