function [val] = search(ht, key)
	hval = hash(ht, key);
	idx = rem(hval, ht.size) + 1;
	tmp = ht.table{idx};
	val = [];
	if ~isempty(tmp)
		for i = 1:length(tmp)
			idx = tmp(i);
			if feval(ht.eq_func, key, ht.data(idx,1:ht.key_size))
				val = ht.data(idx,ht.key_size+1:end);
				break
			end
		end
	end
end
