cluster runs for u’(x,t=1) and u(x,t=1) checking
================
Isabel Kim
5/10/2022

## Parameters:

-   a = 0.02
-   sigma = 0.01
-   uhat = 40%
-   b = 1
-   k = 0.2

## Expectations:

-   When x \< -a/2 (x = 0.47):
    -   Expected u’(x=0.47,t=1) = 0.05850982
    -   Expected u(x=0.47, t=1) = 0.05098523
-   When -a/2 \<= x \<= a/2 (x = 0.50):
    -   Expected u’(x=0.5, t=1) = 0.6321206
    -   Expected u(x=0.5, t=1) = 0.6537119
-   When x > a/2 (x = 0.54):
    -   Expected u’(x=0.54, t=1) = 0.02152456
    -   Expected u(x=0.54, t=1) = 0.01833609

## Current data (40-100 replicates):

-   When x \< -a/2 (x = 0.47):
    -   u’(x,t=1) observed: 0.0545 (close)
    -   u(x,t=1) observed: 0.0412 (too low)
-   When -a/2 \<= x \<= a/2 (x = 0.5):
    -   u’(x,t=1) observed: 0.638 (close)
    -   u(x,t=1) observed: 0.6475 (close)
-   When x > a/2 (x = 0.54):
    -   u’(x,t=1) observed: 0.0202
    -   u(x,t=1) observed: 0.0161

## Cluster script

Output will look like this:

``` r
Bounds of drive in generation 10: 0.490045 to 0.509809
----------------------
u'(x,t=1):
GENERATION: 10
UPRIME_X1:: 0.137931
UPRIME_X2:: 0.6
UPRIME_X3:: 0.0
u(x,t=1):
----------------------

GENERATION: 11
U_X1:: 0.108108
U_X2:: 0.673077
U_X3:: 0.0
----------------------
```

Take this output and create 6 columns:

1.  u’(0.47,1), u’(0.5, 1), u’(0.54, 1), u(0.47,1), u(0.5,1), u(0.54,1)

## Cluster files

-   Python driver:
    `/home/ikk23/underdom/main_scripts/python_u_driver.py`
-   SLiM script: `/home/ikk23/underdom/main_scripts/nonWF-model.slim`
-   Text file: `/home/ikk23/underdom/text_files/may10_u_runs.txt`
    -   50 array job
    -   Each has 20 replicates
-   Main cluster script:
    `/home/ikk23/underdom/u_runs_script/may10_u_runs.sh`
    -   Submitted at 9:12pm on May 10th
-   Merge cluster script:
    `/home/ikk23/underdom/merge_scripts/may10_u_runs_merge.sh`
    -   Creates `/home/ikk23/underdom/csvs/u_check_with_a0.02.csv`
    -   Submitted at 9:19pm on May 10th
    -   On my local computer:
        `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/u_check_with_a0.02.csv`

## New averages

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
data = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/u_check_with_a0.02.csv")
```

    ## Rows: 1000 Columns: 6

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (6): u'(x=0.47), u'(x=0.5), u'(x=0.54), u(x=0.47), u(x=0.5), u(x=0.54)
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
uprime_x1 = mean(data$`u'(x=0.47)`)
uprime_x2 = mean(data$`u'(x=0.5)`)
uprime_x3 = mean(data$`u'(x=0.54)`)
u_x1 = mean(data$`u(x=0.47)`)
u_x2 = mean(data$`u(x=0.5)`)
u_x3 = mean(data$`u(x=0.54)`)

print(paste0("Expected u'(x=0.47, t=1) = ",0.05850982, " vs observed = ", uprime_x1, " -- percent difference = ", (abs(0.05850982-uprime_x1)/0.05850982)*100))
```

    ## [1] "Expected u'(x=0.47, t=1) = 0.05850982 vs observed = 0.0590608175 -- percent difference = 0.941717988535949"

``` r
print(paste0("Expected u(x=0.47, t=1) = ",0.05098523, " vs observed = ", u_x1, " -- percent difference = ", (abs(0.05098523-u_x1)/0.05098523)*100))
```

    ## [1] "Expected u(x=0.47, t=1) = 0.05098523 vs observed = 0.0526556363 -- percent difference = 3.27625529981919"

``` r
print(paste0("Expected u'(x=0.5, t=1) = ",0.6321206, " vs observed = ", uprime_x2, " -- percent difference = ", (abs(0.6321206-uprime_x2)/0.6321206)*100))
```

    ## [1] "Expected u'(x=0.5, t=1) = 0.6321206 vs observed = 0.628664427 -- percent difference = 0.546758482479452"

``` r
print(paste0("Expected u(x=0.5, t=1) = ", 0.6537119, " vs observed = ", u_x2, " -- percent difference = ", (abs(0.6537119-u_x2)/0.6537119)*100))
```

    ## [1] "Expected u(x=0.5, t=1) = 0.6537119 vs observed = 0.651572027 -- percent difference = 0.327341907038859"

``` r
print(paste0("Expected u'(x=0.54, t=1) = ",0.02152456, " vs observed = ", uprime_x3, " -- percent difference = ", (abs(0.02152456-uprime_x3)/0.02152456)*100))
```

    ## [1] "Expected u'(x=0.54, t=1) = 0.02152456 vs observed = 0.0210994993 -- percent difference = 1.97477068056211"

``` r
print(paste0("Expected u(x=0.54, t=1) = ",0.01833609, " vs observed = ", u_x3, " -- percent difference = ", (abs(0.01833609-u_x3)/0.01833609)*100))
```

    ## [1] "Expected u(x=0.54, t=1) = 0.01833609 vs observed = 0.0186565021 -- percent difference = 1.74743961226194"

Good - results are extremely close to the mathematical formulas when the
number of replicates is large.
