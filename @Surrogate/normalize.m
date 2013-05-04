function [x_normal] = normalize(surr, x)
% NORMALIZE() normalizes x value between [eps,1]

	eps = 1.e-4;

	nx = length(surr.range);
	x_normal = zeros(size(x));

	range = surr.range;
	for i = 1:nx
		x_normal(:,i) = eps + (x(:,i) - min(range{i})) * (1-eps) / (max(range{i}) - min(range{i}));
	end
end
