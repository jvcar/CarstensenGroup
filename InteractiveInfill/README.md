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
3. Set up the MBB design problem. Please reference the HiTop 2.0 READme file (steps 3-10) for detailed guidelines for the GUI.
4. 50 iterations will run automatically
   - For the MBB, the 50 iteration output will look like the figure below. ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/e7981801-b13c-4218-86d4-b8a0088a49e9)
5. Draw half a symmetric infill pattern by clicking the continuous lines. Create a closed shape, then double click once complete.
   ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/7a1506f1-b8e6-4dc5-8621-f4d5a5a15662)
6. Five images will be generated of the infill field.
- The infill field as drawn: ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/bee0fba8-80b0-498c-8ee2-e3021f527db0)
- The infill field after the Heavisides projection: ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/810e4dfe-7d66-4508-afed-74fe844ddff0).
- The binary infill field generated using the cutoff parameter: ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/528c6cb0-8984-4cd0-aba8-4df8656f8f72).
- The singular infill pattern: ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/a7bdbde1-58e6-4ab1-aa25-57c1e742a1e7)
- The 50 iteration optimized design overlaid with the binary infill field: ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/75aa4004-e685-4aa7-9b62-ec206c02f438)
7. Enter whether you want to change the alignment of the infill with the optimized design (1) Yes (0) No.
  - If (1) Yes: Enter whether you want to change the left/right alignment (0) or up/down (1).
  - Enter how many elements up (+) or left (+) / down (-) or right (-) you want to shift the infill field.
  - Make additional adjustments or proceed to step 8.
8. Enter how many ROIs you want to draw.
9. Draw a ROI on the overlaid figure, double click once a closed shape is formed.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/57a90890-6fff-4330-9285-7f3649a9e064)
10. Run until convergence.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/b5be4ae4-855c-4015-9d67-bedaf4d04c98)
