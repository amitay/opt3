%% Save Cache
function save_cache(ea)
	if ea.param.use_cache == 1
		filename = sprintf('%s-%s-cache.mat', ea.prob_name, ea.algo_name);
		cache = ea.cache;
		save(filename, 'cache');
	end
end
