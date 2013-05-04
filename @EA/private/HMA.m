%% Hybrid Memetic Algorithm
%   + NSGA2/DE evolution strategies
%   + IDEA constraint handling
%   + gradient based local search
function algo_info = HMA(ea)
	% Algo details
	algo_info.name = 'HMA';
	algo_info.param_func = @hma_param;
	algo_info.init_func = @hma_init;
	algo_info.next_func = @hma_next;
	algo_info.post_func = [];
	
	assert(ea.prob.nf == 1, 'HMA only for single objective problems');
end


%% HMA - parameters
function [param] = hma_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'crossover_de_rate', Range('range', [0,1]));
	param = add(param, 'mutation_de_scale', Range('range', [0,1]));
	param = add(param, 'infeasible_ratio', Range('range', [0,1]));
	param = add(param, 'infeasible_strategy', Range('range', [1,2]));
	param = add(param, 'ls_display', Range('set', {'off', 'iter', 'final'}));
	param = check(param);
	
	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% HMA - initialization
function [ea] = hma_init(ea, varargin)
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
	
	ea.algo_data.f_best1 = [];
	ea.algo_data.f_best2 = [];
	ea.algo_data.change = 0;
	ea.algo_data.change_all = [];
end


%% HMA - generation step
function [ea] = hma_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'idea');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	
	% Best after evaluation
	id = find_best(ea.pop);
	ea.algo_data.f_best1 = get_f(ea.pop, id);
	
	if ea.gen_id > 1
		[ea, ea.pop] = do_localsearch(ea, ea.pop);
		ea.pop = sort(ea, ea.pop, 'idea');
		ea.pop = reduce(ea.pop, ea.param.pop_size);
	end
	
	% Best after local search
	id = find_best(ea.pop);
	ea.algo_data.f_best2 = get_f(ea.pop, id);
	ea.algo_data.change_all = [ea.algo_data.change_all ea.algo_data.change];

	if length(ea.algo_data.change_all) > 10 && ...
			sum(ea.algo_data.change_all(end-9:end)) == 0
		write(ea.logger, 'Reinitializing pop\n');
		ea.childpop = sample(ea.childpop);
		ea.childpop = set_x(ea.childpop, 1, get_x(ea.pop, id));
		ea.algo_data.change_all = [];
	else
		if rand(1) < 0.5
			[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
		else
			[ea, ea.childpop] = evolve(ea, ea.pop, 'de');
		end		
	end
end

%%
function [ea, pop] = do_localsearch(ea, pop)
 
	% selection of solution for local search
	if rand(1) < 0.2 
		id = randint(1, 1, [1 pop.size]);
	else     
		if ea.algo_data.f_best1 < ea.algo_data.f_best2 ...
				|| ea.algo_data.change == 1
			id = find_best(pop);
		else
			id = randint(1, 1, [1 pop.size]);
		end
	end
	x1 = convert_x(ea.object, get_x(pop,id));

	% local search
	[ea, x2, f, g] = localsearch(ea, x1, @obj_func, @constr_func, ...
								max(1000, 50*ea.prob.nx), 10000);
				
	% replace last solution
	pop = set_x(pop, pop.size, convert_obj(ea.object, x2));
	pop = assign_fitness(pop, pop.size, f, -g);
        
	if f < ea.algo_data.f_best1
		ea.algo_data.change = 1;
	else 
		ea.algo_data.change = 0;
	end
end


% objective function
function [obj] = obj_func(f, g)
	obj = f;
end

% constraint function
function [c, ceq] = constr_func(f, g)
	c = -g;
	ceq = [];
end
