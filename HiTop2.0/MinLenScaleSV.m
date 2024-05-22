function [xPhys]=MinLenScaleSV(xPhys,maxloop,HS,HsS,HV,HsV,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr)
parameters

% Set boxcar weighting function parameters
step_s = 3/12;
step_v = 3/12;
step_xv = .26;
alpha=15;
alpha_xv = alpha;
phiMax=1;

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

%% INITIALIZE ITERATION
% x = repmat(volfrac,nely,nelx); % phi
x=xPhys;
% Ws and Wv and Wxv - phase variables 
Ws=1./(1+exp(-(x-(1-step_s))*alpha))-1./(1+exp(-(x-(1+step_s))*alpha));
Wv=1./(1+exp(-(x-(0-step_v))*alpha))-1./(1+exp(-(x-(0+step_v))*alpha));

% Plot boxcar weighting function
figure(figNum);
t=tiledlayout(2,3);
iter='0-50';
graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)

% Miu/xTilde - Filtered phase variables
xTildeS(:)=HS*(Ws(:)./HsS); % Filter for solid
xTildeS=reshape(xTildeS,nely,nelx);
xTildeV(:)=HV*(Wv(:)./HsV); % Filter for void
xTildeV=reshape(xTildeV,nely,nelx);
umax=phiMax;

% xPhys S and V --> xPhys - heavisides
xPhysS=1-exp(-betaHP*xTildeS)+(xTildeS./umax)*exp(-betaHP*umax); %HPM of solid
xPhysV=1-exp(-betaHP*xTildeV)+(xTildeV./umax)*exp(-betaHP*umax); %HPM of void
xPhys=(xPhysS+(1-xPhysV))/2; % combine to one density
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

max_loop = maxloop;
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
  % d Ws / d phi
  dws=(alpha*exp(alpha*(-1*(x)-step_s+1  )))./(1+exp(alpha*(-1*(x)-step_s+1))).^2-(alpha*exp(alpha*(-1*(x)+step_s+1)))./(1+exp(alpha*(-1*(x)+step_s+1))).^2;
  % d Wv / d phi
  dwv=(alpha*exp(alpha*(-1*(x)-step_v+0  )))./(1+exp(alpha*(-1*(x)-step_v+0))).^2-(alpha*exp(alpha*(-1*(x)+step_v+0  )))./(1+exp(alpha*(-1*(x)+step_v+0))).^2;
  % drho / dUs
  dx_s=(betaHP*exp(-betaHP.*xTildeS)+exp(-betaHP)); 
  % drho / dUv
  dx_v=(betaHP*exp(-betaHP.*xTildeV)+exp(-betaHP));
  % dc / dWs (dc/drho * drho/dUs * dUs/dWs)
  dc_s=.5*(HS*(dc(:).*dx_s(:)))./HsS;
  % dc / Wv (dc/drho * drho/dUv * dUv/dWv)
  dc_v=-.5*(HV*(dc(:).*dx_v(:)))./HsV;
  % dc / dphi (dc/dWS * dWs/dphi)
  dc_s=dc_s.*dws(:);
  % dc / dphi (dc/dWv * dWv/dphi)
  dc_v=dc_v.*dwv(:);
  % combine dc
  dc(:)=(dc_s(:)+dc_v(:));
  % dv / dWs (dv/drho * drho/dUs * dUs/dWs)
  dv_s(:)=.5*(HS*(dv(:).*dx_s(:)))./HsS;
  % dv / dWv (dv/drho * drho/dUv * dUv/dWv)
  dv_v(:)=-.5*(HV*(dv(:).*dx_v(:)))./HsV;
  % dv_s/dphi (dv/dWs * dWs/dphi)
  dv_s=reshape(dv_s,nele,1);
  dv_s=dv_s.*dws(:);
  % dv_v/dphi (dv/dWv * dWs/dphi
  dv_v=reshape(dv_v,nele,1);
  dv_v=dv_v.*dwv(:);
  % combine dv
  dv(:)=(dv_s(:)+dv_v(:));
  if passive_usr==2 % skip if no voids
      xdes=x; dvDes=dv; dcDes=dc;
  else 
        dcA=dc(:);dvA=dv(:); xA=x; % to preserve dc,dv,x
        dcDes=dcA(el_D);dvDes=dvA(el_D);xdes=xA(el_D);
        xdes=xdes'; 
  end
  %% METHOD OF MOVING ASYMPTOTES
  xval=xdes(:); 
  f0val=c;
  df0dx=dcDes(:);
  fval=sum(xPhys(:))/(volfrac*nele)-1; 
  dfdx=dvDes(:)'/(volfrac*neleD);
  [xmma,~,~,~,~,~,~,~,low,upp]=mmasub(m,n,loop,xval,xmin,xmax,xold1,xold2, ...
      f0val,df0dx,fval,dfdx,low,upp,a0,a,c_MMA,d,betaMMA);
  %Update MMA Variables
  xnew(el_D)=xmma;
  xnew(elloc)=passive_usr;
  xnew=reshape(xnew,nely,nelx);
  % Ws and Wv and Wxv
  Ws=1./(1+exp(-(xnew-(1-step_s))*alpha))-1./(1+exp(-(xnew-(1+step_s))*alpha));
  Wv=1./(1+exp(-(xnew-(0-step_v))*alpha))-1./(1+exp(-(xnew-(0+step_v))*alpha));
  xTildeS(:)=HS*(Ws(:)./HsS); % Filter for solid
  xTildeS=reshape(xTildeS,nely,nelx);
  xTildeV(:)=HV*(Wv(:)./HsV); % Filter for void
  xTildeV=reshape(xTildeV,nely,nelx);
  xPhysS=1-exp(-betaHP*xTildeS)+(xTildeS./umax)*exp(-betaHP*umax); %HPM of solid
  xPhysV=1-exp(-betaHP*xTildeV)+(xTildeV./umax)*exp(-betaHP*umax); %HPM of void
  xPhys=(xPhysS+(1-xPhysV))/2; % combine to one density
  xold2=xold1(:);
  xold1=xdes(:);
  change = max(abs(xmma(:)-xdes(:)));
  x = xnew;
  %% PRINT RESULTS
  fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f p:%7.3f \n',loop,c, ...
    mean(xPhys(:)),change,penal);
  %% PLOT DENSITIES
  figure(figNum+1)
  colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;

  %% Continuation 
   if loop >=50 && loop < 150
      alpha=45;
      alpha_xv=45;
        if loop ==50
            iter='50-150';
            graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)
        end
  elseif loop >=150 && loop < 200
      step_s=2/12;step_v=2/12; step_xv=.26;
      alpha=15; alpha_xv=15; 
          if loop ==150
              iter='150-200';
              graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)
          end
  elseif loop >=200 && loop < 350
       alpha=45;
       alpha_xv=45;
       penal=5;
       if loop==200
               iter='200-350';
               graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)
       end
  elseif loop >=350
     step_s=1.6/12;step_v=1.6/12; step_xv=.22;
    alpha=55;  
    penal=7;
        if loop ==350
             iter='350-600';
             graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)
        end
    end
end
end

 function graphHP(step_s,step_xv,step_v,alpha,alpha_xv,iter,t)
        nexttile(t)
        hold on
        xgraph=0:0.001:1.0;
        [ygraph_s]=1./(1+exp(-(xgraph-(1-step_s))*alpha))-1./(1+exp(-(xgraph-(1+step_s))*alpha));
        [ygraph_v]=1./(1+exp(-(xgraph-(0-step_v))*alpha))-1./(1+exp(-(xgraph-(0+step_v))*alpha));
        [ygraph_xv]=1./(1+exp(-(xgraph-(0-step_xv))*alpha_xv))-1./(1+exp(-(xgraph-(0+step_xv))*alpha_xv));
        plot(xgraph,ygraph_s,'r','LineWidth',1);
        plot(xgraph,ygraph_v,'b','LineWidth',1);
        plot(xgraph,ygraph_xv,'g','LineWidth',1);
        Ostep_s = 3/12;
        Ostep_v = 3/12;
        Ostep_xv = .26;
        Oalpha=30;
        Oalpha_xv = Oalpha;
        [ygraph_sO]=1./(1+exp(-(xgraph-(1-Ostep_s))*Oalpha))-1./(1+exp(-(xgraph-(1+Ostep_s))*Oalpha));
        [ygraph_vO]=1./(1+exp(-(xgraph-(0-Ostep_v))*Oalpha))-1./(1+exp(-(xgraph-(0+Ostep_v))*Oalpha));
        [ygraph_xvO]=1./(1+exp(-(xgraph-(0-Ostep_xv))*Oalpha_xv))-1./(1+exp(-(xgraph-(0+Ostep_xv))*Oalpha_xv));
        plot(xgraph,ygraph_sO,'r');
        plot(xgraph,ygraph_vO,'b');
        plot(xgraph,ygraph_xvO,'g');
        legend("Solid","Void","Max","Solid-orig","Void-orig","Max-orig")
        title('Weighting',iter);
        hold off
    end