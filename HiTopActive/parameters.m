%% INPUTS
nelx=240;
nely=160;
volfrac=0.5;
rmin =3; 
betaHP = 3; 
penal = 3;

%Other Calcs:
nele=nelx*nely;
gamma=0.1;

%% Notes on Parameters
% low values of rmin (1.5-2) tend to generate unsymmetric results
% higher values of rmin (3-4) will tend towards symmetry
% beta HP = 3 and penal = 3 will both increase according to 
% continuation schemes
% Since the user is drawing the input to be replicated, the distance
% formulation uses a basic squared difference equation. Therefore, lower
% gamma values 0.5-0.3 are necessary for stricter replication of the infill
% compared to the interactive infill approach.