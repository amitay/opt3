%% Display parameter representation
function display(a)
	loose = strcmp(get(0, 'FormatSpacing'), 'loose');

	name = inputname(1);
	if isempty(name)
		name = 'ans';
	end

	if (loose), fprintf('\n'); end
	fprintf('%s = \n', name);
	disp(a);
end
