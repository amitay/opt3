%% Initialize population
function [pop] = sample(pop, varargin)
	% Initialize population with object instances
	pop.x = sample(pop.object, pop.size, varargin{:});
end
