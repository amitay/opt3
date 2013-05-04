%% Check parameters
function [ps] = check(ps)

	fields = fieldnames(ps.param);
	err = 0;
	for i = 1:length(fields)
		key = fields{i};
		if ~isfield(ps.value, key)
			if isfield(ps.ivalue, key)
				verify(ps.param.(key), ps.ivalue.(key), key);
				ps.value.(key) = ps.ivalue.(key);
				ps.ivalue = rmfield(ps.ivalue, key);
			else
				fprintf('*** Parameter %s not defined\n', key);
				err = 1;
			end
		end
	end

	if err == 1
		error('Some of the required parameters are not defined');
	end
end
