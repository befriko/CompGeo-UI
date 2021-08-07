% A script to generate blocked velocity model of the EAGE/SEG salt model.
% Requires CREWES toolbox. Octave compatible.
%
% Befriko Murdianto, Aug 2016
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% Load ascii velocity model
vmodel = load('../../Data/velocities.le.txt');

% Assign depth axis
[mm,nn] = size(vmodel);
dz = 40; z = [0:mm-1]'*dz;
dx = 40; x = [0:dx:(nn-1)*dx];

nblk = 100; %no of blocked samples
zblk = linspace(min(z),max(z),nblk)';

for i=1:nn
    vmodel_pspi(:,i)=logblock(vmodel(:,i),z,zblk,2);
end

% Display original and blocked velocity
figure; imagesc(x,z,vmodel,[min(min(vmodel)) max(max(vmodel))]);
xlabel('Distance (ft)'); ylabel('Depth (ft)');
title('Velocity Model'); colorbar;

figure; imagesc(x,z,vmodel_pspi,[min(min(vmodel)) max(max(vmodel))]);
xlabel('Distance (ft)'); ylabel('Depth (ft)');
title('Blocked Velocity Model'); colorbar;

% Save velocity model for PSPI migration
save ../../Data/vmodel_pspi.mat vmodel_pspi
