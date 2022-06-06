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

### Output

-   Raw csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_vary_m_uhat_k_0.2.csv`
-   Summary csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june6_vary_m_uhat_k_0.2.csv`

``` r
library(tidyverse)

full_csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_vary_m_uhat_k_0.2.csv") %>% arrange(drop_size)
# write out with the drop size least to greatest
#write_csv(x = full_csv, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_vary_m_uhat_k_0.2.csv")

# For each drop size, get the P(increase)
dropsizes = seq(100, 1000, length.out = 50)
drop_size_vector = round(dropsizes)
p_increase_vector = rep(-1,50)

for (i in 1:50){
  m = drop_size_vector[i]
  rows = full_csv %>% filter(drop_size == m)
  p = mean(rows$outcome == "increase")
  p_increase_vector[i] = p
}

summary_csv = tibble(drop_size = drop_size_vector, p_increase = p_increase_vector)
# write out
#write_csv(x = summary_csv, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june6_vary_m_uhat_k_0.2.csv")

p = ggplot(summary_csv, aes(x = drop_size, y = p_increase)) + theme_minimal() + geom_point(color = "red") + geom_line(color = "red") + geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + ggtitle("uhat = 20%, 20 replicates,\ncapacity = 30000, sigma=0.01,\nmating radius = local competition radius = 0.001")
#ggsave(plot = p, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/p_increase_figure_june6_vary_m_uhat_k_0.2.png")
```

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/p_increase_figure_june6_vary_m_uhat_k_0.2.png")
```

![](../new-slim-diffusion-files/cluster_output/p_increase_figure_june6_vary_m_uhat_k_0.2.png)<!-- -->

Drop size of \~800 will yield P(increase) of \~90%.

## Run 100 replicates of a drop size of 800

-   Split this into 4 array jobs of 25 replicates each
-   Text:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_text/focus_june6.txt`
-   Python script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/python_driver_gen_stats.py`
-   SLURM main script:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_scripts/slurm_june6_m800_only.sh`
    -   Submitted at 6:20pm (output will be in
        `/home/ikk23/underdom/out_u20` and I’ll need to merge it myself)
