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

### Output

-   Compiled full csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_uhat_k_0.2_m800_only.csv`
-   Summary csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june6_uhat_k_0.2_m800_only.csv`

``` r
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/raw/"
for (i in 1:4){
  name = paste0(dir,"out",i,".csv")
  output = read_csv(name)
  if (i == 1){
    compiled_output = output
  } else {
    compiled_output = rbind(compiled_output,output)
  }
}
# Add column for replicate number
starts = seq(1, nrow(compiled_output), by = 110)
ends = starts + 109
nparams = length(starts)
replicate_number = rep(-1,nrow(compiled_output))
for (j in 1:nparams){
  s = starts[j]
  e = ends[j]
  replicate_number[s:e] = j
}
compiled_output_edit = compiled_output %>% add_column(replicate = replicate_number)
# write out; delete other part files
#write_csv(x = compiled_output_edit, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_uhat_k_0.2_m800_only.csv")

# Create generation-averaged csv
generation_vector = min(compiled_output_edit$gen):max(compiled_output_edit$gen)
avg_popsize = rep(-1, length(generation_vector))
avg_num_dd = rep(-1, length(generation_vector))
avg_num_dwt = rep(-1, length(generation_vector))
avg_num_wtwt = rep(-1, length(generation_vector))
avg_num_d_alleles = rep(-1, length(generation_vector))
avg_rate_d_alleles = rep(-1, length(generation_vector))
num_replicates = rep(-1, length(generation_vector))

for (i in 1:length(generation_vector)){
  g = generation_vector[i]
  rows = compiled_output_edit %>% filter(gen == g)
  avg_popsize[i] = mean(rows$popsize)
  avg_num_dd[i] = mean(rows$num_dd)
  avg_num_dwt[i] = mean(rows$num_dwt)
  avg_num_wtwt[i] = mean(rows$num_wtwt)
  avg_num_d_alleles[i] = mean(rows$num_d_alleles)
  avg_rate_d_alleles[i] = mean(rows$rate_d_alleles)
  num_replicates[i] = nrow(rows)
}

avg_csv = tibble(gen = generation_vector,
                 avg_popsize = avg_popsize,
                 avg_num_dd = avg_num_dd,
                 avg_num_dwt = avg_num_dwt,
                 avg_num_wtwt = avg_num_wtwt,
                 avg_num_d_alleles = avg_num_d_alleles,
                 avg_rate_d_alleles = avg_rate_d_alleles,
                 num_replicates = num_replicates)
# write out
#write_csv(x = avg_csv, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june6_uhat_k_0.2_m800_only.csv")

# Plot 1 replicate only and the averaged plot
r = sample(generation_vector,1) # replicate 9

one_rep_only = compiled_output_edit %>% filter(replicate == 9)

# Number of drive alleles
ndp = ggplot(one_rep_only, aes(x = gen, y = num_d_alleles)) + geom_line(color = "red") + geom_point(color = "red") + xlab("Generation") + ylab("Number of drive alleles") + ggtitle("Drop size of 800, 1 replicate only") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = ndp, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m800.png")


# Population size
ppp = ggplot(one_rep_only, aes(x = gen, y = popsize)) + geom_line(color = "purple") + geom_point(color = "purple") + xlab("Generation") + ylab("Population size") + ggtitle("Drop size of 800, 1 replicate only") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0) + ylim(min(one_rep_only$popsize), max(one_rep_only$popsize))
#ggsave(plot = ppp, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m800.png")

# Plot averaged stats
avg_d = ggplot(avg_csv, aes(x = gen, y = avg_num_d_alleles)) + geom_line(color = "red") + geom_point(color = "red") + xlab("Generation") + ylab("Average number of drive alleles") + ggtitle("Drop size of 800, averaged 100 replicates") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = avg_d, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m800.png")

avg_popsize = ggplot(avg_csv, aes(x = gen, y = avg_popsize)) + geom_line(color = "purple") + geom_point(color = "purple") + xlab("Generation") + ylab("Average population size") + ggtitle("Drop size of 800, averaged 100 replicates") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0) + ylim(min(avg_csv$avg_popsize), max(avg_csv$avg_popsize))
#ggsave(plot = avg_popsize, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_popsize_m800.png")

avg_dd = ggplot(avg_csv, aes(x = gen)) + 
  geom_line(aes(y = avg_num_dd),color = "red") + 
  geom_line(aes(y = avg_num_dwt), color = "orange") + 
  geom_line(aes(y = avg_num_wtwt), color = "blue") + 
  xlab("Generation") + ylab("Average count") + 
  ggtitle("Drop size of 800, averaged 100 replicates \nblue = wt, red = d/d, orange = d/wt") + 
  theme_minimal() + geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0)
#ggsave(plot = avg_dd, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_genotype_counts_m800.png")
```

#### Averaged plots

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m800.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m800.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_popsize_m800.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_popsize_m800.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m800.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m800.png)<!-- -->

#### One replicate only

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m800.png")
```

![](../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m800.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m800.png")
```

![](../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m800.png)<!-- -->

Monotonic increase in the number of drive alleles

## More cluster runs: a dropsize that yields P(increase)=0 and P(increase)=50%

-   For P(increase)=0, drop size = 300

-   For P(increase)=50, drop size = 625

-   Text files:

    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_text/june6_m300.txt`
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_text/june6_m625.txt`

-   SLURM scripts:

    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_scripts/slurm_june6_m300_only.sh`
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/slurm_scripts/slurm_june6_m625.sh`
    -   Submitted both at 8:46pm

### Output

-   Compiled csvs:
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m300_only.csv`
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m625_only.csv`
-   Averaged csvs:
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june7_uhat_k_0.2_m300_only.csv`
    -   `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june7_uhat_k_0.2_m625_only.csv`

``` r
# Compile csvs
library(tidyverse)
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/raw/"
for (i in 1:4){
  name_m300 = paste0(dir,"m300_",i,".csv")
  name_m625 = paste0(dir,"m625_",i,".csv")
  csv_m300 = read_csv(name_m300)
  csv_m625 = read_csv(name_m625)
  if (i == 1){
    compiled_output_m300 = csv_m300
    compiled_output_m625 = csv_m625
  } else {
    compiled_output_m300 = rbind(compiled_output_m300,csv_m300)
    compiled_output_m625 = rbind(compiled_output_m625,csv_m625)
  }
}
# Add column for replicate number
starts_m300 = seq(1, nrow(compiled_output_m300), by = 110)
ends_m300 = starts_m300 + 109
starts_m625 = seq(1, nrow(compiled_output_m625), by = 110)
ends_m625 = starts_m625 + 109

nparams_m300 = length(starts_m300)
nparams_m625 = length(starts_m625) # both are 100

replicate_number_m300 = rep(-1,11000)
replicate_number_m625 = rep(-1,11000)

for (j in 1:nparams_m300){
  s = starts_m300[j]
  e = ends_m300[j]
  replicate_number_m300[s:e] = j
  replicate_number_m625[s:e] = j
}
compiled_output_edit_m300 = compiled_output_m300 %>% add_column(replicate = replicate_number_m300)
compiled_output_edit_m625 = compiled_output_m625 %>% add_column(replicate = replicate_number_m625)
# Write both of them out
# write_csv(x = compiled_output_edit_m300, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m300_only.csv")
#write_csv(x = compiled_output_edit_m625, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m625_only.csv")

# Averaged csvs
m300 = compiled_output_edit_m300
m625 = compiled_output_edit_m625

generation_vector_m300 = min(m300$gen):max(m300$gen)
avg_popsize_m300 = rep(-1, 110)
avg_num_dd_m300 = rep(-1, 110)
avg_num_dwt_m300 = rep(-1, 110)
avg_num_wtwt_m300 = rep(-1, 110)
avg_num_d_alleles_m300 = rep(-1, 110)
avg_rate_d_alleles_m300 = rep(-1, 110)
num_replicates_m300 = rep(-1, 110)

generation_vector_m625 = min(m625$gen):max(m625$gen)
avg_popsize_m625 = rep(-1,110)
avg_num_dd_m625 = rep(-1,110)
avg_num_dwt_m625 = rep(-1,110)
avg_num_wtwt_m625 = rep(-1,110)
avg_num_d_alleles_m625 = rep(-1,110)
avg_rate_d_alleles_m625 = rep(-1,110)
num_replicates_m625 = rep(-1,110)

for (i in 1:110){
  g_m300 = generation_vector_m300[i]
  g_m625 = generation_vector_m625[i]
  
  rows_m300 = m300 %>% filter(gen == g_m300)
  rows_m625 = m625 %>% filter(gen == g_m625)
  
  avg_popsize_m300[i] = mean(rows_m300$popsize)
  avg_popsize_m625[i] = mean(rows_m625$popsize)
  
  avg_num_dd_m300[i] = mean(rows_m300$num_dd)
  avg_num_dd_m625[i] = mean(rows_m625$num_dd)
  
  avg_num_dwt_m300[i] = mean(rows_m300$num_dwt)
  avg_num_dwt_m625[i] = mean(rows_m625$num_dwt)
  
  avg_num_wtwt_m300[i] = mean(rows_m300$num_wtwt)
  avg_num_wtwt_m625[i] = mean(rows_m625$num_wtwt)
  
  avg_num_d_alleles_m300[i] = mean(rows_m300$num_d_alleles)
  avg_num_d_alleles_m625[i] = mean(rows_m625$num_d_alleles)
  
  avg_rate_d_alleles_m300[i] = mean(rows_m300$rate_d_alleles)
  avg_rate_d_alleles_m625[i] = mean(rows_m625$rate_d_alleles)

  num_replicates_m300[i] = nrow(rows_m300)
  num_replicates_m625[i] = nrow(rows_m625)
}

avg_csv_m300 = tibble(gen = generation_vector_m300,
                 avg_popsize = avg_popsize_m300,
                 avg_num_dd = avg_num_dd_m300,
                 avg_num_dwt = avg_num_dwt_m300,
                 avg_num_wtwt = avg_num_wtwt_m300,
                 avg_num_d_alleles = avg_num_d_alleles_m300,
                 avg_rate_d_alleles = avg_rate_d_alleles_m300,
                 num_replicates = num_replicates_m300)
avg_csv_m625 = tibble(gen = generation_vector_m625,
                 avg_popsize = avg_popsize_m625,
                 avg_num_dd = avg_num_dd_m625,
                 avg_num_dwt = avg_num_dwt_m625,
                 avg_num_wtwt = avg_num_wtwt_m625,
                 avg_num_d_alleles = avg_num_d_alleles_m625,
                 avg_rate_d_alleles = avg_rate_d_alleles_m625,
                 num_replicates = num_replicates_m625)
# write out
#write_csv(x = avg_csv_m300, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june7_uhat_k_0.2_m300_only.csv")
#write_csv(x = avg_csv_m625, file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/summary_june7_uhat_k_0.2_m625_only.csv")

# Plot 1 replicate only 
r = sample(generation_vector_m625,1) # replicate 84

m300_one_rep = m300 %>% filter(replicate == 84)
m625_one_rep = m625 %>% filter(replicate == 84)

# Number of drive alleles 
drives_m300 = ggplot(m300_one_rep, aes(x = gen, y = num_d_alleles)) + 
  geom_line(color = "red") +
  geom_point(color = "red") +
  xlab("Generation") + ylab("Number of drive alleles") + 
  ggtitle("Drop size of 300, 1 replicate only") + theme_minimal() + 
  geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = drives_m300, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m300.png")

drives_m625 = ggplot(m625_one_rep, aes(x = gen, y = num_d_alleles)) + 
  geom_line(color = "red") + geom_point(color = "red") + 
  xlab("Generation") + ylab("Number of drive alleles") + 
  ggtitle("Drop size of 625, 1 replicate only") + 
  theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = drives_m625, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m625.png")

popsize_m300 = ggplot(m300_one_rep, aes(x = gen, y = popsize)) + 
  geom_line(color = "purple") + geom_point(color = "purple") + xlab("Generation") + 
  ylab("Population size") + ggtitle("Drop size of 300, 1 replicate only") + 
  theme_minimal() + 
  geom_vline(xintercept = 0) + ylim(min(m300_one_rep$popsize), max(m300_one_rep$popsize))
ggsave(plot = popsize_m300, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m300.png")

popsize_m625 = ggplot(m625_one_rep, aes(x = gen, y = popsize)) + 
  geom_line(color = "purple") + geom_point(color = "purple") + xlab("Generation") + 
  ylab("Population size") + ggtitle("Drop size of 625, 1 replicate only") + 
  theme_minimal() + 
  geom_vline(xintercept = 0) + ylim(min(m625_one_rep$popsize), max(m625_one_rep$popsize))

ggsave(plot = popsize_m625, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m625.png")


# Plot averaged stats
avg_d_m300 = ggplot(avg_csv_m300, aes(x = gen, y = avg_num_d_alleles)) + geom_line(color = "red") + geom_point(color = "red") + xlab("Generation") + ylab("Average number of drive alleles") + ggtitle("Drop size of 300, averaged 100 replicates") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = avg_d_m300, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m300.png")
avg_d_m625 = ggplot(avg_csv_m625, aes(x = gen, y = avg_num_d_alleles)) + geom_line(color = "red") + geom_point(color = "red") + xlab("Generation") + ylab("Average number of drive alleles") + ggtitle("Drop size of 625, averaged 100 replicates") + theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
#ggsave(plot = avg_d_m625, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m625.png")

avg_popsize_m300 = ggplot(avg_csv_m300, aes(x = gen, y = avg_popsize)) + 
  geom_line(color = "purple") + 
  geom_point(color = "purple") + 
  xlab("Generation") + ylab("Average population size") + 
  ggtitle("Drop size of 300, averaged 100 replicates") + theme_minimal() + 
  geom_hline(yintercept = 0) + geom_vline(xintercept = 0) + 
  ylim(min(avg_csv_m300$avg_popsize), max(avg_csv_m300$avg_popsize))
#ggsave(plot = avg_popsize_m300, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_popsize_m300.png")
avg_popsize_m625 = ggplot(avg_csv_m625, aes(x = gen, y = avg_popsize)) + 
  geom_line(color = "purple") + 
  geom_point(color = "purple") + 
  xlab("Generation") + ylab("Average population size") + 
  ggtitle("Drop size of 625, averaged 100 replicates") + theme_minimal() + 
  geom_hline(yintercept = 0) + geom_vline(xintercept = 0) + 
  ylim(min(avg_csv_m625$avg_popsize), max(avg_csv_m625$avg_popsize))
#ggsave(plot = avg_popsize_m625, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_popsize_m625.png")


avg_dd_m300 = ggplot(avg_csv_m300, aes(x = gen)) + 
  geom_line(aes(y = avg_num_dd),color = "red") + 
  geom_line(aes(y = avg_num_dwt), color = "orange") + 
  geom_line(aes(y = avg_num_wtwt), color = "blue") + 
  xlab("Generation") + ylab("Average count") + 
  ggtitle("Drop size of 300, averaged 100 replicates \nblue = wt, red = d/d, orange = d/wt") + 
  theme_minimal() + geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0)
#ggsave(plot = avg_dd_m300, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_genotype_counts_m300.png")

avg_dd_m625 = ggplot(avg_csv_m625, aes(x = gen)) + 
  geom_line(aes(y = avg_num_dd),color = "red") + 
  geom_line(aes(y = avg_num_dwt), color = "orange") + 
  geom_line(aes(y = avg_num_wtwt), color = "blue") + 
  xlab("Generation") + ylab("Average count") + 
  ggtitle("Drop size of 625, averaged 100 replicates \nblue = wt, red = d/d, orange = d/wt") + 
  theme_minimal() +
  geom_vline(xintercept = 0)


#ggsave(plot = avg_dd_m625, filename = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/avg_genotype_counts_m625.png")
```

Averaged plots

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m300.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m300.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m625.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_num_drive_alleles_m625.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_popsize_m300.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_popsize_m300.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_popsize_m625.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_popsize_m625.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m300.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m300.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m625.png")
```

![](../new-slim-diffusion-files/cluster_output/avg_genotype_counts_m625.png)<!-- -->

One replicate plots

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m300.png")
```

![](../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m300.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m625.png")
```

![](../new-slim-diffusion-files/cluster_output/num_drive_alleles_1_rep_only_m625.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m300.png")
```

![](../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m300.png)<!-- -->

``` r
knitr::include_graphics("../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m625.png")
```

![](../new-slim-diffusion-files/cluster_output/popsize_1_rep_only_m625.png)<!-- -->

## Calculate P(increase) for the 3 different drop-sizes

-   m300 =
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m300_only.csv`
-   m625 =
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m625_only.csv`
-   m800 =
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_uhat_k_0.2_m800_only.csv`

``` r
library(tidyverse)
m300 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m300_only.csv")
replicate_vector = min(m300$replicate):max(m300$replicate) # 100
outcome = rep("*",100)
for (i in 1:100){
  rows = m300 %>% filter(replicate == i)
  initial_drive_rate = rows %>% filter(gen == 0) %>% .$rate_d_alleles
  final_drive_rate = rows %>% filter(gen == max(rows$gen)) %>% .$rate_d_alleles
  if (initial_drive_rate >= final_drive_rate){
    outcome[i] = "decrease"
  } else {
    outcome[i] = "increase"
  }
  if (final_drive_rate == 1){
    outcome[i] = "increase"
  }
}
p_increase = mean(outcome == "increase")

m625 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june7_uhat_k_0.2_m625_only.csv")
replicate_vector = min(m625$replicate):max(m625$replicate) # 100
outcome = rep("*",100)
for (i in 1:100){
  rows = m625 %>% filter(replicate == i)
  initial_drive_rate = rows %>% filter(gen == 0) %>% .$rate_d_alleles
  final_drive_rate = rows %>% filter(gen == max(rows$gen)) %>% .$rate_d_alleles
  if (initial_drive_rate >= final_drive_rate){
    outcome[i] = "decrease"
  } else {
    outcome[i] = "increase"
  }
  if (final_drive_rate == 1){
    outcome[i] = "increase"
  }
}
p_increase = mean(outcome == "increase")


m800 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/cluster_output/june6_uhat_k_0.2_m800_only.csv")
replicate_vector = min(m800$replicate):max(m800$replicate) # 100
outcome = rep("*",100)
for (i in 1:100){
  rows = m800 %>% filter(replicate == i)
  initial_drive_rate = rows %>% filter(gen == 0) %>% .$rate_d_alleles
  final_drive_rate = rows %>% filter(gen == max(rows$gen)) %>% .$rate_d_alleles
  if (initial_drive_rate >= final_drive_rate){
    outcome[i] = "decrease"
  } else {
    outcome[i] = "increase"
  }
  if (final_drive_rate == 1){
    outcome[i] = "increase"
  }
}
p_increase = mean(outcome == "increase")
```

-   For m=300, P(increase) = 0%.
-   For m=625, P(increase) = 22%
-   For m=800, P(increase) = 97%

View a decrease for m800

``` r
rep18 = m800 %>% filter(replicate == 18)

drives = ggplot(rep18, aes(x = gen, y = num_d_alleles)) + 
  geom_line(color = "red") + geom_point(color = "red") + 
  xlab("Generation") + ylab("Number of drive alleles") + 
  ggtitle("Drop size of 800, 1 replicate only") + 
  theme_minimal() + geom_hline(yintercept = 0) + geom_vline(xintercept = 0)
```
