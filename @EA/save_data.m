%% Save population data
function [ea] = save_data(ea)

	% save all population
	save(ea.pop, ea.gen_id, ea.ofd_all);
	
	% save best 
	gen = ea.gen_id;
	fprintf(ea.ofd_best, '%4d %5d %2d ', gen, ea.best.fn_evals(gen), ea.best.feas(gen));
	fprintf(ea.ofd_best, ' %g', ea.best.f(gen,:));
	if ea.prob.ng > 0
		fprintf(ea.ofd_best, ' %g', ea.best.g(gen,:));
	end
	fprintf(ea.ofd_best, ' %s', str(ea.object, ea.best.x{gen}));
	fprintf(ea.ofd_best, '\n');
end
