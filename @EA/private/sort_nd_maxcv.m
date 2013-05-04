%% sort NSGA2
function [pop] = sort_nd_maxcv(ea, pop)

	pop = init_rank(pop);

	feasible = find_feasible(pop);
	infeasible = find_infeasible(pop);

	ranks1 = [];
	if ~isempty(feasible)
		[ranks1, nd_rank, crowd] = sort_obj(pop.f, feasible);
		pop = set_ndrank(pop, feasible, nd_rank(feasible));
		pop = set_crowd(pop, feasible, crowd(feasible));
	end

	ranks2 = [];
	if ~isempty(infeasible)
		ranks2 = sort_constr(pop.cv, infeasible);
	end

	assert(length(ranks1) + length(ranks2) == pop.size);
	pop = set_rank(pop, 1:pop.size, [ranks1; ranks2]);
end
