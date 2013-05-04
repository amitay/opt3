%% Initialize ranks
function [pop] = init_rank(pop)
	% Initialize ranks
	pop.nd_rank = zeros(pop.size, 1);	% ND Rank
	pop.crowd = zeros(pop.size, 1);		% Crowding distance
	pop.rank = zeros(pop.size, 1);		% Solution Rank
end
