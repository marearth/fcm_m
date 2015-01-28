function [U_new, center, obj_fcn] = stepenfcm(data_N,N, U, cluster_n,expo)
%STEPFCM One step in fuzzy c-mean clustering.
%   [U_NEW, CENTER, ERR] = STEPFCM(DATA, U, CLUSTER_N, EXPO)
%   performs one iteration of fuzzy c-mean clustering, where
%
%   DATA: matrix of data to be clustered. (Each row is a data point.)
%   U: partition matrix. (U(i,j) is the MF value of data j in cluster j.)
%   CLUSTER_N: number of clusters.
%   EXPO: exponent (> 1) for the partition matrix.
%   U_NEW: new partition matrix.
%   CENTER: center of clusters. (Each row is a center.)
%   ERR: objective function for partition U.
%
%   Note that the situation of "singularity" (one of the data points is
%   exactly the same as one of the cluster centers) is not checked.
%   However, it hardly occurs in practice.
%
%       See also DISTFCM, INITFCM, IRISFCM, FCMDEMO, FCM.

%   Roger Jang, 11-22-94.
%   Copyright 1994-2002 The MathWorks, Inc. 

% mf = U.^expo;       % MF matrix after exponential modification
% dm1=reshape(data_mean,size(data_mean,1)*size(data_mean,2),1);
% %dm1=data_mean;
% data1=data+a*dm1;
% center = mf*data1./((ones(size(data1, 2), 1)*sum(mf'))'*(1+a)); % new center
% [t1,t2]=obj_mat(center, data,data_mean,U,expo);
% obj_fcn = sum(sum((t1.^2).*mf))+a*sum(sum(t2));  % objective function
% 
% dist = uddistfcm_s2(center, data,dm1,a);     % fill the distance matrix
% tmp = dist.^(-1/(expo-1));      % calculate new U, suppose expo != 1
% U_new = tmp./(ones(cluster_n, 1)*sum(tmp));
mf=U.^expo;
n=size(N,1);
mf1= mf.*(ones(cluster_n,1)*N');
center=mf1*data_N./(sum(mf1'))';
dist=dist_enfcm(center,data_N);
obj_fcn = sum(sum((dist.^2).*mf1));
tmp = dist.^(-2/(expo-1)); 
U_new = tmp./(ones(cluster_n, 1)*sum(tmp));