%% Element subreferencing
function val = subsref(a, s)
	assert(length(s) == 1, 'This type of subreferencing not allowed.');
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
				s(i).type
				s(i).subs
				error('This type of subreferencing not allowed.');
		end
	end
end
