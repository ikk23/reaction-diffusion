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

x_grid = seq(-1000,1000,by=0.1)
n = length(x_grid)
a = 1000
b = 0.5
sigma = 1

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


# reaction
k=0.1
u_hat=0.4
u_x_t1_grid = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  u_x_t1_grid[i] = u_x_t1(x,a,b,sigma,u_hat,k)
}

tib = tibble(x = x_grid,
             ux_t0 = ux0_grid, 
             u_prime_x_t1 = ux_prime_t1_grid,
             ux_t1 = u_x_t1_grid)
ymax = max(c(ux0_grid,ux_prime_t1_grid,u_x_t1_grid))
ymin = min(c(ux0_grid,ux_prime_t1_grid,u_x_t1_grid))

plot = ggplot(data=tib,mapping=aes(x=x_grid)) + 
  geom_line(aes(y=ux_t0),color="black") + 
  geom_line(aes(y=u_prime_x_t1), color = "red") + 
  geom_line(aes(y=ux_t1), color = "blue") + 
  ylim(0,b) + 
  geom_hline(yintercept = 0)
plot

