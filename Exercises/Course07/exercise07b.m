% A script to train a set of attributes using neural network (NN)
% to predict a certain log properties. Input to training is attributes
% WITH P-impedance. You'll see that the network is able to predict
% the target log. See Lecture Note #7 for explanation.
% Octave compatible.
%
% Befriko Murdianto, Feb 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all;

% Load the target log and the attributes at the well
load ../../Data/matfiles/sonic % sonic log
load ../../Data/matfiles/trace % seismic trace
load ../../Data/matfiles/trimp % impedance log
load ../../Data/matfiles/tramp % amplitude envelope
load ../../Data/matfiles/trph  % instantaneous phase
load ../../Data/matfiles/trf   % instantaneous freq

% Transpose everything to row vectors
trc=trc';tramp=tramp';trph=trph';trf=trf';pson=pson';trimp=trimp';

% Assign zeros matrix for input attributes
P = zeros(4,length(pson));
P(1,:) = trimp/400; % first row is band-limited impedance
P(2,:) = trph; % second row is instantaneous phase
P(3,:) = tramp/5; % third row is amplitude envelope
P(4,:) = trf; % fourth row is instantaneous frequency

T = pson; % target log

% Train the network using feed forward network with Levenberg-Marquardt optimization
net = newff([min(trimp) max(trimp); min(trph) max(trph); min(tramp) max(tramp); min(trf) max(trf)],[125 1],{'tansig','purelin'},'trainlm');
net.trainParam.show = 50;
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-4;
net.trainParam.mu = 0.001;
net.trainParam.mu_max = 1e12;
net.trainParam.min_grad = 1e-12;
net = train(net,P,T);

% Predict the log, should be compared with the target log
Tn = sim(net,P);

% Display target log and input seismic
figure;plot(pson,tlog,trc,ts,'r');
axis tight;axis ij;
ylabel('Time(s)');legend('Log','Seismic');

% Display the target log and the NN prediction
figure;plot(T,tlog,Tn,tlog,'r');
axis tight;axis ij;
ylabel('Time(s)');legend('Log','NN predicted');

% Measure correlation between predicted and actual log
xcor=corr(T,Tn);
figure;plot(T,Tn,'bo',T,T,'r');xlabel('Real Sonic');ylabel('Predicted Sonic');legend('Data','Y=X');axis tight;title(sprintf('Correlation=%f',xcor'));