%% Shape matching example
% For details see Problem_Definition.txt
%
function [f, g, x] = shape_matching(x, state)
	if nargin == 0
		prob.nx = 20;
		prob.nf = 1;
		prob.ng = 0;
		prob.range = cell(1, prob.nx);
		for i = 1:prob.nx
			prob.range{i} = Range('range', [-5, 5]);
		end
		
		N = 200;
		pts = zeros(N, 2);
		angle = (1:N) * 360 / N;
		for i = 1:N
			pts(i,1) = 2 * cos(deg2rad(angle(i)));
			pts(i,2) = 2 * sin(deg2rad(angle(i)));
		end
		prob.userdata = pts;
		prob.repair_func = @shape_repair;
		prob.plot_func = @shape_plot;
		
		f = prob;
	else
		[f, g] = shape_matching_true(x, state);
	end
end


function [f, g] = shape_matching_true(x, state)
	xx = reshape(x, 10, 2);
	dist = norm(sum(xx .* xx, 2) - 2*2);
	tmp = xx(1:9, :) - xx(2:10, :);
	dist2 = abs(sum(sum(tmp .* tmp, 2)) - 2*pi*2);
	f = dist + dist2;
	g = [];
end


function [x] = shape_repair(x, state)
	% order points in order
	xx = reshape(x, 10, 2);
	centroid = mean(xx);
	yy = xx - repmat(centroid, 10, 1);
	for i = 1:10
		angle(i) = atan2(yy(i,2), yy(i,1));
	end
	[tmp, I] = sort(angle);
	xx = xx(I,:);
	x = xx(:);
end


function [x] = shape_plot(x, state, fig_id)
	figure(fig_id);
	plot(state.userdata([1:end 1], 1), state.userdata([1:end 1], 2), 'k-');
	hold on;
	xx = reshape(x, 10, 2);
	plot(xx([1:end 1], 1), xx([1:end 1], 2), 'ro-');
	hold off;
	axis([-5 5 -5 5]);
	axis equal;
end
