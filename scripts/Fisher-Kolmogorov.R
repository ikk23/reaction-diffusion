###################################################

# From Murray textbook chapter 13
# The original reaction-diffusion equation is:
#     du/dt = D(d^2u/dx^2) + (ku(1-u))
#       where k is the selection coefficient and k,D > 0
# We rescale x and t s.t. t* = kt and x* = x*sqrt(k/D)
# Then the reaction-diffusion equation becomes:
#     du/dt = d^u/dx^2 + u(1-u)
# A solution to this equation is:
#     u(x,t) = [1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-2) 

# The first derivative wrt x is:
#     du/dx = [(-2*(sqrt(2)-1))/sqrt(6)][exp{(1/sqrt(6))*x - (5t)/6}][1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-3)

# The second derivative wrt x -- the diffusion term -- is:
#    d^u/dx^2 = [(sqrt(2)-1)(exp{(1/sqrt(6))*x - (5t)/6})([1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-3))][(-1/3) + (sqrt(2)-1)(exp{(1/sqrt(6))*x - (5t)/6})[1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-1)]

# The reaction term is still:
#     f(u) = u*(1-u)

###################################################


# calculate x* = x*sqrt(k/D). Use this x* in all future calculations.
translate_x = function(x,k,D){
  # x = the true position
  # k = the selection coefficient
  # D = the dispersion coefficient; ex: sigma^2/2
  x_new = x*sqrt(k/D)
  return(x_new)
}

# calculate t* = kt. Use this t* in all future calculations.
translate_t = function(t,k){
  # t = the true time / generation
  # k = the selection coefficient
  t_new = k*t
  return(t_new)
}

##### The functions below all assume x and t have been transformed using the above equations #####

# exp{(1/sqrt(6))*x - (5t)/6}
e_term = function(x,t){
  x_term = (1/sqrt(6))*x
  t_term = (5*t)/6
  e_t = exp(x_term - t_term)
  return(e_t)
}

# [1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}] taken to a power shows up in many derivatives
common_inner_denom = function(x,t){
  e_t = e_term(x,t)
  sol =  1 + ((sqrt(2)-1)*e_t)
  return(sol)
}

# u(x,t) = [1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-2) 
uxt = function(x,t){
  denom_inner = common_inner_denom(x,t) # [1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]
  uxt_sol = denom_inner^(-2)
  return(uxt_sol)
}

# du/dx = [(-2*(sqrt(2)-1))/sqrt(6)][exp{(1/sqrt(6))*x - (5t)/6}][1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-3)
duxt_dx = function(x,t){
  coeff = (-2/sqrt(6))*(sqrt(2)-1)
  e_t = e_term(x,t)
  e_extended = (common_inner_denom(x,t))^(-3)
  sol = coeff*e_t*e_extended
  return(sol)
}

# d^u/dx^2 = [(sqrt(2)-1)(exp{(1/sqrt(6))*x - (5t)/6})([1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-3))][(-1/3) + (sqrt(2)-1)(exp{(1/sqrt(6))*x - (5t)/6})[1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]^(-1)]
d2uxt_dx2 = function(x,t){
  coeff = sqrt(2) - 1
  e_t = e_term(x,t)
  e_ext_1 = (common_inner_denom(x,t))^(-3)
  product1 = coeff*e_t*e_ext_1
  
  e_ext_2 = (common_inner_denom(x,t))^(-1)
  product2 = (-1/3) + (coeff*e_t*e_ext_2)
  
  sol = product1*product2
  return(sol)
}

reaction = function(u){
  fu = u*(1-u)
  return(fu)
}

# du/dt = d^u/dx^2 + u(1-u) using scaled x and t
reaction_diffusion = function(x,t){
  u = uxt(x,t)
  reaction_term = reaction(u)
  diffusion_term = d2uxt_dx2(x,t)
  du_dt = reaction_term + diffusion_term
  return(du_dt)
}

# Function to calculate u, du/dx, d^u/dx^2, the reaction term, and reaction_diffusion term for just 1 x and 1 t
Fisher_values_one_point = function(k,sigma_squared,x_orig,t_orig){
  # k = the selection coefficient
  # sigma_squared = the variance of the Gaussian dispersal kernel. D = sigma_squared/2
  # x_orig = the unscaled position
  # t_orig = the unscaled time
  
  # First get the scaled and t values
  D = sigma_squared/2
  x = translate_x(x_orig,k,D)
  t = translate_t(t_orig, k)
  
  uxt_value = uxt(x,t)
  du_dx_value = duxt_dx(x,t)
  d2u_dx2_value = d2uxt_dx2(x,t) # diffusion term
  reaction_value = reaction(uxt_value)
  reaction_diffusion_value = reaction_diffusion(x,t)
  
  value_list = list(u = uxt_value,
                    du_dx = du_dx_value,
                    d2u_dx2 = d2u_dx2_value,
                    f_u = reaction_value,
                    du_dt = reaction_diffusion_value)
  
  return(value_list)
}


# Function to iterate over a range of x and calculate u, du/dx, d^u/dx^2, the reaction term, and reaction_diffusion term

Fisher_values_over_x_range = function(k, sigma_squared, x_orig_vector, t_orig_constant){
  # k = the selection coefficient
  # sigma_squared = the variance of the Gaussian dispersal kernel. D = sigma_squared/2
  # x_orig_vector = a vector of unscaled x positions to iterate over
  # t_orig_constant = an unscaled time value to hold constant
  
  n = length(x_orig_vector)
  x_new = rep(0,n) # keep track of transformed x values for plotting
  u_vec = rep(0,n)
  du_dx_vec = rep(0,n)
  d2u_dx2_vec = rep(0,n)
  reaction_vec = rep(0,n)
  reaction_diffusion_vec = rep(0,n)
  t_new = translate_t(t_orig_constant,k)
  
  for (i in 1:n){
    x_orig = x_orig_vector[i]
    value_list = Fisher_values_one_point(k,sigma_squared,x_orig,t_orig_constant)
    
    x_new[i] = translate_x(x_orig,k,D)
    u_vec[i] = value_list$u
    du_dx_vec[i] = value_list$du_dx
    d2u_dx2_vec[i] = value_list$d2u_dx2
    reaction_vec[i] = value_list$f_u
    reaction_diffusion_vec[i] = value_list$du_dt
  }
  
  vector_list = list(t_transformed = t_new, # the t* that was held constant
                     x_transformed = x_new,
                     u = u_vec,
                     du_dx = du_dx_vec,
                     d2u_dx2 = d2u_dx2_vec,
                     f_u = reaction_vec,
                     du_dt = reaction_diffusion_vec)
  return(vector_list)
}

plot_derivs_wrt_x = function(x_transformed,u_vec,du_dx_vec, d2u_dx2_vec, t_transformed){
  # x_transformed = the scaled x range
  # t_transformed = the scaled t constant
  
  par(mfrow=c(3,1))
  plot(x = x_transformed, y = u_vec, xlab = "x", ylab = "u(x,t)",type="l",col="red", main = paste("t =",t_transformed))
  abline(h=0)
  abline(v=0)
  
  plot(x=x_transformed, y = du_dx_vec, xlab = "x", ylab = "du/dx", type = "l", col = "red")
  abline(h=0)
  abline(v=0)

  plot(x=x_transformed, y = d2u_dx2_vec, xlab = "x", ylab = "d^2u/dx^2", type = "l", col = "red")
  abline(h=0)
  abline(v=0)
  
}

plot_reaction_diffusion = function(x_transformed, reaction_diffusion_vec, t_transformed){
  par(mfrow=c(1,1))
  plot(x = x_transformed, y = reaction_diffusion_vec, xlab = "x", ylab = "du/dt", main = paste("t =",t_transformed), col = "blue", type = "l")
  abline(v=0)
  abline(h=0)
}


#### Examples ####

# 1: k=0.1, sigma_squared=0.4
# t = 1 (0.01), t = 10 (1), t = 50 (5), t = 100 (10),t=200 (20),t = 500 (50)
t_orig_constant = 500

x_orig_vector = seq(-10,10,by=0.2) # 101
k = 0.1 
sigma_squared = 0.4
vector_list = Fisher_values_over_x_range(k,sigma_squared,x_orig_vector,t_orig_constant)
t_new = vector_list$t_transformed
x_new = vector_list$x_transformed
u_vec = vector_list$u  
du_dx_vec = vector_list$du_dx
d2u_dx2_vec = vector_list$d2u_dx2
reaction_diffusion_vec = vector_list$du_dt

plot_derivs_wrt_x(x_new, u_vec, du_dx_vec, d2u_dx2_vec, t_new)

plot_reaction_diffusion(x_new,reaction_diffusion_vec,t_new)


# 2. s=0.01, sigma_squared=0.4
x_orig_vector = seq(-10,10,by=0.2) # 101 -- range will now be shorter because k is smaller
k = 0.01 # s
sigma_squared = 0.4

# Start with t = 1 (t* = 0.01)
# t = 10 (t*=0.1)
# t=50 (t*=0.5)
# t = 100 (t*=1)
# t = 1000 (t*=10)
# t=2000 (t*=20)
# t = 10,000 (t*=100)  -- wave completely flattens
t_orig_constant = 10000
vector_list = Fisher_values_over_x_range(k,sigma_squared,x_orig_vector,t_orig_constant)
t_new = vector_list$t_transformed
x_new = vector_list$x_transformed
u_vec = vector_list$u  
du_dx_vec = vector_list$du_dx
d2u_dx2_vec = vector_list$d2u_dx2
reaction_diffusion_vec = vector_list$du_dt

plot_derivs_wrt_x(x_new, u_vec, du_dx_vec, d2u_dx2_vec, t_new)

plot_reaction_diffusion(x_new,reaction_diffusion_vec,t_new)

