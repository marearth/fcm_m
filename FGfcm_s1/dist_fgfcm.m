function out=dist_enfcm(center,data)
out = zeros(size(center, 1), size(data, 1));
  for k = 1:size(center, 1),
	out(k, :) = abs(center(k)-data)';
  end