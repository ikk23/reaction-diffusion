# Modeling the spread of underdominance drives

## R scripts:
* [Simulating reaction-diffusion waves](scripts/numerical-reaction-diffusion-functions.R)
  + [Bistable waves only - examples](bistable-R-waves/examples.md)
* [3-compartment model waves](scripts/compartment-model.R)
* [Simulating u(x,t=0) and u(x,t=1) with new migration - reaction model: main functions](scripts/functions-main-model.R)
  + [Examples](scripts/examples-main-model.R)

## SLiM models:
* [WF model (note - problem with clustering)](slim/WF-model.slim)
* [nonWF model](slim/nonWF-model.slim)
  + [Order of operations in the model](slim/slim_order_of_operations.md)
  + [Figuring out how / how long to let the wild-type population stabilize](slim/wt-stabilize/wild-type-stabilization.md)
  + [Live-plotting on 4/19 (before changing the model)](zero-window/live_plot_results_uhat40.md)


## CLUSTER:

### Management 

* [First runs (with the delta bug)](cluster/slurm_management.md)
* [Second cluster run of uhat=20% only (adding the drive in gen 10) on 4/6](cluster/april6-cluster_runs_2.md)
* [uhat=10%, 5%, 40%, and 15% runs starting on 4/11](cluster/april11-cluster_runs.md)
* [a vs the change in the number of drive alleles for uhat=40% on 4/13](cluster/u_hat=0.4_run/april13-uhat40_a_vs_change_in_dr.md)

### Output from specific runs

* April 5th runs (bug in Python script / before letting the wild-type population stabilize):
  + [uhat = 20% output from 4/5](cluster/u_hat=0.2_run/april5-uhat20_redo_delta.md)
  + [uhat = 10% output from 4/5](cluster/u_hat=0.1_run/april5-uhat10_redo_delta.md)
  + [uhat = 5% output from 4/5](cluster/u_hat=0.05_run/april5-uhat5_redo_delta.md)
  + [Comparing the 3 above](cluster/u_hat_comparisons/april5-redo_delta_uhat_comparison.md)


* Week of April 11th runs (10 generations for wild-types to stabilize + fixed bugs in the python + SLiM scripts):
  + [uhat=40% from 4/12](cluster/u_hat=0.4_run/april12-uhat40_wt_gens_results.md)
  + [uhat=20% from 4/11](cluster/u_hat=0.2_run/april11-uhat20_wt_gens_results.md)
  + [uhat=15% from 4/13](cluster/u_hat=0.15_run/april13-uhat15_wt_gens_results.md)
  + [uhat=10% from 4/12](cluster/u_hat=0.1_run/april12-uhat10_wt_gens_results.md)
  + [uhat=5% from 4/12](cluster/u_hat=0.05_run/april12-uhat5_wt_gens_results.md)
  + [Comparing these](cluster/u_hat_comparisons/april12-uhat_comparison.md)
 
## Mathematica:

* [Tutorial](mathematica/mathematica_tutorial.md)
* [AUC (theta) and delta equations in Mathematica notebook](mathematica/AUC_only.nb)
* [R scripts to check the factored equation](scripts/auc-equations.R)
* [Verifying that the SLiM model matches the mathematical predictions](bistable-R-waves/cluster_ux.md)

## Model equations

* [See Latex document](correct_model_equations.pdf)

## Revised SLiM model -- cluster results (4/19/22 on)

* [a vs the change in the number of drive alleles for uhat=40% on 4/19](cluster/u_hat=0.4_run/april19-uhat40_a_vs_change_in_dr_revised_model.md)
* [full range of a vs outcome](cluster/u_hat=0.4_run/april19-uhat40_a_vs_p_increase.md)
* [uhat=40% windowed drive analysis on the cluster for 5 values of a on 4/20](cluster/u_hat=0.4_run/april20-uhat40_windowed_drive_counts.md)
* [uhat=40% analysis of u(t) in the small window for 5 values of a on 4/20](cluster/u_hat=0.4_run/april20-ut_windowed_uhat40.md)


## Drive allele fitness and other metrics (5/15+)

* [Drive fitness](bistable-R-waves/overall-drive-fitness.md)
* [Four metrics - overall number of drive alleles, number of dd, number of dwt, and drive allele fitness](bistable-R-waves/4_graphs_5_a.md)


