%% SBX crossover
function [c1, c2, fn_evals] = crossover_SBX(ea, p1, p2)
    c1 = p1;
    c2 = p2;
    fn_evals = 0;
    if rand(1) <= ea.param.crossover_prob
        r = rand(ea.prob.nx, 1);
        for i = 1:ea.prob.nx
            if r(i) <= 0.5
                [c1(i), c2(i)] = op_SBX(ea.prob.range{i}, ...
                            p1(i), p2(i), ...
                            ea.param.crossover_sbx_eta);
            end
        end
    end
end
