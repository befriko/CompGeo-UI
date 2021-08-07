% Short-time Fourier Transform SpecDecomp example.
% Input data is a single synthetic trace with frequencies stepping from 30
% to 120 Hz. Octave compatible.
%
% Befriko Murdianto, Feb 2012

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

timeseries = data; %load trace

% Define STFT parameters
window = 3; % Hanning window
window_length = 50; % Change this and observe the effect on the time/freq resolution
step_dist = 1;
padding = 100;
samplingrate = dt;
freq = (1/samplingrate)/2;
LENX = length(data);
IMGX = ceil(LENX/step_dist);
if (padding/2 == round(padding/2))
	IMGY = (padding/2) + 1;
else
	IMGY = ceil(padding/2);
end

y = zeros(IMGX,IMGY); % allocate space
%--------------------------------------------------------------------------
t = (0:length(timeseries)-1)*samplingrate;
y = STFT(data,samplingrate,window,window_length,step_dist,padding);
%--------------------------------------------------------------------------

% Plot the trace and its STFT
figure; subplot(2,1,1);
plot(t,timeseries); axis([(min(t)) (max(t)) -1 1]);
title(['STFT of a trace with ' num2str(nstep) ' stepping frequencies']); xlabel...
    ('Time (s)'); ylabel('Amplitude');
subplot(2,1,2);
imagesc([0:(step_dist*samplingrate):(samplingrate*(LENX-1))], ...
	[0:(freq/(IMGY-1)):freq],y');
xlabel('Time (s)'); ylabel('Frequency (Hz)');flipy; colormap(jet);
