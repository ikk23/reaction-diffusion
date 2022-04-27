library(tidyverse)
library(ggplot2)
library(gifski)
library(av)
library(transformr)
library(gganimate)
library(magick)
require(pracma)

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
u_x_t_plus_1 = function(u, x_grid, D,k, uhat){
  # u: a vector of current u(x,t) values
  # x_grid: the vector of x values that u(x,t) is evaluated over.
  # D: the diffusion constant
  # k: the selection coefficient
  # uhat: the invasion frequency
  
  first_derivative_approximation = approximate_slope(x_grid=x_grid,y_grid = u)
  second_derivative_approximation = approximate_slope(x_grid=x_grid, y_grid=first_derivative_approximation)
  
  diffusion_term = D*second_derivative_approximation
  
  reaction_term = 2*k*u*(1-u)*(u-uhat)
  
  u_x_t_plus_1_approximation = u + diffusion_term + reaction_term
  
  return(u_x_t_plus_1_approximation)
}

# Function to simulate the wave for a certain number of time steps and plot the output as a gif
simulate_u_x_t = function(u, x_grid,time_steps, D, k,uhat, save_plot_path = NULL){
  # u: a vector of u(x,t) values. This can be observed output or the results of the x_grid plugged into a function such as the Gaussian kernel.
  # x_grid: the vector of x values that u(x,t) is evaluated over.
  # time_steps: the number of time steps to run this for
  # D: the diffusion constant
  # k: the selection coefficient
  # uhat: the invasion frequency
  # save_plot_path: if this isn't NULL, saves the gif to this path

  n_space = length(x_grid) # number of x-positions

  # Initialize these vectors with the starting values and append to them during every iteration
  x_expanded_grid = c(x_grid)
  t_expanded_grid = c(rep(0,n_space))
  uxt_expanded_grid = c(u)
  
  for (i in 1:time_steps){
    time = i # take the initial u as t=0
    u = u_x_t_plus_1(u,x_grid,D,k,uhat)
    x_expanded_grid = c(x_expanded_grid,x_grid)
    t_expanded_grid = c(t_expanded_grid,rep(time,n_space))
    uxt_expanded_grid = c(uxt_expanded_grid,u)
  }
  
  results = tibble(t = t_expanded_grid, x = x_expanded_grid, uxt = uxt_expanded_grid)
  
  # Create gif
  plot = ggplot(data = results, aes(x = x, y = uxt)) + 
    geom_line(color="red",aes(group=t)) + 
    transition_time(t) +
    labs(x = "x", y = "u(x,t)",title = "t: {frame_time}") +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) + geom_hline(yintercept = uhat, color = "grey")
  
  if (is.null(save_plot_path)){
    return(plot)
  } else{
    anim = animate(plot,renderer = magick_renderer())
    anim_save(filename = save_plot_path, animation = anim)
    print(paste("Saving",save_plot_path))
    return(plot)
  }
}



