%% INPUTS
nelx=240;
nely=160;
volfrac=0.5;
rmin =3; 
betaHP = 1; 
penal = 3;
%Other Calcs:
nele=nelx*nely;

%% Notes on Parameters
% low values of rmin (1.5-2) tend to generate unsymmetric results
% higher values of rmin (3-4) will tend towards symmetry
% beta HP = 1 and penal = 3 will both increase according to 
% continuation schemes
