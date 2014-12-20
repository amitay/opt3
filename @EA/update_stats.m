%% Update statistics
function [ea] = update_stats(ea)

	id = find_best(ea.pop);

	ea.best.x(ea.gen_id,:) = get_x(ea.pop, id);
	ea.best.f(ea.gen_id,:) = get_f(ea.pop, id);
	if ea.pop.ng > 0
		ea.best.g(ea.gen_id,:) = get_g(ea.pop, id);
	end
	ea.best.feas(ea.gen_id) = get_feasflag(ea.pop, id);
	ea.best.fn_evals(ea.gen_id, :) = ea.fn_evals;
end
