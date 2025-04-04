% Cross validation of the trained network using other well.
% The training script (exercise07b.m) MUST BE run first prior to this one.
% Octave compatible.
%
% Befriko Murdianto, Feb 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

pkg load nnet

% Load the seismic and its attributes
load ../../Data/matfiles/data  % seismic traces
load ../../Data/matfiles/iamp  % amplitude envelope
load ../../Data/matfiles/iph   % instantaneous phase
load ../../Data/matfiles/ifreq % instantaneous freq

% Select a trace closest to the well
idx = find(cdp==423);
trc2 = dataout(201:1439,idx); % seismic trace
tramp2 = iamp(201:1439,idx);  % amplitude envelope
trph2 = iph(201:1439,idx);    % instantaneous phase
trf2 = ifreq(201:1439,idx);   % instantaneous freq

% Load well data
wellx = load('../../Data/wells/X-1b_nohead.las');
tlog2 = wellx(:,1); % time axis
pson2 = wellx(:,5); % P-wave sonic log
rhob2 = wellx(:,2); % density log

% Calculate impedance from sonic and density logs
implog2 = rhob2.*(1./pson2).*1e6;

% Calculate band-limited impedance from seismic data
imp2 = blimp(trc2,implog2,tlog2,10,250);

% Assign zeros matrix for input attributes
P=zeros(4,length(imp2));
P(1,:) = imp2/400;      % first row is band-limited impedance
P(2,:) = trph2;     % second row is instantaneous phase
P(3,:) = tramp2/5;  % third row is amplitude envelope
P(4,:) = trf2;      % fourth row is instantaneous freq

T2 = pson2; % target log

% Predict the log using input attributes, should be compared with the
% target log
Tn2 = sim(net,P);

% Display target log and input seismic
figure;plot(pson2,tlog2,trc2,tlog2,'r');
axis tight;axis ij;
ylabel('Time(s)');legend('Log','Seismic');

% Display the target log and the NN prediction
figure;plot(T2,tlog2,Tn2,tlog2,'r');
axis tight;axis ij;
ylabel('Time(s)');legend('Log','NN predicted');

% Measure correlation between predicted and actual log
xcor=corr(T2,Tn2');
figure;plot(T2,Tn2,'bo',T,T,'r');xlabel('Real Sonic');ylabel('Predicted Sonic');legend('Data','Y=X');axis tight;title(sprintf('Correlation=%f',xcor'));set(gca,"fontsize",12);
