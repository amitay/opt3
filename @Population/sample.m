%% Initialize population
function [pop] = sample(pop)
	% Initialize population with object instances
	pop.x = sample(pop.object, pop.size, pop.sampling, pop.sampling_data);
end
