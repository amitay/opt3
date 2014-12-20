%% NSGA-II evolution strategy
function [ea, childpop] = evolve_nsga2(ea, pop)
    N = pop.size;
    childpop = Population(pop, N);
    a1 = randperm(N);
    a2 = randperm(N);

    for i = 1:4:N
        i1 = tournament(pop, a1(i), a1(i+1));
        i2 = tournament(pop, a1(i+2), a1(i+3));
        p1 = get_x(pop, i1);
        p2 = get_x(pop, i2);
        [c1, c2] = crossover_SBX(ea, p1, p2);
        childpop = set_x(childpop, i, c1);
        childpop = set_x(childpop, i+1, c2);

        i1 = tournament(pop, a2(i), a2(i+1));
        i2 = tournament(pop, a2(i+2), a2(i+3));
        p1 = get_x(pop, i1);
        p2 = get_x(pop, i2);
        [c1, c2] = crossover_SBX(ea, p1, p2);
        childpop = set_x(childpop, i+2, c1);
        childpop = set_x(childpop, i+3, c2);
    end

    % Mutation
    for i = 1:ea.childpop.size
        x = get_x(childpop, i);
        x = mutation_POLY(ea, x);
        childpop = set_x(childpop, i, x);
    end
end
