# Modeling the spread of underdominance drives

## R scripts:
* [Simulating reaction-diffusion waves](scripts/numerical-reaction-diffusion-functions.R)
* [3-compartment model waves](scripts/compartment-model.R)
* [Simulating u(x,t=0) and u(x,t=1) with new migration - reaction model](scripts/functions-main-model.R)
  + [Examples](scripts/examples-main-model.R)

## SLiM models:
* [WF model (note - problem with clustering)](slim/WF-model.slim)
* [nonWF model](slim/nonWF-model.slim)


## CLUSTER output:

* [R markdown keeping track of jobs (with the delta bug)](cluster/slurm_management.md)
* [Comparing uhat=5, uhat=10, and uhat=20](cluster/redo_delta_uhat_comparison.md)

### Specific runs

* [uhat = 20 output](cluster/uhat20_redo_delta.md)
* [uhat = 10 output](cluster/uhat10_redo_delta.md)
* [uhat = 5 output](cluster/uhat5_redo_delta.md)

## Mathematica:

* [Tutorial](mathematica_tutorial.md)
* [AUC (theta) and delta equations](AUC_only.nb)
