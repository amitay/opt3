%% Data Clustering
function [cdata] = Cluster(data, seed, method, varargin)

	% Save random state
	rand_state = RandStream.getDefaultStream.State;

	% Start new random
	rand('twister', seed);

	cdata.centroid = [];
	cdata.id = {};

	switch method
		case 'k_means'
			if nargin ~= 4
				error('Fourth argument (number of clusters) missing');
			end
			k = varargin{1};
			warning('off', 'all');
			[IDX, C] = kmeans(data, k, 'EmptyAction', 'singleton', ...
							'Replicates', 5, 'Display', 'off');
			warning('on', 'all');
			cdata.centroid = C;
			for i = 1:k
				cdata.id{i} = find(IDX == i);
			end
		case 'k_medoids'
			if nargin ~= 4
				error('Fourth argument (number of clusters) missing');
			end
			k = varargin{1};
			warning('off', 'all');
			[IDX, C] = kmeans(data, k, 'EmptyAction', 'singleton', ...
							'Replicates', 5, 'Display', 'off');
			warning('on', 'all');
			for i = 1:k
				id = find(IDX == i);
				cdata.id{i} = id;
				tmp = data(id,:) - repmat(C(i,:), length(id), 1);
				dist = sum(tmp .* tmp, 2);
				[tmp, I] = min(dist);
				cdata.centroid(i) = id(I);
			end
		otherwise
			error('Unknown clustering method');
	end

	cdata = class(cdata, 'Cluster');

	% Restore random state
	RandStream.getDefaultStream.State = rand_state;
end
