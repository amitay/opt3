function [y, valid] = predict_cluster(surr, x)

	assert(size(x,1) == 1, 'Predict_cluster() requires only one point');

	[valid, c_id] = validate(surr, x);
	if valid
		csdata = surr.model_data.csdata{c_id};
		[y, valid] = predict_model(surr, csdata.type, csdata.model, x);
	else
		y = [];
	end
end
