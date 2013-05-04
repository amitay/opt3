%% Run algorithm for fixed number of generations or till function
%% evaluations are reached
function ea = run(ea, varargin)

	% Algorithm first step
	ea = init(ea, varargin{:});
	
	while true
		% Algorithm next step
		ea = next(ea);
			
		% termination conditions
		if ea.param.generations > 0 && ea.gen_id == ea.param.generations
			break
		end
		if ea.param.max_fn_evals > 0 && ea.fn_evals > ea.param.max_fn_evals
			break
		end
		if ~isempty(ea.prob.convergence_func)
			terminate_flag = feval(ea.prob.convergence_func, ea.pop);
			if terminate_flag == 1
				break
			end
		end
	end
	
	% Algorithm final step
	ea = final(ea);
	
	save(ea);
end
