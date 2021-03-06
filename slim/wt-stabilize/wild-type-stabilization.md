Wild-type stabilization
================
Isabel Kim
4/7/2022

## Procedure

-   Run `nonWF-model.slim` with `NO_DRIVE=T`
-   Copy and paste the output into a text file
-   Run the python file that parses the output into a csv
    `python check_N.py path-to-output-text-file > path-to-output-csv-file`

## Standard parameters

-   sigma = 0.01 (average dispersal distance for wikld-types)

-   m = 0.005 (bug)

-   growth at zero density = 2

-   exponent on the competition factor = 2 (punish clustering more)

-   run for 588 generations

-   csv output after python:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/standard-params.csv`

-   figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/standard-params-gen-N.png`

``` r
knitr::include_graphics("../wt-stabilize/standard-params-gen-N.png")
```

![](../wt-stabilize/standard-params-gen-N.png)<!-- --> \* min = 29,318
and max = 30,863 (range of 1545)

The population size seems to never stabilize.

## Try letting m = sigma and raising the exponent on the competition factor from 2 to 3

-   sigma = m = 0.01
-   growth at zero density = 2
-   exponent on the competition factor = 3
-   run for 154 generations

Bash commands:

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp3.csv"

python check_N.py $TXT > $CSV
```

-   csv output:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp3.csv`
-   figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp3_gen_vs_N.png`

``` r
knitr::include_graphics("../wt-stabilize/exp3_gen_vs_N.png")
```

![](../wt-stabilize/exp3_gen_vs_N.png)<!-- --> \* min = 29,340 and max =
30,786 (range of 1446) – has only slightly decreased

## Raise exponent even more – to 4

-   sigma = m = 0.01
-   growth at zero density = 2
-   exponent on the competition factor = 4
-   run for 156 generations

Bash commands:

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp4.csv"

python check_N.py $TXT > $CSV
```

-   csv output:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp4.csv`
-   figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp4_gen_vs_N.png`

``` r
knitr::include_graphics("../wt-stabilize/exp4_gen_vs_N.png")
```

![](../wt-stabilize/exp4_gen_vs_N.png)<!-- --> \* min = 27,269 and max =
33,321 (range = 6052) \* The range has increased even more

## Try competition factor of 1 again

-   sigma = m = 0.01
-   growth at zero density = 2
-   exponent on the competition factor = 1
-   run for 189 generations

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp1.csv"

python check_N.py $TXT > $CSV
```

-   csv output:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp1.csv`
-   figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp1_gen_vs_N.png`

``` r
knitr::include_graphics("../wt-stabilize/exp1_gen_vs_N.png")
```

![](../wt-stabilize/exp1_gen_vs_N.png)<!-- --> \* min = 29,249 and max =
30,810 (range = 1561)

## Best option?

-   Competition factor of 4 is probably the worst.
-   Let’s stick with 2.

keep these parameters the same for 3 replicates

-   sigma = 0.01 (average dispersal distance for wikld-types)
-   m = sigma
-   exponent on the competition factor = 2
-   growth at zero density = 2
-   run for 100 generations

### Replicate 1

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate1.csv"

python check_N.py $TXT > $CSV
```

-   csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate1.csv`
    -   min = 29,371 and max = 30,549 (range = 1178)
-   single figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate1.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_replicate1.png")
```

![](../wt-stabilize/exp2_replicate1.png)<!-- -->

### Replicate 2

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate2.csv"

python check_N.py $TXT > $CSV
```

-   csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate2.csv`
    -   min = 29,549 and max = 30,623 (range of 1074)
-   single figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate2.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_replicate2.png")
```

![](../wt-stabilize/exp2_replicate2.png)<!-- -->

### Replicate 3

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate3.csv"

python check_N.py $TXT > $CSV
```

-   csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate3.csv`
    -   min = 29,244 and max = 30,695 (range of 1451)
-   single figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate3.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_replicate3.png")
```

![](../wt-stabilize/exp2_replicate3.png)<!-- -->

### Replicate 4

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate4.csv"

python check_N.py $TXT > $CSV
```

-   csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate4.csv`
    -   min = 29,348 and max = 30,673 (range of 1325)
-   single figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate4.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_replicate4.png")
```

![](../wt-stabilize/exp2_replicate4.png)<!-- -->

### Replicate 5

Bash commands

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate5.csv"

python check_N.py $TXT > $CSV
```

-   csv:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate5.csv`
    -   min = 29,647 and max = 30,889 (range of 1242)
-   single figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_replicate5.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_replicate5.png")
```

![](../wt-stabilize/exp2_replicate5.png)<!-- -->

### Comparing replicates

-   Figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_combined_replicates_plot.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_combined_replicates_plot.png")
```

![](../wt-stabilize/exp2_combined_replicates_plot.png)<!-- -->

-   Just the first 3 replicates:
    -   Figure:
        `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/exp2_combined_replicates_first_3.png`

``` r
knitr::include_graphics("../wt-stabilize/exp2_combined_replicates_first_3.png")
```

![](../wt-stabilize/exp2_combined_replicates_first_3.png)<!-- -->

No clear generation where anything becomes less stochastic.

## What occurred in our gene drive models (in the ten gens before drive drop)?

-   Run this with BETA=2, EXPONENT=1 (as in the normal models)
-   We had a capacity of 50,000
-   And a speed (sigma) of 0.04 (4% of the total area), as opposed to
    our 0.01
    -   Density interaction distance is 0.01

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/gene_drive_replicate1.csv"

python check_N.py $TXT > $CSV
```

-   Figure:
    `/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/gene_drive_replicate1.png`

``` r
knitr::include_graphics("../wt-stabilize/gene_drive_replicate1.png")
```

![](../wt-stabilize/gene_drive_replicate1.png)<!-- -->

Much greater increase than in the 1D models – less stochastic; seems to
stabilize a bit around 52,000. But here, there is some variability (+ or
- 10,000)

## Back to `nonWF-model.slim` with exponent of 2 but try raising the population size to 50,000

-   run for 54 generations

``` bash
TXT="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/output.txt"
CSV="/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/capacity50k.csv"

python check_N.py $TXT > $CSV
```

Figure:
`/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/wt-stabilize/capacity50k.png`

``` r
knitr::include_graphics("../wt-stabilize/capacity50k.png")
```

![](../wt-stabilize/capacity50k.png)<!-- --> \* min = 49,297 and
max=50,748 (range of 1451) \* Not significant improvement from 30,000

## Conclusion

-   Since there isn’t a clear generation where N “levels off” (it’s
    always varying but stays around the carrying capacity), let’s
    release the drive at generation 10, as we did in the chasing paper.
