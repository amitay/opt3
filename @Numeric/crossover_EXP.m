%% Exponential crossover
function [c1, fn_evals] = crossover_EXP(num, p1, p2)
	x1 = convert_x(num, p1);
	x2 = convert_x(num, p2);

	nx = length(x1);
	n = randint(1, 1, [1 nx]);

	L = 0;
	while L < nx
		L = L+1;
		if rand(1) > num.param.crossover_de_rate
			break
		end
	end

	id1 = mod(n, nx);
	id2 = mod(n+L-1, nx);
	ind1 = min(id1,id2);
	ind2 = max(id1,id2);

	y1 = x1;
	for i = ind1:ind2
		if i ~= 0
			y1(i) = x2(i);
		end
	end

	for i = 1:nx
		y1(i) = min(max(y1(i), min(num.range{i})), max(num.range{i}));
	end
	
	fn_evals = 0;
	c1 = convert_obj(num, y1);
end
