%% ES mutation
function [p, fn_evals] = mutation_MMES(ea, p)
    fn_evals = 0;
    for i = 1:ea.prob.nx
        p(i) = op_POLY(ea.prob.range{i}, p(i), ea.param.mutation_mmes_eta);
    end
end
