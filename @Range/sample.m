%% Sample from range
function [x] = sample(range, N)

	if nargin == 1
		N = 1;
	end

	switch range.type
		case 'scalar'
			x = ones(N,1) * range.val;
		case 'range'
			x = range.val(1) + (range.val(2)-range.val(1)) * rand(N,1);
		case 'irange'
			x = randint(N,1,range.val);
		case 'set'
			x = range.val(randint(N,1,[1, length(range.val)]));
		case {'subset','object'}
			error('Sampling not defined for object/subset range');
	end
end
