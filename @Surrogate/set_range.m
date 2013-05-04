function [surr] = set_range(surr, range)
% SET_RANGE() sets the range of decision variables
%

	nx = length(range);
	for i = 1:nx
		assert(isa(range{i}, 'Range'));
		assert(verify_numeric(range{i}) == 1, ...
			'Variable %d range is not numeric', i);
	end
	
	surr.range = range;
	surr.nx = nx;
end
