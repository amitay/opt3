%% Differential Evolution
function algo_info = DE(ea)
	% Algo details
	algo_info.name = 'DE';
	algo_info.param_func = @de_param;
	algo_info.init_func = @de_init;
	algo_info.next_func = @de_next;
	algo_info.post_func = [];
	
	assert(strcmp(ea.prob.class, 'Numeric'), ...
		'DE is only for Numeric representation');
	assert(ea.prob.nf == 1, 'DE is only for single objective problems');
end


%% DE Parameters
function [param] = de_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_de_rate', Range('range', [0,1]));
	param = add(param, 'mutation_de_scale', Range('range', [0,1]));
	param = check(param);
	
	assert(mod(param.pop_size,2) == 0, ...
			'Population size must be multiple of 2');
end

%% DE initialization
function [ea] = de_init(ea, varargin)
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% DE - generational step
function [ea] = de_next(ea)
	if ea.gen_id == 1
		[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	else
		[ea, ea.childpop] = evolve(ea, ea.pop, 'de_incremental');	
	end
	ea.pop = ea.childpop;
	ea.pop = sort(ea, ea.pop, 'nd_maxcv');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
end
