% Data loading for neural network exercise using NN GUI (nntool)

clear all

% Load the target log and the attributes at the well
load ../../Data/matfiles/sonic % sonic log
load ../../Data/matfiles/trace % seismic trace
load ../../Data/matfiles/tramp % amplitude envelope
load ../../Data/matfiles/trph  % instantaneous phase
load ../../Data/matfiles/trf   % instantaneous freq

% Display target log and input seismic
%figure;plot(pson,tlog,trc,ts,'r');
%axis tight;axis ij;
%ylabel('Time(s)');legend('Log','Seismic');

% Transpose everything into row vectors
trc=trc';tramp=tramp';trph=trph';trf=trf';pson=pson';

% Assign zeros matrix for input attributes
P = zeros(4,length(pson));
P(1,:) = (trc/5);
P(2,:) = trph;
P(3,:) = tramp/5;
P(4,:) = trf;

T = pson; % target log

