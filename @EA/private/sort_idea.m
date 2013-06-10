%% sort IDEA
function [pop] = sort_idea(ea, pop)

	pop = init_rank(pop);

	feasible = find_feasible(pop);
	infeasible = find_infeasible(pop);

	% sort feasible solutions
	ranks1 = [];
	if ~isempty(feasible)
		[ranks1, nd_rank, crowd] = sort_obj(pop.f, feasible);
		pop = set_ndrank(pop, feasible, nd_rank(feasible));
		pop = set_crowd(pop, feasible, crowd(feasible));
	end

	% sort infeasible solutions
	ranks2 = [];
	if ~isempty(infeasible)
		if length(infeasible) == pop.size
			ranks2 = sort_constr(pop.cv, infeasible);
		else
			f_new = new_objective(pop, ea.param.infeasible_strategy);
			[ranks2, nd_rank, crowd] = sort_obj([pop.f f_new], infeasible);
			pop = set_ndrank(pop, infeasible, -nd_rank(infeasible));
			pop = set_crowd(pop, infeasible, crowd(infeasible));
		end
	end

	assert(length(ranks1) + length(ranks2) == pop.size);
	pop = set_rank(pop, 1:pop.size, [ranks1; ranks2]);

	% promote infeasible solutions
	N_inf = min(sum(pop.feas == 0), ...
				round(ea.param.infeasible_ratio*ea.param.pop_size));
	pop = promote_infeasible(pop, N_inf);
end



%% additional objective
function [f_new] = new_objective(pop, strategy)

	if strategy == 1
		% number of constraint violations
		f_new = sum(pop.g < 0, 2);
	elseif strategy == 2
		% constraint violation measure (rank based)
		tmp = [pop.g < 0];
		c = pop.g .* tmp;
		con_f = zeros(pop.size, pop.ng);

		for j = 1:pop.ng
			[tmp, I] = sort(c(:,j), 'descend');
			cur_rank = 0;
			cur_val = 0;
			for i = 1:pop.size
				if tmp(i) < cur_val
					cur_rank = cur_rank+1;
					cur_val = tmp(i);
				end
				con_f(I(i), j) = cur_rank;
			end
		end

		f_new = sum(con_f, 2);
	elseif strategy == 3
		% number of constraint violations + violation value
		cv = sum(pop.g < 0, 2);
		N = max(cv);

		f_new = zeros(pop.size,1);
		if N > 0
			id_list = cell(N,1);

			g_all = pop.g;
			g_all(g_all > 0) = 0;
			g_all = -g_all;

			for i = 1:N
				id = find(cv == i);
				F = nd_sort(g_all, id);
				ranks = [];
				for f = 1:length(F)
					ranks = [ranks F(f).f];
				end
				id_list{i} = ranks;
			end

			cur_rank = 1;
			cur_list = 1;
			N_inf = sum(cv > 0);
			while cur_rank < N_inf
				while isempty(id_list{cur_list})
					cur_list = cur_list + 1;
					if cur_list > N, cur_list = 1; end
				end

				id = id_list{cur_list}(1);
				id_list{cur_list}(1) = [];
				f_new(id) = cur_rank;
				cur_rank = cur_rank + 1;
				cur_list = cur_list + 1;
				if cur_list > N, cur_list = 1; end

			end
		end

	else
		error('IDEA: Unknown strategy');
	end
end


%% Promote infeasible solution above feasible solutions
function [pop] = promote_infeasible(pop, N_inf)
	% promote infeasible solutions
	if ~isempty(find_feasible(pop))
		new_rank = zeros(pop.size,1);
		index1 = 1;
		index2 = N_inf + 1;
		for i = 1:pop.size
			id = get_rank(pop, i);
			if get_feasflag(pop, id) == 0 && index1 <= N_inf
				new_rank(index1) = id;
				index1 = index1+1;
			else
				new_rank(index2) = id;
				index2 = index2 + 1;
			end
		end
		pop = set_rank(pop, 1:pop.size, new_rank);
	end
end
