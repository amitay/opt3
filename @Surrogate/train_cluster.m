function [model_data] = train_cluster(surr, k)

	model_data.cluster = Cluster(surr.x, surr.seed, 'k_means', k);
	model_data.csdata = cell(k,1);
	model_data.error = zeros(k,1);

	% for each cluster
	for i = 1:k
		ids = model_data.cluster.id{i};

		% identify the points used to train
		n_total = length(ids);
		traincount = round(n_total * surr.train_ratio);
		if traincount > surr.max_traincount
			traincount = surr.max_traincount;
			n_max = min(n_total, round(traincount / surr.train_ratio));
			ids = ids(n_total-n_max+1:end);
		else
			n_max = traincount;
		end
		write(surr, '\tCluster %d: %d/%d\n', i, n_max, n_total);

		cdata = Cluster(surr.x(ids,:), surr.seed, 'k_medoids', traincount);
		t_ids = ids(cdata.centroid);
		v_ids = setdiff(ids, t_ids);

		if isempty(surr.ids)
			ids = 1:surr.ny;
		else
			ids = surr.ids;
		end
		n_ids = length(ids);
		
		% for each response
		csdata =[];
		csdata.type = cell(1,n_ids);
		csdata.model = cell(1,n_ids);
		csdata.error = inf * ones(1,n_ids);
				
		for j = 1:n_ids
			r_id = ids(j);
			[csdata.type{j}, csdata.model{j}, csdata.error(j)] = ...
							train_model(surr, t_ids, v_ids, r_id, k);
			if isinf(csdata.error(j))
				break
			end
		end

		model_data.csdata{i} = csdata;
		model_data.error(i) = max(csdata.error);
	end
end
