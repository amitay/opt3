function info(ht)

% Display information about this hashtable.
fprintf('              size: %d\n', ht.size);
fprintf('number of elements: %d\n', ht.count);
fprintf('           loading: %.2g\n', ht.count / ht.size);
fprintf('       load factor: %.2g\n', ht.load_factor);

ne = 0;
mc = 0;
for i = 1:ht.size
	if isempty(ht.table{i})
        ne = ne + 1;
	else
		j = length(ht.table{i});
		mc = max(mc, j);
	end
end

fprintf('      unused slots: %d\n', ne);
fprintf('     longest chain: %d\n', mc);
