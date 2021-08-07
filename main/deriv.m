function dydp = deriv(x,p)
% DERIV: derivative to calculate Jacobian matrix of a gravity anomaly due
% to a cylindrical body.
%
% dydp=deriv(x,p)
%
% x ... lateral distance of gravity measurement
% p ... matrix of parameters to be determined (depth and radius of
% cyllindrical body)
%
% Befriko Murdianto, Oct 2017
% Reservoir Geophysics Graduate Program
% University of Indonesia

g = 6.6732e-11;
drho = -2800;
const = 2*pi*g*drho;
dydp(:,1) = const.*2.*p(1).*p(2)./(x.^2+p(2).^2);
dydp(:,2) = const.*p(1).^2.*(x.^2-p(2).^2)./(x.^2+p(2).^2).^2;