function shadeSD(x,sdm,sdM,y,color,style)

% Inputs:
%       x:      Time vector 1xN
%       y:      Mean vector 1xN
%       sdm:    Standard deviation below Mean
%       sdM:    Standard deviation above Mean
%       color:  Code for color
%       style:  Code for line style: - / -- / -. / .

% Color       Code  RGB     Hexadecimal Code	
% 'red'       'r'	[1 0 0]	'#FF0000'	
% 'green'     'g'	[0 1 0]	'#00FF00'	
% 'blue'      'b'	[0 0 1]	'#0000FF'	
% 'cyan'      'c'	[0 1 1]	'#00FFFF'	
% 'magenta'	  'm'	[1 0 1]	'#FF00FF'	
% 'yellow'	  'y'	[1 1 0]	'#FFFF00'	
% 'black'     'k'	[0 0 0]	'#000000'	
% 'white'     'w'	[1 1 1] '#FFFFFF'

% if isempty(sdm)
%     sdm=mean(y)-std(y);
% end
% if isempty(sdM)
%     sdM=mean(y)+std(y);
%     y=mean(y);
% end

plot(x,y,'LineStyle',style,'Color',color,'LineWidth',.5), hold on
xverts =[x(1:end-1); x(1:end-1); x(2:end); x(2:end)];
yverts = [y(1:end-1); sdM(1:end-1); sdM(2:end); y(1:end-1)];
p = patch(xverts,yverts,color,'EdgeColor','none');
alpha(0.2)

yverts2 = [y(1:end-1); sdm(1:end-1); sdm(2:end); y(1:end-1)];
p = patch(xverts,yverts2,color,'EdgeColor','none');
alpha(0.2)

% plot(x,sdM,'k','LineWidth',.01)
% plot(x,sdm,'k','LineWidth',.01)

end