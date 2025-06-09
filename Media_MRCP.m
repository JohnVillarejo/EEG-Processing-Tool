% for nsuj = 1:length(filename)

% load (currentFile,'MRCP_Ch_ep','MRCP_Ch_ep1','MRCP_Ch_ep2','MRCP_Ch_ep3','MRCP_Ch_ep4')

load('D:\Work\Luana EEG\2 Arquivos em sessão (7 ao 18) - completos\Datasessions\Datasessions\S08_DES_V5_Raw_E_BP_MRCP.mat')
suj = 1;

MRCP_Ch_ep_Full{suj} = MRCP_Ch_ep;
MRCP_Ch_ep1_Full{suj} = MRCP_Ch_ep1;
MRCP_Ch_ep2_Full{suj} = MRCP_Ch_ep2;
MRCP_Ch_ep3_Full{suj} = MRCP_Ch_ep3;
MRCP_Ch_ep4_Full{suj} = MRCP_Ch_ep4;

% load('D:\Work\Luana EEG\2 Arquivos em sessão (7 ao 18) - completos\Datasessions\Datasessions\S13_DES_V5_Raw_E_BP_MRCP.mat')
% suj = 2;
% 
% MRCP_Ch_ep_Full{suj} = MRCP_Ch_ep;
% MRCP_Ch_ep1_Full{suj} = MRCP_Ch_ep1;
% MRCP_Ch_ep2_Full{suj} = MRCP_Ch_ep2;
% MRCP_Ch_ep3_Full{suj} = MRCP_Ch_ep3;
% MRCP_Ch_ep4_Full{suj} = MRCP_Ch_ep4;


% {suj}{div}(ch,:,ii)
for s = 1 : length(MRCP_Ch_ep_Full)
    for div = 1:length(MRCP_Ch_ep_Full{1})
        for ch=1:size(MRCP_Ch_ep_Full{1}{1},1)
            
            MRCP_Ch_ep_M{div}(ch,s,:) = mean(MRCP_Ch_ep_Full{s}{div}(ch,:,:),3);
        
        end
    end
end

for div = 1:length(MRCP_Ch_ep_Full{1})
    for ch=1:size(MRCP_Ch_ep_Full{1}{1},1)

        MRCP_Ch_ep_Ms{div}(ch,:) = mean(MRCP_Ch_ep_M{div}(ch,s,:),2);

    end
end

%%


Fs = 600;
tep = [-1.5 0.5]*Fs; % Full MRCP segment

Plot_MRCP(MRCP_Ch_ep_M{1},20,Fs,tep,[])



