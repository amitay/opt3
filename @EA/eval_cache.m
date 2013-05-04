%% Evaluate x, first search in cache
function [ea, x, f, g] = eval_cache(ea, x, repr_flag, state)

	if repr_flag == 1
		xx = convert_x(ea.object, x);
	else
		xx = x;
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
			[f, g, xx] = feval(ea.analysis, xx_orig, state);
			ea.cache = insert(ea.cache, xx_orig, [xx,f,g]);
		end
	else
		[f, g, xx] = feval(ea.analysis, xx, state);
	end
	
	if repr_flag == 1
		x = convert_obj(ea.object, xx);
	else
		x = xx;
	end
end
