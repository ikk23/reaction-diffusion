library(tidyverse)
library(ggplot2)
library(gifski)
library(av)
library(tidyverse)
library(transformr)
library(gganimate)
library(magick)
require(pracma)

# Possible reaction functions. Always takes in a vector of u(x,t) values but also can take in an additional 0-2 parameters.
fisher_reaction = function(u,k){
  # u = a vector of u(x,t) values
  # k = the selection coefficient
  fu = k*u*(1-u)
  return(fu)
}

bistable_reaction = function(u,k,alpha){
  # *before* x and t are scaled
  # u = a vector of u(x,t) values
  # k = the selection coefficient (aka s in the Barton paper)
  # alpha = (1-2p_hat) = K/k = the strength of directional selection vs underdominance selection
  u_hat = (1-alpha)/2
  fu = 2*k*u*(1-u)*(u-u_hat)
  return(fu)
}

# For a bistable wave with a given invasion frequency, this is the alpha value
alpha_for_u_hat = function(u_hat){
  sol = 1-(2*u_hat)
  return(sol)
}

# For a bistable wave, this is the unstable equilibrium frequency
u_hat = function(alpha){
  return((1-alpha)/2)
}

# For a bistable wave, this is the frequency at the center of the "critical bubble" -- where the local increase due to the f(u) reaction is exactly equal to the local decrease due to migration.
# the initial frequency must exceed this value.
# This will be greater than the panmictic equilibrium value, u_hat
u_alpha = function(alpha){
  sqrt_term = sqrt(alpha*(3+alpha))
  sol = 1 - (alpha/3) - ((1/3)*sqrt_term)
  return(sol)
}

# For a bistable wave, this is proportional to the total number of individuals that must be introduced to start a wave of fixation assuming a "critical bubble"
m_alpha = function(alpha){
  upper_term = sqrt(alpha*(alpha+3))
  lower_term = 3 - alpha - (3*sqrt(1-alpha))
  sol = log(upper_term/lower_term)
  return(sol)
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
  } else if (n_args==2){
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

# Function to plot the movement of u(x,t) with gganimate based on the results of simulate_u_x_t
plot_wave = function(results,save_as = NULL, add_hline = NULL){
  # results = a tibble with columns: t,x,uxt showing how u(x,t) changes over time steps and over the x_grid
  # save_as = if this is NULL, don't save the plot. If you want to save the plot, specify the path to the gif file.
  # add_hline = if this is NULL, do nothing. But if this equals a value, then plot a horizontal line at this value (useful for plotting p_hat).
  plot = ggplot(data = results, aes(x = x, y = uxt)) + 
    geom_line(color="red",aes(group=t)) + 
    transition_time(t) +
    labs(x = "x", y = "u(x,t)",title = "t: {frame_time}") +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0)
  
  if (!is.null(add_hline)){
    plot = plot + geom_hline(yintercept = add_hline, color = "grey")
  }

  
  if (is.null(save_as)){
    return(plot)
  } else{
    # need to work on this
    anim = animate(plot,renderer = magick_renderer())
    anim_save(filename = save_as, animation = anim)
    print(paste("Saving",save_as))
    return(plot)
  }
}

# Helper function to plot the approximated first and second derivatives of a curve
plot_derivatives = function(x_grid, u, save_as = NULL,title=NULL){
  # x_grid = the vector of x values that u(x,t) is evaluated over. Assume its length is greater than 2.
  # u = the last u(x,t) values. Should have equal length to x_grid.
  # save_as = if this is not NULL, save the plot to the file path described by this variable.
  # title = the title of the plot. If this is NULL, there's no title.
  first_derivative_approximation = approximate_slope(x_grid=x_grid,
                                                     y_grid = u)
  second_derivative_approximation = approximate_slope(x_grid=x_grid,
                                                      y_grid=first_derivative_approximation)
  
  # Combine the derivatives in a tibble
  # type = u, du_dx, or d2u_dx2
  # x is repeated 3 times
  n = length(u)

  x_expanded=c()
  types_expanded = c()
  values_expanded=c()
  
  for (i in 1:n){
    x_value = x_grid[i]
    u_value = u[i]
    du_dx_value = first_derivative_approximation[i]
    d2u_dx2_value = second_derivative_approximation[i]
    x_expanded = c(x_expanded,rep(x_value,3))
    types_expanded = c(types_expanded, c("u","du_dx","d2u_dx2"))
    values_expanded = c(values_expanded,c(u_value,du_dx_value,d2u_dx2_value))
  }
  
  derivatives = tibble(x=x_expanded,value=values_expanded,type=types_expanded)
  derivatives$type = factor(derivatives$type, levels=c("u","du_dx","d2u_dx2"))
  
  plot = ggplot(derivatives,aes(x=x,y=value,color=type)) + 
    facet_grid(rows=vars(type)) + 
    geom_line(show.legend = FALSE) +
    geom_hline(yintercept=0) +
    geom_vline(xintercept=0)
  
  if (!is.null(title)){
    plot = plot + ggtitle(title)
  }
  
  if (is.null(save_as)){
    return(plot)
  } else {
    ggsave(filename = save_as)
    return(plot)
  }
}

# Function to find the area above y=u_hat and below y=u(x) for a bistable wave
# Returns results as a list
critical_area = function(x_grid, u_x, u_hat, plot = TRUE, print_to_screen=TRUE){
  # x_grid: a sequence of x-values that u_x is evaluated over
  # u_x: the initial curve of the bistable reaction-diffusion wave 
  # u_hat: the critical frequency that u(x=0) must exceed for the wave to invade
  # plot: whether to plot this graph 
  
  u_0 = u_x[which(x_grid==0)]
  if (u_0 < u_hat){
    stop("Doesn't exceed the invasion frequency")
  }
  
  # Find the two x-values at which the u(x) and y=u_hat curves intersect
  n = length(x_grid)
  u_hat_vector = rep(u_hat,n)
  above = u_x > u_hat_vector
  intersect.points = which(diff(above) != 0)
  
  if (length(intersect.points)!=2){
    stop(paste("Only", length(intersect.points), "intersection points found -- check domain"))
  }
  
  index1 = intersect.points[1]
  index2 = intersect.points[2]
  x1 = x_grid[index1]
  x2 = x_grid[index2]
  x_range_of_integration = x_grid[index1:index2]
  u_x_range_of_integration = u_x[index1:index2]

  # Integration
  rectangle_area = u_hat*(x2-x1)
  u_x_area = trapz(x_range_of_integration,u_x_range_of_integration)
  crit_area = u_x_area - rectangle_area
  
  if (plot){
    df = tibble(x=x_grid,y=u_x)
    plt = ggplot(df, aes(x,y)) + 
      geom_line(color="red") +
      xlab("x") + 
      ylab("u(x)") + 
      geom_vline(xintercept=x1) +
      geom_vline(xintercept = x2) +
      geom_hline(yintercept = u_hat)
    
    if (print_to_screen){
      print(plt)
    }
    
    return(list(critical_area = crit_area, plot = plt))
  } 
  
  return(list(critical_area = crit_area))
}


