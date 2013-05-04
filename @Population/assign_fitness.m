%% assign fitness based on f and g
function [pop] = assign_fitness(pop, id, f, g)
	pop.f(id,:) = f;
	if ~isempty(g)
		pop.g(id,:) = g;
		pop.cv(id) = sum(g(g < 0));
		pop.feas(id) = ~(pop.cv(id) < 0);
	else
		pop.cv(id) = 0;
		pop.feas(id) = 1;
	end
end
