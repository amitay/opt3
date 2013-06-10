function [ht] = expand(ht)

	id = find(ht.primes == ht.size, 1);
	if id == length(ht.primes)
		return
	end

	newsize = ht.primes(id+1);
	newtable = cell(newsize, 1);

	for i = 1:ht.size
		for j = 1:length(ht.table{i})
			s = ht.table{i}{j};
			idx = mod(s.hval, newsize) + 1;
			newtable{idx}{end+1} = s;
		end
	end

	ht.size = newsize;
	ht.table = newtable;
end
