%% SBX crossover
function [c1, c2, fn_evals] = crossover_SBX(ea, p1, p2)
    fn_evals = 0;

    x1 = p1;
    x2 = p2;
    for i = 1:ea.prob.nx
        x_min = min(ea.prob.range{i});
        x_max = max(ea.prob.range{i});
        [x1(:,i), x2(:,i)] = SBX_array(p1(:,i), p2(:,i), x_min, x_max, ea.param.crossover_sbx_eta);
    end

    c1 = p1;
    c2 = p2;
    r = rand(size(p1,1),1);
    c1(r <= ea.param.crossover_prob,:) = x1(r <= ea.param.crossover_prob,:);
    c2(r <= ea.param.crossover_prob,:) = x2(r <= ea.param.crossover_prob,:);
end

%%
function [y1, y2] = SBX_array(x1, x2, x_min, x_max, eta)
    y1 = x1;
    y2 = x2;

    % Make sure the variables are not the same
    id = abs(x1-x2) > 1.e-6;
    x1_sub = x1(id);
    x2_sub = x2(id);

    % make sure x1 < x2
    xx1 = x1_sub;
    xx2 = x2_sub;
    xx1(x2_sub < x1_sub) = x2_sub(x2_sub < x1_sub);
    xx2(x2_sub < x1_sub) = x1_sub(x2_sub < x1_sub);

    r = rand(size(xx1));
    beta = 1 + (2 * (xx1-x_min) ./ (xx2-xx1));
    alpha = 2 - beta.^-(eta+1);
    tmp = r .* alpha;
    tmp_id = r > 1./alpha;
    tmp(tmp_id) = 1 / (2 - r(tmp_id)./alpha(tmp_id));
    betaq = tmp .^ (1/(eta+1));
    yy1 = 0.5 * (xx1+xx2 - betaq.*(xx2-xx1));

    yy1(yy1 < x_min) = x_min;
    yy1(yy1 > x_max) = x_max;

    beta = 1 + (2 * (x_max-xx2) ./ (xx2-xx1));
    alpha = 2 - beta.^-(eta+1);
    tmp = r .* alpha;
    tmp_id = r > 1./alpha;
    tmp(tmp_id) = 1 / (2 - r(tmp_id)./alpha(tmp_id));
    betaq = tmp .^ (1/(eta+1));
    yy2 = 0.5 * (xx1+xx2 + betaq.*(xx2-xx1));

    yy2(yy2 < x_min) = x_min;
    yy2(yy2 > x_max) = x_max;

    swap = rand(size(xx1)) <= 0.5;
    y1_sub = yy1;
    y1_sub(swap) = yy2(swap);
    y2_sub = yy2;
    y2_sub(swap) = yy1(swap);

    y1(id) = y1_sub;
    y2(id) = y2_sub;
end
