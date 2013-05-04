%% Display population summary
function id = find_best(pop)

	% Find the best solution
	id = find(pop.eval == 1 & pop.feas == 1, 1);
	if isempty(id)
		id = find(pop.nd_rank == 1, 1);
		if isempty(id)
			id = pop.rank(1);
		end
	end
end
