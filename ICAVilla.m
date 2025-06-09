function ICAVilla(data,ICAch)
global EEGv

% Loading data
% EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','setname','DaEx','srate',200,'pnts',0,'xmin',0);

% Run EEGvLAB ICA function
% data=concatEpoch2;
nIcaComp=length(ICAch);
interrupt='on';
% EEGv.pnts=size(data,1);
g.icatype='runica';
g.dataset=1;
g.options={'extended' [1]};
g.reorder='on';
g.concatenate='off';
g.concatcond='off';
% g.chanind=1:20;
g.chanind=ICAch;
EEGv.icachansind = g.chanind;
EEGv.chaninfo.icachansind = EEGv.icachansind;

% [EEGv.icaweights, EEGv.icasphere] = runica(data', 'lrate', 0.001, 'extended', 1, 'interupt', 'off');

% interrupt figure
% --------------- 
% if strcmpi(interrupt, 'on')
%     fig = figure('visible', 'off');
%     supergui( fig, {1 1}, [], {'style' 'text' 'string' 'Press button to interrupt runica()' }, ...
%               {'style' 'pushbutton' 'string' 'Interrupt' 'callback' 'setappdata(gcf, ''run'', 0);' } );
%     set(fig, 'visible', 'on');
%     setappdata(gcf, 'run', 1);
%     
%     if strcmpi(interrupt, 'on')
%         drawnow;
%     end
% end




%%
% clear icaweights icasphere

% try
%     p=parpool;
% catch
% % if isempty(p)
%     p=gcp;
% %     p=parpool;
% end

if size(data,3)>1
    dataICA=[];
    for ii=1:4%size(data,3)      
        tmpdata = tmpdata - repmat(mean(data(:,:,ii),2), [1 size(data(:,:,ii),2)]); % zero mean 
        [EEGv.icaweights(:,:,ii), EEGv.icasphere(:,:,ii)] = runica(tmpdata, 'pca', nIcaComp, 'lrate', 0.001, 'extended', 1, 'interupt', 'off');
%                                                   runica(tmpdata, 'lrate', 0.001, g.options{:} );
        % Reconstruct mixing matrix
        W(:,:,ii) = EEGv.icaweights(:,:,ii) * EEGv.icasphere(:,:,ii);
        dataICAEpochs(:,:,ii) = W(:,:,ii) * data(:,:,ii);   
        dataICA=[dataICA dataICAEpochs(:,:,ii)];
    end

else

    tmpdata = data(g.chanind,:) - repmat(mean(data(g.chanind,:),2), [1 size(data(g.chanind,:),2)]); % zero mean 
%     [EEGv.icaweights, EEGv.icasphere]  = runica(tmpdata, 'pca', nIcaComp, 'lrate', 0.001, 'extended', 1, 'interupt', 'off');
    [EEGv.icaweights, EEGv.icasphere] = runica( tmpdata, 'lrate', 0.001,  g.options{:} );
%     [weights,sphere,meanvar,bias,signs,lrates,data,y] = runica(tmpdata, 'pca', nIcaComp, 'lrate', 0.001, 'extended', 1, 'interupt', 'off');
    % Reconstruct mixing matrix
    W = EEGv.icaweights * EEGv.icasphere;
    S = W * data(g.chanind,:);
    EEGv.icawinv = pinv(EEGv.icaweights*EEGv.icasphere); % a priori same result as inv
end

% Reorder components by variance
% ------------------------------
meanvar = sum(EEGv.icawinv.^2).*sum(transpose((EEGv.icaweights *  EEGv.icasphere)*EEGv.data(g.chanind,:)).^2)/((length(g.chanind)*EEGv.pnts)-1);
[~, windex] = sort(meanvar);
windex = windex(end:-1:1); % order large to small
meanvar = meanvar(windex);
EEGv.icaweights = EEGv.icaweights(windex,:);
EEGv.icawinv    = pinv( EEGv.icaweights *  EEGv.icasphere );


% if ~isempty(EEGv.icaact)
%     EEGv.icaact = EEGv.icaact(windex,:,:);
% end

% if strcmpi(interrupt, 'on')
%     close(fig);
% end

% %% iclabel
% EEG = pop_iclabel(EEG, 'default');
% pop_viewprops( EEG, 0, [1:18], {'freqrange', [2 80]}, {}, 1, 'ICLabel' )
% 
% %% Removing components
% components=[1 2];
% EEGv = pop_subcomp( EEGv, components, 0);


% component = 1:size(EEG.icaweights,2);
% % dataICA = inv(W)*S;
% component_keep = setdiff_bc(1:size(EEG.icaweights,1), components);
% 
% Screm= (EEG.icaweights(component_keep,:)*EEG.icasphere)*tmpdata;
% compproj = EEG.icawinv(:,component_keep)*Screm;
% 
% EEG.data(EEG.icachansind,:,:) = compproj;
% EEG.setname = [ EEG.setname ' pruned with ICA'];
% EEG.icaact  = [];
% goodinds    = setdiff_bc(1:size(EEG.icaweights,1), components);
% EEG.icawinv     = EEG.icawinv(:,goodinds);
% EEG.icaweights  = EEG.icaweights(goodinds,:);
% EEG.specicaact  = [];
% EEG.specdata    = [];
% EEG.reject      = [];


% delete(p)

% save ICAtestComplex W icaweights icasphere dataICA data

% Error runica
% step 512 - lrate 0.000000, wchange 53.48959753, angledelta 51.1 deg
% Composing the eigenvector, weights, and sphere matrices
%   into a single rectangular weights matrix; sphere=eye(20)
% Sorting components in descending order of mean projected variance ...
% Warning: Matrix is close to singular or badly scaled. Results may be inaccurate. RCOND =  2.950178e-19. 
% > In runica (line 1487) 
% Index in position 3 exceeds array bounds (must not exceed 1).
%  

%%