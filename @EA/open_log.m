%% Save population
function ea = open_log(ea, append_flag)

	assert(isnumeric(append_flag) && append_flag <= 1, ...
				'Append Flag should be either 0 or 1');

	modes = {'w', 'a+'};
	mode = modes{append_flag+1};

	prefix = sprintf('%s-%s', ea.prob_name, ea.algo_name);

	% Initialize Logger
	ea.logger = Logger(prefix, append_flag);

	% Open data dump files
	filename = sprintf('%s-all.dat', prefix);
	ea.ofd_all = fopen(filename, mode);

	filename = sprintf('%s-best.dat', prefix);
	ea.ofd_best = fopen(filename, mode);
end
