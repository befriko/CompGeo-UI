function [vint_blocked,xout,zout]=makelayeredvint(vint,xin,zin,dg,hor,flag)
% MAKELAYEREDVINT: make layered interval velocity from gridded velocity
% Input is interval velocity in depth or time (fast domain must be in
% consistent unit for all input), such the one you get from vrm2vint in the
% CREWES toolbox.
%
% [vint_blocked,xout,zout]=makelayeredvint(vint,xin,zin,dg,hor,flag)
% [vint_blocked,xout,zout]=makelayeredvint(vint,xin,zin,dg,hor)
%
% vint ... input gridded interval velocity
% xin ... input spatial axis (in consistent unit)
% zin ... input vertical axis (in consistent unit)
% dg ... output grid size (output will be dx=dz)
% hor ... m x n matrix, where m is the number of x locations and n is the
% number of horizons (typically 4 to 5 is sufficient). The number of x
% locations needs to be the same as the velocity model spatial samples.
% flag=0 ... return nonphysical interval velocities as NaN
%     =1 ... set nonphysical interval velocities to zeros
%  ******* default = 1 **********
%
% Befriko Murdianto, June 2021
% Reservoir Geophysics Graduate Program
% University of Indonesia

% Set defaults
if nargin == 5
    flag=1;
elseif nargin <5
    error('Input parameters are not sufficient, please check help file');
end

% Set output spatial and depth axis according to grid size
xmax=max(xin);zmax=max(zin);
xout=[0:dg:xmax];zout=[0:dg:zmax]';

% Resample input model to output grid
velintp=interp2(xin,zin,vint,xout,zout,'linear',min(min(vint)));

% OK, now to create layered model, you need to add the uppermost and
% lowermost layers in the provided horizons. Then you need to shift the
% horizons halfway as we're going to use nearest neighbor interpolation to
% create layered model.
[m,n]=size(hor);
zblock=zeros(m,n+2);
[mm,nn]=size(zblock);horpad=999999*ones(m,2);
nhor=[hor horpad]; % pad with infinite half-space for lowermost layer
for i=3:nn
    zblock(:,i)=nhor(:,i-1)+abs((nhor(:,i-1)-nhor(:,i-2)))/2; % shift the horizons halfway
end
zblock(:,1)=zeros(mm,1); % uppermost horizon should be on depth zero
zblock(:,2)=nhor(:,1)+nhor(:,1)/2;
zblock=zblock';

% Build layered model using horizons
[mmm,nnn]=size(velintp);
for j=1:nnn
    vint_resamp(:,j)=interp1(zout,velintp(:,j),zblock(:,j),'linear','extrap');
    vint_blocked(:,j)=interp1(zblock(:,j),vint_resamp(:,j),zout(:,1),'nearest');
end

if flag==1
    % replace NaNs
    a=isnan(vint_blocked);
    [indx,indy]=find(a==1);
    vint_blocked(indx,indy)=0;
end