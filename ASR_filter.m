function [ Xclean ] = ASR_filter(calibration_set,X,Fs,K,ASR_method,covariance_mean)
% UNTITLED Summary of this function goes here
% Xc: calibration set

%See references
%[1]Mullen, Tim R., et al. "Real-time neuroimaging and cognitive monitoring using wearable dry EEG." 
%  IEEE Transactions on Biomedical Engineering 62.11 (2015): 2553-2567.

%[] Blum, Sarah, et al. "A Riemannian modification of artifact subspace reconstruction for EEG artifact
% handling." Frontiers in human neuroscience 13 (2019): 141.

%[] Blum, Sarah, Bojana Mirkovic, and Stefan Debener. "Evaluation of Riemannian ASR on cEEGrid data:
%  an artifact correction method for BCIs." 2019 IEEE International Conference on Systems, Man and 
% Cybernetics (SMC). IEEE, 2019.



%Getting the calibration set Xc, and rejecting segments with z-score values out of the interval [-3.5,5.5]
[Q,m,k]=size(calibration_set);

% computing the RMS values on the calibration set
for i=1:k
    rms_calibration_set(:,:,i)=rms(calibration_set(:,:,i)')';
end
%Computing the mean value
S=0;
for i=1:k
    S=S+sum(rms_calibration_set(:,:,i)');
end
MU=S./k;
%Computing the standard deviation value
S=0;
for i=1:k
    S=S+sum((rms_calibration_set(:,:,i)'-MU).^2);
end
STD=sqrt(S./(k-1));
%Concatening clean segments
clean_segments=[];Xc=[];
trial=0;
T=round(0.5/(1/Fs)); %sucessive windows
for i=1:k
    z=(rms_calibration_set(:,:,i)'-MU)./STD;
    if sum(sum(z<-3.5))==0 & sum(sum(z>5.5))==0%sum(sum(z<-3.5))==0 & sum(sum(z>5.5))==0
       Xc=[Xc;calibration_set(:,:,i)'];
       clean_segments=[clean_segments;i];
       for j=1:T:m
          trial=trial+1;
          Xc_trials(:,:,trial)=calibration_set(:,(j-1)+[1:T],i);
       end
       
    end
end


 
 
%PCA: principal component analysis
%PGA: principal geodesic analysis

%[s] = sample_variance(Ui,Up);
%principal_components='PCA';
if strcmp(ASR_method,'PCA')==1
 %Getting the geometric mean
 %Eucledian (L1- median): 'geometric_median' 
%



 %Getting the geometric median as done by [1]
 %Eucledian (L1- median): 'geometric_median' 
 %Riemannian: 'geodesic_distance'
[Xc_cov,~] = robust_covariance_matrix(Xc_trials,covariance_mean);
Comp=size(Xc_trials,1);
%Xc_cov=Up;%cov(Xc);
Mc=sqrtm(Xc_cov);
[Vc,Dc] = eig(Mc);
[Dc, order] = sort(diag(Dc),'descend'); 
Vc = Vc(:,order);
Dc=Dc(1:Comp,1);
Vc=Vc(:,1:Comp);
VcT=Vc';

% %Obtaining projection of Xc onto V'*Xc
% Yc=(VcT*Xc')';
% %Computing the RMS signal of Yc
% windows=round(0.5/(1/Fs));
% [n,k]=size(Yc);
% parfor i=1:n-windows-1
%     rms_signal(i,:)=rms(Yc(i:i+windows-1,:));
% end
% 
% %K value can be typically set between 5 and 7. We selected K=5. 
% t=mean(rms_signal)+K*std(rms_signal);
% T=diag(t)*VcT;

elseif strcmp(ASR_method,'PGA')==1
      %Computing components through principal geodesic analysis
      Comp=size(Xc_trials,1);
      [P,Vc,Dc,VcT] = PGA(Xc_trials,Comp);
      Mc=sqrtm(P);      
end

%Obtaining projection of Xc onto V'*Xc
Yc=(VcT*Xc')';
%Computing the RMS signal of Yc
windows=round(0.5/(1/Fs));
n=size(Yc,1);
for i=windows:n%i=1:n-windows-1
    rms_signal(i-windows+1,:)=rms(Yc(i-windows+1:i,:));
end

%Computing threshold T
%K value can be typically set between 5 and 7. We selected K=5. 
%t=median(rms_signal)+K*mad(rms_signal,1);
t=mean(rms_signal)+K*std(rms_signal);
T=diag(t)*VcT;

N=size(X,3);

for i=1:N
    X_cov=cov(X(:,:,i)');
    [V,D] = eig(X_cov); 
    [D, order] = sort(diag(D),'descend');  
     V = V(:,order);
     W=V';
     tv=T*V;
   %  tv=T*W;
     Mp=W*Mc;
     Vtrunc=[];
     for j=1:length(tv)
         L=D(j)<norm(tv(:,j),2)^2;%
         Vtrunc=[Vtrunc V(:,j)*L]; 
      %   Vtrunc=[Vtrunc Mp(:,j)*L];
      %   Vtrunc=[Vtrunc;Mp(j,:)*L];
     %    Vtrunc=[Vtrunc V(:,j)*L];
     end
   % Mp=W*Mc;
  %  R=V*Mp*pinv(Vtrunc)*W;
     R=V*Mp*pinv(Vtrunc'*Mc)*W;
     Xclean(:,:,i)=real(R*X(:,:,i));
    %Xclean(:,:,i)=real(Mc*pinv(Vtrunc*Mc)*W*X(:,:,i));
end

end

