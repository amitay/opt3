function dump(ht)
	for i = 1:ht.size
		fprintf('%d: ', i);
		tmp = ht.table{i};
		if ~isempty(tmp)
			for j = 1:length(tmp)
				s = tmp{j};
				fprintf('%f@%d ', s.key, s.hval);
			end
		end
		fprintf('\n');
	end
end
