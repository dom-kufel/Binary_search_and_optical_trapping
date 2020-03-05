function [msd,s] = msdcalculation(x,Dt,color)
for n = 0:1:(sqrt(length(x))) %/4)
msd(n+1) = mean((x(n+1:end)-x(1:end-n)).^2);
end
s = Dt*[0:1:length(msd)-1];

plot(s,msd,color);
title(['MSD']);
xlabel('time [s]');
ylabel('MSD [m^2]');
hold on;