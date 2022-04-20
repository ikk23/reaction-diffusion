uhat=40% windowed drive analysis
================
Isabel Kim
4/20/2022

## Parameters

-   Values of a:
    -   a=0.025 –> P(increase) = 0.0
    -   a=0.0654 –> P(increase) = 0.25
    -   a=0.0694 –> P(increase) = 0.50
    -   a=0.0721 –> P(increase) = 0.75
    -   a=0.0748 –> P(increase) = 0.90
-   20 replicates each
-   uhat = 40%
-   sigma = 0.01
-   k = 0.2
-   m = 0.001
-   N = 30,000
-   window = \[0.499, 0.501\]

## Files

-   SLiM model (re-transfer):
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/slim/nonWF-model.slim`
-   Python driver:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/python_driver_windowed.py`
    -   This will print out a csv line for each generation of each
        replicate.
    -   The columns are:
        `a,replicate,gen,overall_d_count, overall_d_rate, windowed_d_count, windowed_dd_count, windowed_dwt_count`
        -   Creates one `X.part` file per value of a
-   Text file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_text/april20_windowed_drive_analysis_uhat40.txt`
-   Main SLURM script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_main/april20_windowed_drive_analysis_uhat40.sh`
    -   **Submitted batch job 4311589 on 4/20 at 11:30**
-   Merge script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.4_run/slurm_merge/merge_april20_windowed_drive_uhat40.sh`
    -   But note that the *unmerged* 5 `.part` files contain results for
        different values of a
    -   This creates `uhat40_april20_windowed_drive_counts.csv`
    -   On the cluster at:
        `/home/ikk23/underdom/merge_scripts/merge_april20_windowed_drive_uhat40.sh`
