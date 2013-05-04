%% Open logger
function [logger] = open(logger)
	logger.fp = fopen(logger.filename, 'w');	
end
