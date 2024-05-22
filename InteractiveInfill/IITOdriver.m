clear
close all
tic
set(0,'DefaultFigureWindowStyle','docked')
addpath addpath/

%% Run inputs
parameters

%% Prompt GUI
[U,freedofs,F]=GUI(nelx,nely); % only select 1-3 nodes for the force

%% Run first 50 iterations
max_loop=50;
[xPhys,H,Hs]=top88MMA(nelx,nely,volfrac,rmin,max_loop,U,freedofs,F); % figure 2

%% Draw infill
[el_display]=DrawInfill(patchX,patchY); % figure 3
el_displayleft=flip(el_display,2); % reflect the symmetric infill patch
el_displayFull=[el_displayleft,el_display]; % and generate the full infill pattern
[xPhysInfill,xPhysmap]=adjFilterxPhys(el_displayFull,xPhys); % figure 4,5,6,7,8
% this script generates the full, repeated infill field, filters and forces
% the values to be 0 or 1. It also allows the user to change the alignment
% of the infill with the 50 iteration optimized output.

%% Draw ROI(s) to locate the infill
% Enter number of ROIs to place the infill
ROInum=input('How many ROIs do you want to draw? ');
for i = 1:ROInum
    [indS,~,~]=ROI(); 
    indALL{i}=indS;
end
k=1;
for i=1:ROInum
    indTEMP=[indALL{i}];
    ind(k:k+length(indTEMP)-1)=indTEMP;
    k=length(ind)+1;
end
ind=ind'; 
num_ind=length(ind);
ind=unique(ind); % indices of elements located in the ROI

fprintf('ROI(s) drawn. Calculating initial appearance constraint value...\n')
%% Calculate appearance constraint A* parameter from 50 iteration output
% PREPARE FILTER FOR NEIGHBORHOOD W_I 
rSearch=patchY/2; % this radius is what the appearance constraint uses 
% to ensure neighboring elements replicate the infill across the boundary
% of the ROI
[H_w,~]=PrepFilter(rSearch,nely,nelx);
H_w(H_w>0)=1;

% CALCULATE D 
[D]=CalcDist(ind,num_ind,H_w,xPhys,xPhysInfill); % Distance value for each
% element in the ROI

A50=sum(D(:))./(num_ind); % Appearance constraint value for entire
% design based off of the 50 iteration output

% CALCULATE ASTAR
Astar=gamma*A50; % Astar is calculated from the 50 iteration appearance
% constraint value

%% Run interactive infill TO with appearance constraint activated
max_loop=500;
ind=ind(:);

xPhys=volfrac*ones(nely,nelx); % Reset the design domain to a uniform 
% field to better incorporate the activated appearance constraint 

[xPhys,D,A]=active_app_conTop88(H_w,xPhys, ...
    xPhysInfill,Astar,ind,num_ind, ...
    max_loop,U,freedofs,F); % figure 9
toc