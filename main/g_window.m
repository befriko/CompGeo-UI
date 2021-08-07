function gauss = g_window(length,freq,factor)
% G_WINDOW: A simple taper with a Gaussian-type window
% Usage: gauss = g_window(length,freq,factor)
%        length is the sample length
%        freq is the minimum freq to keep
%        factor is the scaling factor
%
% Abdul Haris, 2011
% Reservoir Geophysics Graduate Program
% University of Indonesia

vector(1,:) = [0:length-1];
vector(2,:) = [-length:-1];
vector = vector.^2;
vector = vector*(-factor*2*pi^2/freq^2);

gauss = sum(exp(vector));