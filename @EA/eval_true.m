%% Evaluate x using single or composite analysis function
function [f, g, x] = eval_true(ea, x, state, f_mask, g_mask)

	if strcmp(ea.analysis.type, 'composite')
		[f, g, x] = feval(ea.analysis.func, x, state);
		
	elseif strcmp(ea.analysis.type, 'single')
		f = zeros(1, ea.prob.nf);
		for i = 1:ea.prob.nf
			if f_mask(i) == 0
				f(i) = feval(ea.analysis.obj{i}, x, state);
			end
		end
		
		g = zeros(1, ea.prob.ng);
		for i = 1:ea.prob.ng
			if g_mask(i) == 0
				g(i) = feval(ea.analysis.constr{i}, x, state);
			end
		end
		
	else
		error('Invalid analysis type');
	end
end
