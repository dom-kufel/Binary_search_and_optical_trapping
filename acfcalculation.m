function [r,s]=acfcalculation(x,Dt,color)
%v = (x(2:end)-x(1:end-1))/Dt;  % average speed in all steps
[r,s] = xcorr(x-mean(x),ceil(sqrt(length(x))),'coeff'); %of position
%s = Dt*[0:1:length(r)-1];
s = s*Dt;
plot(s,r,color);
title(['Position ACF']);
xlabel('time [s]');
ylabel('R[m^2]');
hold on