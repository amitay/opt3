%% Evolve wrapper 
function [ea, childpop] = evolve(ea, pop, method)
% Evolve() - to evolve child population from parent population
%
%   All methods should create childpop from pop
%

	func = sprintf('evolve_%s', method);
	[ea, childpop] = feval(func, ea, pop);
end
