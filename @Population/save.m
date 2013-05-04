%% Save population to file
function save(pop, gen, fid)
% SAVE(pop,gen,fd) saves population in the file

	for i = 1:pop.size
		fprintf(fid, '%4d %3d %2d', gen, i, pop.feas(i));
		fprintf(fid, ' %12.8e', pop.f(i,:));
		fprintf(fid, ' %12.8e', pop.g(i,:));
		fprintf(fid, ' %s', str(pop.object, pop.x{i}));
		fprintf(fid, '\n');
	end
end
