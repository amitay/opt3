%% Cluster solutions in k clusters
% Return ids for each cluster
function [C] = cluster(pop, id, k, seed)
	for i = 1:length(id)
		n = id(i);
		x(i,:) = convert_x(pop.object, pop.x{n});
	end

	cdata = Cluster(x, seed, 'k_medoids', k);
	C.id = cell(1, k);
	for i = 1:k
		C.id{i} = id(cdata.id{i});
	end
end
