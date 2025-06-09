global pathname 
clear dataPSD_CO
for itype = 1:4
for iband=1:12
dataPSD_CO{itype,iband} = [];
end
end
nSuj = 14;

% load ('C:\DADOS EEG\Arquivos de repouso S raw\2 Processamento_Bp1-30_CAR_RemSeg\CO\PSD') % grupo Controle


if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load Control grupo');

if isequal(filename,0)
   
   disp('Selection canceled')
   return
end

pathname = pathname2;
Datafile=fullfile(pathname, filename);
load(Datafile)

gr = 1; 
type = 1; % PSDband
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                        try    
dataPSD_CO{type,iband} = [dataPSD_CO{type,iband};...
    is gr type itest iins PSDband{itest,iins}(iband,:,is)];
                        catch, 
                            dataPSD_CO{type,iband} = nan; end
            end
        end
    end
end

type = 2; % PSDbandLog
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                           try 
dataPSD_CO{type,iband} = [dataPSD_CO{type,iband};...
    is gr type itest iins PSDbandLog{itest,iins}(iband,:,is)];
                           catch, 
                               dataPSD_CO{type,iband} = nan; end
            end
        end
    end
end

type = 3; % PSDbandSets
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                            try
dataPSD_CO{type,iband} = [dataPSD_CO{type,iband};...
    is gr type itest iins PSDbandSets{itest,iins}(iband,:,is)];
                            catch, 
                                dataPSD_CO{type,iband} = nan; end
            end
        end
    end
end

type = 4; % PSDbandLogSets
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                            try
dataPSD_CO{type,iband} = [dataPSD_CO{type,iband};...
    is gr type itest iins PSDbandLogSets{itest,iins}(iband,:,is)];
                            catch, 
                                dataPSD_CO{type,iband} = nan; end
            end
        end
    end
end


%%

clear dataPSD_ST
for itype = 1:4
for iband=1:12
dataPSD_ST{itype,iband} = [];
end
end

nSuj = 15;

% load ('C:\DADOS EEG\Arquivos de repouso S raw\2 Processamento_Bp1-30_CAR_RemSeg\ST\PSD') % grupo ST
if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load ST grupo');

if isequal(filename,0)
   
   disp('Selection canceled')
   return
end

pathname = pathname2;
Datafile=fullfile(pathname, filename);
load(Datafile)

gr = 2;
type = 1; % PSDband
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                        try    
dataPSD_ST{type,iband} = [dataPSD_ST{type,iband};...
    is gr type itest iins PSDband{itest,iins}(iband,:,is)];
                        catch, 
                            dataPSD_ST{type,iband} = nan; end
            end
        end
    end
end

type = 2; % PSDbandLog
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                           try 
dataPSD_ST{type,iband} = [dataPSD_ST{type,iband};...
    is gr type itest iins PSDbandLog{itest,iins}(iband,:,is)];
                           catch, 
                               dataPSD_ST{type,iband} = nan; end
            end
        end
    end
end

type = 3; % PSDbandSets
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                            try
dataPSD_ST{type,iband} = [dataPSD_ST{type,iband};...
    is gr type itest iins PSDbandSets{itest,iins}(iband,:,is)];
                            catch, 
                                dataPSD_ST{type,iband} = nan; end
            end
        end
    end
end

type = 4; % PSDbandLogSets
for itest=2:3
    for iins=1:2
        for iband=1:12
            for is=1:nSuj
                            try
dataPSD_ST{type,iband} = [dataPSD_ST{type,iband};...
    is gr type itest iins PSDbandLogSets{itest,iins}(iband,:,is)];
                            catch, 
                                dataPSD_ST{type,iband} = nan; end
            end
        end
    end
end


