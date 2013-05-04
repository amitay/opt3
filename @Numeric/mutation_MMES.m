%% ES mutation
function [p, fn_evals] = mutation_MMES(num, p)
	fn_evals = 0;
	for i = 1:num.nx
		p(i) = op_POLY(num.range{i}, p(i), num.param.mutation_mmes_eta);
	end
end
