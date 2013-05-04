function [ht] = insert(ht, key, value)
	if ht.count + 1 > ceil(ht.size * ht.load_factor)
		ht = expand(ht);
	end
	
	hval = hash(ht, key);
	
	s.key = key;
	s.value = value;
	s.hval = hval;
	
	idx = mod(hval, ht.size) + 1;
	ht.table{idx}{end+1} = s;
	ht.count = ht.count + 1;
end
