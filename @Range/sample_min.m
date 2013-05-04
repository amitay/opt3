%% Sample min from range
function [x] = sample_min(range, N)

	if nargin == 1
		N = 1;
	end

	switch range.type
		case 'scalar'
			x = ones(N,1) * range.val;
		case 'range'
			x = ones(N,1) * range.val(1);
		case 'irange'
			x = ones(N,1) * range.val(1);
		case 'set'
			x = ones(N,1) * range.val(1);
		case 'subset'
			error('Sampling not defined for subset range');
	end
end
