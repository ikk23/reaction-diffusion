`Mathematica tutorial`
================
Isabel Kim
3/31/2022

## [Fast introduction for programmers](https://www.wolfram.com/language/fast-introduction-for-programmers/en/)

-   To enter commands s.t. `Mathematica` gives you `Out[1]`, you have to
    do `SHIFT` –> `ENTER`
-   ex:

``` r
In[1]= 2+2 SHIFT --> ENTER
Out[1]= 4
```

-   The `In[n]` and `Out[n]` label successive inputs and outputs

-   Wolfram has nearly 6,000 built-in functions

    -   ex: `Range[20]` produces a vector from 1 to 20
    -   ex: `Plus[2,2]` is the same as `2+2`

-   Lists are created with the curly brackets

    -   Index the list with two square brackets
    -   Indexes start at 1

-   Assignments are made with the `=` sign, just like any other language

    -   ex: `In[1]=    x = 7`
    -   This is an “immediate” assignment.

-   An alternative assignment is the *delayed assignment*, where the
    value will be recomputed every time it is needed

    -   ex: a time variable; `In[2]=    t:= Now`
    -   `In[3]=     t`
    -   `Out[3]=    Sat 31 May 2014...`
    -   `In[4]=     t`
    -   `Out[4]=    Sun 1 June 2014...`

-   To clear the assignments, use the period:

    -   `In[1]     x=.`
    -   `In[1]     t=.`

-   Function definitions are just assignments that give transformation
    rules for patterns

    -   ex: `In[1]=      f[x_, y_]:= x + y`
    -   Then `In[2]=     f[4,a]` will use the function’s definition to
        produce
    -   `Out[2]=    4+a`

-   Can remove the function by clearing its definition:
    `In[3]=     Clear[f]`

-   You can graph in `Mathematica`

    -   ex: `In[1]=      ListLinePlot[{5,6,1,5,7,8,1,3}]`
        -   This will use the index of each element in the vector as the
            x-variable
    -   Or you can specify the x and y variables:
        `In[2]=    Graph[{1->3, 1->2, 2->4, 4->5, 5->1}]`

-   By default, `Mathematica` will try to do exact computation.

-   But use the `N[]` function to get (potentially faster) numerical
    results

    -   ex: `In[1]=   3/7 + 2/11` will give the exact fraction:
        `Out[1]=    47/77`
    -   ex: `In[2]=   N[3/7 + 2/11]` will give `Out[2]=    0.61039`

-   Can do natural language input – `Mathematica` will try to interpret
    what you’re asking. Be sure to place an `=` sign in front of the
    command, and only use the ENTER key afterwards.

    -   `In[1]=  = picture of a wolf` ENTER

## [Online textbook](https://www.wolfram.com/language/elementary-introduction/2nd-ed/01-starting-out-elementary-arithmetic.html)

### Basics

-   Exponentiation is like R not python. ex: `3^2`
-   You can do all basic arithmetic functions, like `3*3` with a
    function instead.
-   All functions use square brackets and have names that start with
    capital letters
    -   `Plus[2,2]` is 2+2
    -   `Subtract[5,2]` is 5-2
    -   `Times[2,3]` is 2\*3
    -   `Divide[6,2]` is 6/2
    -   `Power[3,2]` is 3^2
    -   `Max[3,4]` takes the max
    -   `Min[3,4]` takes the min
    -   `RandomInteger[10]` finds a random whole number between 0 and 10

### More about numbers

-   Adding `1/2 + 1/3` will give an exact answer as a fraction `5/6`
-   To get a numerical or decimal approximation, use the function `N[]`
    (for “numerical”)
    -   ex: `N[1/2 + 1/3]` gives `0.83333333`
-   But the presence of a decimal number already makes the result
    approximate
    -   ex: `1.8/2 + 1/3` gives `1.233333`
    -   ex: `1/2. + 1/3` gives `0.83333`
-   For big numbers, use `N[]` to get the answer in scientific notation
    -   ex: `N[2^1000]` gives `1.07151x10^301`
-   To *enter a number in scientific notation*, use `*^`
    -   ex: `2.7*^6` outputs `2.7x10^6`
-   Commonly used numbers like pi are built into the Wolfram Language
    -   ex: `N[Pi]` outputs 3.14159
    -   You can enter another argument into `N[]` to specify *x* number
        of total digits of pi
        -   ex: `N[Pi,10]` outputs 3.141592654
-   Other functions:
    -   `N[expr]` = numerical approximation
    -   `Pi` = the number pi
    -   `Sqrt[x]` = square root
    -   `Log10[x]` = logarithm with base 10
    -   `Log[x]` = natural log
    -   `Abs[x]` = absolute value
    -   `Round[x]` = round to the nearest integer
    -   `Prime[n]` = the nth prime number
    -   `Mod[x,n]` = modulo
    -   `RandomReal[max]` = random real number between 0 and *max*
    -   `RandomReal[max,n]` = list of *n* random real numbers
    -   `ListLogPlot[data]` = plot on a logarithm scale

### Defining your own functions

-   The `:=` after a function name will tell `Mathematica` to define
    this function
-   Use `x_` the underscores in the parameter names
-   ex: `pinks[n_]:= Table[Pink, n]` creates a pink table of length `n`
-   ex: `plusminus[{x_,y_}]:= {x+y, x-y}`
    -   `plusminus[{4,1}]` –> `{5,3}`

## [Calculus](https://reference.wolfram.com/language/guide/Calculus.html)

-   `D[f,x]` gives the partial derivative `df/dx`
    -   ex: `D[x^n, x]` is (d/dx)(x^n) = n(x^{n-1}) –> output:
        `nx^{-1+n}`
-   Can take the *2nd* derivative by supplying a vector argument to
    `D[]`
    -   ex: `D[f, {x,n}]` is the *nth* derivative of `f` with respect to
        `x` = (d^n / dx^n)(f)
    -   ex: the *nth* derivative of Cos(x): `D[Cos[x], {x,n}]`
-   `Integrate[f,x]` gives the indefinite integral `int f dx`
    -   ex: `Integrate[x^2 + Sin[x], x]` outputs `x^3/3 - Cos[x]`
-   For a *definite* integral with bounds, supply a vector argument –
    1st variable is the variable to integrate over (`x`), next variable
    is the lower bound, third variable is the upper bound
    -   ex: `Integrate[1/(x^3 + 1), {x,0,1}]` outputs
        `1/18 (2sqrt(3) + Log[64])`
