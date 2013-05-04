% Check if the surrogate model is valid for given x
function [valid, c_id] = validate(surr, x)

	valid = 0;
	c_id = 0;

	if surr.n_clusters == 1
		if ~isinf(surr.model_data.error(1))
			valid = 1;
			c_id = 1;
		end
	else
		x_normal = normalize(surr, x);
		dist = zeros(1, surr.n_clusters);
		for i = 1:surr.n_clusters
			c = surr.model_data.cluster.centroid(i,:);
			c_normal = normalize(surr, c);
			tmp = x_normal - c_normal;
			dist(i) = sqrt(tmp * tmp');
		end
		[mindist, I] = min(dist);
		if mindist < surr.pred_dist * sqrt(surr.nx)
			if ~isinf(surr.model_data.error(I))
				c_id = I;
				valid = 1;
			end
		end
	
% 	x_normal = normalize(surr, x);
% 	if find_closest(surr, x_normal) < surr.pred_dist * sqrt(surr.nx)
% 		max_nrmse = zeros(1, surr.n_clusters);
% 		id = find_neighbors(surr, x, 10);
% 		xv = surr.x(id,:);
% 		yv = surr.y(id,:);
% 		for j = 1:surr.n_clusters
% 			type = surr.model_data.csdata{j}.type;
% 			model = surr.model_data.csdata{j}.model;
% 			[yv_pred, valid] = predict_model(surr, type, model, xv);
% 			if valid
% 				max_nrmse(j) = normal_rms_error(surr, yv, yv_pred);
% 			else
% 				max_nrmse(j) = inf;
% 			end
% 		end
% 		[tmp, c_id] = min(max_nrmse);
% 		if ~isinf(tmp)
% 			valid = 1;
% 		end
% 	end

	end
end


%% Find closest neighbor
function [min_dist] = find_closest(surr, x_normal)
	tmp = surr.x_normal - repmat(x_normal, surr.count, 1);
	dist = sum(tmp .* tmp, 2);
	[tmp] = min(dist);
	min_dist = tmp(1);
end


%%  Find neighbors of given point
function [id] = find_neighbors(surr, x, n)
	tmp = surr.x - repmat(x, surr.count, 1);
	dist = sum(tmp .* tmp, 2);
	[tmp, I] = sort(dist);
	id = I(1:n);
end

