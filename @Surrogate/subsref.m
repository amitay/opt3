%% Element subreferencing
function [value] = subsref(ps, s)
	switch s.type
		case '.'
			try
				value = ps.(s.subs);
			catch
				error('Paramset: No such parameter (%s)', s.subs);
			end
		otherwise
			error('Paramset: This type of subreferencing not allowed.');
	end
end
