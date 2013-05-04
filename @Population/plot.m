%% Plot f-space
function plot(pop, gen, figure_id)
% PLOT(pop) plots pareto front or pareto surface

	if pop.nf == 1, return; end

	switch pop.nf
		case 2
			figure(figure_id);
			id1 = find(pop.feas == 0);
			id2 = find(pop.feas == 1);
			plot(pop.f(id1,1), pop.f(id1,2), 'r*', ...
					pop.f(id2,1), pop.f(id2,2), 'b*');
			title(sprintf('Generation %d', gen));
		case 3
			figure(figure_id);
			id1 = find(pop.feas == 0);
			id2 = find(pop.feas == 1);
			plot3(pop.f(id1,1), pop.f(id1,2), pop.f(id1,3), 'r*', ...
					pop.f(id2,1), pop.f(id2,2), pop.f(id2,3), 'b*');
			title(sprintf('Generation %d', gen));
	end
	drawnow;
end
