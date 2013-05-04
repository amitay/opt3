function ht = hashtable(minsize, eq_func, hash_func)
% Hashtable() - Create hashtable
%
% properties:
%  'minsize'  - initial capacity of the hash table (default = 100)
%
%  'eq_func'  - the function (handle) to use for testing key equality.
%               The default works for integers, reals, complex numbers, 
%               strings, matrices, structs, and cell arrays of the above,
%               but of course may not be efficient or suitable for your
%               particular data structure.  If you supply a new equality 
%               function, you should probably also supply a new hashcode 
%               function.  Equality functions should take two inputs and
%               return a boolean.
%
%  'hash_func' - the hashcode function to use to generate hash values
%               for keys of the table.  The default works well only
%               with numbers, strings, and matrices.
%               Structs, cell arrays, etc. will get a very weak hash, so
%               you'll need to supply a better hashcode function if you
%               want to use these as keys.

	assert(minsize < 2^30, 'Hashtable size too large');

	if nargin < 1
		minsize = 10;
	end
	if nargin < 2
		eq_func = @array_equal;
	end
	if nargin < 3
		hash_func = @array_hash;
	end

	ht.primes = [ 53, 97, 193, 389, 769, 1543, 3079, 6151, 12289, ...
					24593, 49157, 98317, 196613, 393241, 786433, ...
					1572869, 3145739, 6291469, 12582917, 25165843, ...
					50331653, 100663319, 201326611, 402653189, ...
					805306457, 1610612741 ];
		
	for i = 1:length(ht.primes)
		if ht.primes(i) > minsize
			size = ht.primes(i);
			break
		end
	end
	
	ht.size = size;
    ht.eq_func = eq_func;
    ht.hash_func = hash_func;
    ht.load_factor = 0.75;
	ht.count = 0;
    ht.table = cell(ht.size, 1);
    
    ht = class(ht, 'hashtable');
end
