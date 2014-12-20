%% Pareto Corner Search Evolutionary Algorithm
function algo_info = PCSEA(ea)
	% Algo details
	algo_info.name = 'PCSEA';
	algo_info.param_func = @pcsea_param;
	algo_info.init_func = @pcsea_init;
	algo_info.next_func = @pcsea_next;
	algo_info.post_func = [];
end


%% PCSEA - parameters
function [param] = pcsea_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = check(param);

	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% PCSEA - initialization
function [ea] = pcsea_init(ea, varargin)
	ea.pop = Population(ea.prob, 0);
	ea.childpop = Population(ea.prob, ea.param.pop_size);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% PCSEA - generation step
function [ea] = pcsea_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'corner');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
end
