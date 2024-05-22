function [U,freedofs,F]=GUI(nelx,nely)
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
ndof=2*(nelx+1)*(nely+1); nnode=(nely+1)*(nelx+1);
lg_ndof=reshape(1:ndof,2,nnode);
% Create design space
figure(1); map2 = [1 1 1]; colormap(map2);
pcolor(meshgrid(1:nelx+1,1:nely+1)); grid on; axis equal;caxis([0 1]);
% Highlight ROI 1 = FORCE
fprintf('Highlight location of force \n')
roiF = drawrectangle('Color','Red');
%Wait until user finishes editing ROI
l = addlistener(roiF,'ROIClicked',@clickCallback);
uiwait;
delete(l);
% load('cantF.mat')
% Make Force Vector
dir=input('Direction force (1=x,2=y,3=x,y): ');
[F]=roi2Force(nelx,nely,roiF,ndof,lg_ndof,nodenrs,dir);

ask_BC=input('How many BCs (1 or 2): ');
BCnode_edge=input('Do you want to select manually or pick edge (1=manual,2=edge): ');
if BCnode_edge==1
    % Highlight ROI 2 = BC
    fprintf('Highlight location of BC 1 \n')
    roiBC1=drawrectangle('Color','Blue');
    %Wait until user finishes editing ROI
    l = addlistener(roiBC1,'ROIClicked',@clickCallback);
    uiwait;
    delete(l);
    % load('cantBC.mat')
    % Make BC 1 
    dir_bc1=input('DOF restriction (1=x,2=y,3=x,y): ');
    [fixeddofs]=roi2BC(nelx,nely,roiBC1,lg_ndof,nodenrs,dir_bc1);
elseif BCnode_edge==2
   % Choose edge and DOF restriction
        choose_edge=input('Select which edge (1=left,2=bottom,3=right,4=top: ');
        dir_bc_edge=input('DOF restriction (1=x,2=y,3=x,y): ');
        [fixeddofs]=edge2BC(choose_edge,dir_bc_edge,nely,nnode,lg_ndof);
        if choose_edge ==1
            drawrectangle('Position',[0 0 1 nely+1],'Color','blue');
        elseif choose_edge==2
            drawrectangle('Position',[0 nely+1 nelx+1 1],'Color','blue');
        elseif choose_edge==3
            drawrectangle('Position',[nelx 0 1 nely+1],'Color','blue');
        elseif choose_edge==4
            drawrectangle('Position',[0 0 nelx 1],'Color','blue');
        end
end
if ask_BC==2
    BCnode_edge=input('Do you want to select manually or pick edge (1=manual,2=edge): ');
    if BCnode_edge==1
        % Highlight ROI 3 = BC 
        fprintf('Highlight location of BC 2 \n')
        roiBC2=drawrectangle('Color','Blue');
        % Wait until user finishes editing ROI
        l = addlistener(roiBC2,'ROIClicked',@clickCallback);
        uiwait;
        delete(l);
        % Make BC 2
        dir_bc2=input('DOF restriction (1=x,2=y,3=x,y): ');
        [fixeddofs2]=roi2BC(nelx,nely,roiBC2,lg_ndof,nodenrs,dir_bc2);
        fixeddofs=union([fixeddofs],[fixeddofs2]);
    elseif BCnode_edge==2
        % Choose edge and DOF restriction
        choose_edge=input('Select which edge (1=left,2=bottom,3=right,4=top: ');
        dir_bc_edge=input('DOF restriction (1=x,2=y,3=x,y): ');
        [fixeddofs2]=edge2BC(choose_edge,dir_bc_edge,nely,nnode,lg_ndof);
        fixeddofs=union([fixeddofs],[fixeddofs2]);
        if choose_edge ==1
            drawrectangle('Position',[0 0 1 nely+1],'Color','blue');
        elseif choose_edge==2
            drawrectangle('Position',[0 nely+1 nelx+1 1],'Color','blue');
        elseif choose_edge==3
            drawrectangle('Position',[nelx 0 1 nely+1],'Color','blue');
        elseif choose_edge==4
            drawrectangle('Position',[0 0 nelx 1],'Color','blue');
        end
    end
end
% Set up displacement, alldofs, freedofs vectors
U = zeros(ndof,1);
alldofs = [1:ndof];
freedofs = setdiff(alldofs,fixeddofs);
function clickCallback(~,evt)
    if strcmp(evt.SelectionType,'double')
        uiresume;
    end
end
end