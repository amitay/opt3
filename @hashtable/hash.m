function [hash_value] = hash(ht, key)
	tmp = feval(ht.hash_func, key);
	hash_value = uint32(tmp);
end

