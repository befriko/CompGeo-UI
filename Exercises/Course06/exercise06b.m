% Compare spectrum bandwidth between seismic and impedance log.
% Octave compatible.
%
% Befriko Murdianto, Feb 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% Load seismic and P-impedance from log data
load ../../Data/matfiles/data2
load ../../Data/matfiles/ai

% Determine data size
[m,n] = size(data2);

% Select a trace closest to S-1 well
idx = find(cdp==507);

% Display spectrum of impedance log
figure;dbspec(ts,ai);title('Impedance Log');

% Display spectrum of seismic
figure;dbspec(ts,data2(:,idx));title('Seismic');
