%% Exponential crossover
function [c1, fn_evals] = crossover_EXP(ea, p1, p2)
    n = randint(1, 1, [1 ea.prob.nx]);

    L = 0;
    while L < ea.prob.nx
        L = L+1;
        if rand(1) > ea.param.crossover_de_rate
            break
        end
    end

    id1 = mod(n, ea.prob.nx);
    id2 = mod(n+L-1, ea.prob.nx);
    ind1 = min(id1,id2);
    ind2 = max(id1,id2);

    c1 = p1;
    for i = ind1:ind2
        if i ~= 0
            c1(i) = p2(i);
        end
    end

    for i = 1:ea.prob.nx
        c1(i) = min(max(c1(i), min(ea.prob.range{i})), max(ea.prob.range{i}));
    end
    fn_evals = 0;
end
