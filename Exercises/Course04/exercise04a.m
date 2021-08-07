% This script interpolates a given tnmo and vnmo. Uses shape-preserving cubic
% interpolation, rather than linear interpolation for a smooth function.
% Requires CREWES toolbox. Octave compatible.
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

% spline interpolation
for i = 1:n
    v_interp(:,i) = interp1(tnmo(:,i),vnmo(:,i),t_interp(:,i),'linear','extrap');
    % change to interval velocity
    vint(:,i) = vrms2vint(v_interp(:,i),t_interp(:,i));
end

% block constant vint
tblock = linspace(min(t_interp(:,1)),max(t_interp(:,1)),10);
for j = 1:n
    vrmsblock(:,j) = vint2vrms(vint(:,j),t_interp(:,j),tblock);
    vintblock(:,j) = vrms2vint(vrmsblock(:,j),tblock);
end

% ask user which velocity location to display
fprintf('There are %d velocity locations. \n',n);
qc = input('Which velocity location do you want to display?');
fig_title = sprintf('Velocity function for location %d',qc);

figure;subplot(1,2,1);plot(v_interp(:,qc),t_interp(:,qc),vnmo(:,qc),tnmo(:,qc),'ro');
axis ij;title(fig_title);legend('interpolated','picked');
xlabel('Velocity (m/s)');ylabel('Time (s)');

subplot(1,2,2);plot(v_interp(:,qc),t_interp(:,qc)),drawvint(tblock,vintblock(:,qc),'r');
axis ij;title(fig_title);legend('V_r_m_s','V_i_n_t');
xlabel('Velocity (m/s)');ylabel('Time (s)');

% display interpolated rms velocity
figure;imagesc(1:n,t_interp(:,1),v_interp);colorbar;colormap(jet);
xlabel('Velocity location');ylabel('Time (s)');
title('Interpolated rms velocity');

% display interval velocity
figure;imagesc(1:n,t_interp(:,1),vint);colorbar;colormap(jet);
xlabel('Velocity location');ylabel('Time (s)');
title('Interval velocity');