function f = fun_ray(x,D,h,v);
% FUN_RAY: simple function file to calculate offset difference used to
% estimate ray parameter in ray tracing.
%
% Usage: f=fun_ray(x,D,h,v)
%
% x ... input offset (distance from source to receiver)
% D ... observed offset
% h ... layer thickness
% v ... layer velocity
%
% Befriko Murdianto, ca. 2001
% Reservoir Geophysics Graduate Program
% University of Indonesia

if nargin < 4
    error('Not enough input arguments, please check help file.')
end

f = 2*sum(x*h.*v./sqrt(1-x^2*v.^2)) - D;