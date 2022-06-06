2-step density control
================
Isabel Kim
6/6/2022

## Function

``` r
additional_number_of_offspring = function(local_number, expected_number, max_addition, factor){
  sol = max_addition*exp((-factor*local_number)/expected_number)
  return(sol)
}
```

## Looping through different decay factors

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.6     ✓ dplyr   1.0.8
    ## ✓ tidyr   1.2.0     ✓ stringr 1.4.0
    ## ✓ readr   2.1.2     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
decay_factor = 5
expected_number=60
max_addition=10

local_numbers = seq(0,100)
addition = rep(-1,length(local_numbers))

for (i in 1:length(local_numbers)){
  local = local_numbers[i]
  addition[i] = additional_number_of_offspring(local,expected_number,max_addition,decay_factor)
}
t = tibble(local_density = local_numbers, additional_num_offspring = addition)
g = ggplot(t,aes(x = local_density, y = additional_num_offspring)) + geom_line(color = "green")+theme_minimal() + geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + ggtitle(paste0(max_addition,"e^{-",decay_factor,"ni/nexp}"))
print(g)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
ggsave(filename = "/Users/isabelkim/Desktop/additional_number_offspring_when_exp60.png",plot = g)
```

    ## Saving 7 x 5 in image

Let’s go with 5.

## Plotting the number of drive alleles and population size

### Initial – additional = 10\*exp(-5competition_factor) and global fitnessScaling with capacity = WT_SIZE + DROP_SIZE

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/initial_two_step.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/initial_two_step.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/initial_two_step.csv")
```

    ## Rows: 57 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
plot_num_drive_alleles = ggplot(output, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 100 into 30,000")
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
plot_N_over_time = ggplot(output, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 100 into 30,000")
print(plot_N_over_time)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->
\* Population size is staying pretty constant \* The number of drive
alleles declines but with a pretty normal shape

### Increase drop size to 1000

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/two_step_m1000.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/two_step_m1000.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/two_step_m1000.csv")
```

    ## Rows: 201 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
plot_num_drive_alleles = ggplot(output, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 1000 into 30,000")
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
plot_N_over_time = ggplot(output, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000")
print(plot_N_over_time)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->
Really weird shape. Population size (and number of drive alleles)
increases \~linearly towards the end (because of viability selection)?
Try decreasing the capacity to 30,000 again and running the simulation
for longer. Once the drive allele has fixed, the population size should
stabilize.

### Decrease global capacity to 30,000 and run simulation longer (drop size still 1000)

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_two_step.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_two_step_capacity_30k.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_two_step_capacity_30k.csv")
```

    ## Rows: 292 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
plot_num_drive_alleles = ggplot(output, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 1000 into 30,000")
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
plot_N_over_time = ggplot(output, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000")
print(plot_N_over_time)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->
Is this increase okay?

## Checks: set k=0 s.t. the drive doesn’t have any fitness advantage. Drop size of 1000 (3% introduction frequency)

The population size and number of drive alleles should stay \~ constant

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/checks_m1000.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/checks_m1000.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/checks_m1000.csv")
```

    ## Rows: 196 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
plot_num_drive_alleles = ggplot(output, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 1000 into 30,000")
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

``` r
plot_rate_drive = ggplot(output, aes(x = gen, y = rate_d_alleles)) + theme_minimal() + ylim(0,0.035)+
  geom_line(color = "orange") + xlab("gen") + ylab("rate of drive alleles") + ggtitle("Drop size of 1000 into 30,000")
print(plot_rate_drive)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

``` r
plot_N_over_time = ggplot(output, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000")
print(plot_N_over_time)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->
Why does the number of drive alleles dip and then increase \~gen50?
Re-run and see if this happens again…

Population size stays pretty constant.

## Checks: set k=0 round 2

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/checks_m1000.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/second_checks_m1000.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/second_checks_m1000.csv")
```

    ## Rows: 401 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
gen = c(-9:-1, output$gen)
num_d = c(rep(0,9),output$num_d_alleles)
rate_d = c(rep(0,9), output$rate_d_alleles)
popsize_vec = c(30000, 29954, 29922, 30199, 29955, 30138, 30043, 30025, 29694,output$popsize)
full_info = tibble(gen = gen, num_d_alleles = num_d, rate_d_alleles = rate_d, popsize = popsize_vec)

plot_num_drive_alleles = ggplot(full_info, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 1000 into 30,000") +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0)
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
plot_rate_drive = ggplot(full_info, aes(x = gen, y = rate_d_alleles)) + theme_minimal() + ylim(0,0.035)+
  geom_line(color = "orange") + xlab("gen") + ylab("rate of drive alleles") + ggtitle("Drop size of 1000 into 30,000") +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0)

print(plot_rate_drive)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-12-2.png)<!-- -->

``` r
plot_N_over_time = ggplot(full_info, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000") + 
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + ylim(min(full_info$popsize),max(full_info$popsize))

print(plot_N_over_time)
```

    ## Warning: Removed 1 rows containing missing values (geom_hline).

![](two_step_density_control_files/figure-gfm/unnamed-chunk-12-3.png)<!-- -->

``` r
#ggsave(filename = "/Users/isabelkim/Desktop/rate_of_drive.png", plot = plot_rate_drive)
#ggsave(filename = "/Users/isabelkim/Desktop/num_drive_alleles.png", plot = plot_num_drive_alleles)
#ggsave(filename = "/Users/isabelkim/Desktop/population_size.png", plot = plot_N_over_time)

# MESSED UP N HERE
zoom_in_N = plot_N_over_time + xlim(-9,50)
#ggsave(filename = "/Users/isabelkim/Desktop/population_size_till_gen50.png", plot = zoom_in_N)
```

## Checks: set k=0 round 3 (but add the pre-drop popsize info this time)

``` bash
SLIM_CONSOLE=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/checks_m1000.txt
OUTPUT_CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/third_checks_m1000.csv

cd /Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files
python single-run-number-drive-alleles.py $SLIM_CONSOLE > $OUTPUT_CSV
```

``` r
output = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/third_checks_m1000.csv")
```

    ## Rows: 192 Columns: 7
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (7): gen, popsize, num_dd, num_dwt, num_wtwt, num_d_alleles, rate_d_alleles
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
gen = c(-9:-1, output$gen)
num_d = c(rep(0,9),output$num_d_alleles)
rate_d = c(rep(0,9), output$rate_d_alleles)
popsize_vec = c(30000, 30155, 30045, 30023, 30139, 30092, 30079, 29961, 29986,output$popsize)
full_info = tibble(gen = gen, num_d_alleles = num_d, rate_d_alleles = rate_d, popsize = popsize_vec)

plot_num_drive_alleles = ggplot(full_info, aes(x = gen, y = num_d_alleles)) + theme_minimal() +
  geom_line(color = "red") + xlab("gen") + ylab("number of drive alleles") + ggtitle("Drop size of 1000 into 30,000") +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0)
print(plot_num_drive_alleles)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
plot_rate_drive = ggplot(full_info, aes(x = gen, y = rate_d_alleles)) + theme_minimal() + ylim(0,0.035)+
  geom_line(color = "orange") + xlab("gen") + ylab("rate of drive alleles") + ggtitle("Drop size of 1000 into 30,000") +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0)

print(plot_rate_drive)
```

![](two_step_density_control_files/figure-gfm/unnamed-chunk-14-2.png)<!-- -->

``` r
plot_N_over_time = ggplot(full_info, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000") + 
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + ylim(min(full_info$popsize),max(full_info$popsize))

print(plot_N_over_time)
```

    ## Warning: Removed 1 rows containing missing values (geom_hline).

![](two_step_density_control_files/figure-gfm/unnamed-chunk-14-3.png)<!-- -->

``` r
#ggsave(filename = "/Users/isabelkim/Desktop/rate_of_drive.png", plot = plot_rate_drive)
#ggsave(filename = "/Users/isabelkim/Desktop/num_drive_alleles.png", plot = plot_num_drive_alleles)
#ggsave(filename = "/Users/isabelkim/Desktop/population_size.png", plot = plot_N_over_time)

zoom_in_N = ggplot(full_info, aes(x = gen, y = popsize)) + theme_minimal() +
  geom_line(color = "purple") + xlab("gen") + ylab("population size") +ggtitle("Drop size of 1000 into 30,000") + 
 geom_hline(yintercept = 0) + ylim(min(full_info$popsize),max(full_info$popsize))+ xlim(-9,50)
#ggsave(filename = "/Users/isabelkim/Desktop/population_size_till_gen50.png", plot = zoom_in_N)
```
