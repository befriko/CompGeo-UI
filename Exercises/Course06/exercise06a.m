% Make attributes from P-P reflection data. We will generate three
% attributes: amplitude envelope, instantaneous phase and instantaneous
% freq. Requires CREWES toolbox. Octave compatible.
%
% Befriko Murdianto, Feb 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% Load seismic data
load ../../Data/matfiles/data2

% Determine data size
[m,n] = size(data2);

% Allocate space
iamp = zeros(m,n);
iph = zeros(m,n);
ifreq = zeros(m,n);

% Run attributes: reflection strength, ins. phase, ins. freq.
iamp = ins_amp(data2);
iph = ins_phase(data2);
ifreq = ins_freq(data2,ts);

% Display original seismic and its attributes
figure;imagesc(cdp,ts,data2);colorbar;xlabel('CDP');ylabel('Time (s)');title('Seismic input');colormap(seisclrs);
figure;imagesc(cdp,ts,iamp);colorbar;xlabel('CDP');ylabel('Time (s)');title('Amplitude envelope');colormap(jet);
figure;imagesc(cdp,ts,iph);colorbar;xlabel('CDP');ylabel('Time (s)');title('Instantaneous phase');colormap(jet);
figure;imagesc(cdp,ts,ifreq,[0 70]);colorbar;xlabel('CDP');ylabel('Time (s)');title('Instantaneous freq');colormap(jet);
