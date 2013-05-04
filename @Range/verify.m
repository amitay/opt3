%% Verify if the value is within range
function verify(range, value, varname)

	switch range.type
		case 'irange'
			assert(isnumeric(value), ...
				'%s value (%s) is not numeric', varname, value);
			assert(round(value) == value, ...
				'%s value (%g) is not integer', varname, value);
			assert(value >= range.val(1) && value <= range.val(2), ...
				'%s value (%g) not within range', varname, value);

		case 'range'
			assert(isnumeric(value), ...
				'%s value (%s) is not numeric', varname, value);
			assert(value >= range.val(1) && value <= range.val(2), ...
					'%s value (%g) not within range', varname, value);

		case 'scalar'
			assert(isnumeric(value), ...
				'%s value (%s) is not numeric', varname, value);
			
		case 'set'
			if ischar(value)
				vout = value;
			else
				vout = sprintf('%g', value);
			end
			assert(ismember(value, range.val), ...
				'%s value (%s) not in the set', varname, vout);

		case 'subset'
			assert(iscell(value), '%s value expected as a subset', varname);
			for i = 1:length(value)
				if ischar(value{i})
					vout = value{i};
					assert(ismember(vout, range.val), ...
						'%s value (%s) not in the set', varname, vout);
				else
					vout = sprintf('%g', value{i});
					assert(ismember(vout, range.val), ...
						'%s value (%g) not in the set', varname, vout);
				end
			end
	end
end
