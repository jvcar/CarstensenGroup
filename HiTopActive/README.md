## HiTop Active Design
HiTop Active Design is a creative design tool that allows users to generate unique, custom topology optimized designs. 

## File Familiarization
To start, users should download the HiTopActive folder. Enter the folder and you will find three files. 

1. parameters.m - this is where the user specifies the parameters below. The user will also find the authors' general guidelines on what range for the parameters they have found to work best.

| Parameter  | Description | Parameter |  Description |
| ------------- | ------------- | ------------- | ------------- |
| Nelx | Number of elements in the x-direction | Nely  | Number of elements in the y-direction|
| Volfrac | Volume fraction for optimization problem| rmin  | Radius of minimum solid feature size|
| betaHP | beta value for the Heavisides projection| Penal  | Penalization factor for the SIMP method|
| gamma | Appearance constraint parameter|
2. activeDriver.m - this is the driver file to run the HiTop Active program.
3. addpath folder - this folder contains the supporting MATLAB scripts and MMA folder. 
## How it works (with cantilever beam example):
1. Enter the appropriate variables for the design problem in the parameters.m file.
2. Run the activeDriver.m script
3. Set up the cantilever beam design problem. Please reference the HiTop 2.0 READme file (steps 3-10) for detailed guidelines for the GUI.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/e8beb035-9f39-49d6-af88-cb54e11ec52a)
4. 50 iterations will run automatically.
5. The user will be prompted to draw a Region of Interest (ROI) in which all design variables will be initially set to void (0), but can change once the algorithm resumes.
   - Draw a closed shape, such as the red one shown below, and double click once finished.
   - ![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/a6e9d163-f49f-43e1-8335-626e3e049fe9)
6. In the ROI, the user draws a freehand closed shape, such as the white one shown below, which will be initially set to solid within the shape (1), but similarly can change value.
  - It is advisable, but not necessary that the user includes connection points to rest of the design elements not in the ROI. As shown in the figure below, the user draws multiple overlapping regions so the optimizer can lead to a continuous, manufacturable result. However, since the design elements are active, the optimization can change the input drawing to lower compliance regardless of the initial design element values.
  - Double click once finished.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/02a7fde3-217a-483d-bb38-c73a4983a027)
7. Resume the algorithm and run until convergence.
![image](https://github.com/jvcar/CarstensenGroup/assets/142328197/c3e22467-b8e2-4539-b612-7b69ab32a76e)
Unlike  HiTopPassive, the converged design will likely have interemediate densities due to the increased complexity from the appearance constraint. Also, since the elements in the drawing are active (not passively prescribed as in HiTopPassive), the optimization algorithim will introduce connective elements that lower compliance and deviate from the strict appearance of the user's drawing. 
