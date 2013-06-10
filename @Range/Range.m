%% Range class to handle value ranges or a discrete set
function [obj] = Range(type, val)

	if nargin == 2
		obj.type = lower(type);
		switch obj.type
			case 'scalar'
				obj.val = val(1);
			case 'range'
				obj.val = val(1:2);
			case 'irange'
				obj.val = val(1:2);
			case {'set', 'subset'}
				assert(iscell(val));
				if ~iscellstr(val)
					val = cell2mat(val);
				end
				obj.val = sort(val);
			otherwise
				error('Unknown range type. Use scalar/range/irange/set/subset.');
		end
	else
		obj.type = 'scalar';
		obj.val = [];
	end

	obj = class(obj, 'Range');
end
