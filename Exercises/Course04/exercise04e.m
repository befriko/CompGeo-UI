% This script changes one-way-depth of the SEG/EAGE velocity model into
% two-way-time. Requires CREWES toolbox. Octave compatible.
%
% Befriko Murdianto, 1 November 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% Load velocity model
load ../../Data/vmodel.mat

% Assign depth and time axes
[mm,nn] = size(vmodel);
dz = 40; z = [0:mm-1]*dz';
dx = 40; x = [0:dx:(nn-1)*dx];
tmax = 3; dt = 0.008; t = [0:dt:tmax]';

% Display original velocity model in depth
figure;imagesc(x,z,vmodel,[min(min(vmodel)) max(max(vmodel))]);
xlabel('Distance (ft)');ylabel('Depth (ft)');colorbar;colormap(jet);

% Change one-way depth into two-way time
for j = 1:nn
    t1(:,j) = vint2t(vmodel(:,j),z);
end
t2 = 2*t1;

% Find max time in two-way-time that corresponds to the model and cut it to
% the same length as the velocity model
a = find(t==round(max(max(t2))));
tnew = t(1:a,:);

% Copy interpolated time to every velocity location
t_ones = ones(1,nn);
t_interp = tnew*t_ones;

% Interpolate velocity at every sample on the interpolated time
for i = 1:nn
    v_interp(:,i) = interp1(t2(:,i),vmodel(:,i),t_interp(:,i),'linear','extrap');
    fprintf('Depth-time conversion for trace %d out of %d completed \n', i, nn);
end

figure;imagesc(x,tnew,v_interp,[min(min(vmodel)) max(max(vmodel))]);
xlabel('Distance (ft)');ylabel('Two-way-time (s)');colorbar;colormap(jet);