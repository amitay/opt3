function [ps] = set(ps, key, value)
	if isfield(ps.param, key)
		ps.value.(key) = value;
	else
		error('No such parameter (%s)\n', key);
	end
end
