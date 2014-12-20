%% Population class (place holder for individuals)
function [pop] = Population(prob, pop_size)
% Create population of object instances

% input - problem definition and parameters
% input - or template population

	pop.nx = 0;
	pop.nf = 0;
	pop.ng = 0;
	pop.range = {};

	pop.size = 0;
	pop.x = [];
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

	if (isa(prob, 'Population'))
		pop = prob;
		pop.size = pop_size;
	else
		pop.nx = prob.nx;		% number of variables
		pop.nf = prob.nf;		% number of objectives
		pop.ng = prob.ng;		% number of constraints
		pop.range = prob.range;
		pop.size = pop_size;
	end

	if pop.size > 0
		pop = init(pop);
	end
end
