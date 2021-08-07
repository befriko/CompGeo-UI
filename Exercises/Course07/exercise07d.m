% A script to apply the trained network to the whole seismic line.
% The training script (exercise07b.m) MUST BE run first prior to this one.
% Octave compatible.
%
% Befriko Murdianto, Feb 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

% Load the attributes of the seismic
load ../../Data/matfiles/imp       % P-impedance from log
load ../../Data/matfiles/iamps     % amplitude envelope
load ../../Data/matfiles/ifreqs    % instantaneous freq
load ../../Data/matfiles/iphs      % instantaneous phase
%load ../../Data/matfiles/blimpnet

imp=imp/400; iamps=iamps/5;
% Assign zeros matrix for the predicted logs, same size as the seismic
[m,n] = size(imp);
P = zeros(m,n);
Tn = zeros(m,n);

% Apply NN prediction to the whole seismic line, run trace by trace
for i = 1:n
    P = [imp(:,i) iamps(:,i) iphs(:,i) ifreqs(:,i)]';
    Tn(:,i) = sim(net,P);
end

% Display
figure;imagesc(cdp,ts,Tn,[60 200]);colorbar;xlabel('CDP');ylabel('Time (s)');colormap(rainbow);title('NN-predicted sonic logs');