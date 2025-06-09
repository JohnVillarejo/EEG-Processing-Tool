function [P,V,D,VT] = PGA(X,Comp)

% Computing principal components by applying the principal geodesic analysis (PCA)

%References

%[1] Fletcher, P. Thomas, et al. "Principal geodesic analysis for the study of nonlinear statistics of shape." 
%    IEEE transactions on medical imaging 23.8 (2004): 995-1005.

%[2] Barachant, Alexandre, et al. "Multiclass brain–computer interface classification by Riemannian geometry."
%    IEEE Transactions on Biomedical Engineering 59.4 (2011): 920-928.

%[3] Yang, Jian, et al. "Two-dimensional PCA: a new approach to appearance-based face representation
%  and recognition." IEEE transactions on pattern analysis and machine intelligence 26.1 (2004): 131-137.

% Computing covariance matrices
%  [n,m,k]=size(X);
%  parfor i=1:k
%      Xcov(:,:,i)=cov(X(:,:,i)');%*Xc_trials(:,:,i)';
%  end

 %Computing the intrinsic mean by applying Riemannian (geodesic_distance)
[P,Xcov] = robust_covariance_matrix(X,'geodesic_distance');  
    
%Getting the eigvectors and autovalues maximizing

M=sqrtm(P); %square root of P 

% Projecting the covariance matrices onto the tangential space at P
% Obtaining Si=log_p_X=P^(1/2)*log(P^(-1/2)*Xcov*P^(-1/2))*P^(1/2), as done
% by [2]

S=0;
M_inv=inv(M);
for i=1:size(X,3)
    Si(:,:,i)=M*logm(M_inv*Xcov(:,:,i)*M_inv)*M;
    S=S+Si(:,:,i);
end
S=S./size(X,3);  %mean value

%Computing the eigenvectors and eigenvalues 
[V,D] = eig(S);
%[D, order] = sort(diag(D),'descend');  
%V = V(:,order);


d=1:size(V,2);
%Comp=[];

Vc=[];Dc=[];
var_max=0.1;
var_max_updated=0;
computed_ratio=100;
%while(var_max>=var_max_updated(end) & size(Vc,2)<Comp) % 3)%
best_k_components=1;
while(computed_ratio>5 & (best_k_components-1)<Comp) % 3)%
    clear logp;
    
   % var_max_updated(end+1)=var_max;
    for i=1:size(Si,3)
        logp(i,1:size(V,2))=0;
        for m=best_k_components:size(V,2)%d(best_k_components:end)
            if best_k_components==1  %size(Vc,2)==0  
               Y=X(:,:,i)'*V(:,m);
               logp(i,m)=norm(cov(Y),2)^2;
            else
                
           
               
               for k=1:best_k_components-1%size(Vc,2)
                   Y=X(:,:,i)'*V(:,k);
                   logp(i,m)=logp(i,m)+norm(cov(Y),2)^2;
               end
               Y=X(:,:,i)'*V(:,m);
              logp(i,m)=logp(i,m)+norm(cov(Y),2)^2;
                
            end
        end
    end  
    
     %Getting successive main principal components
     [var_max,I]=max(sum(logp));
     if var_max_updated(end)<var_max
         pos=(best_k_components-1)+find(d(best_k_components:end)~=d(I));
         V= [V(:,1:best_k_components-1) V(:,I) V(:,pos)];
         D= [D(:,1:best_k_components-1) D(:,I) D(:,pos)];
         d= [d(1:best_k_components-1) d(I) d(pos)];
         
         var_max_updated(best_k_components)=var_max;
         if best_k_components>1
            computed_ratio=min(diff(var_max_updated)./max(diff(var_max_updated))*100);
         end
       
         best_k_components=best_k_components+1;
     else
         break;
     end
    
end

     VT=V(:,1:best_k_components-1)';

end

