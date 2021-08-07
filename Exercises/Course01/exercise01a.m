% 3D seismic data loading exercise. Octave compatible.
%
% A. Haris
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all;
clc;

[data, samplerate, header] = altreadsegy('../../Data/3Dseismic.sgy','textheader','yes');

% Inline and crossline info from headers
inline = 119;
xline  = 81;
t = size(data, 1);
time = [0.8:samplerate:0.8+(t-1)*samplerate]';

% Matrix transpose 
data = data';

% Re-shape 2D matrix into 3D 
data = reshape(data,[xline,inline,t]);

% Create slices at middle
[x,y,z]=meshgrid(1:inline,1:xline,time);
figure;slice(x,y,z,data,100,50,1);

% Display seismic
set(gca,'zdir','reverse');
axis('tight');
shading('interp');
title('3D Seismic Test');
xlabel('Inline'); ylabel('Xline'); zlabel('Time');
colormap(jet);colorbar;