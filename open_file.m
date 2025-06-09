% Le arquivos .PLG
% selecionando apenas os canais definidos no vetor quaiscan 
function [dados,Fs,NomeCan]=open_file(Nomearq)
%clear;
% Nomearq = input('Nome completo do Arquivo: ','s');
fid = fopen(Nomearq);
[cab,count] = fread(fid,1024,'uchar');
qtdcn = cab(4);
Fs = cab(11)*256+cab(10);
NomeCan = [];
TipoCan = [];
for k = [1:qtdcn]
    [cabcn,count] = fread(fid,512,'*char');
    NomeCan = [NomeCan;[cabcn(12),cabcn(13),cabcn(14),cabcn(15),cabcn(16)]];
    TipoDesteCan = [];
    for l = [1:25]
        TipoDesteCan = [TipoDesteCan,cabcn(l+41)];
    end
    TipoCan = [TipoCan;TipoDesteCan];
        
end
%quaiscan = [2 6 19];
quaiscan = [1:qtdcn];
qtdparaler = Fs * qtdcn;%1 segundo por vez
count = qtdparaler;%p/ entrar no laço
qtdamos = 0;
dados = zeros(numel(quaiscan),0);%cria uma matriz vazia com 1 linha p/ cada canal desejado
while qtdparaler == count 
    %[dados,count] = fread(fid,qtdparaler,'*int16');% ATENCAO :  ESCOLHI COLOCAR OS DADOS EM UMA MATRIZ DE INTEIROS DE 16 BITS P/ ECONOMIZAR ESPAÇO
    [trecho,count] = fread(fid,qtdparaler,'int16');% ATENCAO :  ESCOLHI COLOCAR OS DADOS EM UMA MATRIZ DE DOUBLES PORQUE NAO PRECISO ECONOMIZAR ESPAÇO
    qtdamos = (count / qtdcn) + qtdamos;% incremento
    trecho = reshape(trecho,qtdcn,count / qtdcn);
    pedaco = zeros(0);
    for l = [1: numel(quaiscan)]
        pedaco = [pedaco ; trecho(quaiscan(l),:)];
    end
    dados = cat(2,dados,pedaco);
end
fclose(fid);