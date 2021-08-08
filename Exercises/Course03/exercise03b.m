% This script simulates acoustic wave propagation in a constant medium
% using finite-difference. Requires CREWES toolbox. See Lecture Notes # 3.
% Octave compatible.
%
% Original version: Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia
%
% Last Update: Befriko Murdianto, June 2021
%              Added two-layer model

clear all
close all

vmodel=ones(1001,1001);
vmodel=vmodel*2500;
vmodel(501:1001,:)=3500;
dx=5; dz=dx;
x=[0:dx:(length(vmodel)-1)*dx];
z=[0:dz:(length(vmodel)-1)*dz];

% Define modeling parameters, make sure it fulfills stability condition
dtstep=0.001; dt=0.002;
tmax=1.3;
laplacian=1;
maxframes=40;

% Initial condition is everything zero (no explosion)
state1=zeros(size(vmodel));
% At t=dtstep, the shot starts to explode (put a value with a magnitude of
% 1 at source location)
state2=state1;
state2(1,501)=1;

% Create wavelet
fdom=15;
[w,tw]=ricker(dt,fdom);

% Acoustic finite-difference modeling
M=afd_movie(dx,dtstep,tmax,vmodel,state1,state2,laplacian,maxframes,w);
%movie(M);
