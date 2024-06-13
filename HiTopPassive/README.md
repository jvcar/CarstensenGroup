## HiTop Passive Design
HiTop Passive Design is a creative design tool that allows users to generate unique, custom topology optimized designs. 

## File Familiarization
To start, users should download the HiTopPassive folder. Enter the folder and you will find three files. 
1. parameters.m - this is where the user specifies the parameters below. The user will also find the authors' general guidelines on what range for the parameters they have found to work best.

| Parameter  | Description | Parameter |  Description |
| ------------- | ------------- | ------------- | ------------- |
| Nelx | Number of elements in the x-direction | Nely  | Number of elements in the y-direction|
| Volfrac | Volume fraction for optimization problem| rmin  | Radius of minimum solid feature size|
| betaHP | beta value for the Heavisides projection| Penal  | Penalization factor for the SIMP method|
2. passiveDriver.m - this is the driver file to run the HiTop Passive program.
3. addpath folder - this folder contains the supporting MATLAB scripts and MMA folder. 
## How it works (with cantilever beam example):
1. Enter the appropriate variables for the design problem in the parameters.m file.
2. Run the passiveDriver.m script
3. Set up the cantilever beam design problem. Please reference the HiTop 2.0 READme file (steps 3-10) for detailed guidelines for the GUI.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/e8beb035-9f39-49d6-af88-cb54e11ec52a)
4. 50 iterations will run automatically.
5. The user will be prompted to draw a Region of Interest (ROI) in which all design variables will be passively set to void (0).
   - Draw a closed shape, such as the red one shown below, and double click once finished.
   -  ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/b8c3828b-13dd-44f7-8c35-4dca558e7581)
6. In the ROI, the user draws a freehand closed shape, such as the white one shown below, which will be set to solid within the shape (1).
- It is important that the user includes connection points to rest of the design elements not in the ROI. As shown in the figure below, the user draws multiple overlapping regions so the optimizer can create a continuous, manufacturable result.
- Double click once finished.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/287e1292-435d-48c4-be9f-4120202a6b83)
7. Resume the algorithm and run until convergence.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/10c39e74-8a6c-4ca7-9080-8f11b8eaecec)
