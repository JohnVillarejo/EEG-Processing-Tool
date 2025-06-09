function th = plotEEG(f,data,xt,Fs,SetCH,settings,color,tit,txtscale)

% if length(varargin)==3
%     flagSamp=0;
%     fact=1;
% end

if length(settings)>=1
    flagSamp=settings(1);   % To plot samples instead seconds
end
if length(settings)>=2 && settings(2)>0
    fact=settings(2);     % To add a factor in the visual scale 
else
    fact=1;                 % Default
end
if length(settings)>=3 && settings(3)>0
    th=settings(3)*fact; % Escale to plot
%     th=1e-4;     
else
%     th=max(abs(data(:)))*fact; % Default threshold
    th=mean(abs(data(:)))+4*std(abs(data(:)))*fact;
end

ax=gca(f);

% Nchannels=20;
[r,c] = size(data);

if r < c && c > 100
    data=data';
    [r,c] = size(data);
end

Nchannels = c;
xi=0;
xe=30*Fs;

% xt=(1:size(data,1))/Fs;

Mdata=0; mdata=0;

% figure
% cla(ax)
hold(ax,'on')
% set(gcf, 'Position', get(0,'Screensize'));

for i=1:Nchannels 
    TH(i)=th*(i-1);
    Mdata=max([th Mdata]);
    mdata=min([-(th/2+TH(i)) mdata]);
    if flagSamp
        plot(ax,data(:,i)-TH(i),color);
%         tx=1-r*0.02;
%         try
%             axis(ax,[tx r mdata Mdata])
%         end
        
    else
        plot(ax,xt,data(:,i)-TH(i),color)   
%         tx=xt(1)-xt(end)*0.02;
%         try
%             axis(ax,[tx xt(r) mdata Mdata])
%         end
        
    end
%     %text(ax,tx*1.5,-TH(i)+th/2,SetCH{1,i})
%     text(ax,tx,-TH(i)+th/2,SetCH{1,i})
end

if flagSamp
    try
        axis(ax,[xi xe mdata Mdata])
    end        
else
    try
        axis(ax,[xt(xi+1) xt(xe) mdata Mdata]) 
    end
end

% if ~isempty('txtscale','var')
if txtscale
    TH=TH(end:-1:1);
    nch=length(SetCH)-Nchannels;
    SetCH=SetCH(1,end-nch:-1:1);

    yticks(TH*-1)
    yticklabels(SetCH)
end

hold(ax,'off')

% if ~isempty(SetCH)
%     legend(SetCH(1,1:Nchannels))
% end

if flagSamp
    xlabel(ax,'Sample')
else
    xlabel(ax,'Time [s]')
end
ylabel(ax,['Channels. [Scale: ',num2str(th,'%02.f'),' uV]'])
title(ax,tit)

% pauser(0.1)
