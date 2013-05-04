%% Read population data from a file
function [pop] = load(pop, fid, type)
	for i = 1:pop.size
		if type == 1
			tmp = fscanf(fid, '%d', [1,3]);
			pop.feas(i) = tmp(3);
			pop.f(i,:) = fscanf(fid, '%f', [1,pop.nf]);
			pop.g(i,:) = fscanf(fid, '%f', [1,pop.ng]);
		end
		pop.x{i} = load(pop.object, fid);
	end
end
