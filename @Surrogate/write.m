%% Display messages
function write(surr, varargin)
	if ~isempty(surr.logger)
		write(surr.logger, varargin{:});
	else
		fprintf(varargin{:});
	end
end

