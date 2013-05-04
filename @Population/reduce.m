%% Extract N 'elite' individuals 
function [newpop] = reduce(pop, N)
% Retain 'elite' individuals from combined population

	newpop = Population(pop, N);

	newpop.x = pop.x(pop.rank(1:N), :);
	newpop.f = pop.f(pop.rank(1:N), :);
	newpop.g = pop.g(pop.rank(1:N), :);
	newpop.feas = pop.feas(pop.rank(1:N));
	newpop.eval = pop.eval(pop.rank(1:N));

	newpop.cv = pop.cv(pop.rank(1:N));
	newpop.nd_rank = pop.nd_rank(pop.rank(1:N));
	newpop.crowd = pop.crowd(pop.rank(1:N));
	newpop.rank = (1:N)';
end
