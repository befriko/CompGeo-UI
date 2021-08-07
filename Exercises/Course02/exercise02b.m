% Simple V(z) raytracing exercise using CREWES raytracing toolbox. Create
% synthetic seismogram and plot F-K spectrum. Octave compatible.
%
% Befriko Murdianto, 2005
% Reservoir Geophysics Graduate Program
% University of Indonesia

clear all;

% Model parameters
zp=[0 500 1000];
vp=[2000 2000 2500];
vs=[1000 1000 1336];
zsrc=10;
zrec=0;
zd=500;
xoff=80:40:25*40;

figure;subplot(2,1,1);flipy;
[t,p]=traceray_pp(vp,zp,zsrc,zrec,zd,xoff,10,-1,10,1,1,-gcf);
title(['Constant velocity, P-P mode zsrc=' num2str(zsrc) ' zrec=' num2str(zrec)])
line(xoff,zrec*ones(size(xoff)),'color','b','linestyle','none','marker','v')
line(0,zsrc,'color','r','linestyle','none','marker','*')
grid;xlabel('meters');ylabel('meters');
axis([0 1000 0 500]);
subplot(2,1,2);flipy;
plot(xoff,t);grid;
title('Traveltime plot');
xlabel('meters');ylabel('seconds');

tmax=1;dt=0.002;
ta=[0:dt:tmax];
spikes=zeros(length(ta),length(t));
for i=1:length(xoff)
    ir(i)=fix(t(i)/dt+0.1)+1;
    theta(i)=asin(p(i)*2000)*180/pi;
    spikes(ir(i),i)=1;
end

% Replace ones on the spikes with zoeppritz reflectivity
rpp=zoeppritz(2,vp(:,2),vs(:,2),2.52,vp(:,3),vs(:,3),1,1,1,theta);
ispk=find(spikes==1);
spikes(ispk)=rpp;

% Convolve reflectivity with the wavelet
f=25;
%w=sin(2.*pi.*f.*ta); % if you want to convolve with sine wave
w=ricker(dt,f); % if you want to convolve with ricker wavelet
for i=1:length(xoff)
    seis(:,i)=conv(spikes(:,i),w);
end

%figure;subplot(1,2,1);plotseis(seis(1:length(ta),:),ta,xoff,1,0.5,1,1,'k')
figure;subplot(1,2,1);imagesc(xoff,ta,seis(1:length(ta),:));colormap(flipud(gray));
title('Synthetic seismogram');set(gca,'xaxislocation','bottom');
xlabel('meters');ylabel('seconds');

[spec,f,kx]=fktran(seis(1:length(ta),:),ta,xoff);
subplot(1,2,2);imagesc(kx,f,real(spec));flipy;colormap(flipud(gray));
title('F-K spectrum');
xlabel('Wavenumber');ylabel('Freq. (Hz)');
axis([-max(kx) max(kx) 0 100]);