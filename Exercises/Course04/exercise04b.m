% This script 1-D interpolates a given tnmo and vnmo. Uses shape-preserving cubic
% interpolation, rather than linear interpolation for a smooth function.
% Requires CREWES toolbox for vrms to vint conversion. Octave compatible.
%
% 1st revision: 20 September, 2015
%               Change the vint interpolation from converting the
%               interpolated vrms into interpolating the vint.
%               Split the script into 2 separate files for 1-D and 2-D
%               interpolation.
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

% lateral position definition
dx = 500; % assume 500 m velocity location interval for original picks
x = [0:dx:(n-1)*dx]';

% convert to interval velocity
for i = 1:n
    vint(:,i) = vrms2vint(vnmo(:,i),tnmo(:,i),1);
end

% regrid pick values to common sample intervals for display
numpicks = 7; % number of picks per velocity location
tlin = linspace(tmin,tmax,numpicks)'; tlin = tlin*t_ones;
for i = 1:n
    vrms_grid(:,i) = interp1(tnmo(:,i),vnmo(:,i),tlin(:,i),'pchip','extrap');
    vint_grid(:,i) = interp1(tnmo(:,i),vint(:,i),tlin(:,i),'pchip','extrap');
end

disp('Running 1-D (fast dimension) interpolation');

% cubic interpolation
for i = 1:n
    vrms_interp(:,i) = interp1(tnmo(:,i),vnmo(:,i),t_interp(:,i),'pchip','extrap');
    vint_interp(:,i) = interp1(tnmo(:,i),vint(:,i),t_interp(:,i),'pchip','extrap');
    fprintf('Finish interpolation for trace no %d out of %d traces \n', i, n);
end

% block constant vint
tblock = linspace(min(t_interp(:,1)),max(t_interp(:,1)),10);
for j = 1:n
    vrmsblock(:,j) = vint2vrms(vint_interp(:,j),t_interp(:,j),tblock);
    vintblock(:,j) = vrms2vint(vrmsblock(:,j),tblock);
end

% ask user which velocity location to display
fprintf('There are %d picked velocity locations. \n',n);
qc = input('Which velocity location do you want to display?');
fig_title = sprintf('Velocity function for location %d',qc);

figure;subplot(1,2,1);plot(vrms_interp(:,qc),t_interp(:,qc),vnmo(:,qc),tnmo(:,qc),'ro');
axis ij;title(fig_title);legend('interpolated','picked');
xlabel('Velocity (m/s)');ylabel('Time (s)');
subplot(1,2,2);plot(vrms_interp(:,qc),t_interp(:,qc)),drawvint(tblock,vintblock(:,qc),'r');
axis ij;title(fig_title);legend('V_r_m_s','V_i_n_t');
xlabel('Velocity (m/s)');ylabel('Time (s)');

% display picked and 1-D interpolated rms velocity
figure;subplot(2,1,1);imagesc(x,t_interp(:,1),vrms_grid,[min(min(vrms_grid)) max(max(vrms_grid))]);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Regridded picked rms velocity');
subplot(2,1,2);imagesc(x,t_interp(:,1),vrms_interp,[min(min(vrms_grid)) max(max(vrms_grid))]);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('1-D interpolated rms velocity');

% display picked and 1-D interpolated interval velocity
figure;subplot(2,1,1);imagesc(x,t_interp(:,1),vint_grid,[min(min(vint_grid)) max(max(vint_grid))]);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('Regridded picked interval velocity');
subplot(2,1,2);imagesc(x,t_interp(:,1),vint_interp,[min(min(vint_grid)) max(max(vint_grid))]);colorbar;
xlabel('Distance (m)');ylabel('Time (s)');colormap(jet);
title('1-D interpolated interval velocity');