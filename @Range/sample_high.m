%% Sample max from range
function [x] = sample_high(range, N)

	if nargin == 1
		N = 1;
	end

	switch range.type
		case 'scalar'
			x = ones(N,1) * range.val;
		case 'range'
			sigma = (range.val(2) - range.val(1)) / 10;
			x = -abs(sigma*randn(N,1)) + range.val(2);
		case 'irange'
			sigma = (range.val(2) - range.val(1)) / 10;
			x = round(-abs(sigma*randn(N,1)) + range.val(2));
		case 'set'
			sigma = length(range.val) / 10;
			x = range.val(round(-abs(sigma*randn(N,1)) + length(range.val)));
		case 'subset'
			error('Sampling not defined for subset range');
	end
end
