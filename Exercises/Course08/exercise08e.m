% Decomposing and reconstructing signal with EMD.
% Octave compatible.
%
% Befriko Murdianto, Nov 2015
% Reservoir Geophysics Graduate Program
% University of Indonesia

addpath(genpath('../../main'));

% Create two sinusoid, [c] and [d] with freq of 20 and 5 Hz, where amplitude
% of [d] is twice of [c].
fc = 20; fd = 5; dt = 0.002;
[c,tc] = sweep(fc,fc,dt,1,0);
c = c*0.5; % [c] amplitude is half of [d]
[d,td] = sweep(fd,fd,dt,1,0);

% Create signal [a] which is an addition of [c] and [d] and plot [a], [c] and [d].
a = c + d;
figure;subplot(3,1,1);plot(tc,c);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('20 Hz sinusoids');
subplot(3,1,2);plot(td,d);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('5 Hz sinusoids');
subplot(3,1,3);plot(td,a);axis([0 1 -1.5 1.5]);xlabel('Time (s)');ylabel('Amplitude');title('Merged sinusoids');

% Decompose [a] into its first 2 IMFs
imf = emd_n(a,2);
cest = imf(1,:); % estimate of [c]
dest = imf(2,:); % estimate of [d]
aest = cest + dest; % reconstruction of [a] using its 2 IMFs

% Plot estimate
figure;subplot(3,1,1);plot(tc,cest);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('IMF 1 of merged sinusoids');
subplot(3,1,2);plot(td,dest);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('IMF 2 of merged sinusoids');
subplot(3,1,3);plot(td,aest);axis([0 1 -1.5 1.5]);xlabel('Time (s)');ylabel('Amplitude');title('Reconstruction using 2 IMFs');

% Full decomposition
imfs = emd(a);
[m,n] = size(imfs);
arecon = zeros(1,n);
for i = 1:m
    arecon = arecon + imfs(i,:);
end

% Plot full reconstruction
figure;subplot(3,1,1);plot(tc,imfs(1,:));axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('IMF 1 of merged sinusoids');
subplot(3,1,2);plot(td,imfs(2,:));axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('IMF 2 of merged sinusoids');
subplot(3,1,3);plot(td,arecon);axis([0 1 -1.5 1.5]);xlabel('Time (s)');ylabel('Amplitude');title('Full reconstruction of merged sinusoids');
