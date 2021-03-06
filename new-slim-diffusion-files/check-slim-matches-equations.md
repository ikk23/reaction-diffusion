Check equations
================
Isabel Kim
6/10/2022

## Equations

``` r
# m = d/d drop size
# x = position, centered at 0 (subtract x = x_slim - 0.5)
# D = 0.5(sigma^2)
# rho = wild-type density
# k = selection coefficient
# uhat = invasion frequency (alpha = 1-2uhat)
expected_NAA_after_dispersal = function(m,x,D){
  numerator = m*exp((-x^2)/(4*D))
  denominator = sqrt(4*pi*D)
  return(numerator/denominator)
}

expected_Naa_after_dispersal = function(wild_type_popsize, cell_width){
  return(cell_width*wild_type_popsize)
}

expected_NAA_after_reproduction = function(m,x,D,rho){
  factor1_numerator = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  factor2_numerator = (m^2)*exp((-x^2)/(2*D))
  num = factor1_numerator*factor2_numerator
  
  denominator_term1_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  sol = (num/denom)
  return(sol)
}

expected_NAa_after_reproduction = function(m,x,D,rho){
  denominator_term1_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  numerator_factor1 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  numerator_factor2 = 2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D)
  numerator = numerator_factor1*numerator_factor2
  
  sol = numerator/denom
  return(sol)
}

expected_Naa_after_reproduction = function(m,x,D,rho){
  denominator_term1_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  term1_num = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  term2_num = 4*pi*D*(rho^2)
  num = term1_num*term2_num
  
  sol = num/denom
  return(sol)
}

expected_NAA_after_viability = function(m,x,D,rho,uhat,k){
  alpha = 1-(2*uhat)
  
  f1_numerator = (1+(2*alpha*k))
  f2 = (m^2)*exp((-x^2)/(2*D))
  f3 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  numerator = f1_numerator*f2*f3
  
  f1_denom = sqrt(4*pi*D)*(1 + (2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  f2_denom = 8*pi*D*rho*m*exp((-x^2)/(4*D))*(1 + ((alpha-1)*k))
  f3_denom = 4*pi*D*(rho^2)*sqrt(4*pi*D)
  denom = f1_denom+f2_denom+f3_denom
  
  sol = numerator/denom
  return(sol)
}

expected_NAa_after_viability = function(m,x,D,rho,uhat,k){
  alpha = 1-(2*uhat)
  
  f1_num = 1 + ((alpha-1)*k)
  f2_num = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  f3_num = 2*m*rho*exp((-x^2)/(4*D))
  num = f1_num*f2_num*f3_num
  
  denom_t1 = (1+(2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  denom_t2 = (1 + ((alpha-1)*k))*2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D)
  denom_t3 = 4*pi*D*(rho^2)
  denom = denom_t1+denom_t2+denom_t3
  
  sol = num/denom
  return(sol)
}

expected_Naa_after_viability = function(m,x,D,rho,uhat,k){
  
  alpha = 1-(2*uhat)
  
  f1_denom = sqrt(4*pi*D)*(1 + (2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  f2_denom = 8*pi*D*rho*m*exp((-x^2)/(4*D))*(1 + ((alpha-1)*k))
  f3_denom = 4*pi*D*(rho^2)*sqrt(4*pi*D)
  denom = f1_denom+f2_denom+f3_denom
  
  num_f1 = 4*pi*D*(rho^2)
  num_f2 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  num = num_f1*num_f2
  sol = num/denom
  
  return(sol)
}

all_expectations = function(m,x,D,rho,uhat,k){
  # after dispersal only
  nAA_prime = expected_NAA_after_dispersal(m,x,D)
  nAa_prime = 0
  naa_prime = rho
  
  # after dispersal and reproduction
  nAA_prime_prime = expected_NAA_after_reproduction(m,x,D,rho)
  nAa_prime_prime = expected_NAa_after_reproduction(m,x,D,rho)
  naa_prime_prime = expected_Naa_after_reproduction(m,x,D,rho)
  
  # after dispersal, reproduction, and viability selection
  nAA_t1 = expected_NAA_after_viability(m,x,D,rho,uhat,k)
  nAa_t1 = expected_NAa_after_viability(m,x,D,rho,uhat,k)
  naa_t1 = expected_Naa_after_viability(m,x,D,rho,uhat,k)
  
  results = list(nAA_after_dispersal = nAA_prime,
                 nAa_after_dispersal = nAa_prime,
                 naa_after_dispersal = naa_prime,
                 nAA_after_reproduction = nAA_prime_prime,
                 nAa_after_reproduction = nAa_prime_prime,
                 naa_after_reproduction = naa_prime_prime,
                 nAA_after_viability = nAA_t1,
                 nAa_after_viability = nAa_t1,
                 naa_after_viability = naa_t1)
  return(results)
}
```

## Expected counts for certain parameters

-   m = d/d drop size
-   x = position, centered at 0 (subtract x = x_slim - 0.5)
-   D = 0.5(sigma^2)
-   rho = wild-type density
-   k = selection coefficient
-   uhat = invasion frequency (alpha = 1-2uhat)

``` r
m = 1000
D = 0.5*(0.01^2)
k = 0.2
uhat = 0.2
rho = 30000/30 # cell width of 0.01
x = 0.283333 - 0.5

all_expectations(m,x,D,rho,uhat,k)
```

    ## $nAA_after_dispersal
    ## [1] 4.592303e-98
    ## 
    ## $nAa_after_dispersal
    ## [1] 0
    ## 
    ## $naa_after_dispersal
    ## [1] 1000
    ## 
    ## $nAA_after_reproduction
    ## [1] 2.108925e-198
    ## 
    ## $nAa_after_reproduction
    ## [1] 9.184606e-98
    ## 
    ## $naa_after_reproduction
    ## [1] 1000
    ## 
    ## $nAA_after_viability
    ## [1] 2.615066e-198
    ## 
    ## $nAa_after_viability
    ## [1] 8.449837e-98
    ## 
    ## $naa_after_viability
    ## [1] 1000

## SLiM equations:

`x` is not adjusted yet.

``` bash
numAA_after_dispersal(float x)

numAa_after_dispersal(float x)

numaa_after_dispersal(float x)

numAA_after_reproduction(float x)

numAa_after_reproduction(float x)

numaa_after_reproduction(float x)

numAA_after_viability(float x)

numAa_after_viability(float x)

numaa_after_viability(float x)
```

## Output analysis in Python script

-   Line examples:
    -   Generation10, after Gaussian dispersal:

``` bash
GEN10_after_dispersal:: X1:: 0.0333333 X2:: 0.0666667 MIDPT:: 0.05 N_DD:: 0.0 EXP_N_DD:: 0.0 N_DWT:: 0.0 EXP_N_DWT:: 0.0 N_WTWT:: 25890.0 EXP_N_WTWT:: 1000.0
```

-   Generation 11, after reproduction but before viability:

``` bash
GEN11_after_reproduction:: X1:: 0.9 X2:: 0.933333 MIDPT:: 0.916667 N_DD:: 0.0 EXP_N_DD:: 0.0 N_DWT:: 0.0 EXP_N_DWT:: 0.0 N_WTWT:: 60240.0 EXP_N_WTWT:: 1000.0
```

-   Generation 11, after both reproduction and viability:

``` bash
GEN11_after_viability:: X1:: 0.966667 X2:: 1.0 MIDPT:: 0.983333 N_DD:: 0.0 EXP_N_DD:: 0.0 N_DWT:: 0.0 EXP_N_DWT:: 0.0 N_WTWT:: 20490.0 EXP_N_WTWT:: 1000.0
```

-   csv:
    `x1, x2, x_midpoint,time_point,n_dd, n_dwt, n_wt, exp_n_dd, exp_n_dwt, exp_n_wt`
    (10 columns)
    -   time_point is either ???after_dispersal???, ???after_reproduction???, or
        ???after_viability???

## Function to plot a genotype count vs expected count at a given time

``` r
plot_count_vs_exp = function(csv, genotype, time_point, show_plot = TRUE){
  # csv = output of single-run-analyze-counts.py, read into R as a tibble
  # genotype = either "dd", "dwt", or "wtwt"
  # time_point = either "after_dispersal", "after_reproduction", or "after_viability"
  
  t = time_point
  filtered_csv = csv %>% filter(time_point == t)
  
  if (genotype == "dd"){
    p = ggplot(filtered_csv, aes(x = x_midpoint)) + 
      geom_line(aes(y=n_dd), color = "black") + geom_line(aes(y=exp_n_dd),color="red") + theme_minimal() + 
      ylab("count") + ggtitle(paste0("expected (red) and observed (black) d/d count ", t))
  } else if (genotype == "dwt"){
    p = ggplot(filtered_csv, aes(x = x_midpoint)) + 
      geom_line(aes(y=n_dwt), color = "black") + geom_line(aes(y=exp_n_dwt),color="red") + theme_minimal() + 
      ylab("count") + ggtitle(paste0("expected (red) and observed (black) d/wt count ", t))
  } else {
    p = ggplot(filtered_csv, aes(x = x_midpoint)) + 
      geom_line(aes(y=n_wtwt), color = "black") + geom_line(aes(y=exp_n_wt),color="red") + theme_minimal() + 
      ylab("count") + ggtitle(paste0("expected (red) and observed (black) wt/wt count ", t))
  }
  if (show_plot){
    print(p)
  }
  return(p)
}
```

## m=1000 run

-   uhat = k = 0.2
-   wt size = 30,000
-   local radius and mating radius = 0.001
-   sigma = 0.01

``` bash
TEXT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_k_uhat0.2.txt
CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2.csv
PYTHON_SCRIPT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/single-run-analyze-counts.py

python $PYTHON_SCRIPT $TEXT > $CSV
```

``` r
library(tidyverse)
```

    ## ?????? Attaching packages ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? tidyverse 1.3.1 ??????

    ## ??? ggplot2 3.3.5     ??? purrr   0.3.4
    ## ??? tibble  3.1.6     ??? dplyr   1.0.8
    ## ??? tidyr   1.2.0     ??? stringr 1.4.0
    ## ??? readr   2.1.2     ??? forcats 0.5.1

    ## ?????? Conflicts ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? tidyverse_conflicts() ??????
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2.csv")
```

    ## Rows: 90 Columns: 10

    ## ?????? Column specification ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ## Delimiter: ","
    ## chr (1): time_point
    ## dbl (9): x1, x2, x_midpoint, n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    ## 
    ## ??? Use `spec()` to retrieve the full column specification for this data.
    ## ??? Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Plot the after dispersal counts
after_dispersal_ndd = plot_count_vs_exp(csv, "dd","after_dispersal",FALSE)
after_dispersal_ndwt = plot_count_vs_exp(csv, "dwt","after_dispersal",FALSE)
after_dispersal_wtdwt = plot_count_vs_exp(csv, "wtwt","after_dispersal",FALSE)

print(after_dispersal_ndd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
print(after_dispersal_ndwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-2.png)<!-- -->

``` r
print(after_dispersal_wtdwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-3.png)<!-- -->

``` r
# Plot the after reproduction counts
after_rep_dd = plot_count_vs_exp(csv, "dd","after_reproduction",FALSE)
after_rep_dwt = plot_count_vs_exp(csv, "dwt","after_reproduction",FALSE)
after_rep_wtwt = plot_count_vs_exp(csv, "wtwt","after_reproduction",FALSE)

print(after_rep_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-4.png)<!-- -->

``` r
print(after_rep_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-5.png)<!-- -->

``` r
print(after_rep_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-6.png)<!-- -->

``` r
# Plot the after reproduction + viability counts
after_viab_dd = plot_count_vs_exp(csv, "dd","after_viability",FALSE)
after_viab_dwt = plot_count_vs_exp(csv, "dwt","after_viability",FALSE)
after_viab_wtwt = plot_count_vs_exp(csv, "wtwt","after_viability",FALSE)

print(after_viab_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-7.png)<!-- -->

``` r
print(after_viab_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-8.png)<!-- -->

``` r
print(after_viab_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-9-9.png)<!-- -->

The expectations are now much lower than the observed counts, especially
for d/wt and wt/wt.

## Should rho = N_wildtypes? Before, I multiplied to approximate the number of wild-types. But (N_wildtypes\*cellwidth)/cellwidth = N_wildtypes

``` bash
TEXT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_k_uhat_0.2_N_rho.txt
CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat_0.2_N_rho.csv
PYTHON_SCRIPT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/single-run-analyze-counts.py

python $PYTHON_SCRIPT $TEXT > $CSV
```

``` r
csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat_0.2_N_rho.csv")
```

    ## Rows: 30 Columns: 10
    ## ?????? Column specification ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ## Delimiter: ","
    ## chr (1): time_point
    ## dbl (9): x1, x2, x_midpoint, n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    ## 
    ## ??? Use `spec()` to retrieve the full column specification for this data.
    ## ??? Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Plot the after dispersal counts
after_dispersal_ndd = plot_count_vs_exp(csv, "dd","after_dispersal",FALSE)
after_dispersal_ndwt = plot_count_vs_exp(csv, "dwt","after_dispersal",FALSE)
after_dispersal_wtdwt = plot_count_vs_exp(csv, "wtwt","after_dispersal",FALSE)

print(after_dispersal_ndd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

``` r
print(after_dispersal_ndwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-2.png)<!-- -->

``` r
print(after_dispersal_wtdwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-3.png)<!-- -->

``` r
# Plot the after reproduction counts
after_rep_dd = plot_count_vs_exp(csv, "dd","after_reproduction",FALSE)
after_rep_dwt = plot_count_vs_exp(csv, "dwt","after_reproduction",FALSE)
after_rep_wtwt = plot_count_vs_exp(csv, "wtwt","after_reproduction",FALSE)

print(after_rep_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-4.png)<!-- -->

``` r
print(after_rep_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-5.png)<!-- -->

``` r
print(after_rep_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-6.png)<!-- -->

``` r
# Plot the after reproduction + viability counts
after_viab_dd = plot_count_vs_exp(csv, "dd","after_viability",FALSE)
after_viab_dwt = plot_count_vs_exp(csv, "dwt","after_viability",FALSE)
after_viab_wtwt = plot_count_vs_exp(csv, "wtwt","after_viability",FALSE)

print(after_viab_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-7.png)<!-- -->

``` r
print(after_viab_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-8.png)<!-- -->

``` r
print(after_viab_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-11-9.png)<!-- -->
Now rho is wayyy too off.

## Try rho = N_wildtypes/cell_width

``` bash
TEXT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_k_uhat_0.2_N_rho.txt
CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat_0.2_rho_div_width.csv
PYTHON_SCRIPT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/single-run-analyze-counts.py

python $PYTHON_SCRIPT $TEXT > $CSV
```

``` r
csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat_0.2_rho_div_width.csv")
```

    ## Rows: 30 Columns: 10
    ## ?????? Column specification ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ## Delimiter: ","
    ## chr (1): time_point
    ## dbl (9): x1, x2, x_midpoint, n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    ## 
    ## ??? Use `spec()` to retrieve the full column specification for this data.
    ## ??? Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Plot the after dispersal counts
after_dispersal_ndd = plot_count_vs_exp(csv, "dd","after_dispersal",FALSE)
after_dispersal_ndwt = plot_count_vs_exp(csv, "dwt","after_dispersal",FALSE)
after_dispersal_wtdwt = plot_count_vs_exp(csv, "wtwt","after_dispersal",FALSE)

print(after_dispersal_ndd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
print(after_dispersal_ndwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->

``` r
print(after_dispersal_wtdwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-3.png)<!-- -->

``` r
# Plot the after reproduction counts
after_rep_dd = plot_count_vs_exp(csv, "dd","after_reproduction",FALSE)
after_rep_dwt = plot_count_vs_exp(csv, "dwt","after_reproduction",FALSE)
after_rep_wtwt = plot_count_vs_exp(csv, "wtwt","after_reproduction",FALSE)

print(after_rep_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-4.png)<!-- -->

``` r
print(after_rep_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-5.png)<!-- -->

``` r
print(after_rep_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-6.png)<!-- -->

``` r
# Plot the after reproduction + viability counts
after_viab_dd = plot_count_vs_exp(csv, "dd","after_viability",FALSE)
after_viab_dwt = plot_count_vs_exp(csv, "dwt","after_viability",FALSE)
after_viab_wtwt = plot_count_vs_exp(csv, "wtwt","after_viability",FALSE)

print(after_viab_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-7.png)<!-- -->

``` r
print(after_viab_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-8.png)<!-- -->

``` r
print(after_viab_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-13-9.png)<!-- -->

## Should the observed counts *not* be divided by the width, but should the width be VERY small such that x=0.5-0.50001 is approximately x=0.5 (dividing by 0.0001 would really inflate this)?

Width of 0.01

``` bash
TEXT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_k_uhat_0.2_N_rho.txt
CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2_small_width_no_division.csv
PYTHON_SCRIPT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/single-run-analyze-counts.py

python $PYTHON_SCRIPT $TEXT > $CSV
```

``` r
csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2_small_width_no_division.csv")
```

    ## Rows: 300 Columns: 10
    ## ?????? Column specification ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ## Delimiter: ","
    ## chr (1): time_point
    ## dbl (9): x1, x2, x_midpoint, n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    ## 
    ## ??? Use `spec()` to retrieve the full column specification for this data.
    ## ??? Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Plot the after dispersal counts
after_dispersal_ndd = plot_count_vs_exp(csv, "dd","after_dispersal",FALSE)
after_dispersal_ndwt = plot_count_vs_exp(csv, "dwt","after_dispersal",FALSE)
after_dispersal_wtdwt = plot_count_vs_exp(csv, "wtwt","after_dispersal",FALSE)

print(after_dispersal_ndd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
print(after_dispersal_ndwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-2.png)<!-- -->

``` r
print(after_dispersal_wtdwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-3.png)<!-- -->

``` r
# Plot the after reproduction counts
after_rep_dd = plot_count_vs_exp(csv, "dd","after_reproduction",FALSE)
after_rep_dwt = plot_count_vs_exp(csv, "dwt","after_reproduction",FALSE)
after_rep_wtwt = plot_count_vs_exp(csv, "wtwt","after_reproduction",FALSE)

print(after_rep_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-4.png)<!-- -->

``` r
print(after_rep_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-5.png)<!-- -->

``` r
print(after_rep_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-6.png)<!-- -->

``` r
# Plot the after reproduction + viability counts
after_viab_dd = plot_count_vs_exp(csv, "dd","after_viability",FALSE)
after_viab_dwt = plot_count_vs_exp(csv, "dwt","after_viability",FALSE)
after_viab_wtwt = plot_count_vs_exp(csv, "wtwt","after_viability",FALSE)

print(after_viab_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-7.png)<!-- -->

``` r
print(after_viab_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-8.png)<!-- -->

``` r
print(after_viab_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-15-9.png)<!-- -->
## Same width but dividing observed counts by the cell_width this time
(as before)

Width of 0.01

``` bash
TEXT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/text_out/m1000_k_uhat_0.2_N_rho.txt
CSV=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2_small_width_with_division.csv
PYTHON_SCRIPT=/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/single-run-analyze-counts.py

python $PYTHON_SCRIPT $TEXT > $CSV
```

``` r
csv = read_csv("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/new-slim-diffusion-files/csv_out/m1000_k_uhat0.2_small_width_with_division.csv")
```

    ## Rows: 300 Columns: 10
    ## ?????? Column specification ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ## Delimiter: ","
    ## chr (1): time_point
    ## dbl (9): x1, x2, x_midpoint, n_dd, n_dwt, n_wtwt, exp_n_dd, exp_n_dwt, exp_n_wt
    ## 
    ## ??? Use `spec()` to retrieve the full column specification for this data.
    ## ??? Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Plot the after dispersal counts
after_dispersal_ndd = plot_count_vs_exp(csv, "dd","after_dispersal",FALSE)
after_dispersal_ndwt = plot_count_vs_exp(csv, "dwt","after_dispersal",FALSE)
after_dispersal_wtdwt = plot_count_vs_exp(csv, "wtwt","after_dispersal",FALSE)

print(after_dispersal_ndd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

``` r
print(after_dispersal_ndwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-2.png)<!-- -->

``` r
print(after_dispersal_wtdwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-3.png)<!-- -->

``` r
# Plot the after reproduction counts
after_rep_dd = plot_count_vs_exp(csv, "dd","after_reproduction",FALSE)
after_rep_dwt = plot_count_vs_exp(csv, "dwt","after_reproduction",FALSE)
after_rep_wtwt = plot_count_vs_exp(csv, "wtwt","after_reproduction",FALSE)

print(after_rep_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-4.png)<!-- -->

``` r
print(after_rep_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-5.png)<!-- -->

``` r
print(after_rep_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-6.png)<!-- -->

``` r
# Plot the after reproduction + viability counts
after_viab_dd = plot_count_vs_exp(csv, "dd","after_viability",FALSE)
after_viab_dwt = plot_count_vs_exp(csv, "dwt","after_viability",FALSE)
after_viab_wtwt = plot_count_vs_exp(csv, "wtwt","after_viability",FALSE)

print(after_viab_dd)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-7.png)<!-- -->

``` r
print(after_viab_dwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-8.png)<!-- -->

``` r
print(after_viab_wtwt)
```

![](check-slim-matches-equations_files/figure-gfm/unnamed-chunk-17-9.png)<!-- -->

Things that could be wrong:

-   The calculation of the wild-type density
