# Interactive Infill Topology Optimization Guided by User Drawn Patterns

Interactive infill is a human in the loop design optimization code published in the recent paper ([here](https://doi.org/10.1080/17452759.2024.2361864)). 

Interactive infill begins with a GUI, allowing for flexible design problem formulation, then runs 50 iterations of traditional topology optimization. With knowledge of the initial optimized layout, the user draws half of a symmetric infill pattern, draws a region of interest (ROI) to enforce the infill, and the optimization resumes with the appearance constraint enforced in the ROI. 

## File Familiarization
To start, users should download the InteractiveInfill folder. Enter the folder and you will find three files. 
1. parameters.m - this is where the user specifies the parameters below. The user will also find the authors' general guidelines on what range for the parameters they have found to work best.

| Parameter  | Description | Parameter |  Description |
| ------------- | ------------- | ------------- | ------------- |
| Nelx | Number of elements in the x-direction | Nely  | Number of elements in the y-direction|
| Volfrac | Volume fraction for optimization problem| rmin  | Radius of minimum solid feature size|
| gamma | Appearance constraint parameter | betaMMA  | beta value for the Heavisides projection|
| betaHP | Same as betaMMA| Penal  | Penalization factor for the SIMP method|
| patchX | Number of elements in the x-direction for the infill patch| patchY | Number of elements in the y-direction for the infill patch|
|cutoff| Value to generate binary infill field|
2. IITOdriver.m - this is the driver file to run the Interactive Infill program.
3. addpath folder - this folder contains the supporting MATLAB scripts and MMA folder. 
## How it works (with MBB example):
1. Enter the appropriate variables for your design problem in the parameters.m file.
2. Run the IITOdriver.m script
3. Set up the design problem. Please reference the HiTop 2.0 READme file (steps 3-10) for detailed guidelines for the GUI.
4. 50 iterations will run automatically
   - For the MBB, the 50 iteration output will look like the figure below, 
