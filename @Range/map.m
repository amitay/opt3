%% Map [0,1] to range
function [x] = map(range, r)
	switch range.type
		case 'scalar'
			x = range.val;
		case 'range'
			x = range.val(1) + (range.val(2)-range.val(1)) * r;
		case 'irange'
			x = round(range.val(1)-0.5 + (range.val(2)-range.val(1)+1) * r);
		case 'set'
			id = round(range.val(1)-0.5 + (range.val(2)-range.val(1)+1) * r);
			x = range.val(id);
		case 'subset'
			error('Cannot map to subset range');
	end
end
