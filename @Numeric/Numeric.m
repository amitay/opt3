%% Numeric object class
function [obj] = Numeric(prob, param)
	obj.param = [];		% parameters

	obj.nx = 0;			% number of variables
	obj.nf = 0;			% number of objectives
	obj.ng = 0;			% number of constraints

	obj.range = {};	% variable range
	obj.func = [];	% analysis function

	if nargin == 2
		obj.nx = prob.nx;
		obj.nf = prob.nf;
		obj.ng = prob.ng;

		obj.range = prob.range;
		for i = 1:obj.nx
			assert(verify_numeric(obj.range{i}) == 1, ...
				'Variable %d does not have numeric range', i);
		end

		assert(isa(param, 'Paramset'));
		obj.param = param.value;
	end

	obj = class(obj, 'Numeric');
end
