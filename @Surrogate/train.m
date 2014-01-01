function [surr] = train(surr)
% TRAIN() trains surrogate model(s)

	% Save random state
	s1 = RandStream.getGlobalStream;
	rand_state = s1.State;

	% First step is construct number of clusters
	% Second step is build surrogate for each cluster

	if ~surr.adaptive_clustering
		surr.model_data = train_cluster(surr, surr.n_clusters);	
	else
		% heuristic on max number of clusters 
		max_clusters = round(sqrt(surr.count/5)/4);

		best_k = 0;
		best_maxerror = inf;
		best_model_data = [];
		for i = 1:max_clusters
			surr.n_clusters = i;
			surr.model_data = train_cluster(surr, i);
			maxerror = max(surr.model_data.error);
			write(surr, '\tTrying %d clusters: Valid=%d, Error=%g\n', i, ...
							sum(~isinf(surr.model_data.error)), maxerror);
			if i == 1 || maxerror < best_maxerror
				best_k = i;
				best_maxerror = maxerror;
				best_model_data = surr.model_data;
			end
		end

		surr.model_data = best_model_data;
		surr.n_clusters = best_k;
	end

	id = find(~isinf(surr.model_data.error));
	if isempty(id)
		n_valid = 0;
		maxerror = inf;
	else
		n_valid = length(id);
		maxerror = max(surr.model_data.error(id));
	end

	write(surr, '\tSurrogate: cluster=%d/%d, error=%g\n', ...
					n_valid, surr.n_clusters, maxerror);

	% Restore random state
	s1.State = rand_state;
end
