% Make P-impedance data from P-P reflection data using band-limited algorithm.
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

% Run inversion trace-by-trace
imp = zeros(m,n);
for i = 1:n
    imp(:,i) = blimp(data2(:,i),ai,ts,6,70);
end

% Display original seismic and P-impedance
figure;imagesc(cdp,ts,data2,[-500 500]);colorbar;xlabel('CDP');ylabel('Time (s)');
title('Seismic input');colormap(seisclrs);
load ../../Data/hor1int.mat; hold on
horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'r','LineWidth',2);
load ../../Data/hor2int.mat;horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'r','LineWidth',2);
load ../../Data/hor3int.mat;horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'r','LineWidth',2);hold off

figure;imagesc(cdp,ts,imp,[10000 40000]);colorbar;xlabel('CDP');ylabel('Time (s)');
title('Band-limited impedance');colormap(flipud(rainbow));
load ../../Data/hor1int.mat; hold on
horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'k','LineWidth',2);
load ../../Data/hor2int.mat;horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'k','LineWidth',2);
load ../../Data/hor3int.mat;horx=picksdata(:,1);hory=picksdata(:,2);
plot(horx,hory,'k','LineWidth',2);hold off

% Select a trace closest to X-1 well
idx = find(cdp==423);
% Select a trace closest to S-1 well
idx2 = find(cdp==507);

% Load well data
wellx=load('../../Data/wells/X-1b_nohead.las');
tlog2=wellx(:,1); % time axis
pson2=wellx(:,5); % P-wave sonic log
rhob2=wellx(:,2); % density log

% Calculate impedance from sonic and density logs
implog2=rhob2.*(1./pson2).*1e6;

% Filter logs to seismic bandwidth
implogf2=filtt(implog2,tlog2,0.1,70,0,128);
aif=filtt(ai,ts,0.1,70,0,128);

% Compare P-impedance from seismic and logs
figure; plot(implogf2,tlog2,imp(1:length(implog2),idx),tlog2,'r');flipy
xlabel('P-imp (gr/cc)*(ft/s)');ylabel('Time (s)');title('X-1 well');
legend('Log','Seismic');
figure;plot(aif,ts,imp(:,idx2),ts,'r');flipy
xlabel('P-imp (gr/cc)*(ft/s)');ylabel('Time (s)');title('S-1 well');
legend('Log','Seismic');