%% SUB-EA evolution strategy using Surrogate based evaluation
function [ea, childpop] = evolve_subea_surr(ea, pop)

	assert(isfield(ea.algo_data, 'surr') && isa(ea.algo_data.surr, 'Surrogate'), ...
			'SUBEA_SURR evolution strategy requires surrogates');

	% Use NSGA2 evolution as the base
	[ea, childpop] = evolve_nsga2(ea, pop);

	% surrogate based recombination only if surrogates are valid
	if is_valid(ea.algo_data.surr)
		pop2 = Population(pop, ea.param.subea_pop_size);

		pop2 = sample(pop2);
		if ea.algo_data.use_pop == 1
			for i = 1:pop.size
				pop2 = set_x(pop2, i, get_x(pop, i));
			end
		end
		ea.algo_data.use_pop = ~ea.algo_data.use_pop;

		[ea, pop2] = eval_pop_surr(ea, pop2, ea.algo_data.surr);
		pop2 = sort_nd_maxcv(ea, pop2);

		for j = 2:ea.param.subea_generations
			[ea, childpop2] = evolve_nsga2(ea, pop2);
			[ea, childpop2] = eval_pop_surr(ea, childpop2, ea.algo_data.surr);
			pop2 = pop2 + childpop2;
			pop2 = sort_nd_maxcv(ea, pop2);
			pop2 = reduce(pop2, ea.param.subea_pop_size);
		end

		for i = 1:childpop.size
			childpop = set_x(childpop, i, get_x(pop2, i));
		end
	end
end
