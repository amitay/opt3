%% Evaluate population
function [ea, pop] = eval_pop_surr(ea, pop, surr, varargin)

	if nargin == 4
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
		if get_evalflag(pop,i) == 0
			x = convert_x(ea.object, get_x(pop,i));
			[y, valid] = predict(surr, x);
			if valid == 1
				f = y(1:pop.nf);
				g = y(pop.nf+1:end);
				pop = assign_fitness(pop, i, f, g);
				pop = set_evalflag(pop, i, 2);
			else
				[ea, x, f, g] = eval_cache(ea, get_x(pop,i), 1, state);
				pop = set_x(pop, i, x);
				pop = assign_fitness(pop, i, f, g);
				pop = set_evalflag(pop, i, 1);
				fn_evals = fn_evals + 1;
			end
		end
	end
	
	ea = add_fnevals(ea, fn_evals);
end
