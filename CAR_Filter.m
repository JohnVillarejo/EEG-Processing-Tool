function dataCar = CAR_Filter(data)

if size(data,1)<size(data,2)
    data=data';
end

% data=data(1:end-3,:);
% Nch=size(data,1);

mdata=mean(data,2);

dataCar=data-mdata;

% for j=1:Nch
%     figure
%     subplot(211)
%     plot(data(j,:))
%     subplot(212)
%     plot(dataCar(j,:))    
% end

% % Previous version
% if size(data,1)<size(data,2)
%     data=data';
% end
% meandData=mean(data(:,1:20),2);
% data = data - meandData;