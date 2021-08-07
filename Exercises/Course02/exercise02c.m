% This is taken from Code Snippet 2.11.1 in NMES Book. Implements eq (5) in
% Lecture Note #2.
% Octave compatible

x=[0:30:30000];
v0=1500;c=0.6;nrays=20;
thetamin=5;thetamax=80;
deltheta=(thetamax-thetamin)/nrays;
zraypath=zeros(nrays,length(x));
for i=1:nrays
    theta=thetamin+(i-1)*deltheta;
    p=sin(pi*theta/180)/v0;
    cs=cos(pi*theta/180);
    z=(sqrt(1/(p^2*c^2)-(x-cs/(p*c)).^2)-v0/c);
    ind=find(imag(z)~=0.0);
    if(~isempty(ind));
        z(ind)=nan*ones(size(ind));
    end
    ind=find(real(z)<0);
    if(~isempty(ind));
        z(ind)=nan*ones(size(ind));
    end
    zraypath(i,:)=real(z);
end
figure;plot(x,zraypath);flipy;
xlabel('Meters');ylabel('Meters');