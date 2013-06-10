%% Load parameters from params.m
function [ps] = load(ps)

	if isempty(ps.ivalue)
		param = [];
		try
			t = fileread('params.m');
			eval(t);
		end
		ps.ivalue = param;
	end
end
