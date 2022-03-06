library(tidyverse)
library(ggplot2)
require(pracma)


u_x0 = function(x,a,b){
  if (x > a/2 || x < -(a/2)){
    return(0)
  } else {
    return(b)
  }
}

u_prime_x1 = function(x,a,b,sigma){
  sig_recip = -1/sigma
  e_term1 = exp(sig_recip*(x+(a/2)))
  e_term2 = exp(sig_recip*((a/2)-x))
  sol = (b/2)*(2 - e_term1 - e_term2)
  return(sol)
}

# initial u(x,t=0)
ux0_grid = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  ux0_grid[i] = u_x0(x,a,b)
}

# migration: u'(x,t=1)
ux_prime_t1_grid = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  ux_prime_t1_grid[i] = u_prime_x1(x,a,b,sigma)
}

# Check that AUC of u'(x,t=1) = a*b
x_grid = seq(-1000,1000,by=0.1)
n = length(x_grid)
a = 1000
b = 0.5
sigma = 1
tib = tibble(x = x_grid, ux_t0 = ux0_grid, u_prime_x_t1 = ux_prime_t1_grid)
ymax = max(c(ux0_grid,ux_prime_t1_grid))
ymin = min(c(ux0_grid,ux_prime_t1_grid))
plot = ggplot(data=tib,mapping=aes(x=x_grid)) + geom_line(aes(y=ux0_grid),color="black") + geom_line(aes(y=ux_prime_t1_grid), color = "red") + ylim(0,ymax) + geom_hline(yintercept = 0)
plot
# Get numerical AUC for u'(x,t=1)
x_axis_vector = rep(0,n)
above = ux_prime_t1_grid > x_axis_vector
intersect.points = which(diff(above) != 0)
index1 = intersect.points[1]
index2 = intersect.points[2]
x1 = x_grid[index1]
x2 = x_grid[index2]
x_range_of_integration = x_grid[index1:index2]
u_x_prime_t1_range_of_integration = ux_prime_t1_grid[index1:index2]
AUC2 = trapz(x_range_of_integration,u_x_prime_t1_range_of_integration)
print(paste("AUC0 =",a*b,"-- AUC1 =",round(AUC2,5))) # CHECKS -- AUC stays the same.
# Check if u'(x,t=1) --> b as a --> infinity
x = 0
a = 1e6
b = 0.5
sigma = 1
u_prime_x1(x,a,b,sigma) # goes to b -- CHECK

##### u(x,t=1) formula #### 

# Solution from last night
u_x_t1 = function(x,a,b,sigma,u_hat,k){
  
  # constants
  term1 = (b-u_hat)*(k*b)*(2-(2*b)-(b*exp(-a/sigma)))
  term2 = (k*(b^2))*((2*b)-1)*(exp(-a/sigma))
  constants = term1 + term2
  
  # e^{-1/sigma * (x+ a/2)}
  term1 = (b-u_hat)*(k*b)*((2*b)-1)
  term2 =  ((-k*(b^2))/2)*(2-(2*b)-(b*exp(-a/sigma)))
  e_1 = (term1+term2)*(exp((-1/sigma)*(x + (a/2))))
  
  # e^{-1/sigma * (a/2 - x)}
  term1 = (b-u_hat)*(k*b)*((2*b) - 1)
  term2 = (-k*(b^2)/2)*(2 - (2*b) - (b*exp(-a/sigma)))
  e_2 = (term1+term2)*(exp((-1/sigma)*((a/2)-x)))
  
  # e^{-2/sigma * (x+ a/2)}
  term1 = (-k*(b^2)/2)*(b-u_hat)
  term2 = (-k*(b^2)/2)*((2*b)-1)
  e_3 = (term1+term2)*(exp((-2/sigma)*(x + (a/2))))
  
  # e^{-2/sigma * (a/2 - x)}
  term1 = (-k*(b^2)/2)*(b-u_hat)
  term2 = (-k*(b^2)/2)*((2*b) - 1)
  e_4 = (term1 + term2)*(exp((-2/sigma)*((a/2) - x)))
  
  # e^{-3/sigma (x + a/2)}
  term = k*(b^3)/4
  e_5 = term*(exp((-3/sigma)*(x+(a/2))))
  
  # e^{-1/sigma * (3a/2 - x)}
  e_6 = term*(exp((-1/sigma)*((3*a/2)-x)))
  
  # e^{-1/sigma * (3a/2 + x)}
  e_7 = term*(exp((-1/sigma)*((3*a/2)+x)))
  
  # e^{-3/sigma * (a/2 - x)}
  e_8 = term*(exp((-3/sigma)*((a/2)-x)))
  
  sol = constants + e_1 + e_2 + e_3 + e_4 + e_5 + e_6 + e_7 + e_8
  
  return(sol)
  
}

# Solution from today -- see if this equals u_x_t1 or the 2-step solution
u_x_t1_factored = function(x,a,b,sigma,u_hat,k){
  e_term = exp((-1/sigma)*(x + (a/2))) + exp((-1/sigma)*((a/2)-x))
  constants = (2*k*b)*(1-b)*(b-u_hat)
  
  
  inner = (b*((3*b)-(2*u_hat)-2)) + u_hat
  c = k*b*inner
  power1_term = c*(e_term)
  
  power2_term = ((-k*(b^2))/2)*((3*b)-u_hat-1)*(e_term^2)
  
  power3_term = (k*(b^3)/4)*(e_term^3)
  
  sol = constants + power1_term + power2_term + power3_term
  
  return(sol)
}

# Graph u(x,t=0), u'(x,t=1), and u(x,t=1)
plot_t0_to_t1 = function(x_grid, a, b, sigma, u_hat, k, plot_all=TRUE){
  n = length(x_grid)
  
  u_xt0_grid = rep(-1,n)
  u_prime_xt1_grid = rep(-1,n)
  u_xt1_grid_full_sol = rep(-1,n)
  u_xt1_grid_two_step = rep(-1,n)
  u_xt1_grid_full_sol_2 = rep(-1,n)
  
  for (i in 1:n){
    x = x_grid[i]
    u_xt0_grid[i] = u_x0(x,a,b)
    u_prime_xt1_grid[i] = u_prime_x1(x,a,b,sigma)
    
    # These should be equal
    u_xt1_grid_full_sol[i] = u_x_t1(x,a,b,sigma,u_hat,k)
    u_xt1_grid_two_step[i] = 2*k*(u_prime_xt1_grid[i])*(1-u_prime_xt1_grid[i])*(u_prime_xt1_grid[i] - u_hat)
   
    u_xt1_grid_full_sol_2[i] = u_x_t1_factored(x,a,b,sigma,u_hat,k)
  }
  
  results = tibble(x = x_grid, 
                   u_x_t0 = u_xt0_grid,
                   u_prime_x_t1 = u_prime_xt1_grid,
                   u_xt1_full_sol = u_xt1_grid_full_sol,
                   u_xt1_two_step = u_xt1_grid_two_step,
                   u_xt1_grid_full_sol_2 = u_xt1_grid_full_sol_2,
                   diff_between_u_xt1_sols = abs(u_xt1_two_step-u_xt1_full_sol),
                   diff_in_uxt_sol1_and_two_step = abs(u_xt1_grid_full_sol-u_xt1_grid_two_step),
                   diff_in_uxt_sol2_and_two_step = abs(u_xt1_grid_full_sol_2-u_xt1_grid_two_step))
  
  if (plot_all){
    plot = ggplot(results, aes(x = x_grid)) + 
    geom_point(aes(y = u_x_t0), color = "black") + # black = initial square
    geom_point(aes(y = u_prime_x_t1), color = "yellow") + # yellow = migration
    geom_point(aes(y = u_xt1_two_step), color = "blue") + # dark blue = first solution
    geom_point(aes(y = u_xt1_full_sol), color = "forestgreen") + # green = what it should be 
    geom_point(aes(y = u_xt1_grid_full_sol_2), color = "darkorchid2") + # purple = second solution
    ylim(0,b) + ylab("u(x)") + xlab("x")
  } else {
      plot = ggplot(results, aes(x = x_grid)) + 
    geom_point(aes(y = u_x_t0), color = "black") + # black = initial square
    geom_point(aes(y = u_prime_x_t1), color = "yellow") + # yellow = migration
    geom_point(aes(y = u_xt1_grid_full_sol_2), color = "darkorchid2") + # purple = second solution
    ylab("u(x)") + xlab("x")
  }

  
  print(plot)
  
  return(list(results = results, plot = plot))
  
}

### ex 1:

# Let a be very large
# Let b be big but less than 1
# Let k be strong
# Let u_hat be weak (not as much of a reaction effect)?
# Let sigma also be large -- lots of diffusion
a = 100
b = 0.9
u_hat = 0.1
k = 0.4
sigma = 10 # avg number of units traveled
x_grid = seq(-100,100,by=0.1)
r = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k)


# For this example, all formulas for u(x,t=1) yield around the same thing

# What is going on at the sides, where the line is going up on u_xt1_full_sol?
r$plot # IS THE AUC here the AUC from ~ -56 to 56?



r$plot + geom_vline(xintercept = -56) + geom_vline(xintercept = 56)

i1 = which(r$results$x == -56)
i2 = which(r$results$x == 56)
ab = a*b # theta0 = 90
AUC_56 = trapz(r$results$x[i1:i2], r$results$u_xt1_full_sol[i1:i2])
AUC_56 # Then theta1 is approx 8.001433 

# Examine u(x,t=1) between x_grid[1:i1]
# Examine u(x,t=1) between x_grid[i2:n]

left = r$results %>% filter(x <= -56)
View(left)
left$x[1] # -100, outside of initial -a/2 to a/2 range
left$u_x_t0[1]
left$u_prime_x_t1[1] # -65.88

x = -100
e1 = exp((-1/sigma) * (x + (a/2))) # e1 > 1, since x+a/2 is negative (x < a/2)
e2 = exp((-1/sigma)* ((a/2) - x)) # e2 < 1 because (a/2 - x) > 0 since (a/2 > x)
(b/2) * (2 - e1 - e2) # -65.88 check

# Apply reaction
C = left$u_prime_x_t1[1]
(2*k*C) # if C < 0, this is negative: -52.70874
(1-C) # if C < 0 < 1, this is positive: 66.88592
(C - u_hat) # if C < 0, then u_hat > 0 so C-u_hat < 0 is negative: -65.98592
# negative * positive * negative = positive
(2*k*C)*(1-C)*(C-u_hat) # 232,631.6 = really large

#### ex 2: decreased sigma
a = 100
b = 0.9
u_hat = 0.1
k = 0.4
sigma = 1 # avg number of units traveled
x_grid = seq(-100,100,by=0.1)
w = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k)
plot(w$plot)
# Zooming out for u(x,t=1)
ggplot(w$results,aes(x=x_grid,y=u_xt1_grid_full_sol_2)) + geom_point() + xlab("x") + ylab("u(x,t=1)")
ggsave(filename = paste0(dir,"a=100_b=0.9_sigma=1_k=0.4_uhat=0.1.png"),plot = w$plot)

# Increase sigma from 10 to 50 -- avg distance traveled is a/2
a = 100
b = 0.9
u_hat = 0.1
k = 0.4
sigma = 30 # avg number of units traveled
x_grid = seq(-100,100,by=0.1)
y = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k)
# Here, the approximations look the most off -- the purple (full solution for u(x,t=1)) is below the green (when C = u'(x,t=1) is plugged into 2kC(1-C)(C-u_hat) for every x) 
View(y$results)
plot(y$plot) 
ggplot(y$results,aes(x=x_grid,y=u_xt1_grid_full_sol_2)) + geom_point() + xlab("x") + ylab("u(x,t=1)")
# How to measure AUC? - only from around -56 to 56? Or should the integral be bounded between x_grid[1] and x_grid[n]?

# Decrease a and sigma
a = 20
b = 0.9
u_hat = 0.1
k = 0.4
sigma = 5
x_grid = seq(-20,20,by=0.1)
t = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k)
plot(t$plot)
# Zooming out
ggplot(t$results,aes(x=x_grid,y=u_xt1_grid_full_sol_2)) + geom_point() + xlab("x") + ylab("u(x,t=1)")


# Expand a - check that the limit as a --> infinity of u'(x,t=1) is b.
a = 10000
b = 0.9
u_hat = 0.1
k = 0.4
sigma = 30
q = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k)
q$plot + geom_hline(yintercept = b) # CHECK - with migration, u'(x,t) stays at b. Reaction pushes the line down
View(q$results)
q$plot

u_hat = 0.6
b = u_hat
p = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k,plot_all=FALSE)

b = 0.8 # should rise
p = plot_t0_to_t1(x_grid,a,b,sigma,u_hat,k,plot_all=FALSE)


e_term = function(x,a,sigma){
  sig = -1/sigma
  
  e1 = exp(sig*(x+(a/2)))
  e2 = exp(sig*((a/2)-x))
  
  sol = e1 + e2
  return(sol)
}

a = 1
sigma = 1
x_grid = seq(-500,500,by=0.1)
n = length(x_grid)
e_term_vector = rep(-1,n)
mig_vector = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  e_term_vector[i] = e_term(x,a,sigma)
  mig_vector[i] = u_prime_x1(x,a,b,sigma)
}
plot(x_grid,e_term_vector)
i1 = which(x_grid == -10)
i2 = which(x_grid == 10)
plot(x_grid[i1:i2],e_term_vector[i1:i2])
plot(x_grid[i1:i2],mig_vector[i1:i2])
