function [T,pValue,Flag]=statistics(X,Label,LabelName,flagDisp)

[N,nIns]=size(X);
flag_normal=nan;
flag_Mc=nan;
if flagDisp
    plan='on';
else
    plan='off';
end

T.X=X;
T.tblX=[];
T.tblSW=[];
T.tblMc=[];
T.tblEps=[];
T.ranovatbl=[];
T.tblAnn=[];
T.tblMultC={};
T.tblKW=[];
T.DescriptiveTab=[];
%%
tblX=table([1:N]',X,'VariableNames',{'Subject',LabelName});
T.tblX=tblX;
%% Descriptive Stats
% Problem
% I'm running the SPSS EXAMINE procedure (Analyze>Descriptive Statistics>Explore in the menus) using a number of dependent variables. Among the descriptive statistics produced are skewness, kurtosis and their standard errors. I've noticed that the standard errors for these two statistics are the same for all of my variables, regardless of the values of the skewness and kurtosis statistics. Is something wrong?
% Resolving The Problem
% No, there is nothing wrong here. The standard errors for skewness and kurtosis are solely functions of the sample size, regardless of the values of the statistics themselves. EXAMINE uses LISTWISE deletion of cases with missing values by default, so for a given group, descriptive statistics for all variables will be based on the same number of cases. Thus the SEs for skewness and kurtosis will be the same for all variables.
% The variance (squared standard error) of the skewness statistic is computed as:
% V_skew = 6*N*(N-1) / ((N-2)*(N+1)*(N+3))
% where N is the sample size. The variance of the kurtosis statistic is:
% V_kur = 4*(N^2-1)*V_skew / ((N-3)*(N+5))

mnx=mean(X);
mdx=median(X);
varx=var(X);
stdx=std(X);
Mx=min(X);
mx=max(X);
Range=Mx-mx;
k = kurtosis(X,0);
sk = skewness(X,0);
V_skew = ( 6*N*(N-1) / ((N-2)*(N+1)*(N+3)) )^0.5;
V_kur = ( 4*(N^2-1)*V_skew / ((N-3)*(N+5)) )^0.5;

V_skew=ones(1,nIns)*V_skew;
V_kur=ones(1,nIns)*V_kur;

VS=V_skew./sk;
VK=V_kur./k;

% Descriptive={'Mean';'Median';'Variance';'SD';'Min';'Max';'Range';'Skewness';'Kurtosis'};
% Descriptive(:,2:4)=mat2cell([mnx;mdx;varx;stdx;Mx;mx;Range;k;sk],ones(1,9),[1 1 1]);

Descriptivedata=[mnx;mdx;varx;stdx;Mx;mx;Range;sk;V_skew;k;V_kur];
% DescriptiveTab=table(Descriptivedata),...
%     'RowNames',{'Mean';'Median';'Variance';'SD';'Min';'Max';'Range';'Skewness';'STD ErrorS';'Kurtosis';'STD ErrorK'});
% DescriptiveTab.Properties.size=[11 3];
% DescriptiveTab.Properties.VariableNames=Label;
% DescriptiveTab.Properties.RowNames={'Mean';'Median';'Variance';'SD';'Min';'Max';'Range';'Skewness';'STD ErrorS';'Kurtosis';'STD ErrorK'};
% %{'Trial1','Trial2','Trial3'}

nCol=length(Label);
sz = [11 nCol];
for jj=1:nCol
    varTypes{jj}='double';
end
% varTypes = {'double','double','double'};
DescriptiveTab = table('Size',sz,'VariableTypes',varTypes);
DescriptiveTab.Properties.RowNames={'Mean';'Median';'Variance';'SD';'Min';'Max';'Range';'Skewness';'STD ErrorS';'Kurtosis';'STD ErrorK'};
DescriptiveTab.Variables=Descriptivedata;
DescriptiveTab.Properties.VariableNames=Label;

T.DescriptiveTab=DescriptiveTab;
%% 1. Bloxplot -> outliers or values (visual)

%% 2. Shapiro-Wilk: normalidade

for i=1:size(X,2)
    [H, pSW(i), W(i)] = swtest(X(:,i)'); 
end
tblSW=table(W',pSW','VariableNames',{'Shapiro_Wilk','p'},'RowNames',Label);
T.tblSW=tblSW;

% Results=normalitytest(X(:,1)');
% pSW=Results(7,2);

flagSW = pSW<0.05; % x > 0.05 : Normal
ind=find(flagSW); % 0:normal ; 1: Non-normal
if ~isempty(ind)
    for ii=1:length(ind)
        jj=ind(ii);

        % Skewneess_SE/Skewneess_Stat
        % Kurtosis_SE/Kurtosis_Stat 
        if  (VS(jj))<1.96 && (VK(jj))<1.96 % Normal for X < 1.96
            flagSW(jj)=0;
        end
    end
end
if sum(flagSW)==0
    flag_normal=1; % Normal
else
    flag_normal=0; % Non-normal
end

%% 4. 


if flag_normal
    
% names=1:12;
% string(names)
% names=string(names)';
% t = table(names,X(:,1),X(:,2),X(:,3),...
%     'VariableNames',{'Subject','Trial1','Trial2','Trial3'})
% 
% rm = fitrm(t,'Trial1-Trial3 ~ Subject','WithinDesign',Meas);
clear varTypes
sz = [N nCol+1];
for jj=1:nCol+1
    varTypes{jj}='double';
end
DataTable = table('Size',sz,'VariableTypes',varTypes);

names=1:N;
% DataTable = table([names' X],'VariableNames',[{'Subject'},Label{:}]);
DataTable.Properties.VariableNames=[{'Subject'},Label{:}];
DataTable.Variables=[names' X];

withinStructure = dataset([1:nCol]','VarNames',LabelName);
% withinStructure = dataset([1 2 3]','VarNames',LabelName);

% rm = fitrm(t,'Trial1-Trial3 ~1','WithinDesign',Meas,'WithinModel','orthogonalcontrasts');
rm = fitrm(DataTable,strcat(Label{1},'-',Label{end},' ~1'),'WithinDesign',withinStructure,'WithinModel','separatemeans');
[ranovatbl] = ranova(rm);

% Alternative multicomp
tblMultC = multcompare(rm,'Test');
T.tblMultC{1}=tblMultC;

tblMc = mauchly(rm);
tblEps = epsilon(rm);
% [x] = epsGG(X);

if tblMc.pValue < 0.05
    flag_Mc=1; % 0: ANOVA ; 1: GG
else 
    flag_Mc=0;
end

T.tblMc=tblMc;
T.tblEps=tblEps;
T.ranovatbl=ranovatbl;

if flag_Mc
    pValue=ranovatbl.pValueGG; % GG
else
    pValue=ranovatbl.pValue; % Anova
end    
   
%% Alternative for Anova 1 and multcompare

% XX=[X(:,1);X(:,2);X(:,3)];
% g1=[1:N 1:N 1:N]; % Sujeito
% g2=[ones(1,N) ones(1,N)*2 ones(1,N)*3]; % Visitas
% 
% % [p,tblAnn2,stats,terms] = anovan(XX,{g1,g2},'model','interaction','display',plan); %'sstype',3
% [p,tblAnn,stats,terms] = anovan(XX,{g1 g2},'display',plan); %'sstype',3
% T.tblAnn=tblAnn;
% 
% results = multcompare(stats,'Dimension',2,'display',plan);
% tblMultC=table(results(:,1),results(:,2),results(:,3),results(:,4),results(:,5),results(:,6),...
%     'VariableNames',{'Group1','Group2','Low_CI','DiffMeans','High_CI','p_Value'});
% T.tblMultC{2}=tblMultC;


% % ANOVA
% [p,tbl,stats] = anova1(X);
% [c,m] = multcompare(stats);
% % anovatbl = anova(rm)


else
    
    [p,tblKW,stats] = kruskalwallis(X,[],plan);
    T.tblKW=tblKW;
    
    results = multcompare(stats,'display',plan);
    tblMultC=table(results(:,1),results(:,2),results(:,3),results(:,4),results(:,5),results(:,6),...
        'VariableNames',{'Group1','Group2','Low_CI','DiffMeans','High_CI','p_Value'});
    T.tblMultC{1}=tblMultC;
    
    pValue=p; % Kruskal-Wallis
end
if flagDisp
    
disp('Descriptive statistic................................................')
disp(DescriptiveTab)
disp('Shapiro-Wilk.........................................................')
disp(T.tblSW)

if flag_normal

    disp('Test de Mauchly..................................................')
    disp(T.tblMc)
    disp('Epsilon..........................................................')
    disp(T.tblEps)
    disp('Repeated measures analysis of variance...........................')
    disp(T.ranovatbl)
%         disp('Repeated measures analysis of variance: Expanded details')
%         disp(T.tblAnn)


else
    disp('Kruskal-Wallis...................................................')
    disp(T.tblKW)

end

disp('Multiple comparison between-groups...............................')
disp(T.tblMultC{1})

end

Flag.flag_normal=flag_normal;
Flag.flag_Mc=flag_Mc;