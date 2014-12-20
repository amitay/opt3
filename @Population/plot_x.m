%% Plot x-space
function plot_x(pop, gen, figure_id)

    xmin = zeros(1, pop.nx);
    xmax = zeros(1, pop.nx);
    for i = 1:pop.nx
        xmin(i) = min(pop.range{i});
        xmax(i) = max(pop.range{i});
    end

	figure(figure_id);
    if pop.nf == 1
        switch pop.nx
            case 1
                frange = minmax(pop.f');
                id1 = find(pop.feas == 0);
                id2 = find(pop.feas == 1);
                plot(pop.x(id1,1), pop.f(id1,1), 'r*', pop.x(id2,1), pop.f(id2,1), 'b*');
                axis([xmin xmax frange(1) frange(2)]);
                title(sprintf('Generation %d', gen));
            case 2
                id1 = find(pop.feas == 0);
                id2 = find(pop.feas == 1);
                plot(pop.x(id1,1), pop.x(id1,2), 'r*', pop.x(id2,1), pop.x(id2,2), 'b*');
                axis([xmin(1) xmax(1) xmin(2) xmax(2)]);
                title(sprintf('Generation %d', gen));
            case 3
                id1 = find(pop.feas == 0);
                id2 = find(pop.feas == 1);
                plot3(pop.x(id1,1), pop.x(id1,2), pop.x(id1,3), 'r*', ...
                        pop.x(id2,1), pop.x(id2,2), pop.x(id2,3), 'b*');
                axis([xmin(1) xmax(1) xmin(2) xmax(2) xmin(3) xmax(3)]);
                title(sprintf('Generation %d', gen));
            otherwise
                boxplot(pop.x);
        end
    else
        boxplot(pop.xx);
    end
	drawnow;
end
