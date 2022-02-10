##################################################################
# u(x,t+1) approx = u(x,t) + D(d^2 u/dx^2) + f(u)

# Step 1: Get your parameters. Start at any value of t (such as t=1). Choose a function for u(x), such as the Gaussian density function. Choose a value for the diffusion constant D. Choose a reaction equation, such as Fisher;s ku(1-u) where k is any selection coefficient value

# Step 2: Evaluate u(x) over a range of x-values (while holding t constant). Graph the curve.

# Step 3: For each point of x, now:
#         - Get the second derivative of u(x) at this point (approximate the slope 2x).
#         - Multiply by D. Now you have your diffusion value here.
#         - Evaluate the reaction equation at this value of u(x).
#         - Add u(x) + diffusion value + reaction value to get an approximation of u(x, t+1) = the value
#           of the solution curve at this same position but at the next time step.

# Step 4: Graph the resulting u(x,t+1).

# Step 5: Repeat 3&4 for a range of t values. Animate how the wave changes.

##################################################################


# calculates f(u) over a vector of current u(x=x*,t=t') values
Fisher_reaction_equation = function(u_vector,k){
  f_u_vector = k*u_vector*(1-u_vector)
  return(f_u_vector)
}

# calculate the derivative based on a grid of x values and their u(x=x*,t=t') values by taking the average of the local slope before a point and after it (except for the 2 endpoints). Returns a vector of slope values. Run this twice to get the second derivative.
approximate_slope = function(x_grid, y_output){
  # assuming that the length(x_grid) > 2
  n = length(x_grid)
  slope = rep(0,n)
  for (i in 1:n){
    if (i ==1){
      # only use the difference between y(x1) and y(x2)
      y_x1 = y_output[i]
      y_x2 = y_output[i+1]
      x1 = x_grid[i]
      x2 = x_grid[i+1]
      m = (y_x2-y_x1)/(x2-x1)
      slope[i] = m
    } else if (i == n){
      # only use the difference between y(n) and y(n-1)
      y_xn = y_output[i]
      y_xn_minus_1 = y_output[i-1]
      xn = x_grid[i]
      xn_minus_1 = x_grid[i-1]
      m = (y_xn-y_xn_minus_1)/(xn-xn_minus_1)
      slope[i] = m
    } else {
      # if there are point on either side, take the average slope
      y_x = y_output[i]
      y_x_plus_1 = y_output[i+1]
      x = x_grid[i]
      x_plus_1 = x_grid[i+1]
      m_right = (y_x_plus_1 - y_x)/(x_plus_1-x)
      
      y_x_minus_1 = y_output[i-1]
      x_minus_1 = x_grid[i-1]
      m_left = (y_x - y_x_minus_1)/(x-x_minus_1)
      
      m = (m_right+m_left)/2
      slope[i] = m
    }
  }
  return(slope)
}


u_x_t_plus_1 = function(u_x_t_vector, x_grid, D, k){
  # u_x_t_vector: a vector of current u(x=x*,t=t') approximations
  # x_grid: vector of x-values
  # D: the diffusion constant
  # k: the selection coefficient used in the reaction term
  
  first_derivative_approximation = approximate_slope(x_grid=x_grid,
                                                     y_output = u_x_t_vector)
  second_derivative_approximation = approximate_slope(x_grid=x_grid,
                                                      y_output=first_derivative_approximation)
  diffusion_term_vector = D*second_derivative_approximation
  
  reaction_term_vector = Fisher_reaction_equation(u_vector = u_x_t_vector, k=k)
  
  approx_u_x_t_plus_1_vector = u_x_t_vector + diffusion_term_vector + reaction_term_vector
  
  return(approx_u_x_t_plus_1_vector)
} 

plot_u_x_t = function(x_grid,u_x_t_vector,t,ylim=NULL){
  if (is.null(ylim)){
   plot(x=x_grid,y=u_x_t_vector,xlab="x",ylab="u(x,t)",main=paste("t=",t),col="red",type="b") 
  } else {
    plot(x=x_grid,y=u_x_t_vector,xlab="x",ylab="u(x,t)",main=paste("t=",t),col="red",type="b",ylim=ylim) 
  }
}

# parameters
D = 1
k = 0.7 # high selective adv
x_grid = seq(-10,10,by=0.1)
u_x_t_vector = dnorm(x_grid,sd=0.5) # starting curve when t = 1
u_x_t_vector[which(x_grid==0)] # 0.798 frequency at the origin


u_x_t_2_vector = u_x_t_plus_1(u_x_t_vector=u_x_t_vector, x_grid=x_grid, D=D, k=k)

u_x_t_3_vector = u_x_t_plus_1(u_x_t_2_vector,x_grid,D,k)
plot_u_x_t(x_grid,u_x_t_3_vector,3)

# t = 4
u_x_t_4_vector = u_x_t_plus_1(u_x_t_3_vector,x_grid,D,k)
plot_u_x_t(x_grid,u_x_t_4_vector,4)

# t = 5
u_x_t_5_vector = u_x_t_plus_1(u_x_t_4_vector,x_grid,D,k)
plot_u_x_t(x_grid,u_x_t_5_vector,5)

u_x_t_6_vector = u_x_t_plus_1(u_x_t_5_vector,x_grid,D,k)
plot_u_x_t(x_grid,u_x_t_6_vector,6)

u_x_t_7_vector = u_x_t_plus_1(u_x_t_6_vector,x_grid,D,k)
plot_u_x_t(x_grid,u_x_t_7_vector,7)

# gganimate
#install.packages("gganimate")
#install.packages("magick")
#install.packages("transformr")

# animate plot that shows u_x_t to t=7
library(tidyverse)
library(gganimate)
library(transformr)

n = length(x_grid)
u_values = c(u_x_t_vector,u_x_t_2_vector)
x_values = c(x_grid,x_grid)
t_values = c(rep(1,n), rep(2,n))
u_x_t_tibble = tibble(u = u_values, x = x_values, time = t_values)

p = ggplot(data = u_x_t_tibble, aes(x = x, y = u)) + 
  geom_line() +
  labs(x = "x", y = "u(x,t)") 


p + transition_time(time) + labs(title = "t: {frame_time}")

# plug in the solution curve for Fisher

uxt = function(x,t,k,D){
  x_scaled = x*sqrt(k/D)
  t_scaled = k*t
  
  x_term = (1/sqrt(6))*x_scaled
  t_term = (5*t_scaled)/6
  e_t = exp(x_term - t_term)
  
  denom_inner = 1 + ((sqrt(2)-1)*e_t) # [1+(sqrt(2)-1)exp{(1/sqrt(6))*x - (5t)/6}]
  uxt_sol = denom_inner^(-2)
  return(uxt_sol)
}

D = 1
k = 0.7
wave1 = uxt(x_grid,t=1,k=0.7,D=1)
wave2 = u_x_t_plus_1(wave1, x_grid, D,k)
wave3 = u_x_t_plus_1(wave2, x_grid, D,k)
wave4 = u_x_t_plus_1(wave3, x_grid, D,k)

n = length(wave1)
wave_vector = c(wave1,wave2,wave3,wave4)
x_values = c(x_grid,x_grid,x_grid,x_grid)
t_values = c(rep(1,n), rep(2,n),rep(3,n),rep(4,n))
wave_tibble = tibble(u = wave_vector, x = x_values, time = t_values)
pw = ggplot(data = wave_tibble, aes(x = x, y = u)) + 
  geom_line(color = "red") +
  labs(x = "x", y = "u(x,t)") + geom_hline(yintercept=0) + geom_vline(xintercept = 0)


pw = pw + transition_time(time) + labs(title = "t: {frame_time}")
anim_save(filename = "Fisher-wave-k=0.7.gif")

magick::image_write(pw, path="myanimation.gif")