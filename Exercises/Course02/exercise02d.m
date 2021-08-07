% Raytracing in V(x,z) medium using SEG/EAGE salt model. Requires CREWES
% toolbox. Octave compatible.
%
% 1st Revision: 5 September, 2019
%               Replaced line with plot and hold on/off to overlay rays on velocity model
%
% Befriko Murdianto, Sep 2016
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

load ../../Data/vmodel.mat;
[m,n]=size(vmodel);dx=40;dz=dx;
x=[0:n-1]*dx;
z=[0:m-1]*dz;

imagesc(x,z,vmodel);colormap(flipud(gray));hold on;
xlabel('Distance (ft)');ylabel('Depth (ft)');
rayvelmod(vmodel,dx);

%estimate tmax,dt,tstep
%tmax=max(z)/min(min(vmodel));dt=.004;tstep=0:dt:tmax;
tmax=5;dt=.004;tstep=0:dt:tmax; %tmax set to 5 seconds, calculated tmax has rays ended prematurely

%specify a fan of rays
angles=[-80:2.5:80]*pi/180;
x0=round(n/2)*dx;z0=0;
indx=near(x,x0);indz=near(z,z0);
v0=vmodel(indz,indx);

%trace the rays
t1=clock;
for k=1:length(angles)
	r0=[x0 z0 sin(angles(k))/v0 cos(angles(k))/v0];
	[t,r]=shootrayvxz(tstep,r0);
	plot(r(:,1),r(:,2),'r');
end
t2=clock;hold off;
deltime=etime(t2,t1);
disp(['raytrace time ' num2str(deltime) ' seconds']);