close all
clear 
set(0,'DefaultFigureWindowStyle','docked')
addpath MMA_Nov22
tic
%% Run Inputs
parameters;
%% Prompt GUI and Define Design Problem
[U,freedofs,F]=GUI(nelx,nely);
passive_usr=input('Do you want to prescribe solid(1), void(0), or neither (2) \n');
if passive_usr==2
    neleD=nele; elloc=[]; el_D=[1:nele];
else
    [neleD,elloc,el_D]=passive();
end
%% Run First 50 iterations
maxloop=50;
xPhys=volfrac*ones(nely,nelx); ellocFree=[]; 
[xPhys,F,U,freedofs]=top88(xPhys,maxloop,2,U,freedofs,F,neleD,elloc,el_D,ellocFree);
%% -----------------ROI -------------- %%
fprintf('Arrived at loop 50. '); 
%% ---------------- DRAW ROI and PASSIVE DESIGNS---------------%% 
maxloop=500;
[xPhys,elloc, neleD,el_D,ellocFree]=draw_infill(nelx,nely,3,xPhys);
[xPhys,F,U,freedofs]=top88(xPhys,maxloop,4,U,freedofs,F,neleD,elloc,el_D,ellocFree);
toc