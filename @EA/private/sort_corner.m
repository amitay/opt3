%% Corner sort
function [pop] = sort_corner(ea, pop)

	pop = init_rank(pop);

	feasible = find_feasible(pop);
	infeasible = find_infeasible(pop);

	ranks1 = [];
	if ~isempty(feasible)
		f = pop.f;
		[tmp, id] = unique(f(feasible,:), 'rows');

		f_unique = feasible(id);
		f_dup = setdiff(feasible, f_unique);

		if pop.nf == 1
			[tmp, I] = sort(f(f_unique));
			ranks1 = feasible(I);
		else
			for i = 1:pop.nf
				[tmp, ID{i}] = sort(f(f_unique,i));
			end
			f_square = f(f_unique,:) .^ 2;
			for i = 1:pop.nf
				idx = (1:pop.nf);
				idx(i) = [];
				[tmp, ID{pop.nf+i}] = sort(sum(f_square(:,idx),2));
			end
			r1 = [];
			cur_id = 1;
			cur_f = 1;
			while length(r1) < length(f_unique)
				r = ID{cur_f}(cur_id);
				if ~ismember(r,r1)
					r1 = [r1 r];
				end
				cur_f = cur_f + 1;
				if cur_f > 2*pop.nf
					cur_f = 1;
					cur_id = cur_id + 1;
				end
			end
			ranks1 = [f_unique(r1); f_dup];
		end
	end

	ranks2 = [];
	if ~isempty(infeasible)
		ranks2 = sort_constr(pop.cv, infeasible);
	end

	assert(length(ranks1) + length(ranks2) == pop.size);
	pop = set_rank(pop, 1:pop.size, [ranks1; ranks2]);
end
