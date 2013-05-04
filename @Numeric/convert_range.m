%% Convert range into min and max values
function [min_x, max_x] = convert_range(nr)
	min_x = zeros(1, length(nr.range));
	max_x = zeros(1, length(nr.range));
	for i = 1:length(nr.range)
		min_x(i) = sample_min(nr.range{i},1);
		max_x(i) = sample_max(nr.range{i},1);
	end
end
