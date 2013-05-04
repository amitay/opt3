%% Find feasible solutions IDs
function id = find_feasible(pop)
	id = find(pop.feas == 1);
end

