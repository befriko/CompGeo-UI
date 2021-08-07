% S-Transform SpecDecomp example.
% Input data is a single synthetic trace with frequencies stepping from 30
% to 120 Hz. This script produces right-hand side figure in Lecture Note
% slide # 16.
% Octave compatible.
%
% ABD Haris, modified by Befriko Murdianto, Dec 2011
% Reservoir Geophysics Graduate Program
% University of Indonesia
 
% 1st revision: Befriko Murdianto, Feb 2012
%               Cleaned up codes, moved main S-transform program into
%               stransf function file.
%               Fixed plotting problems.

clear all

addpath(genpath('../../main'));

% Create single trace with 1024 samples
ntrace = 1;
nsamp = 1024;
data = zeros(nsamp,ntrace); % allocate space
dt = 0.002; % 2ms sample interval

% Merge different frequencies into one trace
nstep = 4; % number of freq steps
fbase = 30; % base freq
for i = 1:nstep
    data(nsamp*((i-1)/nstep)+1:nsamp*(i/nstep),1) = sweep(fbase*i,fbase*...
        i,dt,(nsamp/nstep-1)*dt,0);
end

% Define S-transform parameters
factor = 1; % scaling factor for Gaussian window
df = 1; % freq sample interval
minfreq = 0; % min freq in the S-transform result
maxfreq = 1/(2*dt); % max freq in the S-transform result, set to Nyquist

% S-transform
[st,t,f] = stransf(data,dt,df,minfreq,maxfreq,factor);

% Plot the trace and its S-transform
figure; subplot(2,1,1);
plot(t,data); axis([(min(t)) (max(t)) -1 1]);
title(['Time-frequency map of a trace with ' num2str(nstep) ' stepping frequencies']); xlabel...
    ('Time (s)'); ylabel('Amplitude');
subplot(2,1,2);
imagesc(t,f,abs(st)); colormap(jet);
xlabel('Time (s)'); ylabel('Frequency (Hz)'); flipy
