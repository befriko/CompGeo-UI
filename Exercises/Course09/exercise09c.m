% Simple MATLAB programming for non-linear least squares problem.
% We are trying to find the depth and radius of a cylindrical anomaly based
% on its measured gravity response (given distance x and \Deltag) after 5
% iterations. Octave compatible.
%
% Befriko Murdianto, Oct 2017
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

addpath(genpath('../../main'));

R=0.2; %initial value for the radius
b=400; %initial value for the depth
p=[R b]';
x=[-100 -50 0 50 100]';
%observed data
yobs=[-4.696e-7 -1.174e-6 -2.348e-6 -1.174e-6 -4.696e-7]';
beta=1e-20; %we're using marquardt-levenberg for fitting

for iter=1:10;
    ycal=func(x,p); %calculate response using given equation
    a=deriv(x,p); %calculate its derivatives (Jacobian)
    g=yobs-ycal; %discrepancy matrix
    i=eye(length(p));
    at=a';
    ata=at*a;
    delta=inv(ata+beta*i)*at*g; %parameter increment
    p=p+delta;
    error=sum((yobs-ycal).^2); %calculate sse
    plot(x,yobs,'ro',x,ycal);
    title(sprintf('Inversion of gravity anomaly, iteration %d',iter));
    xlabel('Distance (m)');ylabel('Gravity anomaly \Deltag');
    legend('Observed','Calculated');pause(1);
end

disp(sprintf('Result after %d iterations:',iter));
disp(sprintf('The radius of the anomaly is %d meter',round(p(1))));
disp(sprintf('The depth of the anomaly is %d meter',round(p(2))));
disp(sprintf('SSE between observed and calculated data is %d',error));