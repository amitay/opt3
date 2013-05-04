%% Initialize Cache
function ea = init_cache(ea)
	if ea.param.use_cache == 1
		filename = sprintf('%s-%s-cache.mat', ea.prob_name, ea.algo_name);
		try
			tmp = load(filename);
			ea.cache = tmp.cache;
		catch
			ea.cache = hashtable(100);
		end
	else
		ea.cache = [];
	end
	ea.cache_hits = 0;
end
