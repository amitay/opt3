%% Train surrogate model for jth response
function [m_type, m_data, m_nrmse] = train_model(surr, t_ids, v_ids, r_id, k)

	n = length(surr.type);

	found = 0;
	write(surr, '\t    y(%d): ', r_id);
	for i = 1:n
		m_type = surr.type{i};
		[m_data, m_nrmse] = train_model_single(surr, t_ids, v_ids, m_type, r_id);
		write(surr, '%s (%g), ', m_type, m_nrmse);
		if m_nrmse < surr.mse_threshold
			found = 1;
			break
		end
	end
	write(surr, '\n');

	if ~found
		m_nrmse = inf;
	end
end


%%
function [model, nrmse] = train_model_single(surr, t_ids, v_ids, type, r_id)

	switch type
		case {'rsm', 'rbf', 'dace', 'mlp'}
			x = surr.x_normal;
			ttype = type;
		case 'orsm'
			x = surr.x;
			ttype = 'rsm';
		case 'orbf'
			x = surr.x;
			ttype = 'rbf';
		case 'omlp';
			x = surr.x;
			ttype = 'mlp';
	end

	train_func = strcat(ttype, '_train');
	warning('off', 'all');
	model = feval(train_func, x(t_ids,:), surr.y(t_ids,r_id));
	warning('on', 'all');

	% calculate normalized RMSE
	if ~isempty(v_ids)
		[y, valid] = predict_model(surr, {type}, {model}, surr.x(v_ids,:));
		nrmse = normal_rms_error(surr, surr.y(v_ids,r_id), y);
	else
		nrmse = 0;
	end
end
