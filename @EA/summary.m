%% Collect statistics and Show summary
function summary(ea)

	write(ea.logger, 'Generation %d\n', ea.gen_id);
	mesg = '';

	summary(ea.pop, ea.logger);
	write(ea.logger, '\tFunction Evals:');
	write(ea.logger, ' %d', ea.fn_evals);
	write(ea.logger, '\n');
	if ea.param.use_cache == 1
		write(ea.logger, '\tCache Hits: %d\n', ea.cache_hits);
	end
end
