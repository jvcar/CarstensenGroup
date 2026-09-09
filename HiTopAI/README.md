# AI-Guided Human-In-the-Loop Inverse Design

This repository contains code related to the paper **"AI-Guided Human-In-the-Loop Inverse Design of High Performance Engineering Structures"** by Ha et al. (2026). 

The codebase focuses on the automated extraction and generation of truss-like structures from 2D topological designs using image processing and skeletonization techniques.

## File Overview

*   **HiTopAI_Skeletonization_Demo.m**: This is the main execution script. 
    *   It processes a 2D topology image by binarizing it and extracting special edge features. 
    *   It applies iterative thinning to generate a skeleton of the structure. 
    *   Finally, it extracts truss nodes and elements to plot the generated truss graph.
*   **Class_Thinning2D_2.m**: This file contains the `Class_Thinning2D` object definition, which drives the skeletonization process. 
    *   It includes core methods for simplifying grid points and iterative thinning. 
    *   It also features advanced methods to determine intersection nodes and match elements based on topological relations and hole identification.
*   **gt_topo_1_2.png**: The base PNG image required to run the main script and demonstrate the thinning and skeletonization capabilities.

## Methodology & References

The skeletonization and node-extraction approach implemented in `Class_Thinning2D_2.m` is based on the strut-and-tie generation methods developed by Xia et al.:

1.  Xia, Y., Langelaar, M., & Hendriks, M. A. N. (2020). Automated optimization-based generation and quantitative evaluation of Strut-and-Tie models. *Computers and Structures*, 238, 106297.
2.  Xia, Y., Langelaar, M., & Hendriks, M. A. N. (2020). A critical evaluation of topology optimization results for strut-and-tie modeling of reinforced concrete. *Computer-Aided Civil and Infrastructure Engineering*, 35, 850-869.

## Disclaimer

**For Research Purposes Only.** 
This code is provided "as is" and is intended exclusively for academic and research purposes. The authors make no warranties, express or implied, regarding the accuracy, reliability, or completeness of this software. The authors are not responsible for any errors, omissions, or any legal issues or damages arising from the use of this code. Use at your own risk.
