# Modeling the spread of underdominance drives

## R scripts:
* [Simulating reaction-diffusion waves](scripts/numerical-reaction-diffusion-functions.R)
* [3-compartment model waves](scripts/compartment-model.R)
* [Simulating u(x,t=0) and u(x,t=1) with new migration - reaction model: main functions](scripts/functions-main-model.R)
  + [Examples](scripts/examples-main-model.R)

## SLiM models:
* [WF model (note - problem with clustering)](slim/WF-model.slim)
* [nonWF model](slim/nonWF-model.slim)
  + [Order of operations in the model](slim/slim_order_of_operations.md)
  + [Figuring out how / how long to let the wild-type population stabilize](slim/wt-stabilize/wild-type-stabilization.md)


## CLUSTER:

* [R markdown keeping track of jobs (with the delta bug)](cluster/slurm_management.md)
* [Comparing uhat=5, uhat=10, and uhat=20](cluster/redo_delta_uhat_comparison.md)
* [Second cluster runs (4/7 onwards)](cluster_runs_2.md)


### Output from specific runs

* [uhat = 20 output](cluster/uhat20_redo_delta.md)
* [uhat = 10 output](cluster/uhat10_redo_delta.md)
* [uhat = 5 output](cluster/uhat5_redo_delta.md)

## Mathematica:

* [Tutorial](mathematica/mathematica_tutorial.md)
* [AUC (theta) and delta equations in Mathematica notebook](mathematica/AUC_only.nb)
* [R scripts to check the factored equation](scripts/auc-equations.R)

## Model equations

* [See Latex document](correct_model_equations.pdf)

## Still need to:

* Re-run the cluster jobs with a lower range of *a* values (first minimize |delta - 0| based on the corrected delta equation)
  + We don't want the value of a that *minimizes* delta, we want the value of *a* that minimizes |delta| (doing the former could cause you to select the most negative delta).
