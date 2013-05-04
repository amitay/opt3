%% Check if solution id1 in pop1 dominates solution id2 in pop2
% Return 1, 0, -1 based on domination check
function [flag] = dominates(pop1, id1, pop2, id2)

	if pop1.feas(id1) == 0
		if pop2.feas(id2) == 0
			flag = sign(pop1.cv(id1) - pop2.cv(id2));
		else
			flag = -1;
		end
	else
		if pop2.feas(id2) == 0
			flag = 1;
		else
			dom1 = sum(pop1.f(id1,:) < pop2.f(id2,:));
			dom2 = sum(pop1.f(id1,:) > pop2.f(id2,:));
			flag = sign(dom1 - dom2);
		end
	end
end
