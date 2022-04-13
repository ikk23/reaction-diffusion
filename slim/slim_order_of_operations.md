SLiM write-up
================
Isabel Kim
4/7/2022

## Order of operations:

``` r
knitr::include_graphics("order-slim.png")
```

![](order-slim.png)<!-- -->

### 0. introduction

-   Introduce a population of 30,000 wild-type individuals, each with a
    random x coordinate drawn from the uniform distribution between 0
    and 1.

### 1a. reproduction

-   Get all males within sigma = m = 0.01 of the female
-   Randomly sample a male neighbor to mate with, with their mating
    weight = their fitness
-   Number of offspring depends on the females fitness \* a
    density-dependent factor (beta = 2, exponent = 2)

``` r
knitr::include_graphics("num-offspring-code.png")
```

![](num-offspring-code.png)<!-- -->

### 1b. modifyChild

-   If the generation == the drive release generation (10), then check
    whether the mother was within the drive release square. If so,
    convert the child to d/d.
-   Assign each child a tagF value based on their genotype. This will be
    used in the next generation’s mating weights (for males) and
    fecundity (for females).
-   Draw a displacement distance from the Exponential distribution with
    mean of sigma. Flip a coin to determine whether this is right or
    left of the parent1’s position.
    -   Use periodic conditions such that the boundaries wrap around –
        no position is rejected.

### 2. early() events and fitness evaluation

-   Kill off adults, ie enforce non-overlapping generations

### 3. late() events

-   Only the new children are still present
-   Color all individuals based on whether they have drive (drive = red,
    wt = blue)
-   If gen \< drive release generation, print out just the generation
    and the population size
-   If gen >= drive release generation (“GEN::”), print out the
    generation, population size, frequency of the drive allele, genotype
    frequency of d/d homozygotes, and genotype frequency of d/wt
    heterozygotes
    -   if the drive allele has already been lost, end the simulation
-   Evaluate the i1 interaction (which calculates distances used for
    local mating / density regulation)
-   If gen==100, end the simulation
