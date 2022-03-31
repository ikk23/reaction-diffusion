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
