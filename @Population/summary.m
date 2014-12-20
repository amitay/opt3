%% Display population summary
function summary(pop, varargin)

	if nargin == 2
		logger = varargin{1};
	else
		logger = Logger();
	end
	id = find_best(pop);

	mesg = '';
	% Display f/g/fn_evals
	for i = 1:pop.nf
		tmp = sprintf(' %g', pop.f(id,i));
		mesg = strcat(mesg, tmp);
	end
	if pop.feas(id) == 0
		tmp = sprintf(' (%g)', pop.cv(id));
		mesg = strcat(mesg, tmp);
	end
	write(logger, '\tObjectives: [%s ]\n', mesg);
	mesg = '';
	for i = 1:pop.ng
		tmp = sprintf(' %g', pop.g(id,i));
		mesg = strcat(mesg, tmp);
	end
	write(logger, '\tConstraints: [%s ]\n', mesg);

	if pop.nf > 1
		nd = find(pop.nd_rank == 1);
		write(logger, '\tNon-Dominated: %d\n', length(nd));
	end
	write(logger, '\tFeasible: %d\n', sum(pop.feas));
	mesg = '';
	for i = 1:pop.nx
		tmp = sprintf(' %g', pop.x(id,i));
		mesg = strcat(mesg, tmp);
	end
	write(logger, '\tDesign: [%s ]\n', mesg);
end
