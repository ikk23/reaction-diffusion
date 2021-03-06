uhat=5% debugged cluster runs with wt gens
================
Isabel Kim
4/12/2022

## Additions

-   10 generations for wild-types to stabilize before the drive is added
-   Adjusted the mutation stacking policy to account for converting
    wild-type genomes to drive in generation 10
-   Fixed the python driver such that if the drive is introduced at 0%
    and therefore has an initial and final frequency equal to 0%, it’s
    counted as a “decrease” (before, this was an “increase” due to the
    way I structured the conditional)

## a vs P(increase)

### Full range of a

``` r
knitr::include_graphics("../../cluster/u_hat=0.05_run/figures/april12_full_a_vs_p_increase_uhat5.png")
```

![](../../cluster/u_hat=0.05_run/figures/april12_full_a_vs_p_increase_uhat5.png)<!-- -->

### Zoomed in – a between 0 and 0.1

``` r
knitr::include_graphics("../../cluster/u_hat=0.05_run/figures/april12_zoomed_in_a_vs_p_increase_uhat5.png")
```

![](../../cluster/u_hat=0.05_run/figures/april12_zoomed_in_a_vs_p_increase_uhat5.png)<!-- -->

## a vs delta

### Full range of a

``` r
knitr::include_graphics("../../cluster/u_hat=0.05_run/figures/april12_full_a_vs_delta_uhat5.png")
```

![](../../cluster/u_hat=0.05_run/figures/april12_full_a_vs_delta_uhat5.png)<!-- -->

### Zoomed in – a between 0 and 0.1

``` r
knitr::include_graphics("../../cluster/u_hat=0.05_run/figures/april12_zoomed_in_a_vs_delta_uhat5.png")
```

![](../../cluster/u_hat=0.05_run/figures/april12_zoomed_in_a_vs_delta_uhat5.png)<!-- -->
## delta vs P(increase)

``` r
knitr::include_graphics("../../cluster/u_hat=0.05_run/figures/april12_delta_vs_p_increase_uhat5.png")
```

![](../../cluster/u_hat=0.05_run/figures/april12_delta_vs_p_increase_uhat5.png)<!-- -->
