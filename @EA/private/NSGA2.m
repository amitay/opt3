%% Non-dominated Sorting Genetic Algorithm - II
function algo_info = NSGA2(ea)
	% Algo details
	algo_info.name = 'NSGA-II';
	algo_info.param_func = @nsga2_param;
	algo_info.init_func = @nsga2_init;
	algo_info.next_func = @nsga2_next;
	algo_info.post_func = [];

	assert(strcmp(ea.prob.class, 'Numeric'), ...
		'NSGA-II is only for Numeric representation');
end


%% NSGA2 - parameters
function [param] = nsga2_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = check(param);

	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% NSGA2 - initialization
function [ea] = nsga2_init(ea, varargin)
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% NSGA2 - generation step
function [ea] = nsga2_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'nd_maxcv');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
end
