Cluster
================
Isabel Kim
6/6/2022

## Goal

-   Vary the drop size (m)
    -   Do 20 replicates of each
    -   Calculate the P(increase) over all replicates
-   Determine the “critical m” at which P(increase) = 90%
    -   Go back to this m\*, running like 100 replicates
    -   Average over the 100 m\* replicates; then plot the average
        number of drive alleles over time.
        -   Does this increase monotonically?

## Python script

-   Run SLiM for 100 generations
-   Just control `DRIVE_DROP_SIZE`
-   Script: `python_driver_vary_m.py`

## First run

-   Let’s do 20 replicates of 50 different drop size values, with a
    minimum of 100 (should always decrease) and maximum of 1000 (should
    always increase)
-   Text file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_text/june6_varym.txt`
-   Python file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/python_driver_vary_m.py`
-   SLiM file:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/nonWF-diffusion-model.slim`
-   SLURM script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_scripts/slurm_june6_varym.sh`
    -   Running as of 4:15 on 6/6
-   SLURM merge script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_scripts/slurm_june6_varym_merge.sh`
    -   On the cluster as
        `/home/ikk23/underdom/merge_scripts/slurm_june6_varym_merge.sh`,
        ready to use
