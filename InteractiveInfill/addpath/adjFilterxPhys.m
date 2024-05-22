function [xPhysInfill,xPhysmap]=adjFilterxPhys(el_display,xPhys)
parameters
% PREPARE FILTER that enforces the minimum feature size
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

% Repeat the infill pattern (el_display) across the design domain to form
% xPhysInfill
factorX=2*ceil(nelx/patchX);
factorY=2*ceil(nely/patchY);
xPhysInfill=repmat(el_display,factorY,factorX); % repeated infill pattern
xPhysInfill=xPhysInfill(1:nely,1:nelx);

%% Filter the repeated infill pattern to enforce rmin and force to 0,1
xPhysInfill(:)=(H*xPhysInfill(:))./Hs;
figure(4); % Filtered with the classic density filter 
imagesc(1-xPhysInfill); axis equal; colormap('gray');
xPhysInfill=1-exp(-betaHP*xPhysInfill)+xPhysInfill*exp(-betaHP);
figure(5); % Filtered with the Heaviside's Projection function to push to 0,1 
imagesc(1-xPhysInfill); axis equal;colormap('gray');
figure(6); % Force the density values to either be 0 or 1 for binary field
xPhysInfill(xPhysInfill>=cutoff)=1; xPhysInfill(xPhysInfill<cutoff)=0;
imagesc(1-xPhysInfill); axis equal;colormap('gray');
figure(7) % Show the singular binary infill patch the user has generated
imagesc(1-xPhysInfill(1:patchY,patchX+1:patchX*3+1)); axis equal;colormap('gray');

%% Overlay the 50 iteration optimized design (xPhys) with the infill field (xPhysInfill)
xPhysmap=xPhysInfill*2;
xPhysmap=xPhysmap+xPhys;
figure(8); imagesc(1-xPhysmap); axis equal; axis off; colormap('gray');

%% Adjust the alignment of the infill pattern if the user desires
want_change=input('Change the alignment of the infill? Yes(1) No (0)');
if want_change==1
    el_rep=xPhysInfill(1:patchY,patchX+1:patchX*3+1);
    xPhysPres=repmat(el_rep,factorY,factorX); % Generate a matrix of infill
% patterns (xPhysPres) much larger than the design space (nelx,nely) so 
% the user can adjust the alignment of the repeated infill field with 
% the optimized design
    changeLOC=1;n=1; adjLR=0; adjUD=0;
    while changeLOC~=0
        adjBin=input('change L/R (0) or U/D (1)');
        if adjBin==0
            adjLRnew=input('Shift ? elements Left (+) or Right (-)');
            adjLR=adjLR+adjLRnew;
            xPhysInfill=xPhysPres(nely/2+adjUD+patchY/2:3*nely/2+adjUD+patchY/2-1,nelx/2+patchX+adjLR:3*nelx/2+adjLR+patchX-1);
        else 
            adjUDnew=input('Shift ? elements Up (+) or Down (-)');
            adjUD=adjUD+adjUDnew;
            xPhysInfill=xPhysPres(nely/2+adjUD+patchY/2:3*nely/2+adjUD+patchY/2-1,nelx/2+patchX+adjLR:3*nelx/2+adjLR+patchX-1);
        end
        xPhysmap=xPhysInfill*2;
        xPhysmap=xPhysmap+xPhys;
        figure(8);
        imagesc(1-xPhysmap); axis equal; axis off;colormap('gray');
        changeLOC=input('Make another adjustment? Yes (1) No (0)');
        n=n+1;
    end
else
end
end