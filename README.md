# Binary_search_and_optical_trapping
Implementation of the algorithm I devised optimizing the simulation of Brownian motion in a speckle optical trap.
Algorithm integrates binary search with native interpolation algorithm in MATLAB. This improves efficiency of the code by (at least) 1-2 orders of magnitude compared to the native MATLAB interpolation function. 
**The basic idea of the algorithm**: the Brownian particle has x-y position given as a pair of two real numbers. The light intensity (speckle) pattern in which it moves has, however, a finite resolution i.e. it is represented as a grid of points (finite-size matrix). I would like to interpolate the value of light intensity at the position of the particle knowing the value of light intensity of its closest gridpoints. Instead of running only a native MATLAB interpolation function (interp2 as for 2018) I find the nearest gridpoints to the x-y position of the particle by means of a binary search algorithm and then interpolate the intensity value only based on the position of four nearest gridpoints. 

**How to run the codes?**
Run the runopticaltrap.m file in a MATLAB environment.  

**More physical picture**: particle (e.g. a few micron-sized polysteryne particle) undergoes an erratic motion in a speckle optical 
pattern (loosely speaking: light and dark interference 'speckles' arising from the mode-mixing within the multimode optical 
fibre) created close to the end of the optical fibre. The erratic motion is modulated by the drifting force arising from 
gradients of a speckle pattern intensity: particle is pulled away from the regions of high intensity (light) and pushed 
towards the low intensity (dark) regions.

![Alt Text](https://github.com/Dom98/Binary_search_and_optical_trapping/blob/master/speckletrapandparticletrajectory.png?raw=true) 

The work done during the summer internship at UCL Optical Tweezers group.

Photo of the part of the experimental setup (pc: Hyunseok Oh):
![Alt Text](https://github.com/Dom98/Binary_search_and_optical_trapping/blob/master/speckletweezers_setup_photo.png?raw=true)




