function [D]=CalcDist(ind,num_ind,H_w,xPhys,xPhysInfill)
% Calculate Distance vector between optimized design (xPhys) and the
% repeated infill pattern field (xPhysInfill)
D=zeros(num_ind,1);
for j =1:num_ind
    i=ind(j);
    num_p=H_w(:,i).*xPhys(:);
    num_a=H_w(:,i).*xPhysInfill(:); 
    num=(num_p-num_a).^2;
    total=sum(num(:));
    denom=sum(H_w(:,i));
    D(j,1)=total./denom;
end
end