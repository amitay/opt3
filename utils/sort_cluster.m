%% single objective Cluster sort
function [ranks] = sort_cluster(f, cdata)

	% number of clusters
	k = length(cdata.id);

	% best in each cluster
	best = zeros(1, k);

	% Sort f in each cluster
	max_size = 0;
	for i = 1:k
		id = cdata.id{i};
		[tmp, I] = sort(f(id));
		c_ranks{i} = id(I);
		best(i) = id(I(1));
		if length(id) > max_size
			max_size = length(id);
		end
	end

	% Sort the best from each cluster
	[tmp, c_order] = sort(f(best));

	% Assemble by picking one-one solution from each cluster
	ranks = [];
	for i = 1:max_size
		for j = 1:k
			c = c_order(j);
			if length(c_ranks{c}) >= i
				ranks = [ranks; c_ranks{c}(i)];
			end
		end
	end
end
