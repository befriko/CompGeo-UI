function y = STFT(x, sampling_rate, window, window_length, step_dist, padding)
%
%  y = STFT(x, sampling_rate, window, window_length, step_dist, padding)
%
%  STFT produces a TF image of "x".
%  The output is also stored in "y".
%
%  For "window", use one of the following inputs:
%  rectangular    = 1
%  Hamming        = 2
%  Hanning        = 3
%  Blackman-Tukey = 4
%
%  The time scale is associated with the center of the window,
%  if the window is of odd length.  Otherwise, the window_length/2
%  is used.  "Step_dist" determines the stepping distance between the number
%  of samples, and is arranged to maintain the proper time index
%  provided by "sampling_rate" in seconds.  "Padding" is the
%  total length of the windowed signal before the fft, which is
%  accomplished by zero padding.
%
%  Developed by Timothy D. Dorney
%               Rice University
%               April, 1999
%               tdorney@ieee.org
%
%  Coded using MATLAB 5.X.X.
%
%	REVISION HISTORY
%
%	VERSION 1.0.0		APR. 21, 1999	TIM DORNEY
%

if (nargin ~= 6)
        disp('STFT requires 6 input arguments!')
	return;
end
if ((window < 1) | (window > 4))
	window = 1;
	disp('The argument "window" must be between 1-4, inclusively.  Window set to 1!');
end
if ((step_dist < 1) | (round(step_dist) ~= step_dist))
	step_dist = 1;
	disp('The argument "step_dist" must be an integer greater than 0.  Step_dist set to 1!');
end
if (sampling_rate <= 0)
	disp('The argument "sampling_rate" must be greater than 0.');
	return;
end
if (padding < window_length)
	padding = window_length;
	disp('The argument "padding" must be non-negative.  Padding set to "window_length"!');
end

if (window == 1)
	WIN = ones(1,window_length);
elseif (window == 2)
	WIN = hamming(window_length)';
elseif (window == 3)
	WIN = hanning(window_length)';
elseif (window == 4)
	WIN = blackman(window_length)';
end

[m,n] = size(x);
if (m ~= 1)
	X = x';
else
	X = x;
end
[m,n] = size(X);
if (m ~= 1)
	disp('X must be a vector, not a matrix!');
	return;
end

LENX = length(X);
IMGX = ceil(LENX/step_dist);
if (padding/2 == round(padding/2))
	IMGY = (padding/2) + 1;
else
	IMGY = ceil(padding/2);
end

y = zeros(IMGX,IMGY);

if (window_length/2 == round(window_length/2))
	CENTER = window_length/2;
	x_pad_st = window_length - CENTER - 1;
	x_pad_fi = window_length - CENTER;
else
	CENTER = (window_length+1)/2;
	x_pad_st = window_length - CENTER;
	x_pad_fi = window_length - CENTER;
end

X = [zeros(1,x_pad_st) X zeros(1,x_pad_fi)];

iter = 0;
for kk = 1:step_dist:LENX
	iter = iter + 1;
	XX = X(kk:(kk + window_length - 1));
	YY = XX .* WIN;
	ZZ = abs(fft(YY, padding));
	y(iter,:) = ZZ(1:IMGY);
end

%freq = (1/sampling_rate)/2;
%imagesc([0:(step_dist*sampling_rate):(sampling_rate*(LENX-1))], ...
%	[0:(freq/(IMGY-1)):freq],y');
%xlabel('Time (seconds)');
%ylabel('Frequency (Hz)');
%axis('xy')





