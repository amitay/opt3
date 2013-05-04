This is the version 3 of the Evolutionary optimization framework.

To use the optimization code, add following directories in the path.

opt3/
opt3/mex
opt3/utis

To run Evolutionary Algorithm (EA) code, 

>> ea = EA('problem', 'algorithm');
>> ea = run(ea);

Replace problem with the name of the problem
Replace algorithm with the name of the algorithm. 

Following algorithms are available under the EA framework.

 o NSGA2 - Non-dominated Sorting Genetic Algorithm II
 o IDEA - Infeasibility Driven Evolutionary Algorithm
 o DE - Differential Evolution (basic)
 o SAEA - Surrgate Assisted Evolutionary Algorithm
 o SAMR - Surrogate Assisted Memetic Recombination
 o IEMA - Infeability Driven Memetic Algorithm
 o HMA - Hybrid Memetic Algorithm

After running the code, the output is written in two files

 1. <problem>-<algorithm>-all.dat

    This file stores the population for all the generations. The format of
    this file is as follows:

       gen_id pop_id feas_flag f_vector g_vector x_vector

    o gen_id - generation
    o pop_id - id of the solution in population
    o feas_flag - whether the solution is feasible (1) or not feasible (0)
    o f_vector - objective function(s)
    o g_vector - constraint function(s)
    o x_vector - solution

 2. <problem>-<algorithm>-best.dat

    This file stores the best solutions for all the generations. The format
    of this file is as follows:
  
       gen_id fn_evals feas_flag f_vector g_vector x_vector

    o gen_id - generation
    o fn_evals - number of function evaluations
    o feas_flag - whether the solution is feasible (1) or not feasible (0)
    o f_vector - objective function(s)
    o g_vector - constraint function(s)
    o x_vector - solution

     

