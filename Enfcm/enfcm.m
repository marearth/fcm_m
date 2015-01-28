function [center, U, obj_fcn] = enfcm(data, cluster_n,a,options)
% Use a 3*3 window
data1=data;                                 %Preprocess data
data=[];                                    
data=reshape(data1,size(data1,1)*size(data1,2),1);
data2=padmatrix(data1,1);                    %Preprocess data
% for i=2:size(data1,1)+1,
%     for j=2:size(data1,2)+1,
% %         if(i==1 || j==1 ||i==size(data1,1) || j==size(data1,2))
% %             data_mean(i,j)=data1(i,j);
% %             continue;
% %         end
%         data_mean(i-1,j-1)=dm(i,j,data2);
%     end
% end
        
if nargin ~= 2 && nargin ~= 3 && nargin ~=4,
	error('Too many or too few input arguments!');
end
% 
data_n = size(data, 1);
% in_n = size(data, 2);

% Change the following to set default options
default_options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		1];	% info display during iteration 

if nargin == 2,
	options = default_options;
    a=4.2; %control the effects of the neighbors term
elseif nargin==3,
    options = default_options;   
else
	% If "options" is not fully specified, pad it with default values.
	if length(options) < 5,
		tmp = default_options;
		tmp(1:length(options)) = options;
		options = tmp;
	end
	% If some entries of "options" are nan's, replace them with defaults.
	nan_index = find(isnan(options)==1);
	options(nan_index) = default_options(nan_index);
	if options(1) <= 1,
		error('The exponent should be greater than 1!');
	end
end

expo = options(1);		    % Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not

bitnum=8;
gln=2^bitnum;
obj_fcn = zeros(max_iter, 1);	% Array for objective function
lnai=zeros(data_n,1);           % Compute the local neighbor average image from original image
rc=[size(data1,1) size(data1,2)];

for i=1:data_n,
    lnai(i)=round(lnai_fun(i,data2,rc,a)*(gln-1));
end                             % Compute the local neighbor average image from original image

edges=linspace(0,2^bitnum,2^bitnum+1);      % Compute the histogram of the processed images,8 bit image
[N,~,bin]=histcounts(lnai,edges);       
N=N';
data_N=(linspace(0,2^bitnum-1,2^bitnum))';% Compute the histogram of the processed images,8 bit image


data_n=size(N,1);
U = enfcm_init(cluster_n, data_n);			% Initial fuzzy partition
% Main loop
for i = 1:max_iter,
	[U, center, obj_fcn(i)] = stepenfcm(data_N,N, U, cluster_n,expo);
	if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
	end
	% check termination condition
	if i > 1,
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
	end
end

iter_n = i;	% Actual number of iterations 
obj_fcn(iter_n+1:max_iter) = [];
U1=U;
U=[];
U=U1(:,bin);

   

function out=lnai_fun(i,data2,rc,a)
 data=reshape(data2,size(data2,1)*size(data2,2),1);
 neigh=neighbor(rc,i);
 out=(data(i)+a*sum(data(neigh))/8)/(1+a);
 
 
 function out=neighbor(rc,i) 
  out=[];
  r=rc(1);
  c=rc(2);
  %c1=floor(i/r)+1;
  r1=mod(i,r);
  if(r1==0),
      r1=r;
      c1=floor(i/r);
  else
      c1=floor(i/r)+1;        
  end
 temp=[-1 1;-1 0;1 -1;1 0;0 1;0 -1;1 1;-1 -1];
 temp(:,1)=temp(:,1)+r1+1;
 temp(:,2)=temp(:,2)+c1+1;
%  if(r1==1 || c1==1 || r1==r || c1==c),   %Deal with boundary
%  nr=find(temp(:,1)==0 | temp(:,1)==r+1);
%  nc=find(temp(:,2)==0 | temp(:,2)==c+1);
%  rc=union(nc,nr);
%  temp(rc,:)=[];
%  end
 temp(:,2)=temp(:,2)-1;
 out=temp*[1;r+2];
  


