library(tidyverse)
library(ggplot2)
require(pracma)

# Fitness values are defined by Barton as:
# fitness(A1A1) = 1 + 2K
# fitness(A2A2) = 1
# fitness(A1A2) = 1 + (K-k)
# such that fitness(A1A1) > fitness(A2A2) > fitness(A1A2)
# and alpha = K/k such that K = alpha*k
# Fitness can also be re-written as:
# fitness(A1A1) = 1 + 2*alpha*k
# fitness(A2A2) = 1
# fitness(A1A2) = 1 + k*(alpha - 1)

# Set up u(x,t=0) square
u_x0 = function(x,a,b){
  if (x > a/2 || x < -(a/2)){
    return(0)
  } else {
    return(b)
  }
}

# Model migration with u'(x,t=1)
u_prime_x1 = function(x,a,b,sigma){
  sig_recip = -1/sigma # term that shows up in all integrals
  if (x < -a/2){
    e_term1 = exp(sig_recip*((a/2)-x))
    e_term2 = exp(sig_recip*((-a/2)-x))
    sol = (-b/2)*(e_term1 - e_term2)
  } else if ((x >= -a/2) & (x <= a/2)){
    e_term1 = exp(sig_recip*(x+(a/2)))
    e_term2 = exp(sig_recip*((a/2)-x))
    sol = (b/2)*(2 - e_term1 - e_term2)
  } else { # x > a/2
    e_term1 = exp(sig_recip*(x - (a/2)))
    e_term2 = exp(sig_recip*(x + (a/2)))
    sol = (b/2)*(e_term1 - e_term2)
  }
  return(sol)
}

# Plot u(x,t=0) and u'(x,t=1) only
plot_migration_step = function(x_grid, a, b, sigma){
  n = length(x_grid)
  u_x_t0_vector = rep(-1,n)
  u_prime_x_t1_vector = rep(-1,n)
  for (i in 1:n){
    x = x_grid[i]
    u_x_t0_vector[i] = u_x0(x,a,b)
    u_prime_x_t1_vector[i] = u_prime_x1(x,a,b,sigma)
  }
  
  migration = tibble(x = x_grid,
                     u_x_t0 = u_x_t0_vector,
                     u_prime_x_t1 = u_prime_x_t1_vector)
  
  plot = ggplot(migration,aes(x=x_grid)) + 
    geom_point(aes(y = u_x_t0),color="black") +
    geom_point(aes(y=u_prime_x_t1),color="yellow") +
    xlab("x") + ylab("u(x,t=0) or u'(x,t=1)") + 
    geom_vline(xintercept = -a/2, color="grey") + 
    geom_vline(xintercept = a/2, color="grey")
  print(plot)
  
  return(list(migration_results = migration,plot = plot))
}

# Add the reaction function to get u(x,t=1) (using the full mathematical equation)
u_x_1 = function(x,a, b, sigma,k,u_hat){
  if (x < -a/2){
    sig_n_recip = -1/sigma
    e1_inner = (a/2)-x
    e1 = exp(sig_n_recip*e1_inner)
    e2_inner = (-a/2)-x
    e2 = exp(sig_n_recip*e2_inner)
    e_term = e1 - e2
    
    c_e1 = b*((k*u_hat) - 0.5)
    e1_term = c_e1*e_term
    
    c_e2 = ((k*(b^2))/2)*(1+u_hat)
    e2_term = c_e2*(e_term^2)
    
    c_e3 = ((k*(b^3))/4)
    e3_term = c_e3*(e_term^3)
    
    sol = e1_term + e2_term + e3_term
    
  } else if ((x >= -a/2) & (x <= a/2)){
    sig_n_recip = -1/sigma
    e_1_inner = x + (a/2)
    e_1 = exp(sig_n_recip*e_1_inner)
    e_2_inner = (a/2) - x
    e_2 = exp(sig_n_recip*e_2_inner)
    e_term = e_1 + e_2
    
    constants = b*((2*k*(b-u_hat)*(1-b)) + 1)
    
    
    b_term = b*((3*b) - 2)
    u_term = u_hat*(1 - (2*b))
    inside = (k*(b_term + u_term)) - 0.5
    c_e1 = b*inside
    e1_term = c_e1*e_term
    
    c_e2 = ((-k*(b^2))/2)*((3*b) - u_hat - 1)
    e2_term = c_e2*(e_term^2)
    
    c_e3 = ((k*(b^3))/4)
    e3_term = c_e3*(e_term^3)
    
    sol = constants + e1_term + e2_term + e3_term
  } else { # x > a/2
    sig_n_recip = -1/sigma
    e1_inner = x - (a/2)
    e1 = exp(sig_n_recip*e1_inner)
    e2_inner = x + (a/2)
    e2 = exp(sig_n_recip*e2_inner)
    e_term = e1 - e2
    
    c_e1 = b*(0.5 - (k*u_hat))
    e1_term = c_e1*e_term
    
    c_e2 = ((k*(b^2))/2)*(1 + u_hat)
    
    e2_term = c_e2*(e_term^2)
    c_e3 = (-k*(b^3))/4
    e3_term = c_e3*(e_term^3)
    sol = e1_term + e2_term + e3_term
  }
  return(sol)
}

# You can also solve for u(x,t=1) by u'(x,t=1) + bistable_reaction(u'(x,t=1)). This function is Barton's 2ku(1-u)(u-u_hat) for a bistable wave with small k
bistable_reaction = function(u,k,u_hat){
  sol = 2*k*u*(1-u)*(u-u_hat)
  return(sol)
}

# Set up u(x,t=0), model migration with u'(x,t=1), and add the reaction to get u(x,t=1). Plot u(x,t=0) in black, u'(x,t=1) in yellow, and u(x,t=1) in blue. Add a red horizontal line for u_hat and grey vertical lines for -a/2 and a/2. 
# Return a list with the results in a tibble, the plot, theta0 = a*b, and theta1 = the new AUC.
###     Note: the migration curve will always fall below b due to diffusion.
###     But if b > u_hat, we would expect the blue curve to be above the yellow.
###     And if b < u_hat, we would expect the blue curve to fall below the yellow.
###     If b = u_hat, we would expect the blue curve to fall right on top of the yellow.
u_t0_to_t1 = function(x_grid, a, b, sigma, k, u_hat){
  n = length(x_grid)
  u_x_t0_vector = rep(-1,n)
  u_x_prime_t1_vector = rep(-1,n)
  u_x_t1_full_sol_vector = rep(-1,n) # applying the u_x_1() function 
  u_x_t1_two_step_vector = rep(-1,n) # plugging u'(x,t=1) into 2ku'(1-u')(u'-u_hat)
  diff_in_u_x_t1_vector = rep(-1,n) # abs(difference between the last 2 vectors)

  for (i in 1:n){
    x = x_grid[i]
    u = u_x0(x,a,b)
    
    u_prime = u_prime_x1(x,a,b,sigma)
    two_step_sol = u_prime + bistable_reaction(u_prime,k,u_hat)
    
    equation_sol = u_x_1(x,a,b,sigma,k,u_hat)
    diff = abs(two_step_sol - equation_sol)
    
    u_x_t0_vector[i] = u
    u_x_prime_t1_vector[i] = u_prime
    u_x_t1_full_sol_vector[i] = equation_sol
    u_x_t1_two_step_vector[i] = two_step_sol
    diff_in_u_x_t1_vector[i] = diff
  }
  
  results = tibble(x = x_grid,
                   u_x_t0 = u_x_t0_vector,
                   u_x_prime_t1 = u_x_prime_t1_vector,
                   u_x_t1_full_sol = u_x_t1_full_sol_vector,
                   u_x_t1_two_step = u_x_t1_two_step_vector,
                   diff_in_u_x_t1 = diff_in_u_x_t1_vector)
  
  plot = ggplot(results, aes(x = x)) +
    geom_point(aes(y = u_x_t0), color = "black") +
    geom_point(aes(y = u_x_prime_t1), color = "yellow") +
    geom_point(aes(y=u_x_t1_two_step), color = "purple") +
    geom_point(aes(y = u_x_t1_full_sol), color = "blue") +
    xlab("x") + ylab("u(x,t)") + 
    geom_vline(xintercept = -a/2, color = "grey") + 
    geom_vline(xintercept = a/2, color="grey") +
    geom_hline(yintercept = u_hat, color = "red")
  
  
  print(plot)
  
  
  # Get AUC numerically
  theta0 = a*b
  theta1 = trapz(x_grid, u_x_t1_full_sol_vector)
  
  return(list(results = results, plot = plot, theta0 = theta0, theta1 = theta1))
  
}

