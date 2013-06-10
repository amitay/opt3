%% Verify if the type is numeric
function [is_numeric] = verify_numeric(range)

	is_numeric = 0;

	switch range.type
		case {'irange', 'range', 'scalar'}
			is_numeric = 1;
	end
end
