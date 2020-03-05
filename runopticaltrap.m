%{
Author: D.Kufel
Date: 12/06/2018

Code calculating various statistical properties of the optical trap.
ADAPTED from the Volpe&Volpe (2013);

1. For 0 stiffness of the traps I get just a random walk and the results of
the MSD and ACF show very minor decay of the cross-correlation function. 
Random walk has a random path in 3D space.

2. For kx=ky=1e-6 and kz=0.2e-6 stiffness there is a characteristic MSD and
 ACF behaviour with significant decay of the cross correlation function. 
Additionally for this set of stifness variance is about 3 orders of
magnitude smaller than in the previous case. 
 
%}
clear all;
close all;
clc;

rng(2)

tic;
    
N=1e+4;
Dt=1e-2; %s
%kx=0; %1e-6;
%ky=0; %1e-6;
%kz=0.2e-6; %0.2e-6;

[x,y,t,tau,taux]=newalternativetrapping(N,Dt); %,kx,ky);

disp(['Variance in different axes: ',' x: ',num2str(var(x)),' y: ', ...
    num2str(var(y))]); %,' z: ',num2str(var(z))])
disp([' Total variance: ', ...
    num2str(sqrt(var(x)^2+var(y)^2))]) %+var(z)^2
disp(['Momentum relaxation timescale: ',num2str(tau)])
disp(['Optical trap timescale in x-axis: ',num2str(taux)])

toc;

figure();
acfcalculation(x,Dt,'b.');
acfcalculation(y,Dt,'g.');
%acfcalculation(z,Dt,'r.');
legend('x-axis','y-axis');%,'z-axis');
hold off

figure();
msdcalculation(x,Dt,'b.');
msdcalculation(y,Dt,'g.');
%msdcalculation(z,Dt,'r.');
legend('x-axis','y-axis');%,'z-axis');
hold off