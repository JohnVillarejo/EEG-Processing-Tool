function [U,Xcov] = robust_covariance_matrix(Xi,covariance_mean)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%References
%[1] Fletcher, P. Thomas, et al. "Principal geodesic analysis for the study
% of nonlinear statistics of shape." IEEE transactions on medical imaging 23.8 (2004): 995-1005.

 k=size(Xi,3);
 parfor i=1:size(Xi,3)
     Xcov(:,:,i)=cov(Xi(:,:,i)');%*Xc_trials(:,:,i)';
 end

if strcmp('mean_covariance',covariance_mean)==1
    %Computing the mean covariance


     S=0;
     for i=1:k
         S=S+Xcov(:,:,i);
     end
     U=S./k;  % mean covariance
    
     return;
elseif strcmp('geometric_median',covariance_mean)==1
    for i=1:k
        parfor j=1:k
            S(j,i)=norm(Xcov(:,:,j)-Xcov(:,:,i),2); 
        end
    end
elseif strcmp('geodesic_distance',covariance_mean)==1
    for i=1:k
        Xcov_inv=inv(Xcov(:,:,i));
        for j=1:k
            D = eig(Xcov_inv*Xcov(:,:,j));
            S(j,i)=sum(log(D).^2); 
        end
    end    
end
 [~,S_argmin]=min(sum(S));
 U=Xcov(:,:,S_argmin);
end

