%% Initialize EA
function ea = init(ea)

	ea = open_log(ea, 0);

	% Initialize Random seed
	if ea.param.seed == 0
		ea.param = set(ea.param, 'seed', round(rand(1)*2^32));
	end
	rand('twister', ea.param.seed);

	% Starting algorithm
	write(ea.logger, sprintf('Starting %s\n', ea.algo_name));

	% Initial step
	ea.gen_id = 0;
	ea = feval(ea.algo_init_func, ea);
end
