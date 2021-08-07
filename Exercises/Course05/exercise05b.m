% A script to run Kirchhoff post-stack time migration on the EAGE/SEG salt model.
% Requires CREWES toolbox. If you have an error complaining about matrix
% dimension must agree, you may need to change line 142 in kirk.m from
% CREWES to vmin=min(min(aryvel(:)));
% Octave compatible.
%
% Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia
%
% 1st Revision: 30 Aug 2019
%               Replaced NaNs in velocity model with max(vels) for migration.

clear all

% Load stack data
[seismogram,dt] = altreadsegy('../../Data/data.le.sgy');

% Assign time and spatial axis
[m,n] = size(seismogram);
t = [0:dt:(m-1)*dt]';
dx = 40; x = [0:dx:(n-1)*dx];

% Load velocity model
vmodel = load('../../Data/velocities.le.txt');

% Assign depth axis
[mm,nn] = size(vmodel);
dz = 40; z = [0:mm-1]*dz';

% Change one-way depth into two-way time
for j=1:nn
    t1(:,j)=vint2t(vmodel(:,j),z);
end
t2 = 2*t1;
a = find(t==round(max(max(t2))));

% Cut the stack section to the same length as the velocity matrix
tnew = t(1:a,:);
seis2 = seismogram(1:a,:);

% Copy interpolated time to every velocity locations
t_ones = ones(1,n);
t_interp = tnew*t_ones;

% Interpolate velocity at every sample on the stack section
for i = 1:n
    v_interp(:,i) = interp1(t2(:,i),vmodel(:,i),t_interp(:,i),'linear','extrap');
    % Convert to rms velocity
    vrms(:,i) = vint2vrms(v_interp(:,i),t_interp(:,i));
    fprintf('Velocity conversion for trace %d completed \n', i);
end

% Display input data
imagesc(x,tnew,seis2,[-0.1 0.1]); colormap(seisclrs); colorbar;
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('Migration Input');

%% Replace NaN veltrcs samples for kirk.m to run in Octave (No need to run this, as
%% we set interpolation using the 'extrap' option)
%a = isnan(vrms);
%[ii,jj] = find(a==1);
%vrms(ii,jj) = max(max(vrms));

% Display migration velocity
figure;imagesc(x,tnew,vrms,[5000 11000]); colormap(jet); colorbar;
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('RMS Velocity');

% Set migration parameters, 3 km aperture
params = NaN*ones(1,5); params(1,1) = 10000;

% Kirchhoff migration and plot
[arymig,tmig,xmig] = kirk(seis2,vrms,tnew,x,params);
figure; imagesc(xmig,tmig,arymig,[-0.01 0.01]); colormap(seisclrs); colorbar;
xlabel('Distance (ft)'); ylabel('Two-way time (s)');
title('Kirchhoff Migration');