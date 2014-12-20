%% Evaluate population
function [ea, pop] = eval_pop(ea, pop, varargin)

	if nargin == 3
		id = varargin{1};
		assert(isnumeric(id), 'IDs should be numeric');
	else
		id = 1:pop.size;
	end

	fn_evals = 0;

	if strcmp(ea.analysis.type, 'composite')
		f_mask = [];
		g_mask = [];
	else
		f_mask = zeros(1, ea.prob.nf);
		g_mask = zeros(1, ea.prob.ng);
	end

	state = [];
	state.gen_id = ea.gen_id;
	state.nx = ea.prob.nx;
	state.nf = ea.prob.nf;
	state.ng = ea.prob.ng;
	state.userdata = ea.prob.userdata;

	% Evaluate population
	for i = id
		state.pop_id = i;
		if get_evalflag(pop, i) ~= 1
			x = get_x(pop, i);
			[ea, x, f, g] = eval_cache(ea, x, state, f_mask, g_mask);
			pop = set_x(pop, i, x);
			pop = assign_fitness(pop, i, f, g);
			pop = set_evalflag(pop, i, 1);
			fn_evals = fn_evals + 1;
		end
	end

	ea = add_fnevals(ea, fn_evals);
end
