%% Create samples
function [inst] = sample(num, N, method, arg)

	if nargin < 2, N = 1; end
	if nargin < 3, method = 'uniform'; end
	if nargin < 4, arg = []; end

	inst = cell(N, 1);

	% Actual sampling
	if strcmp(method, 'uniform')
		x = sample_uniform(num, N);
		for i = 1:N
			inst{i}.x = x(i,:);
		end
	elseif strcmp(method, 'lhs')
		x = sample_lhs(num, N);
		for i = 1:N
			inst{i}.x = x(i,:);
		end
	elseif strcmp(method, 'special')
		inst{1}.x = arg;
		for i = 2:N
			x = mutation_POLY(num, arg);
			inst{i}.x = x;
		end
	elseif strcmp(method, 'all')
		for i = 1:N
			inst{i}.x = arg(i,:);
		end
	else
		error('Numeric:Error: Unknown Sampling Method');
	end
end


%% Sample uniform
function [x] = sample_uniform(num, N)
	x = zeros(N, num.nx);
	for i = 1:N
		for j = 1:num.nx
			x(i,j) = sample(num.range{j});
		end
	end
end

%% Sample Latin-Hypercube
function [x] = sample_lhs(num, N)
	x = lhsdesign(N, num.nx);
	for i = 1:N
		for j = 1:num.nx
			x(i,j) = map(num.range{j}, x(i,j));
		end
	end
end
