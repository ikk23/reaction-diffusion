# Trying to discretize the reaction-diffusion wave into compartments

source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-reaction-diffusion-functions.R")

# Plot the wave as boxes, like a barchart
plot_discrete_wave = function(results, save_as=NULL,add_hline=NULL){
  plot = ggplot(data = results, aes(x = x, y = uxt)) + 
    geom_bar(fill="red",aes(group=t),stat='identity') + 
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

wrapper_discrete_bistable_wave = function(u_hat,
                                 x_grid=seq(-2,2,by=1),
                                 u_x=dnorm(x_grid),
                                 k=0.3,
                                 D=0.01,
                                 time_steps=100){
  alpha = alpha_for_u_hat(u_hat)
  u_x0 = u_x[which(x_grid==0)]
  u_diff = u_x0 - u_hat
  results = simulate_u_x_t(u=u_x,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = bistable_reaction,
                         additional_reaction_arguments = c(k,alpha))
  wave_plot = plot_discrete_wave(results,add_hline = u_hat)
  results.list = list(u_difference = u_diff,
                      wave_plot = wave_plot,
                      tibble_from_simulation = results)
  return(results.list)
}

# Assuming the discrete x_grid is {-1,0,1} and the continous x_grid is {-1,-0.9,...,0.0,0.1,...,1}
discrete_vs_continuous = function(u_hat,a,sigma,k,D,time_steps){
  x_grid_discrete = c(-1,0,1)
  x_grid_continuous = seq(-1,1,by=0.1)
  u_x_discrete = u_function(x_grid_discrete,a,sigma)
  u_x_continuous = u_function(x_grid_continuous,a,sigma)
  
  alpha = alpha_for_u_hat(u_hat)
  results_discrete = simulate_u_x_t(u=u_x_discrete,x_grid=x_grid_discrete,
                                    time_steps=time_steps, D=D, 
                                    REACTION_FUNCTION=bistable_reaction, 
                                    additional_reaction_arguments=c(k,alpha))
  wave_plot_discrete = plot_discrete_wave(results_discrete,add_hline = u_hat)
  
  results_continuous = simulate_u_x_t(u=u_x_continuous,x_grid=x_grid_continuous,
                                      time_steps=time_steps, D = D, 
                                      REACTION_FUNCTION = bistable_reaction, 
                                      additional_reaction_arguments=c(k,alpha))
  wave_plot_continuous = plot_wave(results_continuous,add_hline = u_hat)
  
  return(list(discrete_plot = wave_plot_discrete, continuous_plot = wave_plot_continuous))
}

solve_for_a = function(k,sigma,u_hat,D){
  b = -1/(2*(sigma^2))
  inside_radical = ((-1-u_hat)^2) - (4*(u_hat - (D*b/k)))
  numerator_left = 1+u_hat
  denom = 2
  a_lower = (numerator_left-sqrt(inside_radical))/denom
  a_upper = (numerator_left+sqrt(inside_radical))/denom
  solutions = c()
  if (a_lower >= 0 & a_lower <= 1){
    solutions = c(solutions,a_lower)
  }
  if (a_upper >= 0 & a_upper <= 1){
    solutions = c(solutions,a_upper)
  }
  print(paste("Solutions from the quadratic equation:",a_lower,"and",a_upper))
  return(solutions)
}

# The normal density except that the scaling term (a = u(0)) is free to vary
u_function = function(x,a,sigma){
  sig_sq = sigma^2
  x_sq = x^2
  u_x = a*exp(-x_sq/(2*sig_sq))
  return(u_x)
}

# EX1: set u_hat=0.2, k = 0.1, D=0.01
k=0.1
D=0.01
u_hat = 0.2
sigma=1
# what does a=u(0,0) need to be such that du/dt=0 at x=0?
sols = solve_for_a(k,sigma,u_hat,D)
a = sols[1] # 0.27; take the lower 
wave_plots = discrete_vs_continuous(u_hat,a,sigma,k,D,time_steps=50)
wave_plots$continuous_plot # narrows and then falls 
wave_plots$discrete_plot # the wave falling in the discrete model looks like only the bar at x=0 rising
# Not sure why this a value doesn't lead to wave spread?

# Increase the u(0,0) more -- try extreme case where a=u(x=0)=1. Do the other bars rise to 1?
a = 1
wave_plots= discrete_vs_continuous(u_hat,a,sigma,k,D,time_steps=50)
wave_plots$continuous_plot # wave rise to 1 everywhere
wave_plots$discrete_plot # all bars rise to 1 -- SANITY CHECK check

# Where is the critical propagule, where no bars are rising or falling?
a = 0.34
wave_plots = discrete_vs_continuous(u_hat,a,sigma,k,D,time_steps=100)
wave_plots$continuous_plot # clearly the wave is rising, but it only rises around x=0
wave_plots$discrete_plot # only the x=0 bar rises; the others fall (does this mean failure?)
run_u_hat(u_hat,x_grid=seq(-5,5,by=0.1),u_x=u_function(seq(-5,5,by=0.1),a=0.34,sigma=1),k=0.1,D=0.01,time_steps=200,get_critical_area = FALSE)$wave_plot  # narrows and then rises at x=0 (the narrowing is what makes the -1 and 1 bars on the discrete model seem to decrease)

# try adding more time steps -- do the -1 and 1 bars eventually rise?
wave_plots = discrete_vs_continuous(u_hat,a,sigma,k,D,time_steps=300)
wave_plots$discrete_plot # really strange glitchy behavior
wave_plots$continuous_plot

# Am I simulating the compartment model incorrectly? 
