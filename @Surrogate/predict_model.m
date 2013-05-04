function [y, valid] = predict_model(surr, type, model, x)

	N = size(x,1);
	m = length(type);

	y = zeros(N, m);

	valid = 1;
	for i = 1:m
		if ~isempty(model{i})
			y(:,i) = predict_model_single(surr, type{i}, model{i}, x);
		else
			valid = 0;
			break
		end
	end
end


function [y] = predict_model_single(surr, type, model, x)

	switch(type)
		case {'rsm', 'rbf', 'dace', 'mlp'}
			x = normalize(surr, x);
			ptype = type;
		case 'orsm'
			ptype = 'rsm';
		case 'orbf'
			ptype = 'rbf';
		case 'omlp'
			ptype = 'mlp';
	end

	pred_func = strcat(ptype, '_predict');
	y = zeros(size(x,1), 1);
	for i = 1:size(x,1)
		y(i) = feval(pred_func, x(i,:), model);
	end
end
