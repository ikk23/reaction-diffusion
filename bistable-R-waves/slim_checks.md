Check u(x,t=1)
================
Isabel Kim
4/29/2022

## Load in the dataset and filter to get only the N=30,000 runs

-   a = 0.02
-   sigma = 0.01
-   uhat = 40%
-   b = 1
-   k = 0.2

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
data = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/xpoints.csv") %>% filter(N==30000)
```

    ## Rows: 45 Columns: 5

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (5): replicate, x=0.47_freq, x=0.5_freq, x=0.54_freq, N
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# 41 replicates

# x1 = 0.47
avg_x1 = data %>% .$`x=0.47_freq` %>% mean()

# x2 = 0.5
avg_x2 = data %>% .$`x=0.5_freq` %>% mean()

# x = 0.54
avg_x3 = data %>% .$`x=0.54_freq` %>% mean()


predicted_x1 = 0.05098523
predicted_x2 = 0.6537119
predicted_x3 = 0.01833609

print(paste("Predicted u(-0.03,t=1) = ", round(predicted_x1,4), " vs observed = ",round(avg_x1,4)))
```

    ## [1] "Predicted u(-0.03,t=1) =  0.051  vs observed =  0.034"

``` r
print(paste("Predicted u(0.0,t=1) = ", round(predicted_x2,4), " vs observed = ",round(avg_x2,4)))
```

    ## [1] "Predicted u(0.0,t=1) =  0.6537  vs observed =  0.6475"

``` r
print(paste("Predicted u(0.04,t=1) = ", round(predicted_x3,4), " vs observed = ",round(avg_x3,4)))
```

    ## [1] "Predicted u(0.04,t=1) =  0.0183  vs observed =  0.0161"

Observed rates are a *bit* lower than the predicted ones. Is diffusion
too strong? Can check u’(x,t=1) next.
