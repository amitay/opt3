%% Display/Plot summary information
function plot(ea)
	if ea.prob.nf == 1
		% progress plot
		show_progress(ea, 1);
	else
		% pareto plot
		plot(ea.pop, ea.gen_id, 1);
	end

	% x distribution
	plot_x(ea.pop, ea.gen_id, 2);

	% object specific plot
	plot(ea.object, ea.best.x{end}, 3);

	% user defined plot function
	if ~isempty(ea.prob.plot_func)
		state = [];
		state.gen_id = ea.gen_id;
		state.nx = ea.prob.nx;
		state.nf = ea.prob.nf;
		state.ng = ea.prob.ng;
		state.userdata = ea.prob.userdata;
		x = convert_x(ea.object, ea.best.x{end});
		feval(ea.prob.plot_func, x, state, 4);
	end
	drawnow;
end


%% Show progress plot
function show_progress(ea, fig_id)
	figure(fig_id);
	id1 = find(ea.best.feas == 0);
	id2 = find(ea.best.feas == 1);
	plot(id1, ea.best.f(id1), 'r*', id2, ea.best.f(id2), 'b*-');
	xlabel('Generations');
	ylabel('Objective');
end
