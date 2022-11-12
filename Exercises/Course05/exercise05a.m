% A script to run Stolt post-stack time migration on impulse response model.
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
% 2nd Revision: 17 Dec 2021
%               Change to impulse response model.

clear all; clc;

spk=zeros(751,501);
t=[0:750]*0.004;
spk(251,251)=1; spk(376,251)=1; spk(501,251)=1; spk(626,251)=1;
w=ricker(20,0.004); seis=convz(spk,w);
[m,n]=size(seis);
dx = 12.5; x = [0:dx:(n-1)*dx];

disp('Stolt constant-velocity migration');
v = input('Input velocity value (m/s) -->');

% Set migration parameters
params = NaN*ones(1,13);
params(:,1)=62.5; params(:,3)=90; params(:,4)=10; params(:,12)=1;

% Display input data
%plotimage(seismogram,t,x);
figure;imagesc(x,t,seis,[-0.01 0.01]);colorbar;colormap(seisclrs);
xlabel('Distance (m)'); ylabel('Two-way time (s)');
title('Migration Input');

% Stolt migration and plot
[seismig,tmig,xmig] = fkmig(seis,t,x,v,params);
%plotimage(seismig,t,x);
figure;imagesc(x,t,seismig,[-0.01 0.01]);colorbar;colormap(seisclrs);
xlabel('Distance (m)'); ylabel('Two-way time (s)');
title('Stolt Migration');
