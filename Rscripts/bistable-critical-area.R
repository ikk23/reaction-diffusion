# Loaded in functions
library(tidyverse)
library(ggplot2)

source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-reaction-diffusion-functions.R")

run_u_hat = function(u_hat,x_grid=seq(-10,10,by=0.01),u_x=dnorm(x_grid),k=0.3,D=0.01,time_steps=100,
                     get_critical_area = TRUE){
  # track the critical area (value and graph), the difference in u(x=0,t=0)-u_hat, and the plot of the wave over time
  alpha = alpha_for_u_hat(u_hat)
  u_x0 = u_x[which(x_grid==0)]
  u_diff = u_x0 - u_hat
  
  if (get_critical_area){
    ca.list = critical_area(x_grid,u_x,u_hat,print_to_screen = FALSE)
    ca_value = ca.list$critical_area
    ca_plot = ca.list$plot  
  }

  
  results = simulate_u_x_t(u=u_x,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = bistable_reaction,
                         additional_reaction_arguments = c(k,alpha))
  wave_plot = plot_wave(results,add_hline = u_hat)
  
  if (get_critical_area){
    results.list = list(critical_area = ca_value, 
                        critical_plot = ca_plot, 
                        u_difference = u_diff,
                        wave_plot = wave_plot,
                        tibble_from_simulation = results)
  } else {
    results.list = list(u_difference = u_diff, wave_plot = wave_plot, tibble_from_simulation = results)
  }

  return(results.list)
}


# Example 1: standard normal s.t. u(x=0, t=0) = 0.398. Low invasion frequency of 0.15
k = 0.05 
alpha = 0.7
u_hat = (1-alpha)/2
D = 0.01
x_grid = seq(-10,10,by=0.01) # length = 2001
u_at_0 = dnorm(0) # 0.399
u_diff = u_at_0 - u_hat
u0 = dnorm(x_grid)
time_steps = 100
results = run_u_hat(u_hat = u_hat, x_grid = x_grid, u_x = u0, k=k,D=D,time_steps=time_steps)
results$wave_plot
# Issues when the grid is too fine
tib = results$tibble_from_simulation
# Going from tc=5 to tc=6 --> the second derivative becomes very rough
tc = 5
plot_derivatives(x_grid,(tib %>% filter(t==tc) %>% .$uxt),title=paste0("t=",tc)) 
tc = 6
plot_derivatives(x_grid,(tib %>% filter(t==tc) %>% .$uxt),title=paste0("t=",tc)) 
# By tc=7, the graph is filled with errors
tc = 7 
plot_derivatives(x_grid,(tib %>% filter(t==tc) %>% .$uxt),title=paste0("t=",tc)) 
# Does this occur when the spacing on the x-axis is 0.1?
x_grid2 = seq(-10,10,by=0.1)
u02 = dnorm(x_grid2)
time_steps = 100
results2 = run_u_hat(u_hat = u_hat, x_grid = x_grid2, u_x = u02, k=k,D=D,time_steps=time_steps)
results2$wave_plot # no, when the spacing is 0.1, the graph remains smooth
tib2 = results2$tibble_from_simulation
# Going from tc=5 to tc=6 --> the second derivative becomes very rough
tc = 5
plot_derivatives(x_grid2,(tib2 %>% filter(t==tc) %>% .$uxt),title=paste0("t=",tc)) 
tc = 6
plot_derivatives(x_grid2,(tib2 %>% filter(t==tc) %>% .$uxt),title=paste0("t=",tc)) 
# Try refining the x-grid to 0.05 spacing
x_grid_0.05 = seq(-10,10,by=0.05) # length of 401
u0_0.05 = dnorm(x_grid_0.05)
results_0.05 = run_u_hat(u_hat = u_hat, 
                         x_grid = x_grid_0.05, 
                         u_x = u0_0.05, 
                         k=k,
                         D=D,
                         time_steps=time_steps)
results_0.05$wave_plot
# 0.05 is too fine
# Try 0.08
x_grid_0.08 = seq(-10,10,by=0.08) # length 251
u0_0.08 = dnorm(x_grid_0.08)
results_0.08 = run_u_hat(u_hat = u_hat, 
                         x_grid = x_grid_0.08, 
                         u_x = u0_0.08, 
                         k=k,
                         D=D,
                         time_steps=time_steps)
results_0.08$wave_plot
# KEEP THE 0.08 SPACING

# Standard x_grid and u(x,t=0)
x_grid = x_grid_0.08
u_x = u0_0.08


# Focus on raising the invasion frequency until the wave "doesn't move"
# Standard constants:
#     k = 0.05 
#     D = 0.01
#     time_steps = 100
#     u(x) = dnorm(mu=0,sigma=1). u(x=0,t=0) is 0.399.

u_hat = 0.3
results_uhat0.3 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_uhat0.3$wave_plot # Does not spread
results_uhat0.3$critical_area # CA = 0.09614022

u_hat = 0.25
results_uhat0.25 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_uhat0.25$wave_plot # Does not spread
results_uhat0.25$critical_area # 0.1820447

u_hat = 0.245
results_0.245 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.245$wave_plot # Does not spread
results_0.245$critical_area # 0.1920447

u_hat = 0.2425
results_0.2425 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.2425$wave_plot # Falls and then stays mostly constant after t=70.
results_0.2425$critical_area # 0.1970447

# CLOSE
u_hat = 0.24125
results_0.24125 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.24125$wave_plot # Again just slightly falls and then stays constant after like t=40
results_0.24125$critical_area # 0.1995447

# **********
# Starts to exhibit the weird behavior here when it's falling and rising -- this seems to be around the "critical propagule size" when u_hat = 0.24 and u0 = 0.399
u_hat = 0.24
results_0.24 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.24$wave_plot 

# Does this confirm the equation: a(a-1-u_hat)+u_hat = Db/k at du/dt=0?
a = 1/sqrt(2*pi) # sigma = 1
b = -1/2
left = a*(a-1-u_hat)+u_hat
right = (D*b)/k
print(paste(left,"=",right)) # VERY close

# The equation would predict that the following u_hat would cause the critical propagule
num = sqrt(2*pi)*((D*pi) + 0.05) - (2*0.05*pi)
denom = (2*0.05*pi)*(1-sqrt(2*pi))
u_hat = num/denom # 0.2325689
print(paste("when u0 =",u_x[which(x_grid==0)],"u_hat = ",u_hat)) 
# k = 0.05, D=0.01, u0 = 0.399, u_hat = 0.233
# 0.24 - 0.2325 = 0.0074

# test this one out
results_critical = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_critical$wave_plot # stays stagnant for a few generations but then spreads. Only a bit off.
# **********


u_hat = 0.2375 # Slowly spreads
results_0.2375 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.2375$wave_plot

u_hat = 0.23
results_0.23 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.23$wave_plot # Slowly spreads

u_hat = 0.225
results_0.225 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_0.225$wave_plot # Slowly spreads

u_hat = 0.2
results_uhat0.2 = run_u_hat(u_hat,x_grid,u_x,k,D,time_steps)
results_uhat0.2$wave_plot # DOES spread
results_uhat0.2$critical_area # 0.2893219

### Testing the du/dt equation out 
u_hat_with_fixed_u0 = function(D,k,sigma){
  a = 1/(sigma*sqrt(2*pi))
  b = -1/(2*(sigma^2))
  u_hat = (1/(1-a))*((D*b/k)-(a^2)+a)
  return(u_hat)
}

# Ex: keeping sigma=1, D=0.01, but raising k=0.1
k = 0.1
D = 0.01
sigma = 1
u_hat_crit = u_hat_with_fixed_u0(D,k,sigma)
u_hat_crit # 0.3157556

# Should see the wave barely moving
results_u_hat_crit = run_u_hat(u_hat_crit,x_grid,u_x,k,D,time_steps)
results_u_hat_crit$wave_plot # Wave falls
# Decrease u_hat a bit from 0.3157556
run_u_hat(0.3,x_grid,u_x,k,D,time_steps)$wave_plot # seems to be close
# 0.3-0.3157556 = 0.015


