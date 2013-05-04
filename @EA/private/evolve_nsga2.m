%% NSGA-II evolution strategy
function [ea, childpop] = evolve_nsga2(ea, pop)
	N = pop.size;
	childpop = Population(pop, N);
	a1 = randperm(N);
	a2 = randperm(N);

	for i = 1:4:N
		p1 = tournament(pop, a1(i), a1(i+1));
		p2 = tournament(pop, a1(i+2), a1(i+3));
		[c1, c2] = crossover_SBX(ea.object, p1, p2);
		childpop = set_x(childpop, i, c1);
		childpop = set_x(childpop, i+1, c2);

		p1 = tournament(pop, a2(i), a2(i+1));
		p2 = tournament(pop, a2(i+2), a2(i+3));
		[c1, c2] = crossover_SBX(ea.object, p1, p2);
		childpop = set_x(childpop, i+2, c1);
		childpop = set_x(childpop, i+3, c2);
	end

	% Mutation
	for i = 1:ea.childpop.size
		x = get_x(childpop, i);
		x = mutation_POLY(ea.object, x);
		childpop = set_x(childpop, i, x);
	end
end


%% Tournament - used only after sorting
function [parent] = tournament(pop, id1, id2)
	rank = get_rank(pop, [id1 id2]);
	
	if rank(1) < rank(2)
		id = id1;
	elseif rank(2) < rank(1)
		id = id2;
	elseif rand(1) <= 0.5
		id = id1;
	else
		id = id2;
	end
		
	parent = get_x(pop, id);
end