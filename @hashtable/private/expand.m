function [ht] = expand(ht, newsize)

	id = find(ht.primes == ht.size, 1);
	if id == length(ht.primes)
		return
	end

	for i = id+1 : length(ht.primes)
		if ht.primes(i) > newsize
			newsize = ht.primes(i);
			break
		end
	end

	ht.data = [ht.data ; zeros(newsize-ht.size, ht.key_size+ht.value_size)];
	ht.hlist = [ht.hlist ; zeros(newsize-ht.size, 1)];
	newtable = cell(newsize, 1);

	for i = 1:ht.size
		for j = 1:length(ht.table{i})
			s = ht.table{i}(j);
			idx = mod(ht.hlist(s), newsize) + 1;
			newtable{idx}(end+1) = s;
		end
	end

	ht.size = newsize;
	ht.table = newtable;
end
