% This script simulates exploding reflector in the SEG/EAGE salt model
% using finite-difference. Requires CREWES toolbox. See Lecture Notes # 3.
% Octave compatible.
%
% Original version: Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia
%
% Last Update: Befriko Murdianto, September 2016
%              Added exploding reflector exercise

clear all

load ../../Data/vmodel.mat;
[m,n]=size(vmodel);dx=40;

% Define modeling parameters, make sure it fulfills stability condition
dtstep=0.001; dt=0.002;
tmax=3;laplacian=2;

% Receivers are located on the surface
xrec=[0:n-1]*dx;
zrec=zeros(size(xrec));

% Exploding reflectors with acoustic finite-difference
[seismogram,seis,t]=afd_explode(dx,dtstep,dt,tmax,vmodel,xrec,zrec,[3 6 45 65],0,laplacian,1);
 
%plotimage(seismogram,t,xrec);
figure;imagesc(xrec,t,seismogram,[-0.5 0.5]);
xlabel('Distance (ft)');ylabel('Time (sec)'); colormap(seisclrs);
title('Exploding reflector of SEG/EAGE salt model');