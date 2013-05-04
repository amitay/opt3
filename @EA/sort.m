%% Sort wrapper 
function [pop] = sort(ea, pop, method)
% Sort() - to assign ranks to the population
%
%   All methods should sort pop and assign following fields
%	- pop.rank
%	- pop.nd_rank
%	- pop.crowd
%

	func = sprintf('sort_%s', method);
	pop = feval(func, ea, pop);
end
