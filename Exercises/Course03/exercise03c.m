% This script generates 10 synthetic shot gathers for an SEG/EAGE salt
% model. First shot is on the upper left and then moving to the right with
% 30m shotpoint increment. Receivers are set with off-end geometry,
% furthest offset is 4500m. Both source and receivers are located on the
% surface. Record length is 1s with 4ms sample interval. Requires CREWES
% toolbox. Octave compatible.
%
% Befriko Murdianto, 2008
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all

% load SEG/EAGE velocity model
load ../../Data/vmodel.mat;

% set grid size, time step, sample rate and recording length
[m,n]=size(vmodel);dx=30;dz=dx;
dtstep=.001;dt=.004;tmax=3;

% x and z coordinates of the model
x=[0:n-1]*dx;z=[0:m-1]*dz;

% where's offset 4500?
a=find(x<=4500);

% receivers coordinates
xrec=x(:,1:length(a));zrec=zeros(size(xrec));

% create wavefield snapshots at t=0 and t=dtstep. At t=0, the snapshot
% simply all blanks (no shot exploded), at t=dtstep, the snapshot is blank
% everywhere except on the shot location.
snap1=zeros(size(vmodel));
snap2=snap1;

% create 10 gathers, set zeros matrix for recorded seismogram
ng=10;seismogram=zeros((tmax/dt+1),length(xrec)*ng);
b=length(xrec)-1;seis=zeros(size(seismogram));

% generate shot records, iterate over each record
tic;
for i=1:ng
    % where's my shot?
    xpos=find(x==(i-1)*dx);
    % put the explosion on the shot location and then move the receivers
    snap2(1,xpos)=1;xrec=xrec+((i-1)*dx);
    % second order laplacian
    [seismogram(:,i+b*(i-1):i+b*i),seis(:,i+b*(i-1):i+b*i),t]=afd_shotrec(dx,dtstep,dt,tmax,...
        vmodel,snap1,snap2,xrec,zrec,[5 10 30 40],0,1);
    fprintf('Finished generating shot gather no. %d \n',i);
end
toc;

% display velocity model
figure;imagesc(x,z,vmodel);
colormap(jet);colorbar;
xlabel('Distance (m)');ylabel('Depth (m)');
title('Velocity model');
% display shot records
%plotimage(seismogram,t,1:length(xrec)*ng);
figure; imagesc(1:length(xrec)*ng,t,seismogram,[-0.01 0.01]);
xlabel('Trace no.');ylabel('Time (s)');
title('Shot records');colormap(seisclrs);