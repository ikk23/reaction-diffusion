# Given a value of a and the total number of x-positions to simulate over,
# this function sets up the initial u(x,t=0) such that this is 1 within the 
# release area and 0 elsewhere
set_u0 = function(length, a){
  # length = the total number of x-positions (the longer the length, the smoother the plot)
  # a = the release width
  x_grid = seq(0, 1, length.out = length)
  
  lower = 0.5 - (a/2)
  upper = 0.5 + (a/2)
  
  u = rep(0, length)
  u[x_grid >= lower & x_grid <= upper] = 1
  
  return(list(x_grid = x_grid, u0 = u))
}



# Sample a point within the release range. 
diffusion_step = function(u, x_grid, sigma,n){
  # sample points based on the height of the curve 
  displaced_point_x = c()
  for (i in 1:n){
    point = sample(x = x_grid, size = 1, prob = u)
    displacement = rexp(1,rate=1/sigma)
    direction = sample(x = c(-1,1),size=1,prob=c(1/2,1/2))
    moved_point = point + (direction*displacement)
    displaced_point_x = c(displaced_point_x,moved_point)
  }
  
  # now need to find the density at each position?
  num_bins = length(x_grid)/3
}