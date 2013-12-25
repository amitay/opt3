%% Polynomial mutation operator
function [x] = op_POLY(r, x, eta)

	switch r.type
		case 'scalar'
			x = r.val;
		case 'range'
			x = POLY(x, r.val(1), r.val(2), eta);
		case 'irange'
			x = round(POLY(x, r.val(1), r.val(2), eta));
		case 'set'
			i = find(r.val == x, 1);
			t = POLY(i, 1, length(r.val), eta);
			x = r.val(round(t));
		case {'subset', 'object'}
			error('Operator not defined for object/subset range');
	end
end


%%
function x = POLY(x, x_min, x_max, eta_mu)
	% Make sure the range is non-zero
	if x_max-x_min > 0
		delta1 = (x-x_min) / (x_max-x_min);
		delta2 = (x_max-x) / (x_max-x_min);
		mut_pow = 1/(eta_mu+1);
		r = rand(1);
		if r <= 0.5
			xy = 1 - delta1;
			val = 2*r + (1-2*r) * xy^(eta_mu+1);
			deltaq = val^mut_pow - 1;
		else
			xy = 1 - delta2;
			val = 2*(1-r) + 2*(r-0.5) * xy^(eta_mu+1);
			deltaq = 1 - val^mut_pow;
		end
		x = x + deltaq*(x_max-x_min);
		x = min(max(x, x_min), x_max);
	end
end
