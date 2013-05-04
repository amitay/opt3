%% Final step of EA
function ea = final(ea)

	% Final step
	if ~isempty(ea.algo_post_func)
		ea = feval(ea.algo_post_func, ea);
	end
end
