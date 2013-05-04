function save(ea)
% SAVE(ea) saves EA
%

	save_cache(ea);
	
	filename = sprintf('%s-%s-ea.mat', ea.prob_name, ea.algo_name);
	save(filename, 'ea');
end
