%% Message display
function [logger] = Logger(prefix, batch_mode, varargin)

	logger.filename = '';
	logger.batch_mode = 0;
	logger.fp = [];

	logger = class(logger, 'Logger');

	if nargin >= 2
		logger.filename = sprintf('%s.log', prefix);
		logger.batch_mode = batch_mode;

		append_flag = 0;
		if nargin == 3
			append_flag = varargin{1};
		end

		if append_flag == 0
			logger = open(logger);
		else
			logger = reopn(logger);
		end
	end
end
