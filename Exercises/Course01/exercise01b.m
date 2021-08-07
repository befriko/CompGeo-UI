% Horizon loading exercise. Creates plan view and 3-D view.
% Octave compatible.
%
% Befriko Murdianto, Sep 2016
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all;

% Read horizon text file
hor=load('../../Data/Caddo.txt');

% Column 1 is xline, column 2 is inline, column 5 is the Z value
horx=hor(:,1);
hory=hor(:,2);
horz=hor(:,5);

% Set number of inlines and xlines
nxline=(max(horx)-min(horx))+1;
niline=(max(hory)-min(hory))+1;
xline=[min(horx):max(horx)];
iline=[min(hory):max(hory)];

% Plan view
horr=reshape(horz,nxline,niline);hort=horr';
figure;imagesc(xline,iline,hort);
xlabel('Crossline');ylabel('Inline');title('Caddo: Plan View');
colormap(hsv);colorbar;

% 3-D view
figure;surf(iline,xline,horr);shading interp;set(gca,'zdir','reverse','ydir','reverse');
xlabel('Inline');ylabel('Crossline');zlabel('Time (msec)');
title('Caddo: 3-D View');
colormap(hsv);colorbar;