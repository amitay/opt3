%% Re-open logger
function [logger] = save(logger)
	close(logger);
	logger = reopen(logger);
end
