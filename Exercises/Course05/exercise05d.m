% A script to run PSPI post-stack depth migration on the EAGE/SEG salt model.
% Requires CREWES toolbox. Octave compatible.
%
% Befriko Murdianto, Aug 2016
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% Load stack data
[seismogram,dt] = altreadsegy('../../Data/data.le.sgy');

% Assign time and spatial axis
[m,n] = size(seismogram);
t = [0:dt:(m-1)*dt]';
dx = 40; x = [0:dx:(n-1)*dx];

% Load velocity model
vmodel = load('../../Data/velocities.le.txt');
load ../../Data/vmodel_pspi.mat

% Assign depth axis
[mm,nn] = size(vmodel);
dz = 40; z = [0:mm-1]*dz';

fmax=38;%maximum frequency (Hz) of interest.
fmin=4;%minimum frequency (fmin > 0 Hz) of interest.

% Display input data
imagesc(x,t,seismogram,[-0.1 0.1]); colormap(seisclrs); colorbar;
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('Migration Input');

% Display migration velocity
figure; imagesc(x,z,vmodel,[min(min(vmodel)) max(max(vmodel))]);
xlabel('Distance (ft)'); ylabel('Depth (ft)');
title('Velocity Model'); colorbar; colormap(jet);

% Build frequency axis of interest
f=1/2/dt/m*[0:2:m-2];%positive frequency axis in Hz.
nf=min(find(f>=fmax));%index in f for fmax.
f1=max(find(f<=fmin));%index in f for fmin.
f=f(f1:nf);%desired range of positive frequencies.

%2D FFT
temp=ifft(fft(seismogram),[],2);clear seismogram;%fft t->f and ifft x-> kx.
fdata=temp(f1:nf,:);%spectrum band-limited between fmin and fmax.

% PSPI depth migration
pspi_zero=pspi_zero_mig(fdata,f,vmodel/2,vmodel_pspi/2,dx,dz);

figure;imagesc(x,z,pspi_zero,[-0.01 0.01]); colormap(seisclrs); colorbar;
xlabel('Distance (ft)'); ylabel('Depth (ft)');
title('PSPI Depth Migration');