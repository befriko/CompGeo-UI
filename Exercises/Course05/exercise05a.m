% A script to run Stolt post-stack time migration on the EAGE/SEG salt model.
% Requires CREWES toolbox. User needs to input the constant velocity.
% Octave compatible.
%
% Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia
%
% 1st Revision: 29 Aug 2019
%               Modified Octave built-in hanning function to accept zero index
%               in order for mwhalf function to run.

clear all; clc;

% Load stack data
[seismogram,dt] = altreadsegy('../../Data/data.le.sgy');

% Assign time and spatial axis
[m,n] = size(seismogram);
t = [0:dt:(m-1)*dt]';
dx = 40; x = [0:dx:(n-1)*dx];

disp('Stolt constant-velocity migration');
v = input('Input velocity value (ft/s) -->');

% Set migration parameters
params = NaN*ones(1,13);
params(:,1)=62.5; params(:,3)=90; params(:,4)=10; params(:,12)=1;

% Display input data
%plotimage(seismogram,t,x);
figure;imagesc(x,t,seismogram,[-0.03 0.03]);colorbar;colormap(seisclrs);
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('Migration Input');

% Stolt migration and plot
[seismig,tmig,xmig] = fkmig(seismogram,t,x,v,params);
%plotimage(seismig,t,x);
figure;imagesc(x,t,seismig,[-0.03 0.03]);colorbar;colormap(seisclrs);
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('Stolt Migration');