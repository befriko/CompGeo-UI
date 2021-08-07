% This script 2-D interpolates a given tnmo and vnmo. Uses shape-preserving cubic
% interpolation, rather than linear interpolation for a smooth function.
% Requires CREWES toolbox for vrms to vint conversion. Octave compatible.
%
% 1st revision: 20 September, 2015
%               Added the 2-D interpolation (one pass and two passes)
%
% Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all
% load tnmo and vnmo
run('../../Data/velpick');

[m,n] = size(tnmo);
tmax = max(max(tnmo));
tmin = min(min(tnmo));

% interpolated time vector
dt = 0.02;
t_interp = [tmin:dt:tmax]';

% copy interpolated time for other velocity locations
t_ones = ones(1,n);
t_interp = t_interp*t_ones;

% perform single pass 2-D interpolation, first need to regrid picked values
% to common sample intervals
tlin = linspace(tmin,tmax,m)'; tlin = tlin*t_ones;
for i = 1:n
    vrms_grid(:,i) = interp1(tnmo(:,i),vnmo(:,i),tlin(:,i),'pchip','extrap');
end

disp('Running first pass 1-D (fast dimension) interpolation');

% cubic interpolation
for i = 1:n
    vrms_interp(:,i) = interp1(tlin(:,i),vrms_grid(:,i),t_interp(:,i),'pchip','extrap');
    vint(:,i) = vrms2vint(vnmo(:,i),tnmo(:,i),1); % change to interval velocity
    vint_grid(:,i) = interp1(tnmo(:,i),vint(:,i),tlin(:,i),'pchip','extrap');
    vint_interp(:,i) = interp1(tlin(:,i),vint_grid(:,i),t_interp(:,i),'pchip','extrap');
    fprintf('Finish interpolation for trace no %d out of %d traces \n', i, n);
end

disp('Running second pass 1-D (slow dimension) interpolation');

vrms_interp_transp = vrms_interp'; vint_interp_transp = vint_interp';
dx = 500; % assume 500 m velocity location interval for original picks
dxn = 25; % interpolate to 25 m velocity location interval
[mm,nn] = size(vrms_interp);
[mmt,nnt] = size(vrms_interp_transp);
x = [0:dx:(n-1)*dx]'; x = x*ones(1,mm);
x_interp = [0:dxn:(n-1)*dx]'; x_interp = x_interp*ones(1,mm);

for i = 1:nnt
    vrms_interp_2d(:,i) = interp1(x(:,i),vrms_interp_transp(:,i),x_interp(:,i),'pchip','extrap');
    vint_interp_2d(:,i) = interp1(x(:,i),vint_interp_transp(:,i),x_interp(:,i),'pchip','extrap');
    fprintf('Finish interpolation for trace no %d out of %d traces \n', i, nnt);
end

% transpose back to original dimension
vrms_interp_2d = vrms_interp_2d'; vint_interp_2d = vint_interp_2d';

disp('Running one-pass 2-D interpolation');
vrms_interp_2d_1pass = interp2(x(:,1),tlin(:,1),vrms_grid,x_interp(:,1)',t_interp(:,1),'cubic');
vint_interp_2d_1pass = interp2(x(:,1),tlin(:,1),vint_grid,x_interp(:,1)',t_interp(:,1),'cubic');

% display 1-D and 2-D interpolated rms velocity
figure;subplot(3,1,1);imagesc(x(:,1),tlin(:,1),vrms_grid);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Regridded picked rms velocity');
subplot(3,1,2);imagesc(x_interp(:,1),t_interp(:,1),vrms_interp_2d);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Two-pass 1-D interpolated rms velocity');
subplot(3,1,3);imagesc(x_interp(:,1),t_interp(:,1),vrms_interp_2d_1pass);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('One-pass 2-D interpolated rms velocity');

% display 1-D and 2-D interpolated interval velocity
figure;subplot(3,1,1);imagesc(x(:,1),tlin(:,1),vint_grid);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Regridded picked interval velocity');
subplot(3,1,2);imagesc(x(:,1),t_interp(:,1),vint_interp_2d);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Two-pass 1-D interpolated interval velocity');
subplot(3,1,3);imagesc(x_interp(:,1),t_interp(:,1),vint_interp_2d_1pass);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('One-pass 2-D interpolated interval velocity');