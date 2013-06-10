%% Incremental DE evolution strategy (DE/best/1/exp)
function [ea, childpop] = evolve_de_incremental(ea, pop)
	N = pop.size;

	childpop = pop;

	% Best vector
	id = get_rank(childpop, 1);
	x1 = convert_x(ea.object, get_x(childpop, id));

	for i = 1:N
		tpop = Population(childpop, 1);

		% Random vectors
		a = randperm(N);
		x2 = convert_x(ea.object, get_x(childpop, a(1)));
		x3 = convert_x(ea.object, get_x(childpop, a(2)));

		% trial vector
		xtrial = x1 + ea.param.mutation_de_scale * (x2 - x3);
		ptrial = convert_obj(ea.object, xtrial);

		c1 = crossover_EXP(ea.object, get_x(childpop,i), ptrial);
		tpop = set_x(tpop, 1, c1);

		[ea, tpop] = eval_pop(ea, tpop);

		% if solution has improved, replace it 
		if dominates(tpop, 1, childpop, i) == 1
			childpop = set_x(childpop, i, get_x(tpop, 1));
			childpop = assign_fitness(childpop, i, get_f(tpop,1), get_g(tpop,1));
		end
	end
end
