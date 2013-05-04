%% N objective ND sort
function [ranks, nd_rank, crowd] = sort_obj(f, id)

	[N, M] = size(f);

	nd_rank = zeros(N,1);
	crowd = zeros(N,1);

	if M == 1
		[tmp, I] = sort(f(id));
		ranks = id(I);
	else
		ranks = [];
		F = nd_sort(f, id);
		for front = 1 : length(F)
			nd_rank(F(front).f(:)) = front;
			[r1, d1] = sort_crowding(f, F(front).f);
			crowd(F(front).f(:)) = d1;
			ranks = [ranks; r1];
		end
	end
end
