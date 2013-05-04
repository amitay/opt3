%% display range
function display(range)
	switch range.type
		case 'scalar'
			fprintf('scalar: %g\n', range.val);
		case 'range'
			fprintf('range: [%g, %g]\n', range.val(1), range.val(2));
		case 'irange'
			fprintf('irange: [%g, %g]\n', range.val(1), range.val(2));
		case 'set'
			fprintf('set: %s\n', range.val);
		case 'subset'
			fprintf('subset: %s\n', range.val);
	end
end
