function [y, valid] = predict(surr, x)
	y = zeros(size(x,1), surr.ny);
	valid = zeros(size(x,1),1);
	for i = 1:size(x,1)
		[yp, valid(i)] = predict_cluster(surr, x(i,:));
		if valid(i)
			y(i,:) = yp;
		end
	end
end
