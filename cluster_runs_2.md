Second batch of cluster runs (with the right delta equation)
================
Isabel Kim
4/6/2022

## Python driver changes

-   Added functions to calculate delta (according to the Mathematica
    equation) in the cluster csv output file.
-   Now the csv will have 6 columns: `a,sigma,k,u_hat,delta,outcome`

## Before submitting to the cluster…

-   Know your sigma, k, and uhat.
-   Create a grid of *a* values.
-   Evaluate *delta* over the grid using
    `factored_delta(a,b,sigma,k,uhat)` with b=1
-   Find the x-intercept (besides a = 0). This is where the critical
    propagule is predicted to occur. Evaluate *a* around this range.

### Example
