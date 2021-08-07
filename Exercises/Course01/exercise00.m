load ../../Data/clown
figure;imagesc(X);colormap(map);
Xa=X(50:110,135:238);
figure;imagesc(Xa);colormap(map);
figure;imagesc(X');colormap(map);
Xr=reshape(X,100,640);
figure;imagesc(Xr);colormap(map);
X1=Xr(:,1:2:640);X2=Xr(:,2:2:640);
figure;subplot(211);imagesc(X1);subplot(212);imagesc(X2);colormap(map);