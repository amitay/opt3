%% Infeasibility Enabled Memetic Algorithm
function algo_info = IEMA(ea)
	% Algo details
	algo_info.name = 'IEMA';
	algo_info.param_func = @iema_param;
	algo_info.init_func = @iema_init;
	algo_info.next_func = @iema_next;
	algo_info.post_func = [];
	
	assert(ea.prob.nf == 1, 'IEMA only for single objective problems');	
end


%% IEMA - parameters
function [param] = iema_param(param)
	param = add(param, 'pop_size', Range('irange', [1,inf]));
	param = add(param, 'crossover_prob', Range('range', [0,1]));
	param = add(param, 'crossover_sbx_eta', Range('range', [1,100]));
	param = add(param, 'mutation_prob', Range('range', [0,1]));
	param = add(param, 'mutation_poly_eta', Range('range', [1,100]));
	param = add(param, 'infeasible_ratio', Range('range', [0,1]));
	param = add(param, 'infeasible_strategy', Range('range', [1,2]));
	param = add(param, 'ls_display', Range('set', {'off', 'iter', 'final'}));
	param = check(param);
	
	assert(mod(param.pop_size,4) == 0, ...
		'Population size must be multiple of 4');
end


%% IEMA - initialization
function [ea] = iema_init(ea, varargin)
	ea.pop = Population(ea.object, 0, ea.prob);
	ea.childpop = Population(ea.object, ea.param.pop_size, ea.prob);
	ea.childpop = sample(ea.childpop, varargin{:});
	
	ea.algo_data.change = 0;
	ea.algo_data.change_all = [];
end


%% IEMA - generation step
function [ea] = iema_next(ea)
	[ea, ea.childpop] = eval_pop(ea, ea.childpop);
	ea.pop = ea.pop + ea.childpop;
	ea.pop = sort(ea, ea.pop, 'idea');
	ea.pop = reduce(ea.pop, ea.param.pop_size);
	
	if ea.gen_id > 1
		[ea, ea.pop] = do_localsearch(ea, ea.pop);
		ea.pop = sort(ea, ea.pop, 'idea');
		ea.pop = reduce(ea.pop, ea.param.pop_size);
	end

	ea.algo_data.change_all = [ea.algo_data.change_all ea.algo_data.change];
	
	[ea, ea.childpop] = evolve(ea, ea.pop, 'nsga2');
end


%%
function [ea, pop] = do_localsearch(ea, pop)
 
	% select solution for local search
	if ea.algo_data.change == 0
		idx = find_feasible(pop);
		if ~isempty(idx)
			id = randint(1,1,[1 idx(end)]);
		else
			id = randint(1, 1, [1 ea.param.infeasible_ratio*pop.size]);
		end
	else
		id = find_best(pop);
	end
    x1 = convert_x(ea.object, get_x(pop,id));

	% perform local search
	[ea, x2, f, g] = localsearch(ea, x1, @obj_func, @constr_func, ...
									max(1000, 50*ea.prob.nx), 1000);

	% replace last solution with new solution
	pop = set_x(pop, pop.size, convert_obj(ea.object, x2));
	pop = assign_fitness(pop, pop.size, f, g);

	if ~isequal(x1, x2)
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
