%% Perform local search
function [ea, x2, f, g] = localsearch(ea, x, user_obj_func, user_con_func, ...
								max_fn_evals, max_iter)

	if ea.param.max_fn_evals > 0
		fn_evals_balance = max(0, ea.param.max_fn_evals - ea.fn_evals);	
		max_fn_evals = min(max_fn_evals, fn_evals_balance);
	end

	options = optimset('Display', ea.param.ls_display, ...
						'MaxFunEvals', max_fn_evals, ...
						'MaxIter', max_iter);

	[min_x, max_x] = convert_range(ea.object);

	o_handle = @obj_func;
	if isempty(user_con_func)
		c_handle = [];
	else
		c_handle = @constr_func;
	end

	state = [];
	state.gen_id = ea.gen_id;
	state.pop_id = 0;
	state.userdata = ea.prob.userdata;

	fn_evals = 0;

	warning('off', 'all');
	x2 = fmincon(o_handle, x, [], [], [], [], min_x, max_x, ...
					c_handle, options);
	warning('on', 'all');

	[f, g] = feval(ea.analysis, x2, state);

	ea = add_fnevals(ea, fn_evals + 1);

	% ----------------------------------------------------------------
	function [obj] = obj_func(x)
		[f, g, x] = eval_func(x);
		obj = feval(user_obj_func, f, g);
	end

	% ----------------------------------------------------------------
	function [c, ceq] = constr_func(x)
		[f, g, x] = eval_func(x);
		[c, ceq] = feval(user_con_func, f, g);
	end

	% ----------------------------------------------------------------
	function [f, g, x] = eval_func(x)
		[ea, x, f, g] = eval_cache(ea, x, 0, state);
		fn_evals = fn_evals + 1;
	end
end
