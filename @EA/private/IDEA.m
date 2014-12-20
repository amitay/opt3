%% Infeasibility Driven Evolutionary Algorithm 
function algo_info = IDEA(ea)
	% Algo details
	algo_info.name = 'IDEA';
	algo_info.param_func = @idea_param;
	algo_info.init_func = @idea_init;
	algo_info.next_func = @idea_next;
	algo_info.post_func = [];
end

%% IDEA Parameters
function [param] = idea_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'infeasible_ratio', Range('range', [0,1]));
	param = add(param, 'infeasible_strategy', Range('range', [1,2]));
	param = check(param);

	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% IDEA - initialization
function [ea] = idea_init(ea, varargin)
	ea.pop = Population(ea.prob, 0);
	ea.childpop = Population(ea.prob, ea.param.pop_size);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% IDEA - generation step
function [ea] = idea_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'idea');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
end
