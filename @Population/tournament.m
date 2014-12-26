%% Tournament - used only after sorting
function [id] = tournament(pop, id1, id2)
    assert(numel(id1) == numel(id2), 'Two ID sets should be of same size');

    rank1 = pop.rank(id1);
    rank2 = pop.rank(id2);

    if numel(id1) == 1
        id = tournament_single(rank1, rank2);
    else
        id = tournament_multi(rank1, rank2);
    end
end

%%
function [rank] = tournament_single(rank1, rank2)
	if rank1 < rank2
        rank = rank1;
    elseif rank2 < rank1
        rank = rank2;
    elseif rand(1) <= 0.5
        rank = rank1;
    else
        rank = rank2;
    end
end

%%
function [rank] = tournament_multi(rank1, rank2)
    r = rand(size(rank1));
    rank = rank1;
    rank(rank2 < rank1) = rank2(rank2 < rank1);
    rank((rank1 == rank2) & (r > 0.5)) = rank2((rank1 == rank2) & (r > 0.5));
end
