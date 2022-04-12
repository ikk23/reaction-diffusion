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

### Management 

* [First runs (with the delta bug)](cluster/slurm_management.md)
* [Second cluster run of uhat=20% only (adding the drive in gen 10) on 4/6](cluster/april6-cluster_runs_2.md)
* [uhat=10% and uhat=5% runs on 4/11](cluster/april11-cluster_runs.md)

### Output from specific runs

* April 5th runs (bug in Python script / before letting the wild-type population stabilize):
  + [uhat = 20% output from 4/5](cluster/u_hat=0.2_run/april5-uhat20_redo_delta.md)
  + [uhat = 10% output from 4/5](cluster/u_hat=0.1_run/april5-uhat10_redo_delta.md)
  + [uhat = 5% output from 4/5](cluster/u_hat=0.05_run/april5-uhat5_redo_delta.md)
  + [Comparing the 3 above](cluster/u_hat_comparisons/april5-redo_delta_uhat_comparison.md)


* Week of April 11th runs (10 generations for wild-types to stabilize + fixed bugs in the python + SLiM scripts):
  + [uhat=20% from 4/11](cluster/u_hat=0.2_run/april11-uhat20_wt_gens_results.md)
  + [uhat=10% from 4/12](cluster/u_hat=0.1_run/april12-uhat10_wt_gens_results.md)

## Mathematica:

* [Tutorial](mathematica/mathematica_tutorial.md)
* [AUC (theta) and delta equations in Mathematica notebook](mathematica/AUC_only.nb)
* [R scripts to check the factored equation](scripts/auc-equations.R)

## Model equations

* [See Latex document](correct_model_equations.pdf)

