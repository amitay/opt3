%% Add parameter
function [ps] = add(ps, name, range)

	if isfield(ps.param, name)
		warning('Parameter %s defined already', name);
	else
		ps.param.(name) = range;
	end
end
