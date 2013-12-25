%% Simulated Binary Crossover (SBX) operator
function [y1, y2] = op_SBX(r, x1, x2, eta)
	switch r.type
		case 'scalar'
			y1 = r.val;
			y2 = r.val;
		case 'range'
			[y1, y2] = SBX(x1, x2, r.val(1), r.val(2), eta);
		case 'irange'
			[y1, y2] = SBX(x1, x2, r.val(1), r.val(2), eta);
			y1 = round(y1);
			y2 = round(y2);
		case 'set'
			i1 = find(r.val == x1, 1);
			i2 = find(r.val == x2, 1);
			[t1, t2] = SBX(i1, i2, 1, length(r.val), eta);
			y1 = r.val(round(t1));
			y2 = r.val(round(t2));
		case {'subset', 'object'}
			error('Operator not defined for object/subset range');
	end
end


%%
function [y1, y2] = SBX(x1, x2, x_min, x_max, eta)
	% Make sure the variables are not the same
	if abs(x1-x2) > 1.e-6
	% make sure x1 < x2
   	 if x2 < x1, tmp = x1; x1 = x2; x2 = tmp; end

		r = rand(1);
		beta = 1 + (2 * (x1-x_min) / (x2-x1));
		alpha = 2 - beta^-(eta+1);
		if r <= 1/alpha
			betaq = (r*alpha)^(1/(eta+1));
		else
			betaq = (1/(2-r*alpha))^(1/(eta+1));
		end
		y1 = 0.5 * (x1+x2 - betaq*(x2-x1));

		beta = 1 + (2 * (x_max-x2) / (x2-x1));
		alpha = 2 - beta^-(eta+1);
		if r <= 1/alpha
			betaq = (r*alpha)^(1/(eta+1));
		else
			betaq = (1/(2-r*alpha))^(1/(eta+1));
		end
		y2 = 0.5 * (x1+x2 + betaq*(x2-x1));

		y1 = min(max(y1, x_min), x_max);
		y2 = min(max(y2, x_min), x_max);

		if rand(1) <= 0.5, tmp = y1; y1 = y2; y2 = tmp; end
	else
		y1 = x1;
		y2 = x2;
	end
end
