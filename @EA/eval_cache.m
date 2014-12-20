%% Evaluate x, first search in cache
function [ea, x, f, g] = eval_cache(ea, x, repr_flag, state, varargin)
	if repr_flag == 1
		xx = convert_x(ea.object, x);
	else
		xx = x;
	end

	if nargin == 4
		f_mask = zeros(1, ea.prob.nf);
		g_mask = zeros(1, ea.prob.ng);
	elseif nargin == 6
		f_mask = varargin{1};
		g_mask = varargin{2};
	end

	if ea.param.use_cache == 1
		yy = search(ea.cache, xx);
		if ~isempty(yy)
			ea.cache_hits = ea.cache_hits + 1;
			xx = yy(1:ea.prob.nx);
			f = yy(ea.prob.nx+1:ea.prob.nx+ea.prob.nf);
			g = yy(ea.prob.nx+ea.prob.nf+1:end);
		else
			xx_orig = xx;
			[f, g, xx] = eval_true(ea, xx_orig, state, f_mask, g_mask);
			ea.cache = insert(ea.cache, xx_orig, [xx,f,g]);
		end
	else
		[f, g, xx] = eval_true(ea, xx, state, f_mask, g_mask);
	end

	if repr_flag == 1
		x = convert_obj(ea.object, xx);
	else
		x = xx;
	end
end
