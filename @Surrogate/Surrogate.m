function [surr] = Surrogate(varargin)
% SURROGATE() creates surrogate model
%
%  There are 5 steps to building surrogate models and using them
%
%  1. Create surrogate class with appropriate parameters
%  2. Set the variable ranges (for normalization)
%  3. Add points to the archive
%  4. Train the surrogate model
%  5. Use the surrogate model for prediction
%
%Example: building a surrogate model for y = f(x)
%
%  surr = Surrogate();
%  surr = set_range(surr, Range('range', [0,1]));
%  x = rand(10,1);
%  y = some_func_to_approximate(x);
%  surr = add_points(surr, x, y);
%  surr = train(surr);
%  y_pred = predict(surr, x);
%
%Parameters: 
%
%  surr_type  - type of surrogate model { 'rsm', 'rbf', 'dace', 'mlp' }
%               To add a new type, check surrogate/ subdirectory.
%
%  surr_num_clusters   - number of clusters (0 for adaptive)
%  surr_add_crit       - epsilon neighborhood to add new points to archive 
%  surr_train_ratio    - fraction of solutions used for training
%  surr_max_traincount - maximum no. of points used for training
%  surr_mse_threshold  - surrogate validity criteria
%  surr_pred_dist      - fraction of solid diagonal to prevent extrapolation
%  

	surr.range = [];
	surr.x = [];
	surr.x_normal = [];
	surr.y = [];
	surr.nx = 0;
	surr.ny = 0;
	surr.ids = [];
	surr.count = 0;
	surr.logger = [];

	surr.n_clusters = 1;
	surr.type = { 'rbf' };
	surr.adaptive_clustering = 0;
	surr.seed = 1;
	surr.max_traincount = 200;
	surr.train_ratio = 0.8;
	surr.add_crit = 1.e-3;
	surr.mse_threshold = 0.05;
	surr.pred_dist = 0.05;
	

	% model data
	%   model_data.cluster  - data clusters
	%	model_data.error(i) - max prediction error for each cluster
	%	model_data.csdata{i} - surrogate models for each cluster
	% 	  model_data.csdata{i}.type{j} - surrogate model type for jth response
	%	  model_data.csdata{i}.model{j} - surrogate model parameters
	%	  model_data.csdata{i}.error(j) - prediction error
	surr.model_data = [];

	% load parameters
	param_value = [];
	if nargin == 1, param_value = varargin{1}; end
	param = Paramset(param_value);
	param = add(param, 'seed', Range('irange', [1,2^32-1]));

	param = add(param, 'surr_num_clusters', Range('irange', [0,100]));
	param = add(param, 'surr_type', ...
		Range('subset', {'rsm', 'orsm', 'rbf', 'orbf', 'dace', 'mlp', 'omlp'}));
	param = add(param, 'surr_max_traincount', Range('irange', [1, 10000]));
	param = add(param, 'surr_train_ratio', Range('range', [0.5,1]));
	param = add(param, 'surr_add_crit', Range('range', [0,1]));
	param = add(param, 'surr_mse_threshold', Range('range', [0,1]));
	param = add(param, 'surr_pred_dist', Range('range', [0,1]));
	param = check(param);
			
	% Assign parameter values
	surr.seed = param.seed;
	surr.n_clusters = param.surr_num_clusters;
	if surr.n_clusters == 0
		surr.adaptive_clustering = 1;
	end
	surr.type = param.surr_type;
	surr.max_traincount = param.surr_max_traincount;
	surr.train_ratio = param.surr_train_ratio;
	surr.add_crit = param.surr_add_crit;
	surr.mse_threshold = param.surr_mse_threshold;
	surr.pred_dist = param.surr_pred_dist;

	surr = class(surr, 'Surrogate');
end
