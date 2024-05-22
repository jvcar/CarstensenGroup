%% INPUTS
nelx=300;
nely=100;
volfrac=0.5;
rmin=3; 
betaMMA=5; 
betaHP=5; 
penal=3;
nele=nelx*nely;

% Inputs for the appearance constraint
gamma=0.3;
patchX=15; patchY=30;
cutoff=0.5;

%% Notes on Parameters
% low values of rmin (1.5-2) tend to generate unsymmetric results
% higher values of rmin (3-4) will tend towards symmetry
% beta MMA and HP are the same, and best performing when set to 3-5
% Penalization = 3 is best, coninuation scheme is constant across all
% algorithms

% low values of gamma (0.1-0.3) will more strictly replicate the infill
% high values of gamma (0.5-0.7) will loosely mirror the infill
% patchX is half of the x-dimension number of elements for the 
% infill patch, and patchY is the full y-dimension 
% These parameters can be equal to form a square, or unequal to form
% a rectangular infill patch
% cutoff is the number that the adjFilterxPhys.m uses to force the infill
% pattern to be 0 or 1
