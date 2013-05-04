%% Initialize population
function [pop] = init(pop, varargin)
	% Initialize population with object instances
	pop.x = cell(pop.size,1);
	pop.f = zeros(pop.size, pop.nf);	% Objectives
	pop.g = zeros(pop.size, pop.ng);	% Constraints
	pop.feas = zeros(pop.size, 1);		% Solution feasibility
	pop.eval = zeros(pop.size, 1);		% Evaluation flag
	pop.cv = zeros(pop.size, 1);		% Constraint Violation
	pop.nd_rank = zeros(pop.size, 1);	% ND Rank
	pop.crowd = zeros(pop.size, 1);		% Crowding distance
	pop.rank = zeros(pop.size, 1);		% Solution Rank
end
