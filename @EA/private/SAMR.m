%% Surrogate Assisted Memetic Recombination
%   uses NSGA-II + spatially distributed surrogates + sub EA
function algo_info = SAMR(ea)
	% Algo details
	algo_info.name = 'SAMR';
	algo_info.param_func = @samr_param;
	algo_info.init_func = @samr_init;
	algo_info.next_func = @samr_next;
	algo_info.post_func = [];
	
	assert(strcmp(ea.prob.class, 'Numeric'), ...
			'SAMR is only for Numeric representation');
end


%% SAMR - parameters
function [param] = samr_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'train_period', Range('irange', [1,100]));
	param = add(param, 'subea_pop_size', Range('irange', [1,inf]));
	param = add(param, 'subea_generations', Range('irange', [1,100]));
	param = check(param);
	
	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
	assert(mod(param.subea_pop_size,4) == 0, ...
		'SubEA Population size must be multiple of 4');
	assert(param.subea_pop_size > param.pop_size, ...
		'SubEA population size must be larger than population size');
end


%% SAMR - initialization
function [ea] = samr_init(ea, varargin)
	surr = Surrogate(ea.param_value);
	surr = set_range(surr, ea.prob.range);
	surr = set_mask(surr, ea.prob.eval_mask);
	ea.algo_data.surr = surr;
	
	ea.algo_data.use_pop = 0;
	
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% SAMR - generation step
function [ea] = samr_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.algo_data.surr = add_pop(ea.algo_data.surr, ea.childpop);
	
	if ea.gen_id >= ea.param.train_period
		ea.algo_data.surr = train(ea.algo_data.surr);
	end
	
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'nd_maxcv');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	
	if ea.gen_id < ea.param.train_period
		[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
	else
		[ea, ea.childpop] = evolve(ea, ea.pop, 'subea_surr');
	end
end
