%% Evaluate population
function [ea, pop] = eval_pop_surr(ea, pop, surr, varargin)

	if nargin == 4
		id = varargin{1};
		assert(isnumeric(id), 'IDs should be numeric');
	else
		id = 1:pop.size;
	end

	if strcmp(ea.analysis.type, 'composite')
		fn_evals = 0;
		f_mask = [];
		g_mask = [];
	else
		fn_evals = zeros(1, ea.prob.nf+ea.prob.ng);
		f_mask = ones(1, ea.prob.nf);
		g_mask = ones(1, ea.prob.ng);

		if isempty(ea.prob.eval_mask)
			surr_f_mask = zeros(1, ea.prob.nf);
			surr_g_mask = zeros(1, ea.prob.ng);
		else
			surr_f_mask = ea.prob.eval_mask(1:ea.prob.nf);
			surr_g_mask = ea.prob.eval_mask(ea.prob.nf+1:end);
		end
		surr_fn_evals = 1 - [surr_f_mask surr_g_mask];
	end

	state = [];
	state.gen_id = ea.gen_id;
	state.nx = ea.prob.nx;
	state.nf = ea.prob.nf;
	state.ng = ea.prob.ng;
	state.userdata = ea.prob.userdata;

	% Evaluate population
	for i = id
		state.pop_id = i;
		if get_evalflag(pop,i) == 0
			x = get_x(pop,i);
			[y, valid] = predict(surr, x);
			if valid == 1
				if strcmp(ea.analysis.type, 'composite')
					f = y(1:pop.nf);
					g = y(pop.nf+1:end);
				else
					f1 = y(1:pop.nf);
					g1 = y(pop.nf+1:end);
					[ea, ~, f2, g2] = eval_cache(ea, x, state, surr_f_mask, surr_g_mask);
					[f, g] = merge_fg(f1, g1, f2, g2, surr_f_mask, surr_g_mask);
					fn_evals = fn_evals + surr_fn_evals;
				end
				pop = assign_fitness(pop, i, f, g);
				pop = set_evalflag(pop, i, 2);
			else
				[ea, xx, f, g] = eval_cache(ea, x, 1, state);
				pop = set_x(pop, i, xx);
				pop = assign_fitness(pop, i, f, g);
				pop = set_evalflag(pop, i, 1);
				fn_evals = fn_evals + 1;
			end
		end
	end

	ea = add_fnevals(ea, fn_evals);
end


function [f, g] = merge_fg(f, g, f2, g2, f_mask, g_mask)
	for i = 1:length(f_mask)
		if f_mask(i) == 0
			f(i) = f2(i);
		end
	end
	for i = 1:length(g_mask)
		if g_mask(i) == 0
			g(i) = g2(i);
		end
	end
end
