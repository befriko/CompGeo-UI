function [propout,xout,zout]=gridsmoother(propin,xin,zin,dg,smoothx,smoothz)
% GRIDSMOOTHER: a utility to smooth any gridded property (velocity model,
% elastic model, reservoir model, etc.)
% Input property may have different grid size in both fast and slow
% dimension, as they will be regridded to equal grid size specified by dg
% before smoothing. You can also use different smoother length between
% spatial and vertical dimension.
%
% [propout,xout,zout]=gridsmoother(propin,xin,zin,dg,smoothx,smoothz)
%
% propin ... input property to be smoothed
% xin ... input spatial axis (in consistent unit)
% zin ... input vertical axis (in consistent unit)
% dg ... output grid size of your property to be regridded
% smoothx ... smoothing operator length for the slow dimension (in
% consistent unit)
% smoothz ... smoothing operator length for the fast dimension (in
% consistent unit)
%
% propout ... output smoothed property
% xout ... output spatial axis with dg grid size
% zout ... output vertical axis with dg grid size
%
% Befriko Murdianto, June 2021
% Reservoir Geophysics Graduate Program
% University of Indonesia

if nargin < 6
    error('Not enough input arguments, please check help file.');
end

% Set output spatial and depth axis according to grid size
xmax=max(xin);zmax=max(zin);
xout=[0:dg:xmax];zout=[0:dg:zmax]';

% Resample input model to output grid
proprg=interp2(xin,zin,propin,xout,zout,'linear',min(min(propin)));

nx=length(xout);nz=length(zout);
nsmoothx=2*round(.5*smoothx/dg)+1;%odd number
nsmoothz=2*round(.5*smoothz/dg)+1;%odd number

% Run a smoother over it
t1=clock;
propout=conv2(proprg,ones(nsmoothx,nsmoothz)/(nsmoothx*nsmoothz),'valid');
t2=clock;
deltime=etime(t2,t1);
disp(['smoothing time ' num2str(deltime) ' seconds']);