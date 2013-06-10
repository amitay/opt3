%% sort kpeaks
function [pop] = sort_kpeaks(ea, pop)

	pop = init_rank(pop);

	feasible = find_feasible(pop);
	infeasible = find_infeasible(pop);

	ranks1 = [];
	if ~isempty(feasible)
		cdata = cluster(pop, feasible, ea.param.peaks, ea.param.seed);
		[ranks1] = sort_cluster(pop.f, cdata);
	end

	ranks2 = [];
	if ~isempty(infeasible)
		ranks2 = sort_constr(pop.cv, infeasible);
	end

	assert(length(ranks1) + length(ranks2) == pop.size);
	pop = set_rank(pop, 1:pop.size, [ranks1; ranks2]);
end
