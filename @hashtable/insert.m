function [ht] = insert(ht, key, value)
	if size(key,1) ~= size(value,1)
		error('num keys != num values\n');
	end
	if size(key,2) ~= ht.key_size
		error('key size != %d\n', ht.key_size);
	end
	if size(value,2) ~= ht.value_size
		error('value size != %d\n', ht.value_size);
	end

	count = size(key, 1);

	if ht.count + count > ceil(ht.size * ht.load_factor)
		ht = expand(ht, ht.count + count);
	end

	ht.data(ht.count+1:ht.count+count,:) = [key, value];

	for i = 1:count
		hval = hash(ht, key(i,:));
		ht.hlist(ht.count+i) = hval;
		idx = mod(hval, ht.size) + 1;
		ht.table{idx}(end+1) = ht.count+i;
	end
	ht.count = ht.count + count;
end
