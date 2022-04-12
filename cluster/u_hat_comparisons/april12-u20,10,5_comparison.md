uhat=20, 10, and 5% comparison after debugging + wt gens
================
Isabel Kim
4/12/2022

## Compile csvs

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
source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/plotting_functions.R")

summary_u20 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.2_run/csvs/summary_april11_full_range_uhat20.csv")
```

    ## Rows: 150 Columns: 6

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (6): a, sigma, k, u_hat, delta, p_increase
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
obs_vs_pred_u20 = get_a_pred_and_a_obs(summary_u20)

summary_u10 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.1_run/csvs/summary_april11_full_range_uhat10.csv")
```

    ## Rows: 150 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (6): a, sigma, k, u_hat, delta, p_increase
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
obs_vs_pred_u10 = get_a_pred_and_a_obs(summary_u10)

summary_u5 = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/cluster/u_hat=0.05_run/csvs/summary_april11_full_range_uhat5.csv")
```

    ## Rows: 150 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (6): a, sigma, k, u_hat, delta, p_increase
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
obs_vs_pred_u5 = get_a_pred_and_a_obs(summary_u5)

compiled = rbind(summary_u5,summary_u10, summary_u20)
compiled$u_hat = as.character(compiled$u_hat)
#View(compiled)

compiled$p_increase[150] = 1.0 # fix
```

## Compare a vs P(increase) graphs

``` r
compiled_plot = ggplot(data = compiled, aes(x = a, y = p_increase, color = u_hat)) +
  geom_line() +
  xlab("a") +
  ylab("P(increase)") +
  xlim(0, 0.05) +
  geom_vline(xintercept = obs_vs_pred_u5$a_pred, color = "coral1") +
  geom_vline(xintercept = obs_vs_pred_u10$a_pred, color = "green3") +
  geom_vline(xintercept = obs_vs_pred_u20$a_pred, color = "dodgerblue") +
  labs(title = paste0("for u_hat = 5,   a_pred is ", round(obs_vs_pred_u5$a_pred, 4),
                      " and a_obs is ", round(obs_vs_pred_u5$a_obs, 4),
                      "\nfor u_hat = 10, a_pred is ", round(obs_vs_pred_u10$a_pred,4), 
                      " and a_obs is ", round(obs_vs_pred_u10$a_obs, 4), 
                      "\nfor u_hat = 20, a_pred is ", round(obs_vs_pred_u20$a_pred,4), 
                      " and a_obs is ", round(obs_vs_pred_u20$a_obs,4)))

compiled_plot
```

    ## Warning: Removed 135 row(s) containing missing values (geom_path).

![](april12-u20,10,5_comparison_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Compare delta vs P(increase) graphs

``` r
compiled_delta_v_p_increase = ggplot(data = compiled, aes(x = delta, y = p_increase, color = u_hat)) +
  geom_line() +
  xlab("delta") +
  ylab("P(increase)") +
  labs(title = paste0("for u_hat = 5,   delta_obs is ", round(obs_vs_pred_u5$delta_obs, 4),
                      "\nfor u_hat = 10, delta_obs is ", round(obs_vs_pred_u10$delta_obs,4), 
                      "\nfor u_hat = 20, delta_obs is ", round(obs_vs_pred_u20$delta_obs,4)))

compiled_delta_v_p_increase
```

![](april12-u20,10,5_comparison_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
## What are the delta transition range boundaries (delta_min – below
which P(increase)=0 and delta_max – above which P(increase)=1.0)?

``` r
uhat5 = compiled %>% filter(u_hat=="0.05")
uhat10 = compiled %>% filter(u_hat=="0.1")
uhat20 = compiled %>% filter(u_hat=="0.2")

# View each file
```

-   For uhat=5%, there is no delta_min because P(increase) is always >
    0, but the lowest value of delta_min=-(9.84e-06) and delta_max=
    around 0.000573111
-   For uhat=10%, delta_min = around 0.000308603 (except for some
    outliers) and delta_max = 0.000893806
-   For uhat=20%, delta_min=0.000797672 (besides the outlier at
    delta=-1.91e-5) and delta_max=0.001219991