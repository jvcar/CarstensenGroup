function []=StressPlot(xPhys,U,figNum)
parameters

%% MATERIAL PROPERTIES
E0 = 1;
Emin = 1e-9;
nu = 0.3;
nodenrs = reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1,nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
  
%Strain-Displacement matrix for 4-node element
B = [-1/2   0    1/2     0     1/2   0    -1/2   0
      0    -1/2   0     -1/2   0     1/2   0     1/2
     -1/2  -1/2  -1/2    1/2   1/2   1/2   1/2  -1/2];
% UE = reshape(sum(U(edofMat),2),100,160);
 
%Constitutive matrix for plane stress
DE = 1/(1-nu^2)*[ 1   nu  0
                 nu  1   0
                 0   0   (1-nu)/2];
 
%% UNPENALIZED STRESS CALCULATION
E_plot = Emin+xPhys(:)*(E0-Emin);
s = (U(edofMat)*(DE*B)').*repmat(E_plot,1,3);
vms = sqrt(sum(s.^2,2)-s(:,1).*s(:,2)+2.*s(:,3).^2);
vms = reshape(vms,[nely,nelx]);

% Plot stress distribution on a scale of 0 to 0.5 of max VMS 
figure(figNum)
colormap(jet); imagesc(vms); caxis([0 max(vms(:))*.5]); axis equal; axis off; drawnow;
colorbar;
max(vms(:))

end