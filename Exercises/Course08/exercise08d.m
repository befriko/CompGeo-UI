% Exercise to reproduce figure (a), (c) and (d) in Lecture #8 ppt.
% Octave compatible.
%
% Befriko Murdianto, Nov 2015
% Reservoir Geophysics Graduate Program
% University of Indonesia

addpath(genpath('../../main'));

% Create two sinusoid, [c] and [d] with freq of 20 and 5 Hz, where
% amplitude of [d] is twice of [c].
fc = 20; fd = 5; dt = 0.002;
[c,tc] = sweep(fc,fc,dt,1,0);
c = c*0.5; % [c] amplitude is half of [d]
[d,td] = sweep(fd,fd,dt,1,0);

% Create signal [a] which is an addition of [c] and [d] and plot [a], [c] and [d].
a = c + d;
figure;subplot(3,1,1);plot(tc,c);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('20 Hz sinusoids');
subplot(3,1,2);plot(td,d);axis([0 1 -1 1]);xlabel('Time (s)');ylabel('Amplitude');title('5 Hz sinusoids');
subplot(3,1,3);plot(td,a);axis([0 1 -1.5 1.5]);xlabel('Time (s)');ylabel('Amplitude');title('Merged sinusoids');

% S-transform to see the [a]'s spectrum
[sta,ta,fa] = stransf(a,0.002,1);
figure;subplot(2,1,1);plot(tc,a);axis([0 1 -1.5 1.5]);xlabel('Time (s)');ylabel('Amplitude');title('Merged sinusoids');
subplot(2,1,2);imagesc(ta,fa,abs(sta));axis([0 1 0 30]);xlabel('Time (s)');ylabel('Frequency (Hz)');title('S-transform of merged sinusoids');flipy;
colormap(jet);