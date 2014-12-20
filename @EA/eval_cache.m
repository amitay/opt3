%% Evaluate x, first search in cache
function [ea, xx, f, g] = eval_cache(ea, x, state, varargin)
	if nargin == 3
		f_mask = zeros(1, ea.prob.nf);
		g_mask = zeros(1, ea.prob.ng);
	elseif nargin == 5
		f_mask = varargin{1};
		g_mask = varargin{2};
	else
		error('Wrong number of arguments %d', nargin);
	end

	if ea.param.use_cache == 1
		yy = search(ea.cache, x);
		if ~isempty(y)
			ea.cache_hits = ea.cache_hits + 1;
			xx = yy(1:ea.prob.nx);
			f = yy(ea.prob.nx+1:ea.prob.nx+ea.prob.nf);
			g = yy(ea.prob.nx+ea.prob.nf+1:end);
		else
			[f, g, xx] = eval_true(ea, x, state, f_mask, g_mask);
			ea.cache = insert(ea.cache, x, [xx,f,g]);
		end
	else
		[f, g, xx] = eval_true(ea, x, state, f_mask, g_mask);
	end
end
