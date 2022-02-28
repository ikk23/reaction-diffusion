# Equation 13 - the solution to the scaled 1-dimensional reaction-diffusion equation

# Wa1a1 > Wa2a2 > Wa1a2
# (1+alpha*s) > (1) > (1+s(alpha-1)) where alpha is the strength of directional selection over underdominant selection, S/s
# alpha must be between (0,1)
# dp/dt = 0 when p=0,p=1, or p=(1-alpha)/2
# since alpha < 1, p is always less than 1/2

# Reaction term when the scaled T and X^2 are plugged in
fP_scaled = function(p, s, alpha){
  p_hat = (1-alpha)/2
  
  # if p > p_hat, the allele frequency will increase locally. If not, it will decrease.
  # p_hat = (1-alpha)/2
  fP = 2*p*(1-p)*(p-p_hat)
  return(fP)
}

# p(X,T) = 1/(1+e^{X-alphaT})
pXT = function(x,t,s,sigma_squared,alpha){
  T_scaled = s*t
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  solution_value = 1/(1 + exp(X-(alpha*T_scaled)))
  return(solution_value)
}


# dp(X,T)/dX = -(e^{X-alphaT})(1+e^{X-alphaT})^{-2}
dPXT_dX = function(x,t,s,sigma_squared,alpha){
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  T_scaled = s*t
  e_term = exp(X-(alpha*T_scaled))
  deriv = -(e_term)/((1+e_term)^2)
  return(deriv)
}

# d^2 p(X,T) / dX^2 = (e^{X-alphaT})(1+e^{X-alphaT})^{-2}[-1 + 2(e^{X-alphaT})(1+e^{X-alphaT})^{-1}]
d2PXT_dX2 = function(x,t,s,sigma_squared,alpha){
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  T_scaled = s*t
  e_term = exp(X-(alpha*T_scaled))
  
  first_term = -(e_term)/((1+e_term)^2) # equals the first derivative
  second_term = (2*(e_term^2))/((1+e_term)^3)
  second_deriv = first_term + second_term
  
  return(second_deriv)
}

# Reaction-diffusion equation
# dp(X,T)/dT = d^2P/dX^2 + reaction function

reaction_diffusion = function(p,x,t,s,alpha,sigma_squared){
  # p = the current value of p(X,T) 
  # x = the current position
  # t = the current generation
  # s = the selection coefficient
  # alpha = S/s; must be within (0,1)
  # sigma_squared = the variation of the Gaussian dispersal kernel
  
  diffusion = d2PXT_dX2(x,t,s,sigma_squared,alpha)
  reaction = fP_scaled(p,s,alpha)
  
  dPXT_dT = diffusion + reaction
  return(dPXT_dT)
}

alpha_and_fitness_values = function(p_hat,s){
  
  if (p_hat >= 0.5){
    print("p_hat must be less than 1/2")
    return()
  }
  
  alpha = 1-(2*p_hat)
  Wa1a1 = (1+alpha*s) # the more fit homozygote
  Wa2a2 = 1
  Wa1a2 = 1 + s*(alpha-1)
  print(paste("When p_hat is", p_hat, "and s is",s,", alpha =",alpha))
  print(paste("Wa1a1=",Wa1a1, "Wa2a2=",Wa2a2,"Wa1a2=",Wa1a2))
}

Barton_equations_at_x_and_t = function(s,alpha,sigma_squared,x, t){
  # s = the selection coefficient
  # alpha = S/s; must be within (0,1)
  # sigma_squared = the variation of the Gaussian dispersal kernel
  
  # x = the current position
  # t = the current generation
  
  # scaled X and T
  T_scaled = s*t
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  
  # get the current allele frequency based on p(X,T)
  # ex: alpha = 0.6, t = 2, x = 1, s = 0.01
  
  p = pXT(x,t,s,sigma_squared,alpha) # 0.44
  
  # get the first derivative of p(X,T)
  dp_dx = dPXT_dX(x,t,s,sigma_squared,alpha)
  
  # get the second derivative of p(X,T)
  dp2_dx2 = d2PXT_dX2(x,t,s,sigma_squared,alpha)
  
  # get the reaction term
  local_increase_in_p_wrt_t = fP_scaled(p,s,alpha)
  
  # get the reaction-diffusion dp/dT value
  dp_dt_rxn_diff = reaction_diffusion(p,x,t,s,alpha,sigma_squared)
  
  values = list(p = p, # allele frequency at this x and t
                dp_dx = dp_dx, # first derivative of p(X,T) with respect to X (scaled)
                dp2_dx2 = dp2_dx2, # second derivative of p(X,T) wrt X
                fp = local_increase_in_p_wrt_t, # reaction term - the local increase in p
                dp_dt = dp_dt_rxn_diff, # dp(X,T)/dT = the reaction-diffusion equation value
                x_new = X,
                t_new = T_scaled)
  
  return(values)
}

Barton_equations_over_a_range = function(s,alpha,sigma_squared, t, x_range, plot_x_derivs=TRUE){
  # s = the selection coefficient
  # alpha = S/s; must be within (0,1)
  # sigma_squared = the variation of the Gaussian dispersal kernel
  # x_range = a vector of x-values to simulate over
  # t = one value of t (unscaled)
  # plot_x_derivs = whether to plot p(X,T), dp(X,T)/dX, and d^2p(X,T)/dX^2 on 1 graph
  
  # track how p(X,T) changes,
  # how dp(X,T)/dX changes
  # how d^2p(X,T)/dX^2 changes,
  # how the reaction term changes,
  # and how the reaction-diffusion equation dp(X,T)/dT changes
  
  num_x = length(x_range)
  p_vector = rep(0,num_x)
  dp_dx_vector = rep(0,num_x)
  dp2_dx2_vector = rep(0,num_x)
  reaction_vector = rep(0,num_x)
  reaction_diffusion_vector = rep(0,num_x)
  x_new_vec = rep(0, num_x)
  
  T_scaled = t*s
  
  for (i in 1:num_x){
    x = x_range[i]
    values = Barton_equations_at_x_and_t(s,alpha,sigma_squared,x,t)
    x_new_vec[i] = values$x_new
    p_vector[i] = values$p
    dp_dx_vector[i] = values$dp_dx
    dp2_dx2_vector[i] = values$dp2_dx2
    reaction_vector[i] = values$fp
    reaction_diffusion_vector[i] = values$dp_dt
  }
  
  vector_list = list(p_values = p_vector,
                     dp_dx_values = dp_dx_vector,
                     dp2_dx2_values = dp2_dx2_vector,
                     reaction_values = reaction_vector,
                     reaction_diffusion_values = reaction_diffusion_vector,
                     x_new_values = x_new_vec,
                     t_new = T_scaled)
  
  if (plot_x_derivs){
    par(mfrow=c(3,1))
    plot(x = x_new_vec, y = p_vector, xlab = "x (scaled)", ylab = "p(X,T)", 
        main = paste("t (scaled) =",T_scaled), type = "l", col = "red")
    abline(h=0)
    abline(v=0)
    
    plot(x = x_new_vec, y = dp_dx_vector, xlab = "x (scaled)", ylab = "dp(X,T)/dX", 
         type = "l", col = "red", main = paste("t (scaled) =",T_scaled))
    abline(h=0)
    abline(v=0)
    
    plot(x = x_new_vec, y = dp2_dx2_vector, xlab = "x (scaled)", ylab = "d^2p(X,T)/dX^2", 
         main = paste("t (scaled) =",T_scaled), type = "l", col = "red")
    abline(h=0)
    abline(v=0)
  }
  
  return(vector_list)
}

# Plotting functions for the above
reaction_diffusion_equation_plot = function(x_range, reaction_diffusion_values, t_new){
  par(mfrow=c(1,1))
  plot(x = x_range, y = reaction_diffusion_values, type = "l", col = "red", xlab = "x",
       ylab = "dp(X,T)/dT", main = paste("t (scaled) =",t_new))
  abline(h=0)
  abline(v=0)
}

# Hypothetical parameters


# Simulation 1: p_hat = 0.35, alpha=0.3, sigma_squared = 0.4, s = 0.1
# t = 1 (0.1)
t = 10000
alpha = 0.3
p_hat = (1-alpha)/2 # 0.35
sigma_sq = 0.4
s = 0.1
Wa1a1 = 1 + (alpha*s)
Wa2a2 = 1
Wa1a2 = 1 + s*(alpha-1)
print(paste("Unstable equilibrium frequency (p_hat) =",p_hat))
print(paste("Wa1a1 fitness:",Wa1a1, "Wa2a2 fitness:", Wa2a2, "Wa1a2 fitness:", Wa1a2)) # checks

x_vec = seq(-10,10,by=0.2)

# Plots p(X,T), dp(X,T)/dX, and d^2p(X,T)/dX^2
vector_list = Barton_equations_over_a_range(s,alpha,sigma_squared,t,x_vec)
rxn_diffusion = reaction_diffusion_equation_plot(vector_list$x_new_values, vector_list$reaction_diffusion_values, vector_list$t_new)
