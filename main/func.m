function yc = func(x,p)
% FUNC: function file to calculate gravity anomaly of a cylinder.
%
% yc=func(x,p)
%
% x ... lateral distance of gravity measurement
% p ... matrix of parameters to be determined (depth and radius of
% cyllindrical body)
%
% Befriko Murdianto, Oct 20017
% Reservoir Geophysics Graduate Program
% University of Indonesia

g = 6.6732e-11;
drho = -2800;
const = 2*pi*g*drho;
yc = const.*p(1).^2.*p(2)./(x.^2+p(2).^2);