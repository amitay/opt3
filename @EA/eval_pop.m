%% Evaluate population
function [ea, pop] = eval_pop(ea, pop, varargin)

	if nargin == 3
		id = varargin{1};
		assert(isnumeric(id), 'IDs should be numeric');
	else
		id = 1:pop.size;
	end
	
	% Evaluate population
	fn_evals = 0;

	state = [];
	state.gen_id = ea.gen_id;
	state.userdata = ea.prob.userdata;

	for i = id 
		state.pop_id = i;
		if get_evalflag(pop, i) ~= 1
			x = get_x(pop, i);
			[ea, x, f, g] = eval_cache(ea, x, 1, state);
			pop = set_x(pop, i, x);
			pop = assign_fitness(pop, i, f, g);
			pop = set_evalflag(pop, i, 1);
			fn_evals = fn_evals + 1;
		end
	end
	
	ea = add_fnevals(ea, fn_evals);
end
