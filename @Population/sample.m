%% Initialize population
function [pop] = sample(pop, varargin)

    if strcmp(pop.sampling, 'uniform')
        pop.x = sample_uniform(pop, pop.size);
    elseif strcmp(pop.sampling, 'lhs')
        pop.x = sample_lhs(pop, pop.size);
    elseif strcmp(pop.sampling, 'special')
        assert(nargin == 1, '');
        arg = varargin{1};
        pop.x(1,:) = arg;
        for i = 2:pop.size
            pop.x(i,:) = mutation_POLY(arg);
        end
    elseif strcmp(pop.sampling, 'all')
        pop.x = arg;
    else
        error('Error: Unknown sampling method %s', pop.sampling);
    end

end

%% Sample uniform
function [x] = sample_uniform(pop, N)
    x = zeros(N, pop.nx);
    for i = 1:N
        for j = 1:pop.nx
            x(i,j) = sample(num.range{j});
        end
    end
end

%% Sample Latin-Hypercube
function [x] = sample_lhs(pop, N)
    x = lhsdesign(N, pop.nx);
    for i = 1:N
        for j = 1:pop.nx
            x(i,j) = map(pop.range{j}, x(i,j));
        end
    end
end
