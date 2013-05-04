function status = array_equal(x, y)
	assert(isnumeric(x) == 1);
	assert(isnumeric(y) == 1);
	status = x == y;
end
