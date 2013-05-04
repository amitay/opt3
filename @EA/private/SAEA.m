%% Surrogate Assisted Evolutionary Algorithm
%   uses NSGA-II + spatially distributed surrogates
function algo_info = SAEA(ea)
	% Algo details
	algo_info.name = 'SAEA';
	algo_info.param_func = @saea_param;
	algo_info.init_func = @saea_init;
	algo_info.next_func = @saea_next;
	algo_info.post_func = [];
	
	assert(strcmp(ea.prob.class, 'Numeric'), ...
			'SAEA is only for Numeric representation');
end


%% SAEA - parameters
function [param] = saea_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'train_period', Range('irange', [1,100]));
	param = add(param, 'retain_count', Range('irange', [1,100]));
	param = check(param);
	
	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% SAEA - initialization
function [ea] = saea_init(ea, varargin)
	surr = Surrogate(ea.param_value);
	surr = set_range(surr, ea.prob.range);
	surr = set_mask(surr, ea.prob.eval_mask);
	ea.algo_data.surr = surr;
	
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
end


%% SAEA - generation step
function [ea] = saea_next(ea)
	if rem(ea.gen_id, ea.param.train_period) == 0
		retrain_flag = 1;
	else
		retrain_flag = 0;
	end
	
	% Periodically re-evaluate parent population
	if retrain_flag == 1 && ea.gen_id > ea.param.train_period
		[ea, ea.pop] = eval_pop(ea, ea.pop);
		ea.algo_data.surr = add_pop(ea.algo_data.surr, ea.pop);
	end
	
	if ea.gen_id <= ea.param.train_period
		[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	else
		[ea, ea.childpop] = eval_pop_surr(ea, ea.childpop, ea.algo_data.surr);
		if ea.param.retain_count > 0
			ea.childpop = sort(ea, ea.childpop, 'nd_maxcv');
			ea = eval_extra(ea);								
		end
	end
	ea.algo_data.surr = add_pop(ea.algo_data.surr, ea.childpop);
	
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'nd_maxcv');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
	
	if retrain_flag == 1
		ea.algo_data.surr = train(ea.algo_data.surr);
	end
end


%% Extra evaluation
function [ea] = eval_extra(ea)
	fn_evals = 0;
	
	state = [];
	state.gen_id = ea.gen_id;
	state.userdata = ea.prob.userdata;
	
	for i = 1:ea.param.retain_count
		state.pop_id = ea.pop.size + i;
		id = get_rank(ea.childpop, i);
		if dominates(ea.childpop, id, ea.pop, 1) >= 0 && get_evalflag(ea.childpop, i) ~= 1
			[ea, x, f, g] = eval_cache(ea, get_x(ea.childpop,i), 1, state);
			ea.childpop = set_x(ea.childpop, i, x);
			ea.childpop = assign_fitness(ea.childpop, i, f, g);
			ea.childpop = set_evalflag(ea.childpop, i, 1);
			fn_evals = fn_evals + 1;
		end
	end
	
	ea = add_fnevals(ea, fn_evals);
end
