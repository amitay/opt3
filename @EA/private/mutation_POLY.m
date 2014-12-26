%% Polynomial mutation
function [p, fn_evals] = mutation_POLY(ea, p)
    fn_evals = 0;
    x = p;
    for i = 1:ea.prob.nx
        x_min = min(ea.prob.range{i});
        x_max = max(ea.prob.range{i});
        x(:,i) = POLY_array(p(:,i), x_min, x_max, ea.param.mutation_poly_eta);
    end

    r = rand(size(p));
    p(r <= ea.param.mutation_prob) = x( r <= ea.param.mutation_prob);
end

%%
function x= POLY_array(x, x_min, x_max, eta_mu)
    delta1 = (x-x_min) ./ (x_max-x_min);
    delta2 = (x_max-x) ./ (x_max-x_min);
    mut_pow = 1/(eta_mu+1);

    r = rand(size(x));

    xy = 1 - delta1;
    val = 2*r + (1-2*r) .* xy.^(eta_mu+1);
    deltaq = val.^mut_pow - 1;

    xy(r > 0.5) = 1 - delta2(r > 0.5);
    val(r > 0.5) = 2*r(r > 0.5) + 2*(r(r > 0.5) - 0.5) .* xy(r > 0.5).^(eta_mu+1);
    deltaq(r > 0.5) = 1 - val(r > 0.5).^mut_pow;

    x = x + deltaq*(x_max - x_min);
    x(x < x_min) = x_min;
    x(x > x_max) = x_max;
end
