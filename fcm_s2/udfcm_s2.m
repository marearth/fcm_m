function [center, U, obj_fcn] = udfcm_s2(data, cluster_n,a,options)
%
data1=data;                                 
data=[];
data=reshape(data1,size(data1,1)*size(data1,2),1);
data2=padmatrix(data1,1);
for i=2:size(data1,1)+1,
    for j=2:size(data1,2)+1,
%         if(i==1 || j==1 ||i==size(data1,1) || j==size(data1,2))
%             data_mean(i,j)=data1(i,j);
%             continue;
%         end
        data_mean(i-1,j-1)=dm(i,j,data2);
    end
end
        
if nargin ~= 2 && nargin ~= 3 && nargin ~=4,
	error('Too many or too few input arguments!');
end

data_n = size(data, 1);
in_n = size(data, 2);

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

expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not

obj_fcn = zeros(max_iter, 1);	% Array for objective function

U = udinitfcm_s2(cluster_n, data_n);			% Initial fuzzy partition
% Main loop
for i = 1:max_iter,
	[U, center, obj_fcn(i)] = udstepfcm_s2(data,data_mean, U, cluster_n,a,expo);
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
   

function out=dm(x,y,d)
 temp=[d(x-1,y) d(x-1,y-1) d(x-1,y+1) d(x+1,y) d(x+1,y-1) d(x+1,y+1) d(x,y-1) d(x,y+1)];
 out=median(temp);
 
  


