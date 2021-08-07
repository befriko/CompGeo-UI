% This script generates shot record for a VSP geometry. Receiver depth is
% from 140m to 620m with 10m increment. Shot is at the surface. Requires
% CREWES toolbox. Octave compatible.
%
% Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia

% Model geometry
dx=10;xmax=200;zmax=650;
x=[0:dx:xmax-dx];z=[0:dx:zmax-dx];
v=zeros(zmax/dx,xmax/dx);

% Velocity model is 6 layers with different velocities
v(1:11,:)=2000;
v(12:21,:)=2500;
v(22:31,:)=3000;
v(32:51,:)=3500;
v(52:61,:)=4000;
v(62:65,:)=5000;

% Shot and receiver geometries
xshot=0;zshot=0;
zrec=[140:10:620];xrec=100.*ones(size(zrec));
figure;imagesc(x,z,v);colormap(flipud(autumn));colorbar;
xlabel('Distance (m)');ylabel('Depth (m)');
line(xshot,zshot,'color','k','linestyle','none','marker','*');
line(xrec,zrec,'color','k','linestyle','none','marker','v');

% FD modeling parameters
dtstep=0.001;dt=0.002;tmax=1;
snap1=zeros(size(v));snap2=snap1;
snap2(1,xshot/dx+1)=1;

% Create wavelet
[wavelet,tw]=ricker(dt,30);laplacian=2;

% FD modeling
[seismogram,seis,t]=afd_shotrec(dx,dtstep,dt,tmax,v,snap1,snap2,xrec,...
    zrec,wavelet,tw,laplacian);
seisr=real(seismogram);
%plotimage(seisr,t,zrec);
figure;imagesc(zrec,t,seisr,[-0.00005 0.00005]);colormap(seisclrs);
xlabel('Depth (m)');ylabel('Time (s)');
