%% Return eval flag
function [pop] = get_evalflag(pop, id, evalflag)
	pop.eval(id) = evalflag;
end

