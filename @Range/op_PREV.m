%% Sample values less than the current value
function [x] = op_PREV(r, x, eta)

	switch r.type
		case 'scalar'
			x = r.val;
		case 'range'
			x = POLY(x, r.val(1), r.val(2), eta);
			% x = REDUCE(x, r.val(1), r.val(2), eta);
		case 'irange'
			x = round(POLY(x, r.val(1), r.val(2), eta));
		case 'set'
			i = find(r.val == x, 1);
			t = POLY(i, 1, length(r.val), eta);
			x = r.val(round(t));
	end
end


%%
function x = POLY(x, x_min, x_max, eta_mu)
% Make sure the range is non-zero
	if x_max-x_min > 0
		delta1 = (x-x_min) / (x_max-x_min);
		mut_pow = 1/(eta_mu+1);
		r = rand(1);
		if r > 0.5, r = r-0.5; end
		xy = 1 - delta1;
		val = 2*r + (1-2*r) * xy^(eta_mu+1);
		deltaq = val^mut_pow - 1;
		x = x + deltaq*(x_max-x_min);
		x = max(min(x, x_max), x_min);
	end
end


%%
function x = REDUCE(x, x_min, x_max, eta)
	x = x - (x_max-x_min)/100;
	x = max(x, x_min);
end
