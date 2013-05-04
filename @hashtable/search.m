function [val] = search(ht, key)
	hval = hash(ht, key);
	idx = rem(hval, ht.size) + 1;
	tmp = ht.table{idx};
	val = [];
	if ~isempty(tmp)
		for i = 1:length(tmp)
			if feval(ht.eq_func, key, tmp{i}.key)
				val = tmp{i}.value;
				break
			end
		end
	end
end
