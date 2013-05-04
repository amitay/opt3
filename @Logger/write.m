%% Log message to logger
function write(logger, varargin)
	if ~isempty(logger.fp)
		fprintf(logger.fp, varargin{:});
	end
	if logger.batch_mode == 0 || logger.batch_mode == 1
		fprintf(varargin{:});
	end
end
