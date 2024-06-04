# Human-Informed Topology Optimization 2.0 (HiTop 2.0)

HiTop is a human in the loop design optimization code first published in the paper "Human Informed Topology Optimization: Interactive Application of Feature Size Controls" (Ha, D. and Carstensen, J.V., 2023, Structural and Multidisciplinary Optimization 66:59. DOI 10.1007/s00158-023-03512-0). 

HiTop 2.0 builds upon the original version of HiTop in the recent paper ([here](https://doi.org/10.1080/17452759.2023.2268603)). 

Different from the original HiTop, HiTop 2.0 implements a GUI that allows for a flexible design problem formulation. Additionally, the user can make 1 or 2 changes to the minimum solid, minimum void, maximum solid, and/or passive regions of interest in the design.

## File Familiarization
To start, users should download the HiTop2_0 folder. Enter the folder and you will find three files.
1. Parameters.m – this is where the user specifies the parameters below. The user will also find the authors’ general guidelines on what range for the parameters they have found to work best.
   
| Parameter  | Description | Parameter |  Description |
| ------------- | ------------- | ------------- | ------------- |
| Nelx | Number of elements in the x-direction | Nely  | Number of elements in the y-direction|
| Volfrac | Volume fraction for optimization problem| rminS  | Radius of minimum solid feature size|
| rminV | Radius of minimum void feature size | betaMMA  | beta value for the Heavisides projection|
| betaHP | Same as betaMMA| Penal  | Penalization factor for the SIMP method|
2. hiTopDriver.m – this is the driver file to run the HiTop 2.0 program.
3. addpath folder – this folder contains the supporting MATLAB scripts and MMA folder
## How it works (with L-Bracket example):
1.	Enter the appropriate variables for your design problem in the parameters.m file
2.	Run the HiTopDriver.m MATLAB script
3.	Highlight location of force
- The authors recommend zooming into the mesh to ensure accurate selection.
- For best results, only select <10 nodes and ensure the node locations are fully enclosed by your drawn rectangle Region of Interest (ROI)
- Double click the ROI
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/b2efc60f-b4de-4f75-9df3-7e3a9280ebbd">

Proper selection of 8 nodes for the L-Bracket problem

<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/81c32e9e-2fba-4e91-87c9-d3d400b0e516">

Too many nodes selected for the load

4.	Specify the direction of the negative force with 1 = x, 2 = y, 3 = x and y
- Assumed positive x and y directions  <img width="70" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/d804b13f-e526-4f14-89fb-76514dfc6993">
- For L-bracket enter 2
5.	Enter whether you are going to emplace 1 or 2 boundary conditions
- For L-bracket enter 1
6.	Enter whether you want to manually draw (1) or automatically pick an edge (2) of the design domain for your boundary condition
- For L-bracket enter 1
7.	Highlight the location of the boundary condition
  - Ensure your ROI only encloses the desired nodes
  - Double click the ROI
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/a23514f6-293f-4820-a3c5-cbf2cb9f0be0">

Proper selection of single line of nodes on upper edge of domain

<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/66aae4ad-8260-4099-8637-3179d330680c">

Too many nodes selected

<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/26f4a8cc-6c4c-46da-9a8c-730f72d22e9a">

No nodes are selected

8.	Specify the direction of the translation restriction with 1 = x, 2 = y, 3 = x and y
- For L-bracket enter 3
9.	Enter whether you’d like to specify a solid (1), void (0), or no (0) passive region in the design problem
- For L-bracket enter 0
10.	Draw the passive region
- The authors find that drawing the passive region zoomed out, then zooming in to refine is a successful method to specify the passive ROI
 <img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/525d9734-31c9-4d2d-a16f-fd888fbe321b">

- Next, zoom into the areas of the passive ROI that may overlap with force or boundary condition ROIs
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/b982c201-cdb8-4b7b-a70e-231a13b53326">

For the L-bracket problem, the passive region should be flush to the force ROI

<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/44e4ecb6-4766-408f-a722-b46a84a1c80c">

Proper selection of nodes for the passive ROI

<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/47e2026c-ca05-4c37-96f1-7518b8993486">

Passive ROI overlaps location of force nodes

11.	 50 Iterations will run automatically
- a.	For the L-Bracket, the 50 iteration output will look like the  figures below, where a stress plot is presented to the user
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/6874fe91-52ee-4fce-9a61-e857701b65d6">
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/8a573bb8-8b5f-4f6e-bb0b-2554afb40f5b">

12.	Enter whether you want to make 1 or 2 changes
- For this example, the user will make 2 changes

13.	Enter whether you want to specify a new passive ROI (3), max solid ROI (2), min solid (1), or min void (0)?
- For this example, the user will specify a passive void region (3) at the sharp corner in order to reduce the stress concentration.

14.	Draw the 1st change ROI
-	For the L-Bracket example:
-	<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/66573b62-b5cb-4924-b82f-ceb7fdfc09bd">

15.	Enter which phase you’d like to specify as passive (1) for solid, (0) for void

16.	50 Iterations run automatically
-	If the user decided to only make one change, then the algorithm would run to 2000 iterations or convergence

17.	Enter whether you want to specify a new passive ROI (3), max solid ROI (2), min solid (1), or min void (0)?
	For this example, the user’s second change will specify a minimum solid length scale in the thin lower, right portion of the L-Bracket.

18.	Highlight the ROI on the stress plot.
-	The authors have found success when singular members are identified, rather than middle of members. 
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/6afe9ddb-772e-4fc4-923b-77f8049a7c1f">

19.	Enter contour lines, lambda (degree of gradation), and new radius
 	-	For this example, the user set contour = 2, radius = 4, and lambda = 5

20.	Run until convergence.
<img width="400" alt="image" src="https://github.com/jvcar/CarstensenGroup/assets/142328197/abb37570-2d2b-408c-9ac5-4f73d3492c05">
Final Output
