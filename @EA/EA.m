%% Evolutionary Algorithm framework
function [ea] = EA(problem, algo, varargin)
%EA(problem, algo) - Create EA instance for a given problem
%
%

	% Problem related info
	ea.prob_name = '';				% problem string
	ea.prob = [];					% Problem data structure
	ea.analysis = [];				% Analysis informaton

	% Algorithm related info
	ea.algo_name = '';
	ea.algo_param_func = [];
	ea.algo_init_func = [];
	ea.algo_next_func = [];
	ea.algo_post_func = [];

	% User defined parameters
	ea.param_value = [];
	ea.param = [];

	% Algorithm state related info
	ea.gen_id = 0;

	% Algorithm manipulated info
	ea.algo_data = [];
	ea.pop = [];
	ea.childpop = [];
	ea.fn_evals = [];

	% Representation related info
	ea.object = [];

	% Evaluation cache
	ea.cache = [];
	ea.cache_hits = 0;

	% Progress related info
	ea.best = [];

	% Logger and Data dump
	ea.logger = [];
	ea.ofd_all = [];
	ea.ofd_best = [];

	ea = class(ea, 'EA');

	if nargin >= 2

		% Set problem information
		if isa(problem, 'struct')
			p_field = {'name', 'analysis'};
			for i = 1:length(p_field)
				assert(isfield(problem, p_field{i}), ...
						'Problem missing information (%s)', p_field{i});
			end
			ea.prob_name = problem.name;
			prob = problem;
		else
			if isa(problem, 'function_handle')
				ea.prob_name = strrep(func2str(problem), '/', '__');
				analysis = problem;
			else
				ea.prob_name = problem;
				analysis = str2func(problem);
			end
			prob = feval(problem);
            if ~isfield(prob, 'analysis')
                prob.analysis = analysis;
            end
		end

		% Check for required fields
		p_field = {'nx', 'nf', 'ng', 'range', 'analysis'};
		for i = 1:length(p_field)
			assert(isfield(prob, p_field{i}), ...
					'Problem missing information (%s)', p_field{i});
		end

		if isstruct(prob.analysis)
			assert(isfield(prob.analysis, 'obj'), ...
					'analysis missing obj');
			assert(iscell(prob.analysis.obj), ...
					'analysis.obj must be a cell array');
			assert(length(prob.analysis.obj) == prob.nf, ...
					'analysis.obj must have %d function handles', prob.nf);

			assert(isfield(prob.analysis, 'constr'), ...
					'analysis missing constr');
			assert(iscell(prob.analysis.constr), ...
					'analysis.constr must be a cell array');
			assert(length(prob.analysis.constr) == prob.ng, ...
					'analysis.constr must have %d function handles', prob.ng);

			ea.analysis = prob.analysis;
			ea.analysis.type = 'single';
			ea.fn_evals = zeros(1, prob.nf+prob.ng); 
		else
			assert(isa(prob.analysis, 'function_handle'), ...
					'analysis must be a function handle or a structure');
			ea.analysis.func = prob.analysis;
			ea.analysis.type = 'composite';
			ea.fn_evals = 0;
		end

		% Check for optional fields
		if ~isfield(prob, 'class')
			prob.class = 'Numeric';
		end
		if ~isfield(prob, 'userdata')
			prob.userdata = [];
		end
		if ~isfield(prob, 'plot_func')
			prob.plot_func = [];
		end
		if ~isfield(prob, 'repair_func')
			prob.repair_func = [];
		end
		if ~isfield(prob, 'convergnce_func')
			prob.convergence_func = [];
		end
		if ~isfield(prob, 'eval_mask')
			prob.eval_mask = [];
		end
		ea.prob = prob;

		% Set algorithm information
		algo_info = feval(algo, ea);
		assert(isfield(algo_info, 'name'), ...
			'%s: Algorithm name not defined', algo);
		ea.algo_name = algo_info.name;

		f_handle = {'param_func', 'init_func', 'next_func', 'post_func'};
		for i = 1:length(f_handle)
			assert(isfield(algo_info, f_handle{i}), ...
				'%s: Function handle %s not defined', algo, f_handle{i});
		end
		ea.algo_param_func = algo_info.param_func;
		ea.algo_init_func = algo_info.init_func;
		ea.algo_next_func = algo_info.next_func;
		ea.algo_post_func = algo_info.post_func;

		% Load parameters
		if nargin == 3
			ea.param_value = varargin{1};
		end

		param = Paramset(ea.param_value);
		param = add(param, 'generations', Range('irange', [1,inf]));
		param = add(param, 'seed', Range('irange', [0, 2^32-1]));
		param = add(param, 'max_fn_evals', Range('irange', [0,inf]));
		param = add(param, 'batch_mode', Range('set', {0,1,2}));
		param = add(param, 'use_cache', Range('set', {0,1}));
		ea.param = check(param);

		% Load algorithm parameters
		if ~isempty(ea.algo_param_func)
			ea.param = feval(ea.algo_param_func, ea.param);
		end

		% Initialize solution cache
		ea = init_cache(ea);

		% Create object
		ea.object = feval(ea.prob.class, ea.prob, ea.param);
	end
end
