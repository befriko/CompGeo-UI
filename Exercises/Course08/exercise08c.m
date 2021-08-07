% Solution to Final Exam, Computational Geophysics
% Fall term 2011 - Problem #6. Octave compatible.
% 
% Befriko Murdianto, Feb 2012
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

addpath(genpath('../../main'));

load('../../Data/matfiles/data2.mat'); % load the seismic trace

[m,n] = size(data2); % determine data size
dt = 0.002; % time sample interval
df = 1; % freq sample interval
freq1 = 10; % freq to be analyzed, low freq
freq2 = 50; % freq to be analyzed, high freq
factor = 1; % factor for Gaussian window

% Allocate space
stlow = zeros(m,n);
sthigh = zeros(m,n);

% Run S-transform, loop over traces
for i = 1:n
    [stlow(:,i),f,t] = stransf(data2(:,i),dt,df,freq1,freq1,factor);
    [sthigh(:,i),f,t] = stransf(data2(:,i),dt,df,freq2,freq2,factor);
end

% Plot results
figure;subplot(2,1,1);
imagesc(cdp,ts,abs(stlow));colormap(jet);
title(['Time-frequency map at ' num2str(freq1) 'Hz']);
xlabel('Xline No.');ylabel('Time (s)');

subplot(2,1,2);
imagesc(cdp,ts,abs(sthigh));colormap(jet);
title(['Time-frequency map at ' num2str(freq2) 'Hz']);
xlabel('Xline No.');ylabel('Time (s)');