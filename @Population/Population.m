%% Population class (place holder for individuals)
function [pop] = Population(object, size, prob)
% Create population of object instances

% input - problem definition and parameters
% input - or template population

	pop.object = [];

	pop.size = 0;
	pop.nf = 0;
	pop.ng = 0;

	pop.x = {};
	pop.f = [];
	pop.g = [];

	% flags
	pop.feas = [];
	pop.eval = [];

	% constraint violation value
	pop.cv = [];

	% ND sort information
	pop.nd_rank = [];
	pop.crowd = [];

	% Ranks
	pop.rank = [];

	% load parameters
	param = Paramset();
	param = add(param, 'sampling', ...
		Range('set', {'uniform', 'lhs', 'centroid', 'specified'}));
	param = add(param, 'sampling_data', Range('object', []));
	param = check(param);

	% Assign parameter values
	pop.sampling = param.sampling;
	pop.sampling_data = param.sampling_data;

	pop = class(pop, 'Population');

	if nargin > 0
		if nargin == 2
			assert(isa(object, 'Population'));
			pop = object;
			pop.size = size;
		elseif nargin == 3
			pop.object = object;
			pop.size = size;
			pop.nf = prob.nf;			% number of objectives
			pop.ng = prob.ng;			% number of constraints
		else
			error('Wrong number of arguments');
		end

		if pop.size > 0
			pop = init(pop);
		end
	end
end
