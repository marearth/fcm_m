%       data = rand(100,2);
%       [center,U,obj_fcn] = udfcm(data,2);
%       plot(data(:,1), data(:,2),'o');
%       hold on;
%       maxU = max(U);
%       % Find the data points with highest grade of membership in cluster 1
%       index1 = find(U(1,:) == maxU);
%       % Find the data points with highest grade of membership in cluster 2
%       index2 = find(U(2,:) == maxU);
%       line(data(index1,1),data(index1,2),'marker','*','color','g');
%       line(data(index2,1),data(index2,2),'marker','*','color','r');
%       % Plot the cluster centers
%       plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
%       hold off;
clc;clear
tic
d1=imread('wheel.png');
d2=rgb2gray(d1);
subplot(1,3,1);
imshow(d2);
dnsp=imnoise(d2,'salt & pepper',0.02);
subplot(1,3,2);
imshow(dnsp);
d3=im2double(dnsp);
d4=reshape(d3,size(d3,1)*size(d3,2),1);
[center,U,obj_fcn]=udfcm_s1(d3,4,4.2);
maxU=max(U); 
index1=find(U(1,:)==maxU);
index2=find(U(2,:)==maxU);
index3=find(U(3,:)==maxU);
index4=find(U(4,:)==maxU);
r=round(center*255);
d5=d4;
d5(index1,1)=r(1);
d5(index2,1)=r(2);
d5(index3,1)=r(3);
d5(index4,1)=r(4);
d6=reshape(d5,size(d3,1),size(d3,2));
d7=mat2gray(d6,[0 255]);
subplot(1,3,3);
imshow(d7);
toc