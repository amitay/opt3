function [flag] = is_valid(surr)

	flag = ~isempty(surr.model_data) & sum(isinf(surr.model_data.error)) == 0;
end
