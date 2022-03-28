library(tidyverse)
library(ggplot2)
library(gifski)
library(av)
library(transformr)
library(gganimate)
library(magick)
require(pracma)

# Function to simulate an initial square with width (a) and height (b)
u_initial = function(x,a,b){
  if (x >= -a/2 & x <= a/2){
    u = b
  } else {
    u = 0
  }
  return(u)
}

# Function for the probability of dispersing a distance of |x-x_prime| based on 
# the exponential distribution with mean of sigma / rate of 1/sigma.
exponential_dispersal_kernel = function(sigma,x,x_prime){
  rate = 1/sigma
  x_distance = abs(x-x_prime)
  p = dexp(x=x_distance,rate=rate)
  return(p)
}

# Function to get the new u'(x,t) curve after migration but before the reaction equation
u_prime_x = function(u_x_here, x, sigma, a){
  # when t = 0, u_x_here is always b
  # when t > 0, u_x_here = u(x') = u(x) at this new position
  if (x < -a/2 || x > a/2){
    return(0)
  }
  e_term_1 = exp((-1/sigma)*(x + (a/2)))
  e_term_2 = exp((-1/sigma)*((a/2) - x))
  sol = u_x_here*(2-e_term_1-e_term_2)
  return(sol)
}

# Barton 2011's bistable wave reaction equation. Apply this to u'(x,t) after migration
bistable_reaction_function = function(u,k,u_hat){
  f = 2*k*u*(1-u)*(u-u_hat)
  return(f)
}

u_x_t1 = rep(-1,n)
for (i in 1:n){
  x = x_grid[i]
  u_x_t1[i] = bistable_reaction_function(u_prime_t0[i],k,u_hat)
}

simulate = function(x_grid, a, b, sigma, k, u_hat,time_steps){
  n = length(x_grid)
  lower = -a/2
  index_lower = which(x_grid == lower)
  upper = a/2
  index_upper = which(x_grid == upper)
  
  if (x_grid[1] > lower || x_grid[n] < upper){
    stop("x_grid has to be bigger")
  }
  if (length(index_lower) == 0 || length(index_upper) == 0){
    stop("make sure -a/2 and a/2 are within x_grid")
  }
  
  # Vectors to store all the simulation data in for the gganimation 
  x_expanded_grid = c() # length = time_steps*n
  time_expanded = c() # length = time_steps*n
  u_x_expanded = c() # length = time_steps*n
  AUC_with_time = c() # only 1 per timestep, so length = time_steps
  time_vector = c() # simply 0,1,...,timesteps
  
  # Set up u(x,t=0) based on the initial square function
  u_x_t = rep(-1,n)
  for (i in 1:n){
    x = x_grid[i]
    u_x_t[i] = u_initial(x,a,b)
  }
  # Store u(x,t=0) data
  x_expanded_grid = c(x_expanded_grid, x_grid) 
  time_expanded = c(time_expanded, rep(0,n))
  u_x_expanded = c(u_x_expanded, u_x_t) 
  
  time_vector = c(time_vector, 0)
  AUC_with_time = c(AUC_with_time, a*b)
  
  # moving beyond t=0:
  for (t in 1:time_steps){ # t = the time step we're aiming to find u(x,t) for. Currently have u(x,t-1).
    u_x_prime_t_vec = rep(-1,n)
    u_x_t_new = rep(-1,n)
    # Loop through the x-grid and, if x is within [-a/2, a/2], apply the migration function and then reaction function
    for (i in 1:n){
      x = x_grid[i]
      
      # If x is out of range, don't bother applying the migration or reaction functions
      if (x < lower || x > upper){
        u_x_prime_t_vec[i] = 0
        u_x_t_new[i] = 0
      } else {
        constant = u_x_t[i] # u(x',t) = u(x,t) after moving from x to x' here....
        u_x_prime_t_vec[i] = u_prime_x(constant,x,sigma,a) # curve after migration -- NEED TO FIX.
        u_x_t_new[i] = bistable_reaction_function(u_x_prime_t_vec[i], k, u_hat)
      }
    }
    # Calculate new AUC
    AUC = trapz(x=x_grid[index_lower:index_upper],y=u_x_t_new[index_lower:index_upper])
      
    # Save variables
    x_expanded_grid = c(x_expanded_grid, x_grid) 
    time_expanded = c(time_expanded, rep(t,n))
    u_x_expanded = c(u_x_expanded, u_x_t_new) 
    time_vector = c(time_vector,t)
    AUC_with_time = c(AUC_with_time, AUC)
    
    # Save new u_x_t
    u_x_t = u_x_t_new
  }
  
  concacenated_results = tibble(x=x_expanded_grid,
                                u_x = u_x_expanded,
                                t = time_expanded)
  
  y_upper = max(concacenated_results$u_x)
  y_lower = min(concacenated_results$u_x)
  
  plot = ggplot(data = concacenated_results, aes(x = x, y = u_x)) + 
    geom_point(color="red",aes(group=t)) + 
    transition_time(t) +
    labs(x = "x", y = "u(x,t)", title = 't: {frame_time}') +
    xlim(x_grid[1], x_grid[n]) + ylim(y_lower,y_upper) + 
    ylab("u(x)") + 
    xlab("x")
  
  print(plot)
  
  return(list(concacenated_results = concacenated_results, time_vector = time_vector, AUC_vector = AUC_with_time))
  
}


x_grid = seq(-3,3,by=0.01)
a = 4
b = 0.4
u_hat = 0.2
k = 0.05
time_steps = 3
sigma = 0.5
r = simulate(x_grid,a,b,sigma,k,u_hat,time_steps)

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
