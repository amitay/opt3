%% Display population
function disp(pop)
	for i = 1:pop.size
		disp(pop.x{i});
	end
end
