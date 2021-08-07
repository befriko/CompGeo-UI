function [snapshotn,z,x,shot]=get_snapn_rtm(delx,delt,velocity,snap1,snap2,toutput,laplacian,boundary,wavelet,zs)
% AFD_SNAPN ... time steps a wavefield "n" steps
%
% [snapshotn,z,x]=afd_snapn(delx,delt,velocity,snap1,snap2,toutput,laplacian,boundary,wavelet)
%
% AFD_SNAP propogates a wavefield forward in depth to
% a desired output time.  Two input matrices of the wavefield, 
% one at time=0-delt and one at time=0, are used in a finite 
% difference algorithm to propogate the wavefield.  The 
% finite difference algorithm can be calculated with a 
% five or nine point approximation to the Laplacian operator.  
% The five point approximation is faster, but the nine 
% point results in a broader bandwidth.The snapshot of this 
% propagated wavefield is returned. Note that the velocity 
% and grid spacing must fulfill the equation
% max(velocity)*delt/delx > 0.7 for the model to be stable.  
% This condition usually results in snap1 and snap2 
% being identical. 
%
% delx = the horizontal AND vertical bin spacing in consistent units
% delt = time interval in seconds
% velocity = the input velocity matrix in consisnent units
%          = has a size of floor(zmax/delx)+1 by floor(xmax/delx)+1
% snap1 = the wavefield at time=0 - delt (same size as velocity matrix)
% snap2 = the wavefield at time = 0 (same size as velocity matrix
% toutput = the time in seconds at which the propagated wavefield will be returned
% laplacian - an option between two approximation to the laplacian operator
%           - 1 is a 5 point approximation
%           - 2 is a nine point approximation
% boundary = indicate whether all sides of the matrix are absorbing
%          = '1' indicates all four sides are absorbing
%          = '2' choses three sides to be absorbing, and the top one not to be
%             this enables sources to be put on the surface
%
% snapshotn = the image of the wavefield at the specified time
%
% by Carrie Youzwishen, February 1999
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.
 
% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by 
% its author (identified above) and the CREWES Project.  The CREWES 
% project may be contacted via email at:  crewesinfo@crewes.org
% 
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the 
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may 
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers 
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any 
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE
tic
[nx,nz]=size(snap1);
if(prod(double(size(snap1)~=size(snap2))))
	error('snap1 and snap2 must be the same size');
end
if(prod(double(size(snap1)~=size(velocity))))
	error('snap1 and velocity must be the same size');
end

if(nargin<9) wavelet=1; end

xmax=(nx-1)*delx;
zmax=(nz-1)*delx;

x=0:delx:xmax;
z=(0:delx:zmax)';

if laplacian ==1 

    if max(max(velocity))*delt/delx > 1/sqrt(2)
    disp('Model is unstable:  max(velocity)*delt/delx MUST BE < 1/sqrt(2)');
    return;
    end
else

    if max(max(velocity))*delt/delx > sqrt(3/8)
    disp('Model is unstable:  max(velocity)*delt/delx MUST BE < sqrt(3/8)');
    return;
    end
end

disp(['There are ' int2str(toutput/delt-1) ' steps to complete']);

sources=snap2;
snap2=wavelet(1)*sources;

fidwavefield=fopen('wavefield.bin','w');

xxx=0:delx:size(velocity,2)*delx;
zzz=0:delx:size(velocity,1)*delx;

for k=1:round(toutput/delt)

   [snapshotn]=get_snap_rtm(delx,delt,velocity,snap1,snap2,laplacian,boundary);
   
   snap1=snap2;
   snap2=snapshotn;
   if(k+1<=length(wavelet))
       snap2=snapshotn+wavelet(k+1)*sources;
   else
       snap2=snapshotn;
   end
   
   if rem(k,10) == 0
           disp(['The wavefield has been propagated to ' num2str(k*delt) ' seconds']);
   end 
   shot(k,:)=snapshotn(zs,:);
   
   % display waveproopagation
%    figure(2);cla
%    set(gcf,'color','w')
%    imagesc(xxx,zzz,snapshotn);
%    xlabel('Distance (m)','fontsize',12,'fontweight','bold');
%    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
%    title(strcat('Forward Modeling at (s)    ',num2str(k*delt)),'fontsize',12,'fontweight','bold');
%    colormap('gray');
%    
%    if k==500
%      forward=snapshotn;
%      save forward.mat forward
%    end
 fwrite(fidwavefield,snapshotn,'float');
end
 fclose(fidwavefield);

toc
