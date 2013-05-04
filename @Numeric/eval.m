%% Eval wrapper to call actual func
function [x, f, g] = eval(nr, x, anl, state)
	[f, g, xnew] = feval(anl, x.x, state);
	x.x = xnew;
end

