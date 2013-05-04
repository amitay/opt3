function [surr] = add_points(surr, x, y)
% ADD_POINTS() adds observations (decision+response) for the surrogate model
%

	if isempty(surr.range)
		error('Range of decision variables not defined.');
	end

	assert(size(x,1) == size(y,1));
	assert(size(x,2) == surr.nx);

	if surr.ny == 0
		surr.ny = size(y,2);
	else
		assert(size(y,2) == surr.ny);
	end

	N = size(x,1);

	% Verify that the new point is not in the neighborhood of archived points
	for i = 1:N
		% ignore points with objectives/constraints set to inf
		if sum(isinf(y(i,:))) == 0
			x_normal = normalize(surr, x(i,:));
			is_new = 1;
			if surr.count > 0
				for j = 1:surr.count
					if norm(surr.x_normal(j,:) - x_normal, 2) < surr.add_crit
						is_new = 0;
						break
					end
				end
			end
			if is_new == 1
				surr.x(surr.count+1,:) = x(i,:);
				surr.x_normal(surr.count+1,:) = x_normal;
				surr.y(surr.count+1,:) = y(i,:);
				surr.count = surr.count + 1;
			end
		end
	end
end
