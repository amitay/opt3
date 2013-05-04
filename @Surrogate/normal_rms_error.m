%% Calculate normalized RMS error
function [max_nrmse,varargout] = normal_rms_error(surr, y, ypred)

	[N, m] = size(y);
	nrmse = zeros(1,m);
	for i = 1:m
		ydiff = y(:,i) - ypred(:,i);
		mse = (ydiff' * ydiff) / N;
		rmse = sqrt(mse);
		mm = minmax(y');
		delta = mm(2) - mm(1);
		if delta < 1.e-6, delta = 1; end
		nrmse(i) = rmse / delta;
	end
	max_nrmse = max(nrmse);
	
	if nargout == 2
		varargout{1} = nrmse;
	end
end
