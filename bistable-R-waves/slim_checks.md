Check u(x,t=1)
================
Isabel Kim
4/29/2022

## Parameters

-   a = 0.02
-   sigma = 0.01
-   uhat = 40%
-   b = 1
-   k = 0.2

### u(x,t=1) expectations versus results

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

### u’(x,t=1) expectations

``` r
# for x = -0.03 / x_raw = 0.47
predicted_uprime_x1 = 0.05850982

# for x = 0.0 / x_raw = 0.5
predicted_uprime_x2 = 0.6321206

# for x = 0.02152456
predicted_uprime_x3 = 0.02152456

## Read in csv file -- 40 replicates
library(tidyverse)
uprime_data = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/uprime.csv")
```

    ## Rows: 40 Columns: 4
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (4): replicate, uprime_x0.47, uprime_x0.5, uprime_x0.54
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# x1 = 0.47
avg_x1 = uprime_data %>% .$`uprime_x0.47` %>% mean()

# x2 = 0.5
avg_x2 = uprime_data %>% .$`uprime_x0.5` %>% mean()

# x = 0.54
avg_x3 = uprime_data %>% .$`uprime_x0.54` %>% mean()

# Comparison
print(paste("Predicted u'(-0.03,t=1) = ", round(predicted_uprime_x1,4), " vs observed = ",round(avg_x1,4)))
```

    ## [1] "Predicted u'(-0.03,t=1) =  0.0585  vs observed =  0.0442"

``` r
print(paste("Predicted u'(0.0,t=1) = ", round(predicted_uprime_x2,4), " vs observed = ",round(avg_x2,4)))
```

    ## [1] "Predicted u'(0.0,t=1) =  0.6321  vs observed =  0.638"

``` r
print(paste("Predicted u'(0.04,t=1) = ", round(predicted_uprime_x3,4), " vs observed = ",round(avg_x3,4)))
```

    ## [1] "Predicted u'(0.04,t=1) =  0.0215  vs observed =  0.0202"

### Summary for a = 0.02, sigma = 0.01, uhat = 40%, k = 0.2

-   For x \< -a/2 (x = 0.47): \<– furthest off
    -   u(x,t=1) expected: 0.051
        -   u(x,t=1) observed: 0.034
        -   Therefore, the rate of the drive was much lower than
            expected to the left of the drive release range after 1
            round of diffusion and reaction.
    -   u’(x,t=1) expected: 0.0585
        -   u’(x,t=1) observed: 0.0442
        -   The rate of the drive was lower than expected after just 1
            round of migration. Maybe individuals are moving too far
            away?
-   For -a/2 \<= x \<= a/2 (x = 0.50):
    -   u(x,t=1) expected: 0.6537
        -   u(x,t=1) observed: 0.6475
        -   Rate of the drive was just slightly lower than expected in
            the middle of the release range after 1 round of diffusion
            and reaction.
    -   u’(x,t=1) expected: 0.6321
        -   u’(x,t=1) observed: 0.638
        -   Everything seems fine after just diffusion.
-   For x > a/2 (x = 0.54):
    -   u(x,t=1) expected: 0.0183
        -   u(x,t=1) observed: 0.0161
        -   Rate of the drive is *slightly* lower than expected after 1
            round of diffusion and reaction.
    -   u’(x,t=1) expected: 0.0215
        -   u’(x,t=1) observed: 0.0202
        -   After just diffusion, the rate of the drive is slightly
            lower than expected.

## Increase a to 0.07

-   a = 0.07
-   sigma = 0.01
-   uhat = 40%
-   b = 1
-   k = 0.2

### Expectations

-   For x \< -a/2 (x = 0.47):
    -   u’(x,t=1) expected: 0.695983
    -   u(x,t=1) expected: 0.7210338
-   For -a/2 \<= x \<= a/2 (x = 0.50):
    -   u’(x,t=1) expected: 0.9698026
    -   u(x,t=1) expected: 0.9764774
-   For x > a/2:
    -   u’(x,t=1) expected: 0.3029888
    -   u(x,t=1) expected: 0.2947938

### Observed data for a = 0.07

``` r
library(tidyverse)
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/u_a0.07.csv"
data =  read.table(file, sep = "", header = T)

# x < -a/2 (x = 0.47)
x1_uprime_expected = 0.695983
x1_uprime_observed = data %>% .$`uprime_x0.47` %>% mean()
x1_u_expected = 0.7210338
x1_u_observed = data %>% .$`u_x0.47` %>% mean()

# -a/2 <= x <= a/2 (x = 0.50)
x2_uprime_expected = 0.9698026
x2_uprime_observed = data %>% .$`uprime_x0.5` %>% mean()
x2_u_expected = 0.9764774
x2_u_observed = data %>% .$`u_x0.5` %>% mean()

# x > a/2 (x = 0.54)
x3_uprime_expected = 0.3029888
x3_uprime_observed = data %>% .$`uprime_x0.54` %>% mean()
x3_u_expected = 0.2947938
x3_u_observed = data %>% .$`u_x0.54` %>% mean()

cat(paste("For x < -a/2 (x = 0.47), u'(x,t=1) expected was", round(x1_uprime_expected,4), "and u'(x,t=1) observed is", round(x1_uprime_observed,4), "\n u(x,t=1) expected was", round(x1_u_expected,4), "and u(x,t=1) observed is", round(x1_u_observed,4)))
```

    ## For x < -a/2 (x = 0.47), u'(x,t=1) expected was 0.696 and u'(x,t=1) observed is 0.7041 
    ##  u(x,t=1) expected was 0.721 and u(x,t=1) observed is 0.7409

``` r
cat(paste("For -a/2 <= x <= a/2 (x = 0.5), u'(x,t=1) expected was", round(x2_uprime_expected,4), "and u'(x,t=1) observed is", round(x2_uprime_observed,4), "\n u(x,t=1) expected was", round(x2_u_expected,4), "and u(x,t=1) observed is", round(x2_u_observed,4)))
```

    ## For -a/2 <= x <= a/2 (x = 0.5), u'(x,t=1) expected was 0.9698 and u'(x,t=1) observed is 0.9633 
    ##  u(x,t=1) expected was 0.9765 and u(x,t=1) observed is 0.9627

``` r
cat(paste("For x >= a/2 (x = 0.54), u'(x,t=1) expected was", round(x3_uprime_expected,4), "and u'(x,t=1) observed is", round(x3_uprime_observed,4), "\n u(x,t=1) expected was", round(x3_u_expected,4), "and u(x,t=1) observed is", round(x3_u_observed,4)))
```

    ## For x >= a/2 (x = 0.54), u'(x,t=1) expected was 0.303 and u'(x,t=1) observed is 0.2762 
    ##  u(x,t=1) expected was 0.2948 and u(x,t=1) observed is 0.268

-   For x \< -a/2 (x = 0.47), when a = 0.07, our observations actually
    *exceeds* the expectations by a bit, which is the opposite as what
    occurred with the smaller a of 0.02.

-   For -a/2 \<= x \<= a/2 (x = 0.50), the observations are close to the
    expectations, but the observed u’(x,t=1) and u(x,t=1) is a bit
    smaller.

-   For x > a/2 (x = 0.54), the observed u’(x,t=1) and observed u(x,t=1)
    are both lower than their expected value

### Repeat runs for x \< -a/2 (x = 0.47)

``` r
library(tidyverse)

# new 100 replicates
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/a0.02_x0.47_only.csv"
data = read_csv(file)
```

    ## Rows: 99 Columns: 2
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (2): uprime_x0.47, u_x0.47
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
uprime_observed = data$uprime_x0.47 %>% mean()
u_observed = data$u_x0.47 %>% mean()

u_predicted = 0.05098523
uprime_predicted = 0.05850982

cat("100 replicates")
```

    ## 100 replicates

``` r
cat(paste("u'(x=0.47,t=1) predicted =",uprime_predicted, "u'(x=0.47,t=1) observed =", uprime_observed, "\nu(x=0.47,t=1) predicted = ", u_predicted, "u(x=0.47,t=1) observed =", u_observed))
```

    ## u'(x=0.47,t=1) predicted = 0.05850982 u'(x=0.47,t=1) observed = 0.0586757868686869 
    ## u(x=0.47,t=1) predicted =  0.05098523 u(x=0.47,t=1) observed = 0.0441202555555556

``` r
### add the replicates from before
more_u = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/xpoints.csv") %>% filter(N==30000) %>% .$`x=0.47_freq`
```

    ## Rows: 45 Columns: 5
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (5): replicate, x=0.47_freq, x=0.5_freq, x=0.54_freq, N
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
more_uprime = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/uprime.csv") %>% .$`uprime_x0.47`
```

    ## Rows: 40 Columns: 4
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (4): replicate, uprime_x0.47, uprime_x0.5, uprime_x0.54
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
all_uprime_x0.47 = c(data$uprime_x0.47, more_uprime) # 139
all_u_x0.47 = c(data$u_x0.47, more_u) # 140

observed_total_uprime = mean(all_uprime_x0.47)
observed_total_u = mean(all_u_x0.47)

cat("all replicates")
```

    ## all replicates

``` r
cat(paste("u'(x=0.47,t=1) predicted =",uprime_predicted, "u'(x=0.47,t=1) observed =", observed_total_uprime, "\nu(x=0.47,t=1) predicted = ", u_predicted, "u(x=0.47,t=1) observed =", observed_total_u))
```

    ## u'(x=0.47,t=1) predicted = 0.05850982 u'(x=0.47,t=1) observed = 0.0545019604316547 
    ## u(x=0.47,t=1) predicted =  0.05098523 u(x=0.47,t=1) observed = 0.0411583485714286

The u’(x,t=1) observed value is close to the true value. But the
u(x,t=1) observed value is still around 0.01 lower consistently.

## Decrease k such that the reaction equation is more applicable

### Parameters

-   a = 0.02

-   sigma = 0.01

-   uhat = 40%

-   b = 1

-   k = 0.01

-   When x \< -a/2 (x = 0.47):

    -   Expected u’(x=0.47,t=1) = 0.05850982
    -   Expected u(x=0.47, t=1) = 0.05813359

-   When -a/2 \<= x \<= a/2 (x = 0.50):

    -   Expected u’(x=0.5, t=1) = 0.6321206
    -   Expected u(x=0.5, t=1) = 0.6332001

-   When x > a/2 (x = 0.54):

    -   Expected u’(x=0.54, t=1) = 0.02152456
    -   Expected u(x=0.54, t=1) = 0.02136514

### Data (40 replicates)

``` r
library(tidyverse)
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/klower_a0.02.csv"

data = read.table(file, sep = "", header = T)

obs_uprime_x0.47 = mean(data$uprime_x0.47)
obs_uprime_x0.5 = mean(data$uprime_x0.5)
obs_uprime_x0.54 = mean(data$uprime_x0.54)

obs_u_x0.47 = mean(data$u_x0.47)
obs_u_x0.5 = mean(data$u_x0.5)
obs_u_x0.54 = mean(data$u_x0.54)

predicted_uprime_x0.47 = 0.05850982
predicted_uprime_x0.5 = 0.6321206
predicted_uprime_x0.54 = 0.02152456

predicted_u_x0.47 = 0.05813359
predicted_u_x0.5 = 0.6332001
predicted_u_x0.54 = 0.02136514

# Why are the x = 0.47 predicted and observed values so off?
cat(paste("u'(x=0.47,t=1) expected =", predicted_uprime_x0.47, "u'(x=0.47,t=1) observed =", obs_uprime_x0.47,"\nu(x=0.47, t=1) expected =", predicted_u_x0.47,"u(x=0.47,t=1) observed =",obs_u_x0.47))
```

    ## u'(x=0.47,t=1) expected = 0.05850982 u'(x=0.47,t=1) observed = 0.0659471435897436 
    ## u(x=0.47, t=1) expected = 0.05813359 u(x=0.47,t=1) observed = 0.082728741025641

``` r
# These predictions are somewhat closer 
cat(paste("u'(x=0.5,t=1) expected =", predicted_uprime_x0.5, "u'(x=0.5,t=1) observed =", obs_uprime_x0.5,"\nu(x=0.5, t=1) expected =", predicted_u_x0.5,"u(x=0.5,t=1) observed =",obs_u_x0.5))
```

    ## u'(x=0.5,t=1) expected = 0.6321206 u'(x=0.5,t=1) observed = 0.641981153846154 
    ## u(x=0.5, t=1) expected = 0.6332001 u(x=0.5,t=1) observed = 0.629430717948718

``` r
# These are quite close
cat(paste("u'(x=0.54,t=1) expected =", predicted_uprime_x0.54, "u'(x=0.54,t=1) observed =", obs_uprime_x0.54,"\nu(x=0.54, t=1) expected =", predicted_u_x0.54,"u(x=0.54,t=1) observed =",obs_u_x0.54))
```

    ## u'(x=0.54,t=1) expected = 0.02152456 u'(x=0.54,t=1) observed = 0.0209009615384615 
    ## u(x=0.54, t=1) expected = 0.02136514 u(x=0.54,t=1) observed = 0.0261302358974359

### Parameters

-   a = 0.07

-   sigma = 0.01

-   uhat = 40%

-   b = 1

-   k = 0.01

-   When x \< -a/2 (x = 0.47):

    -   Expected u’(x=0.47,t=1) = 0.695983
    -   Expected u(x=0.47, t=1) = 0.6972355

-   When -a/2 \<= x \<= a/2 (x = 0.50):

    -   Expected u’(x=0.5, t=1) = 0.9698026
    -   Expected u(x=0.5, t=1) = 0.9701364

-   When x > a/2 (x = 0.54):

    -   Expected u’(x=0.54, t=1) = 0.3029888
    -   Expected u(x=0.54, t=1) = 0.302579

### Data (28 replicates)

``` r
library(tidyverse)
file = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/bistable-R-waves/klower_a0.07.csv"

data = read.table(file, sep = "", header = T)

obs_uprime_x0.47 = mean(data$uprime_x0.47)
obs_uprime_x0.5 = mean(data$uprime_x0.5)
obs_uprime_x0.54 = mean(data$uprime_x0.54)

obs_u_x0.47 = mean(data$u_x0.47)
obs_u_x0.5 = mean(data$u_x0.5)
obs_u_x0.54 = mean(data$u_x0.54)

predicted_uprime_x0.47 = 0.695983
predicted_uprime_x0.5 = 0.9698026
predicted_uprime_x0.54 = 0.3029888

predicted_u_x0.47 = 0.6972355
predicted_u_x0.5 = 0.9701364
predicted_u_x0.54 = 0.302579

# Much closer values when a = 0.07
cat(paste("u'(x=0.47,t=1) expected =", predicted_uprime_x0.47, "u'(x=0.47,t=1) observed =", obs_uprime_x0.47,"\nu(x=0.47, t=1) expected =", predicted_u_x0.47,"u(x=0.47,t=1) observed =",obs_u_x0.47))
```

    ## u'(x=0.47,t=1) expected = 0.695983 u'(x=0.47,t=1) observed = 0.708573928571429 
    ## u(x=0.47, t=1) expected = 0.6972355 u(x=0.47,t=1) observed = 0.712516821428571

``` r
# Somewhat close
cat(paste("u'(x=0.5,t=1) expected =", predicted_uprime_x0.5, "u'(x=0.5,t=1) observed =", obs_uprime_x0.5,"\nu(x=0.5, t=1) expected =", predicted_u_x0.5,"u(x=0.5,t=1) observed =",obs_u_x0.5))
```

    ## u'(x=0.5,t=1) expected = 0.9698026 u'(x=0.5,t=1) observed = 0.940596 
    ## u(x=0.5, t=1) expected = 0.9701364 u(x=0.5,t=1) observed = 0.954654642857143

``` r
# Pretty close
cat(paste("u'(x=0.54,t=1) expected =", predicted_uprime_x0.54, "u'(x=0.54,t=1) observed =", obs_uprime_x0.54,"\nu(x=0.54, t=1) expected =", predicted_u_x0.54,"u(x=0.54,t=1) observed =",obs_u_x0.54))
```

    ## u'(x=0.54,t=1) expected = 0.3029888 u'(x=0.54,t=1) observed = 0.284308214285714 
    ## u(x=0.54, t=1) expected = 0.302579 u(x=0.54,t=1) observed = 0.307340928571429
