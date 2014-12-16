function ht = hashtable(key_size, value_size, min_size)
% Hashtable() - Create hashtable
%
% properties:
%  'key_size'   - size of x vector
%  'value_size' - size of y vector
%  'min_size'   - initial size of data
%
	if nargin == 2
		min_size = 100;
	end

	ht.eq_func = @array_equal;
	ht.hash_func = @array_hash;

	ht.key_size = key_size;
	ht.value_size = value_size;

	ht.primes = [ 53, 97, 193, 389, 769, 1543, 3079, 6151, 12289, ...
			24593, 49157, 98317, 196613, 393241, 786433, ...
			1572869, 3145739, 6291469, 12582917, 25165843, ...
			50331653, 100663319, 201326611, 402653189, ...
			805306457, 1610612741 ];

	for i = 1 : length(ht.primes)
		if ht.primes(i) > min_size
			size = ht.primes(i);
			break
		end
	end

	ht.count = 0;
	ht.size = size;
	ht.data = zeros(ht.size, ht.key_size+ht.value_size);
	ht.hlist = zeros(ht.size, 1);

	ht.table = cell(ht.size, 1);
	ht.load_factor = 0.75;

	ht = class(ht, 'hashtable');
end
