%% Element subreferencing
function [val] = subsref(a, s)
	val = a;
	for i = 1:length(s)
		switch s(i).type
			case '.'
				val = val.(s(i).subs);
			case '()'
				val = val(s(i).subs{:});
			case '{}'
				val = val{s(i).subs{:}};
			otherwise
				error('Cluster: This type of subreferencing not allowed.');
		end
	end
