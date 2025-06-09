% ICA_Villa

% Remove the mean
% F = bst_bsxfun(@minus, F, mean(F,2));
            
% Run EEGLAB ICA function
nIcaComp=20;
if ~isempty(nIcaComp) && (nIcaComp ~= 0)
    [icaweights, icasphere] = runica(data', 'pca', nIcaComp, 'lrate', 0.001, 'extended', 1, 'interupt', 'off');
else
    [icaweights, icasphere] = runica(data', 'lrate', 0.001, 'extended', 1, 'interupt', 'off');
end


% Error handling
if isempty(icaweights) || isempty(icasphere)
    bst_report('Error', sProcess, sInputsA, 'Function "runica" did not return any results.');
    return;
end
% Reconstruct mixing matrix
W = icaweights * icasphere;
% Fill with the missing channels with zeros
Wall = zeros(length(ChannelMat.Channel), size(W,1));
Wall(iChannels,:) = W';
% Build projector structure
proj = db_template('projector');
proj.Components = Wall;
proj.CompMask   = zeros(size(Wall,2), 1);   % No component selected by default
proj.Status     = 1;
proj.SingVal    = 'ICA';
% Apply component selection (if set explicetly)
if ~isempty(SelectComp)
    proj.CompMask(SelectComp) = 1;
end


%%

    if ~isempty(icaSort)
        y = W * data;
        C = bst_corrn(Fref, y);
        [corrs, iSort] = sort(max(abs(C),[],1), 'descend');
        proj.Components = proj.Components(:,iSort);
    end
    
    % Modality used in the end
    AllMod = unique({ChannelMat.Channel(iChannels).Type});
    strMod = '';
    for iMod = 1:length(AllMod)
        strMod = [strMod, AllMod{iMod} '+'];
    end
    strMod = strMod(1:end-1);
    % Comment
    if ~isempty(evtName)
        proj.Comment = [evtName ': ' Method ', ' strMod ', ' datestr(clock)];
    else
        proj.Comment = [Method ': ' strMod  ', ' datestr(clock)];
    end
    
    
    % ===== APPLY PROJECTORS (FILES B) =====
    bst_progress('text', 'Applying projector to the recordings...');
    % Get all the channel files
    ChannelFiles = unique({sInputsB.ChannelFile});
    % Apply projectors to all the files in input
    for iFile = 1:length(ChannelFiles)
        % Load destination channel file
        ChannelMatB = in_bst_channel(ChannelFiles{iFile});
        destChanNames = {ChannelMatB.Channel.Name};
        % If channel names in projector and destination files do not match at all: ERROR
        [commonNames,I,J] = intersect(projChanNames, destChanNames);
        if isempty(commonNames)
            bst_report('Error', sProcess, sInputsB(iFile), 'List of channels are too different in the source and destination files.');
            return;
        end
        % If the channels list is not the same: re-order them to match the destination channel file
        if ~isequal(projChanNames, destChanNames)
            fixComponents = zeros(length(destChanNames), size(proj.Components,2));
            fixComponents(J,:) = proj.Components(I,:);
            proj.Components = fixComponents;
            bst_report('Warning', sProcess, sInputsB(iFile), sprintf('List of channels differ in FilesA (%d) and FilesB (%d). The common channels (%d) have been re-ordered to match the channels in FilesB.', length(projChanNames), length(destChanNames), length(commonNames)));
        end
        % Add projector to channel file
        [newproj, errMsg] = import_ssp(ChannelFiles{iFile}, proj, 1, 1, strOptions);
        if ~isempty(errMsg)
            bst_report('Error', sProcess, sInputsB(iFile), errMsg);
            return;
        end
    end
    
    
    % ===== SAVE THE AVERAGE =====
    if SaveErp && ~isempty(Favg)
        % Divide by number of average
        ChannelFlag = ones(size(Favg,1), 1);
        ChannelFlag(iBad) = -1;
        % Remove transients
        if ~isempty(nTransientDiscard)
            Favg = Favg(:, (nTransientDiscard+1):(end-nTransientDiscard));
            TimeVector = TimeVector((nTransientDiscard+1):(end-nTransientDiscard));
        end
        
        % === BEFORE ===
        % Create new output structure
        sOutput = db_template('datamat');
        sOutput.data           = Favg;
        sOutput.Comment     = [proj.Comment ' (before)'];
        sOutput.ChannelFlag = ChannelFlag;
        sOutput.Time        = TimeVector;
        sOutput.DataType    = 'recordings';
        sOutput.Device      = 'ArtifactERP';
        sOutput.nAvg        = nAvg;
        sOutput.Leff        = nAvg;
        % Get output study
        [tmp, iOutputStudy] = bst_process('GetOutputStudy', sProcess, sInputsB);
        sOutputStudy = bst_get('Study', iOutputStudy);
        % Output filename
        OutputFileERP = bst_process('GetNewFilename', bst_fileparts(sOutputStudy.FileName), 'data_artifact_before');
        % Save file
        bst_save(OutputFileERP, sOutput, 'v6');
        % Add file to database structure
        db_add_data(iOutputStudy, OutputFileERP, sOutput);
        
        % === SSP COMPONENTS ===
        if ~isICA
            % Force the first component to be used (allow multiple components by default)
            projErp = proj;
            projErp.Status(1) = 1;
            %projErp.CompMask = 0 * projErp.CompMask;
            projErp.CompMask(1) = 1;
            % Build projector
            Projector = BuildProjector(projErp, 1);
            % Apply to average data
            sOutput.data       = Projector * Favg;
            sOutput.Comment = [proj.Comment ' (after)'];
            % Output filename
            OutputFileERP = bst_process('GetNewFilename', bst_fileparts(sOutputStudy.FileName), 'data_artifact_after');
            % Save file
            bst_save(OutputFileERP, sOutput, 'v6');
            % Add file to database structure
            db_add_data(iOutputStudy, OutputFileERP, sOutput);
        % === ICA COMPONENTS ===
        else
            % Create file structure
            sOutput = db_template('matrixmat');
            sOutput.Value       = proj.Components' * Favg;
            sOutput.Comment     = [proj.Comment ' (ICA)'];
            sOutput.Time        = TimeVector;
            sOutput.ChannelFlag = [];
            sOutput.nAvg        = nAvg;
            sOutput.Leff        = nAvg;
            % Description of the signals: IC*
            sOutput.Description = cell(size(proj.Components,1),1);
            for i = 1:size(proj.Components,1)
                sOutput.Description{i} = sprintf('IC%d', i);
            end
            % Output filename
            OutputFileIC = bst_process('GetNewFilename', bst_fileparts(sOutputStudy.FileName), 'matrix_artifact_ica');
            % Save file
            bst_save(OutputFileIC, sOutput, 'v6');
            % Add file to database structure
            db_add_data(iOutputStudy, OutputFileIC, sOutput);
        end
    end
    % Return all the input files
    OutputFiles = {sInputsB.FileName};
    
%% FROM EEGLAB

[ALLEEG, com] = pop_runica( ALLEEG, varargin )



%------------------------------
% compute ICA on a definite set
% -----------------------------
tmpdata = reshape( EEG.data(g.chanind,:,:), length(g.chanind), EEG.pnts*EEG.trials);
tmprank = getrank(double(tmpdata(:,1:min(3000, size(tmpdata,2)))));

tmpdata = double(tmpdata);
tmpdata = tmpdata - repmat(mean(tmpdata,2), [1 size(tmpdata,2)]); % zero mean (more precise than single precision)

[EEG.icaweights,EEG.icasphere] = runica( tmpdata, 'lrate', 0.001,  g.options{:} );
