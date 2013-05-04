%% Append logger
function [logger] = reopen(logger)
	logger.fp = fopen(logger.filename, 'a+');
end
