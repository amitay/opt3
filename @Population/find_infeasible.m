%% Find infeasible solutions IDs
function id = find_infeasible(pop)
	id = find(pop.feas == 0);
end

