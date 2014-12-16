function dump(ht)
	for i = 1:ht.size
		fprintf('%d: ', i);
		tmp = ht.table{i};
		if ~isempty(tmp)
			for j = 1:length(tmp)
				s = tmp(j)
				fprintf('%d ', ht.hlist(s));
			end
		end
		fprintf('\n');
	end
end
