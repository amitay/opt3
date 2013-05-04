%% Handles User-defined parameters
function [obj] = Paramset(varargin)
	obj.param = [];
	obj.value = [];
	obj.ivalue = [];

	obj = class(obj, 'Paramset');

	if nargin == 1
		if isa(varargin{1}, 'Paramset')
			obj = varargin{1};
		else
			obj.ivalue = varargin{1};
		end
	end

	obj = load(obj);
end
