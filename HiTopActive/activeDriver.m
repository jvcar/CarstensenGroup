clear 
close all
tic
parameters
addpath addpath/
addpath addpath/MMA_Nov22/
set(0,'DefaultFigureWindowStyle','docked')
%% GUI
[U,freedofs,F]=GUI(nelx,nely);

%% 50 Iterations of Traditional TO
max_loop=50;
[xPhys,H,Hs]=top88MMA(nelx,nely,volfrac,rmin,max_loop,U,freedofs,F,2); 

%% Draw 2 ROIs - region of drawing and input drawing to be replicated
[xPhys,elloc, neleD,el_D,ellocFree,xPhysbig,ind]=draw_infill(nelx,nely,3,xPhys);

%% Calculate Distance, Appearance Constraint, and Astar Parameter
num_ind=length(ind);
DTotal=(xPhys-xPhysbig).^2;
D=DTotal(ind);

A=sum(D(:))./(num_ind);
Astar=gamma*A

%% Run with activated appearance constraint
max_loop=600;
ind=ind(:);
xPhys(ind)=xPhysbig(ind);
[xPhys,D,A]=AppTop88(xPhys,xPhysbig,Astar,ind,num_ind,max_loop,U,freedofs,F);
toc
