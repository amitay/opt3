function [y, valid] = predict(surr, x)
	y = zeros(size(x,1), surr.ny);
	valid = zeros(size(x,1),1);
	
	if isempty(surr.ids)
		ids = 1:surr.ny;
	else
		ids = surr.ids;
	end
	
	for i = 1:size(x,1)
		[yp, valid(i)] = predict_cluster(surr, x(i,:));
		if valid(i)
			y(i,ids) = yp;
		end
	end
end
