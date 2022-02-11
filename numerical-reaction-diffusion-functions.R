library(tidyverse)
library(gifski)
library(av)
library(tidyverse)
library(transformr)
library(gganimate)
library(magick)


# Possible reaction functions. Always takes in a vector of u(x,t) values but also can take in an additional 0-2 parameters.
fisher_reaction = function(u,k){
  # u = a vector of u(x,t) values
  # k = the selection coefficient
  fu = k*u*(1-u)
  return(fu)
}

bistable_reaction = function(u,k,alpha){
  # u = a vector of u(x,t) values
  # k = the selection coefficient (aka s in the Barton paper)
  # alpha = (1-2p_hat) = K/k = the strength of directional selection vs underdominance selection
  u_hat = (1-alpha)/2
  fu = 2*u*(1-u)*(u-u_hat)
  return(fu)
}

multiply_reaction = function(u, factor){
  # u = a vector of u(x,t) values
  # factor = what to multiply u(x,t) by
  fu = u*factor
  return(fu)
}


# Function to calculate du/dx. Apply this function twice to get d^2u/dx^2
approximate_slope = function(x_grid, y_grid){
  # x_grid = the vector of x values that u(x,t) is evaluated over. Assume its length is greater than 2.
  # y_grid = the last u(x,t) values. Should have equal length to x_grid.
  n = length(x_grid)
  slope = rep(0,n)
  for (i in 1:n){
    # For the first point, only take the local slope to the right of the point.
    if (i ==1){
      slope[i] = (y_grid[i+1]-y_grid[i])/(x_grid[i+1]-x_grid[i])
    } else if (i == n){
      # For the last point, only take the local slope to the left of the point.
      slope[i] = (y_grid[i]-y_grid[i-1])/(x_grid[i]-x_grid[i-1])
    } else {
      # For points not on the edges, average the slope to the right and to the left of the point.
      m_right = (y_grid[i+1]-y_grid[i])/(x_grid[i+1]-x_grid[i])
      m_left = (y_grid[i]-y_grid[i-1])/(x_grid[i]-x_grid[i-1])
      slope[i] = (m_right+m_left)/2
    }
  }
  return(slope)
}


# Function to get to the next u(x,t+1)
u_x_t_plus_1 = function(u, x_grid, D, REACTION_FUNCTION,additional_reaction_arguments){
  # u: a vector of current u(x,t) values
  # x_grid: the vector of x values that u(x,t) is evaluated over.
  # D: the diffusion constant
  # REACTION_FUNCTION: the function to use for f(u), the reaction. This function may take 0-2 additional arguments besides u.
  # additional_reaction_arguments: if REACTION_FUNCTION takes other arguments besides u, provide them in this vector in the order that they should be passed into REACTION_FUNCTION. It's assumed that this vector is between length 0 (if the reaction equation only depends on u) and 2 (ex: the bistable wave, which also depends on k and alpha)
  
  first_derivative_approximation = approximate_slope(x_grid=x_grid,y_grid = u)
  second_derivative_approximation = approximate_slope(x_grid=x_grid, y_grid=first_derivative_approximation)
  
  diffusion_term = D*second_derivative_approximation
  
  if (!is.function(REACTION_FUNCTION)){
    stop("This is not a defined REACTION_FUNCTION")
  }
  n_args = length(additional_reaction_arguments)
  if (n_args==0){
    reaction_term = REACTION_FUNCTION(u)
  } else if (n_args==1){
    reaction_term = REACTION_FUNCTION(u,additional_reaction_arguments)
  } else if (n==2){
    reaction_term = REACTION_FUNCTION(u, additional_reaction_arguments[1],additional_reaction_arguments[2])
  } else {
    stop("REACTION_FUNCTION has more than 2 other arguments")
  }
  
  u_x_t_plus_1_approximation = u + diffusion_term + reaction_term
  
  return(u_x_t_plus_1_approximation)
} 


# Function to simulate the wave for a certain number of time steps and return a tibble of x,t,u(x,t) values
simulate_u_x_t = function(u, x_grid,time_steps, D, REACTION_FUNCTION, additional_reaction_arguments){
  # u: a vector of u(x,t) values. This can be observed output from SLiM or x_grid plugged into a function such as the Gaussian kernel.
  # x_grid: the vector of x values that u(x,t) is evaluated over.
  # time_steps: the number of time steps to run this for
  # D: the diffusion constant
  # REACTION_FUNCTION: the function to use for f(u), the reaction. This function may take 0-2 additional arguments besides u.
  # additional_reaction_arguments: if REACTION_FUNCTION takes other arguments besides u, provide them in this vector in the order that they should be passed into REACTION_FUNCTION. It's assumed that this vector is between length 0 (if the reaction equation only depends on u) and 2 (ex: the bistable wave, which also depends on k and alpha).
  
  n_space = length(x_grid)

  # Initialize these vectors with the starting values and append to them during every iteration
  x_expanded_grid = c(x_grid)
  t_expanded_grid = c(rep(0,n_space)) # fill in 
  uxt_expanded_grid = c(u) # fill in 
  
  for (i in 1:time_steps){
    time = i # take the initial u as t=0
    u = u_x_t_plus_1(u,x_grid,D,REACTION_FUNCTION,additional_reaction_arguments)
    
    # append to vector
    x_expanded_grid = c(x_expanded_grid,x_grid)
    t_expanded_grid = c(t_expanded_grid,rep(time,n_space))
    uxt_expanded_grid = c(uxt_expanded_grid,u)
  }
  
  results = tibble(t = t_expanded_grid, x = x_expanded_grid, uxt = uxt_expanded_grid)
  return(results)
}

plot_wave = function(results){
  # results = a tibble with columns: t,x,uxt showing how u(x,t) changes over time steps and over the x_grid
  
}



results_normal_t2 = simulate_u_x_t(u0,x_grid,2,D=1, REACTION_FUNCTION = fisher_reaction, additional_reaction_arguments = c(0))
dim(results_normal_t2)
View(results_normal_t2)
