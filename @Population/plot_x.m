%% Plot x-space
function plot_x(pop, gen, figure_id)

	xx = convert_x(pop.object, pop.x{1});
	m = length(xx);

	xx = zeros(pop.size, m);
	for i = 1:pop.size
		xx(i,:) = convert_x(pop.object, pop.x{i});
	end

	figure(figure_id);
	switch m
		case 1
			[xmin, xmax] = convert_range(pop.object);
			frange = minmax(pop.f');
			id1 = find(pop.feas == 0);
			id2 = find(pop.feas == 1);
			plot(xx(id1,1), pop.f(id1,1), 'r*', xx(id2,1), pop.f(id2,1), 'b*');
			axis([xmin xmax frange(1) frange(2)]);
			title(sprintf('Generation %d', gen));
		case 2
			[xmin, xmax] = convert_range(pop.object);
			id1 = find(pop.feas == 0);
			id2 = find(pop.feas == 1);
			plot(xx(id1,1), xx(id1,2), 'r*', xx(id2,1), xx(id2,2), 'b*');
			axis([xmin(1) xmax(1) xmin(2) xmax(2)]);
			title(sprintf('Generation %d', gen));
		case 3
			[xmin, xmax] = convert_range(pop.object);
			id1 = find(pop.feas == 0);
			id2 = find(pop.feas == 1);
			plot3(xx(id1,1), xx(id1,2), xx(id1,3), 'r*', ...
					xx(id2,1), xx(id2,2), xx(id2,3), 'b*');
			axis([xmin(1) xmax(1) xmin(2) xmax(2) xmin(3) xmax(3)]);
			title(sprintf('Generation %d', gen));
		otherwise
			boxplot(xx);
	end
	drawnow;
end
