function O = myLineCallback(LineH, EventData, LineList, SetCH)
global O

if isfield(O,'htext')
    delete(O.htext)
end

% disp(LineH);                    % The handle
% disp(get(LineH, 'YData'));      % The Y-data
O.selLine=find(LineList == LineH);% Selected Line
% disp(selLine);  % Index of the active line in the list
set(LineList, 'LineWidth', 0.5);
set(LineH,    'LineWidth', 2.5);
uistack(LineH, 'top');  % Set active line before all others
disp(SetCH{O.selLine})

O.htext = text(EventData.IntersectionPoint(1),EventData.IntersectionPoint(2),SetCH{O.selLine});