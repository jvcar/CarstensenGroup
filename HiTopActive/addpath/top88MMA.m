%%%% AN 88 LINE TOPOLOGY OPTIMIZATION CODE Nov, 2010 %%%%
function [xPhys,H,Hs]=top88MMA(nelx,nely,volfrac,rmin,max_loop,U,freedofs,F,figNum)
parameters

%% MATERIAL PROPERTIES
E0 = 1;
Emin = 1e-9;
nu = 0.3;
nele=nelx*nely;
%% PREPARE FINITE ELEMENT ANALYSIS
A11 = [12  3 -6 -3;  3 12  3  0; -6  3 12 -3; -3  0 -3 12];
A12 = [-6 -3  0  3; -3 -6 -3 -6;  0 -3 -6  3;  3 -6  3 -6];
B11 = [-4  3 -2  9;  3 -4 -9  4; -2 -9 -4 -3;  9  4 -3 -4];
B12 = [ 2 -3  4 -9; -3  2  9 -2;  4  9  2  3; -9 -2  3  2];
KE = 1/(1-nu^2)/24*([A11 A12;A12' A11]+nu*[B11 B12;B12' B11]);
nodenrs = reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1,nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
iK = reshape(kron(edofMat,ones(8,1))',64*nelx*nely,1);
jK = reshape(kron(edofMat,ones(1,8))',64*nelx*nely,1);
%% PREPARE FILTER
[H,Hs]=PrepFilter(rmin,nely,nelx);
%% INITIALIZE ITERATION
x = repmat(volfrac,nely,nelx);
xTilde=x;
xPhys=1-exp(-betaHP*xTilde)+xTilde*exp(-betaHP); %Heavisides Projection filter 
loop = 0;
loopbeta=0;
change = 1;
%% INITIALIZE MMA OPTIMIZER
m=1; % number of general constrinats
n=nele; %number of design variables x_j
xmin=zeros(n,1); % column vector lower bounds for x_j
xmax=ones(n,1); % column vector upper bounds x_j
xold1=x(:); % xval, one iteration ago (if iter>1)
xold2=x(:); % xval 2 iterations ago (if iter >2)
low=ones(n,1); %column vector with lower asymptotes from previous iteration (if iter>1)
upp=ones(n,1); % column vector with upper asymptotes from previous iteration (if iter<1)
a0=1; % constants a_0 in term a_0*z
a=zeros(m,1); % column vector with constaints a_1 in terms of a_i*z
c_MMA=10000*ones(m,1); % column vector with constaints c_1 in terms c_i*y_i
d=zeros(m,1); % Column vector with constants d_1 in terms 0.5*d_i*(y_i)^2
%% START ITERATION
while change > 0.01 && max_loop>loop
  loopbeta=loopbeta+1;
  loop = loop + 1;
  %% FE-ANALYSIS
  sK = reshape(KE(:)*(Emin+xPhys(:)'.^penal*(E0-Emin)),64*nelx*nely,1);
  K = sparse(iK,jK,sK); K = (K+K')/2;
  U(freedofs) = K(freedofs,freedofs)\F(freedofs);
  %% OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
  ce = reshape(sum((U(edofMat)*KE).*U(edofMat),2),nely,nelx);
  c = sum(sum((Emin+xPhys.^penal*(E0-Emin)).*ce));
  dc = -penal*(E0-Emin)*xPhys.^(penal-1).*ce;
  dv = ones(nely,nelx);
  %% FILTERING/MODIFICATION OF SENSITIVITIES
  dx=betaHP*exp(-betaHP*xTilde)+exp(-betaHP);
  dc(:) = H*(dc(:).*dx(:)./Hs);
  dv(:)=H*(dv(:).*dx(:)./Hs);
  %% METHOD OF MOVING ASYMPTOTES
  xval=x(:);
  f0val=c;
  df0dx=dc(:);
  fval=sum(xPhys(:))/(volfrac*nele)-1;
  dfdx=dv(:)'/(volfrac*nele);
  [xmma,~,~,~,~,~,~,~,low,upp]=mmasub(m,n,loop,xval,xmin,xmax,xold1,xold2, ...
      f0val,df0dx,fval,dfdx,low,upp,a0,a,c_MMA,d,betaHP);
  %Update MMA Variables
  xnew=reshape(xmma,nely,nelx);
  xTilde(:)=(H*xnew(:))./Hs;
  xPhys=1-exp(-betaHP*xTilde)+xTilde*exp(-betaHP);
  xold2=xold1(:);
  xold1=x(:);
  change = max(abs(xnew(:)-x(:)));
  x = xnew;
  %% PRINT RESULTS
  fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f p:%7.3f \n',loop,c, ...
    mean(xPhys(:)),change,penal);
  %% PLOT DENSITIES
  figure(figNum)
  colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;
end
