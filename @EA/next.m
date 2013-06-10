%% Next step of EA
function ea = next(ea)
	% Next step
	ea.gen_id = ea.gen_id + 1;

	% Problem specific repair function
	if ~isempty(ea.prob.repair_func)
		state = [];
		state.gen_id = ea.gen_id;
		state.nx = ea.prob.nx;
		state.nf = ea.prob.nf;
		state.ng = ea.prob.ng;
		state.userdata = ea.prob.userdata;

		for i = 1:ea.childpop.size
			state.pop_id = i;
			x = convert_x(ea.object, ea.childpop.x{i});
			x = feval(ea.prob.repair_func, x, state);
			ea.childpop.x{i} = convert_obj(ea.object, x);
		end
	end

	% Algorithm next function
	ea = feval(ea.algo_next_func, ea);

	% Housekeeping
	ea = update_stats(ea);

	% Data dump
	save_data(ea);

	% Display summary
	summary(ea);

	% Plot
	if ea.param.batch_mode == 0
		plot(ea);
	end
end
