function [x] = denormalize(surr, x_normal)
% DENORMALIZE() de-normalizes x values from [eps,1]
%

	eps = 1.e-4;

	nx = length(surr.range);
	x = zeros(size(x_normal));

	for i = 1:nx
		x(:,i) = min(range{i}) + x_normal(:,i) * (max(range{i}) - min(range{i})) / (1-eps);
	end
end
