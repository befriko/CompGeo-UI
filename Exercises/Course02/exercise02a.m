% This script calculates traveltime of a P-wave in a V(z) medium using
% raytracing. Requires CREWES toolbox for display. See Lecture Notes # 2.
% Octave compatible.
%
% 1st Revision: 5 September, 2019
%               Modify fzero to access extra parameters using anonymous function
%               instead of conventional parameterization, to be compatible with Octave. 
%               https://www.mathworks.com/help/matlab/math/parameterizing-functions.html
%
% Befriko Murdianto, October 2011
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all;

addpath(genpath('../../main/'));

% model parameters for raytracing : velocity, thickness, and offset
v = [3000 3000 2000 3000 3500 3300 4000 3400 3600];
z = [0 400 600 900 1100 1500 1600 1800 2000];
h = diff(z); % depth from surface should be the integration of h
D = [50:50:3000];

% number of traces (receivers) and number of interfaces
ntrace = length(D);
nint = min([length(h) length(v)]);

% find ray parameters using MATLAB command : fzero
disp('Calculating ray parameters...');

% iterate over receivers
for j = 1:ntrace
   offset = D(j); 
   % iterate over interfaces
   for i = 1:nint
      hh = h(1:i);
      vv = v(1:i);
      er = 1e-6;
      x  = min(1./vv) - er;
      p(i,j) = fzero(@(x) fun_ray(x,offset,hh,vv),[-er x]);
      theta(i,j) = (asin(p(i,j)*vv(i)))*180/pi;
      
      % calculate traveltime based on ray parameters
      t(i,j) = 2*sum(hh./(vv.*sqrt(1-p(i,j)^2*vv.^2)));
      
   end % iteration over interfaces  
end % iteration over receivers

% print completion info
disp('Ray parameter calculation completed');

% display traveltime plot
figure;hold on
for i=1:nint
    plot(D,t(i,:)); xlabel('Offset (m)'); ylabel('Traveltime (s)');
end
hold off; flipy

% the following elastic parameters are not required by the raytracing, they
% are required to calculate reflectivity
rho = [2.5 2.5 1.9 2.5 2.1 2.5 2.2 1.5 2]; % density
vs = 0.5*v; % shear wave velocity
%pois = (vs.^2-0.5*v.^2)./(vs.^2-v.^2); % Poisson's ratio

% create zeros matrix for spike's location
tmax = max(max(t)); dt = 0.002; % use 2ms sample rate
ta = [0:dt:tmax];
spikes = zeros(length(ta),ntrace); % matrix size should be length(ta) rows
                                   % by ntrace columns

% add n+1th layer to calculate reflectivity
%v(nint+1) = 3800; rho(nint+1) = 2.5; vs(nint+1) = 0.5*v(nint+1);

% put spikes into location
disp('Creating synthetics...');

% iterate over interfaces
for i = 1:nint
    % iterate over receivers
    for j = 1:ntrace
        ir(i,j) = fix(t(i,j)/dt+0.1)+1; % index of spike
        % calculate reflectivity using Zoeppritz's equation
        refl(i,j) = zoeppritz(rho(:,i),v(:,i),vs(:,i),...
            rho(:,i+1),v(:,i+1),vs(:,i+1),1,1,1,theta(i,j));
        refl(i,j) = real(refl(i,j));
        spikes(ir(i,j),j) = spikes(ir(i,j),j)+refl(i,j);
    end % iteration over receivers
end % iteration over interfaces

% convolve spikes with 30Hz ricker wavelet
[w,tw] = ricker(0.002,30);
% loop over traces
for i = 1:ntrace
    seis(:,i) = convz(spikes(:,i),w);
end % loop over traces

% print completion info
disp('Synthetics done');

% plot synthetics
figure;plotseis(seis,ta,D,1,3,1,1,'k');
title('Synthetic seismogram');set(gca,'xaxislocation','bottom');
xlabel('Offset (m)');ylabel('Time (s)');