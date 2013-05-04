%% Combine two populations
function [newpop] = plus(pop, childpop)
% Combine parent and offspring population

	newpop = Population(childpop, pop.size+childpop.size);

	newpop.x = [pop.x ; childpop.x];
	newpop.f = [pop.f ; childpop.f];
	newpop.g = [pop.g ; childpop.g];
	newpop.feas = [pop.feas ; childpop.feas];
	newpop.eval = [pop.eval ; childpop.eval];

	newpop.cv = [pop.cv ; childpop.cv];
	
	% ND information and ranks of merged population should not be used
	newpop.nd_rank = [pop.nd_rank ; childpop.nd_rank];
	newpop.crowd = [pop.crowd ; childpop.crowd];
	newpop.rank = [pop.rank ; childpop.rank];
end
