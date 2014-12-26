%% NSGA-II evolution strategy
function [ea, childpop] = evolve_nsga2(ea, pop)
    N = pop.size;
    childpop = Population(pop, N);
    a1 = randperm(N);
    a2 = randperm(N);
    a = reshape([a1, a2], 2, N)';

    w = tournament(pop, a(:,1), a(:,2));
    p1 = get_x(pop, w(1:2:end));
    p2 = get_x(pop, w(2:2:end));

    [c1, c2] = crossover_SBX(ea, p1, p2);
    childpop = set_x(childpop, (1:N/2)', c1);
    childpop = set_x(childpop, (N/2+1:N)', c2);

    x = get_x(childpop, (1:N)');
    x = mutation_POLY(ea, x);
    childpop = set_x(childpop, (1:N)', x);
end
