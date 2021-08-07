% This is a basic version of reverse time migration
% by Wenyong Pan, March 2013
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


clc;
clear;

% Link core folders
addpath(genpath('../../main/'));

%% build the simple layered model
vel=ones(200,200)*2000;
vel(50:100,:)=2500;
vel(101:151,:)=3000;
vel(151:end,:)=3500;
vel_smooth=ones(200,200)*2000;

%% initial parameters
delx=3; % grid size
delt=.0005; % time step

% initial wavefields 
snap1=zeros(size(vel));
snap2=snap1;

% max time 
tmax=0.5;

% source wavelet
frequency=35; % dominant frequency of the source wavelet

[wavelet,tw]=ricker(delt,frequency);
zs=5;% source depth

xxx=0:delx:size(vel,2)*delx;
zzz=0:delx:size(vel,1)*delx;

% display velocity model
figure(1)
imagesc(vel);
set(gcf,'color','w')
imagesc(xxx,zzz,vel);
xlabel('Distance (m)','fontsize',12,'fontweight','bold');
ylabel('Depth (m)','fontsize',12,'fontweight','bold');
title('Velocity Model','fontsize',12,'fontweight','bold');
colormap('jet');
colorbar

% source position
 s_x=100;
% s_x=80;

imaging_result=zeros(size(snap2));
source_illumination=zeros(size(snap2));
receiver_illumination=zeros(size(snap2));
imaging_result_normalized=zeros(size(snap2));
imaging_result_normalized2=zeros(size(snap2));

cresult_sum=zeros(size(snap2));
cresult_sum_source=zeros(size(snap2));
cresult_sum_source_normalization=zeros(size(snap2));
cresult_sum_receiver=zeros(size(snap2));
cresult_sum_receiver_normalization=zeros(size(snap2));


%% reverse time migration
i=100;
% for i=s_x:s_x
snap2=zeros(size(vel));
snap2(zs,i)=1; %set source location
% forward modeling 
[snapn,x,z,shot]=get_snapn_rtm(delx,delt,vel,snap1,snap2,tmax,2,1,wavelet,zs);
[snapn,x,z,shot_smooth]=get_snapn_rtm(delx,delt,vel_smooth,snap1,snap2,tmax,2,1,wavelet,zs);

% remove the direct wave
data=shot-shot_smooth;

[cresult_sum,cresult_sum_source,cresult_sum_receiver,cresult_sum_source_normalization,cresult_sum_receiver_normalization]=get_snapn_rtm_reverse(delx,delt,vel,snap1,snap2,tmax,2,1,data,zs);

figure;
imagesc(xxx,zzz,cresult_sum./cresult_sum_source)
xlabel('Distance (m)','fontsize',12,'fontweight','bold');
ylabel('Depth (m)','fontsize',12,'fontweight','bold');
title('Migration Result','fontsize',12,'fontweight','bold');