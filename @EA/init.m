%% Initialize EA
function ea = init(ea)

	ea = open_log(ea, 0);

	% Initialize Random seed
	if ea.param.seed == 0
		ea.param = set(ea.param, 'seed', round(rand(1)*2^32));
	end
	s = RandStream('mt19937ar', 'Seed', ea.param.seed);
	RandStream.setGlobalStream(s);

	% Starting algorithm
	write(ea.logger, sprintf('Starting %s\n', ea.algo_name));

	% Initial step
	ea.gen_id = 0;
	ea = feval(ea.algo_init_func, ea);
end
