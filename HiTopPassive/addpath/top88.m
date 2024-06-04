function [xPhys,F,U,freedofs]=top88(xPhys,maxloop,figNum,U,freedofs,F,neleD,elloc,el_D,ellocFree)

parameters;
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
iH = ones(nelx*nely*(2*(ceil(rmin)-1)+1)^2,1);
jH = ones(size(iH));
sH = zeros(size(iH));
k = 0;
for i1 = 1:nelx
  for j1 = 1:nely
    e1 = (i1-1)*nely+j1;
    for i2 = max(i1-(ceil(rmin)-1),1):min(i1+(ceil(rmin)-1),nelx)
      for j2 = max(j1-(ceil(rmin)-1),1):min(j1+(ceil(rmin)-1),nely)
        e2 = (i2-1)*nely+j2;
        k = k+1;
        iH(k) = e1;
        jH(k) = e2;
        sH(k) = max(0,rmin-sqrt((i1-i2)^2+(j1-j2)^2));
      end
    end
  end
end
H = sparse(iH,jH,sH);
Hs = sum(H,2);
%% INITIALIZE ITERATION
x = xPhys;
xTilde=x;
xPhys=1-exp(-betaHP*xTilde)+xTilde*exp(-betaHP);
loop = 0;
loopbeta=0;
change = 1;
%% INITIALIZE MMA OPTIMIZER
m=1; % number of general constrinats
n=neleD; %number of design variables x_j
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
while change > 0.01 && maxloop>loop
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
  dcA=dc(:);dvA=dv(:); xA=x; % using A preserves full dc,dv,x vectors
  dcDes=dcA(el_D);dvDes=dvA(el_D);xdes=xA(el_D); % active elements only, fed into MMA
  xdes=xdes'; 
 %% METHOD OF MOVING ASYMPTOTES
  xval=xdes(:); % excludes the passive elements
  f0val=c;
  df0dx=dcDes(:);
  fval=sum(xPhys(:))/(volfrac*nele)-1; 
  dfdx=dvDes(:)'/(volfrac*neleD);
  [xmma,~,~,~,~,~,~,~,low,upp]=mmasub(m,n,loop,xval,xmin,xmax,xold1,xold2, ...
      f0val,df0dx,fval,dfdx,low,upp,a0,a,c_MMA,d,betaHP);
  %Update MMA Variables
  xnew(el_D)=xmma; % reformat x with the updated design variables, prescribed void and solid elements
  xnew(elloc)=0;
  xnew(ellocFree)=1;
  xnew=reshape(xnew,nely,nelx);
  xTilde(:)=(H*xnew(:))./Hs;
  xPhys=1-exp(-betaHP*xTilde)+xTilde*exp(-betaHP);
  xold2=xold1(:);
  xold1=xdes(:);
  change = max(abs(xmma(:)-xdes(:)));
  x = xnew;
  %% PRINT RESULTS
  fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f p:%7.3f beta:%7.3f \n',loop,c, ...
    mean(xPhys(:)),change,penal,betaHP);
  %% PLOT DENSITIES
  figure(figNum); 
  colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;
  if loop >25 && loop<50
      betaHP=3;
  elseif loop >50 && loop <100
      penal=3;
      betaHP=5;
  elseif loop > 100 && loop < 150
      penal=4;
      betaHP=10; 
  elseif loop > 200 
      penal=5;
      betaHP=15; 
  end
end
