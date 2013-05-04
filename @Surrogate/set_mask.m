function [surr] = set_mask(surr, mask)
% SET_MASK() identifies the responses to be approximated
%

	if surr.ny == 0
		surr.ny = length(mask);
	else
		assert(length(mask) == surr.ny);
	end
	
	surr.ids = find(mask == 1);
end