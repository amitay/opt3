%% Sample max from range
function [x] = sample_max(range, N)

	if nargin == 1
		N = 1;
	end

	switch range.type
		case 'scalar'
			x = ones(N,1) * range.val;
		case 'range'
			x = ones(N,1) * range.val(2);
		case 'irange'
			x = ones(N,1) * range.val(2);
		case 'set'
			x = ones(N,1) * range.val(end);
		case {'subset', 'object'}
			error('Sampling not defined for object/subset range');
	end
end
