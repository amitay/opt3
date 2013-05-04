%% Update function evalation count
function [ea] = add_fnevals(ea, fneval_count)
	ea.fn_evals = ea.fn_evals + fneval_count;
end

