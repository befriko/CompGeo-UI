function [st,t,f] = stransf(s,dt,df,minfreq,maxfreq,factor)
% STRANSF: Time-frequency analysis of seismic trace using S-transform
% Usage: [st,t,f] = stransf(s,dt,df,minfreq,maxfreq,factor)
%        s is the input seismic trace
%        dt is the time sample interval
%        df is the freq sample interval (default 1)
%        minfreq is the minimum freq to be analyzed (default 0)
%        maxfreq is the maximum freq to be analyzed (default Nyquist)
%        factor is the scaling factor for Gaussian window (default 1)
%
% Befriko Murdianto, Dec 2011 modified after Stockwell's (1997) st program
% Reservoir Geophysics Graduate Program
% University of Indonesia

% 1st revision: Befriko Murdianto, Feb 2012
%               Fixed min and max freq in the S-transform output.

% Check number of input arguments, assign defaults if not specified
if nargin == 6
    minfreq = minfreq*2; maxfreq = maxfreq*2;
end

if nargin == 5
    minfreq = minfreq*2; maxfreq = maxfreq*2; factor = 1;
end

if nargin == 4
    minfreq = minfreq*2; maxfreq = fix(length(s)/2); factor = 1;
end

if nargin == 3
    minfreq = 0; maxfreq = fix(length(s)/2); factor = 1;
end

if nargin == 2
    df = 1; minfreq = 0; maxfreq = fix(length(s)/2); factor = 1;
end

timeseries = s; % load trace
samplingrate = dt; % time sample rate
freqsamplingrate = df; % freq sample rate

%--------------------------------------------------------------------------
% Create time and freq vectors
t = (0:length(timeseries)-1)*samplingrate;
spe_nelements = ceil((maxfreq-minfreq+1)/freqsamplingrate);
f = (minfreq + [0:spe_nelements-1]*freqsamplingrate)/(samplingrate*...
    length(timeseries));
%--------------------------------------------------------------------------

n = length(timeseries);
vector_fft = fft(timeseries); % FFT of input trace
vector_fft = [vector_fft,vector_fft];

% Perform S-transformation
st = zeros(ceil((maxfreq-minfreq+1)/freqsamplingrate),n); % allocate space
if minfreq == 0
   st(1,:) = mean(timeseries)*(1&[1:1:n]);
else
  	st(1,:) = ifft(vector_fft(minfreq+1:minfreq+n).*g_window(n,minfreq,...
        factor));
end

for banana = freqsamplingrate:freqsamplingrate:(maxfreq-minfreq)
   st(banana/freqsamplingrate+1,:) = ifft(vector_fft(minfreq+banana+1:...
       minfreq+banana+n).*g_window(n,minfreq+banana,factor));
end   
