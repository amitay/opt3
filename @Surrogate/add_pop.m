%% Add population to surrogate archive
function [surr] = add_pop(surr, pop)
% ADD_POP() adds points from the population to the surrogate

	assert(isa(pop, 'Population'));

	x = zeros(pop.size, surr.nx);
	y = zeros(pop.size, pop.nf+pop.ng);
	count=0;
	for i = 1:pop.size
		% Need to add only solutions that are evaluated truly
		if get_evalflag(pop,i) == 1
			x(count+1,:) = get_x(pop,i);
			y(count+1,:) = [get_f(pop,i) get_g(pop,i)];
			count = count+1;
		end
	end
	surr = add_points(surr, x(1:count,:), y(1:count,:));
end

