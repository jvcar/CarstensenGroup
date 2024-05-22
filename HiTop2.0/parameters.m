%% INPUTS
nelx=300;
nely=100;
volfrac=0.5;
rminS=3; 
rminV=3;
betaMMA = 5; 
betaHP = betaMMA; 
penal = 3;
nele=nelx*nely;


%% Notes on Parameters
% low values of rmin (1.5-2) tend to generate unsymmetric results
% higher values of rmin (3-4) will tend towards symmetry
% beta MMA and HP are the same, and best performing when set to 3-5
% Penalization = 3 is best, coninuation scheme is constant across all
% algorithms


