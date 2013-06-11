%% K-peaks GA
function algo_info = KPGA(ea)
	% Algo details
	algo_info.name = 'KPGA';
	algo_info.param_func = @kpga_param;
	algo_info.init_func = @kpga_init;
	algo_info.next_func = @kpga_next;
	algo_info.post_func = [];

	assert(strcmp(ea.prob.class, 'Numeric'), ...
		'KPGA is only for Numeric representation');
	assert(ea.prob.nf == 1, 'KPGA is only for single objective problems');
end


%% KPGA - parameters
function [param] = kpga_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'peaks', Range('irange', [1, inf]));
	param = check(param);

	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
	assert(param.peaks < param.pop_size, ...
		'Number of peaks must be less than population size');
end


%% KPGA - initialization
function [ea] = kpga_init(ea, varargin)
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% KPGA - generation step
function [ea] = kpga_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'kpeaks');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
end
