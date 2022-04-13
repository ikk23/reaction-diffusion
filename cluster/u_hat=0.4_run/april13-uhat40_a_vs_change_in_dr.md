uhat=40% a vs change in number of drive alleles
================
Isabel Kim
4/13/2022

## Description

-   For a given value of a:
    -   Run SLiM 100 times
    -   Obtain just the change in the number of drive alleles from gen11
        to gen10
    -   In csv, print *a* vs *change*
-   Make sure there are a good amount of *a* values below a_predicted
    and above a_predicted (based on the delta equation)
-   Other parameters to keep constant from run to run:
    -   sigma = m = 0.01
    -   k = 0.2
    -   u_hat = 0.4
    -   N = 30,000
    -   Stop the simulation at generation 11
        -   Changing the SLiM simulation to reflect this (transfer new
            version)
-   Need a new python driver parsing function
    -   `python_driver_num_drives.py` – use this instead. Only need to
        specify -a

## a values from before

-   The predicted value of a that will cause delta=0 is a_predicted =
    0.0258
-   But the observed value of a that caused P(increase)=50% was
    a_observed = 0.0682
-   The value of a beyond which/at which P(increase)=100% was a_upper =
    0.07884 –> round to 0.08

### Values to focus on

-   focus mostly on a = 0.01 to a = 0.1

``` r
a_values = seq(0.01,0.1,length.out=200) # 200 jobs --> a increases by 0.00045 only

a_pred_diff = abs(a_values - 0.0258)
a_pred_ind = which.min(a_pred_diff) # 36
a_value_concentrate = a_values[a_pred_ind] # the 36th job is a* = 0.02582915

a_obs_diff = abs(a_values - 0.0682)
a_obs_ind = which.min(a_obs_diff) # 130
a_obs_concentrate = a_values[a_obs_ind] # the 130th job is a_observed = 0.06834171
```

## Files

-   slim file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/slim/nonWF-model.slim`
    -   on the cluster:
        `/home/ikk23/underdom/main_scripts/nonWF-model.slim`
-   python driver (new):
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/python_driver_num_drives.py`
    -   on the cluster:
        `/home/ikk23/underdom/main_scripts/python_driver_num_drives.py`
-   text file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_text/uhat40_a_vs_dr_change_april13.txt`
    -   on the cluster:
        `/home/ikk23/underdom/text_files/uhat40_a_vs_dr_change_april13.txt`
-   main SLURM script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_main/uhat40_april13_a_vs_change_main.sh`
    -   on the cluster:
        `/home/ikk23/underdom/vary_a_scripts/uhat40_april13_a_vs_change_main.sh`
    -   **Submitted batch job 4301202 on 4/13 at 7:06pm**
-   merge SLURM script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_merge/uhat40_april13_a_vs_change_merge.sh`
    -   creates:
        `/home/ikk23/underdom/out_u40/uhat40_april13_a_vs_change.csv` on
        the cluster
    -   on the cluster:
        `/home/ikk23/underdom/merge_scripts/uhat40_april13_a_vs_change_merge.sh`