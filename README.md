# Binary_search_and_optical_trapping
Implementation of the algorithm I devised optimizing the simulation of Brownian motion in a speckle optical trap.
Algorithm integrates binary search with native interpolation algorithm in MATLAB. This improves efficiency (by several
orders of magnitude) of the code by (at least) 1-2 orders of magnitude compared to the native MATLAB interpolation function. 

Physical picture: particle (e.g. a few micron-sized polysteryne particle) undergoes an erratic motion in a speckle optical 
pattern (loosely speaking: light and dark interference 'speckles' arising from the mode-mixing within the multimode optical 
fibre) created close to the end of the optical fibre. The erratic motion is modulated by the drifting force arising from 
gradients of a speckle pattern intensity: particle is pulled away from the regions of high intensity (light) and pushed 
towards the low intensity (dark) regions.

HOW TO RUN THE CODES?
Run the runopticaltrap.m file in a MATLAB environment.  
