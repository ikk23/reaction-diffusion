library(tidyverse)
library(ggplot2)
library(gifski)
library(av)
library(transformr)
library(gganimate)
library(magick)
require(pracma)

# Start with individuals only released in a square with width a and height b
u_initial = function(x,a,b){
  if (x >= -a/2 & x <= a/2){
    u = b
  } else {
    u = 0
  }
  return(u)
}

# ex: a = 4 and b = 4. Therefore, the area is bounded by x = -2 and x = 2.
a=6
b=0.3 # frequency of 30%
k = 0.1
u_hat = 0.1
x_grid = seq(-10,10,by=0.01)
u_x_t0 = rep(4,length(x_grid))
for (i in 1:length(x_grid)){
  u_x_t0[i] = u_initial(x_grid[i],a,b)
}
plot(x_grid,u_x_t0)

# The dispersal kernel is the exponential, with mean = sigma. This means that the rate is 1/sigma.
sigma = 0.5
rate = 1/sigma
x = 0
x_prime = 2
x_distance = abs(x-x_prime)
dispersal_probability = dexp(x=x_distance,rate=rate)

exponential_dispersal_kernel = function(sigma,x,x_prime){
  # sigma = the average dispersal distance
  rate = 1/sigma
  x_distance = abs(x-x_prime)
  p = dexp(x=x_distance,rate=rate)
  return(p)
}

# Plot some of this kernel
x_distances = seq(0,10,by=0.1)
sigma=0.5
rate = 1/sigma
probs = dexp(x_distances,rate=rate)
plot(x_distances,probs)

# u'(x,0) = integral of (b)(exponential_dispersal_kernel) for t=0
u_prime_of_x_t0 = function(x,a,b,sigma){
  
  if (x < (-a/2) || x > (a/2)){
    return(0)
  }
  
  e_term_1 = exp((-1/sigma)*(x+(a/2)))
  e_term_2 = exp((-1/sigma)*((a/2)-x))
  sol = b*(2-e_term_1-e_term_2)
  return(sol)
}

n = length(u_x_t0)
u_prime_t0 = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  u_prime_t0[i] = u_prime_of_x_t0(x,a,b,sigma)
}

# Reaction
bistable_reaction_function = function(u,k,u_hat){
  f = 2*k*u*(1-u)*(u-u_hat)
  return(f)
}

u_x_t1 = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  u_x_t1[i] = bistable_reaction_function(u_prime_t0[i],k,u_hat)
}

library(tidyverse)
library(ggplot2)
info = tibble(x = x_grid, u_x_t0 = u_x_t0, u_prime_t0 = u_prime_t0, u_x_t1 = u_x_t1)

plot = ggplot(info) + 
  geom_point(aes(x=x,y=u_x_t0),col="black") + 
  geom_point(aes(x=x,y=u_prime_t0),col="yellow") + 
  geom_point(aes(x=x,y=u_x_t1),col="red") +
  geom_hline(yintercept=0) + geom_vline(xintercept = 0) +
  xlim(-2,2) + ylim(0,0.6)
plot

AUC = trapz(x = x_grid[c(which(x_grid==-2):which(x_grid==2))], y = u_x_t1[c(which(x_grid==-2):which(x_grid==2))])
AUC > (a*b) # FALSE


time_step1 = function(x_grid,a,b,sigma,k,u_hat,plot=TRUE){
  n = length(x_grid)
  
  # For each x:
  ## Calculate u(x=x,t=0), the initial square
  ## Calculate u'(x=x,t=0) based on the dispersal kernel
  ## Calculate u(x=x,t=1) based on the reaction function

  ux0 = rep(-1,n)
  ux_prime0 = rep(-1,n)
  ux_t1 = rep(-1,n)
  for (i in 1:n){
    x = x_grid[i]
    u_of_x_t0 = u_initial(x,a,b) # u(x=x,t=0)
    u_prime_of_x_at_t0 = u_prime_of_x_t0(x,a,b,sigma) # u'(x=x,t=0) post-migration
    u_of_x_t1 = bistable_reaction_function(u_prime_of_x_at_t0,k,u_hat)
    
    ux0[i] = u_of_x_t0
    ux_prime0[i] = u_prime_of_x_at_t0
    ux_t1[i] = u_of_x_t1
  }
  
  info = tibble(x = x_grid, u_x_t0 = ux0, u_prime_x_t0 = ux_prime0, u_x_t1 = ux_t1)
  
  AUC_initial = a*b
  
  index1 = which(x_grid==(-a/2))
  index2 = which(x_grid==(a/2))
  
  AUC_t1 = trapz(x=x_grid[index1:index2],y=ux_t1[index1:index2])
  auc_increased = (AUC_t1 > AUC_initial)
  
  if (plot){
    plt = ggplot(info) + 
      geom_point(aes(x=x,y=u_x_t0),col="black") + 
      geom_point(aes(x=x,y=u_prime_x_t0),col="yellow") + 
      geom_point(aes(x=x,y=u_x_t1),col="red") +
      geom_hline(yintercept=0) + geom_vline(xintercept = 0) +
      xlim(-(a/2),(a/2)) + ylim(0,1.0) + ylab("u(x)")
    print(plt)
    
    results = list(u_info = info, 
                   ab = AUC_initial, 
                   AUC_u_x_t1 = AUC_t1, 
                   auc_increased = auc_increased, 
                   plot = plt)
  } else {
    results = list(u_info = info, 
                   ab = AUC_initial, 
                   AUC_u_x_t1 = AUC_t1, 
                   auc_increased = auc_increased)
  }
  return(results)
}

time_steps_after_1 = function(u_x,x_grid,a,b,sigma,k,u_hat){
  n = length(x_grid)
  u_x_prime = rep(-1,n)
  u_x_next = rep(-1,n)
  for (i in 1:n){
    x = x_grid[i]
    u_t_here = u_x[i]
    
    # 1. u'(x=x,t=t) = integral from -a/2 to a/2 of u(x=x,t=t)*(delta(x,x'))
    u_prime_x_here = (1/b)*(u_t_here)*u_prime_of_x_t0(x,a,b,sigma)
    u_x_prime[i] = u_prime_x_here
    
    # 2. Reaction
    u_x_next_here = bistable_reaction_function(u_prime_x_here,k,u_hat)
    u_x_next[i] = u_x_next_here
  }
  
  return(u_x_next)
}

a = 4
b = 0.3
u_hat = 0.01
k = 0.99
sigma = 0.2
x_grid = seq(-a/2,a/2,by=0.01)
res = time_step1(x_grid,a,b,sigma,k,u_hat)
res$ab
res$AUC_u_x_t1
res$auc_increased

res_after_t2 = time_steps_after_1(res$u_info$u_x_t1, x_grid,a,b,sigma,k,u_hat)
info_more = res$u_info %>% add_column(u_x_t2 = res_after_t2)
plt = ggplot(info_more) + 
      geom_point(aes(x=x,y=u_x_t0),col="black") + 
      geom_point(aes(x=x,y=u_x_t1),col="red") +
      geom_point(aes(x=x,y=u_x_t2), col="purple")+
      geom_hline(yintercept=0) + geom_vline(xintercept = 0) +
      xlim(-(a/2),(a/2)) + ylim(0,1.0) + ylab("u(x)")
plt

simulate_discrete_time_wave = function(x_grid,a,b,sigma,k,u_hat,time_steps){
  step1 = time_step1(x_grid,a,b,sigma,k,u_hat,plot=FALSE)
  ab_start = step1$ab
  AUC_t1 = step1$AUC_u_x_t1
  ux0 = step1$u_info$u_x_t0
  ux = step1$u_info$u_x_t1
  
  n = length(x_grid)
  x_expanded_grid = c(x_grid,x_grid)
  u_x_expanded = c(ux0, ux)
  t_vector = c(rep(1,n),rep(2,n))
  for (i in 2:time_steps){
    ux = time_steps_after_1(ux,x_grid,a,b,sigma,k,u_hat)

    x_expanded_grid = c(x_expanded_grid,x_grid)
    u_x_expanded = c(u_x_expanded,ux)
    t_vector = c(t_vector,rep(i,n))
  }
  concacenated_results = tibble(x=x_expanded_grid,
                                u_x = u_x_expanded,
                                t = t_vector)
  
  plot = ggplot(data = concacenated_results, aes(x = x, y = u_x)) + 
    geom_point(color="red",aes(group=t)) + 
    transition_time(t) +
    labs(x = "x", y = "u(x,t)",title = "t: {frame_time}") +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) +
    xlim(-a/2, a/2) + ylim(0,1) + ylab("u(x)") + xlab("x") +
    geom_vline(xintercept = -a/2, col="yellow") + 
    geom_vline(xintercept = a/2, col="yellow") +
    geom_hline(yintercept = b, col="yellow")
  
  print(plot)
  return(concacenated_results)
}

# a = 4, b = 0.3, k = 0.99, u_hat = 0.01, sigma = 0.2
r = simulate_discrete_time_wave(x_grid,a,b,sigma,k,u_hat,time_steps = 6)
# simulate a smaller area
a=1
r = simulate_discrete_time_wave(x_grid,a,b,sigma,k,u_hat,time_steps = 6)
# raise u_hat
u_hat = 0.1
r = simulate_discrete_time_wave(x_grid,a,b,sigma,k,u_hat,time_steps = 6)
