# ex: use the standard normal to simulate u(x,t0) over x range: -10,10 for 5 time steps. No reaction function. Diffusion constant of 1.
x_grid = seq(-10,10,by=0.1)
u0 = dnorm(x_grid)
time_steps = 4
D = 1
REACTION_FUNCTION = fisher_reaction # no reaction
k = 0
results_normal_t3 = simulate_u_x_t(u=u0,
                                   x_grid=x_grid,
                                   time_steps=time_steps,
                                   D=1,
                                   REACTION_FUNCTION = fisher_reaction,
                                   additional_reaction_arguments = c(k))

# Wave at t=0 (the standard normal)
wave0 = plot_derivatives(x_grid,u0,title = "t = 0")
wave0
ggsave(plot=wave0,filename = "t=0.png")

# Approximated wave at t=1
wave1 = plot_derivatives(x_grid,results_normal_t3 %>% filter(t==1) %>% .$uxt,title = "t = 1")
wave1
ggsave("t=1.png",wave1)

# Approximated wave at t=2
wave2 = plot_derivatives(x_grid,results_normal_t3 %>% filter(t==2) %>% .$uxt,title = "t = 2")
wave2
ggsave("t=2.png",wave2)

# Approximated wave at t=3
wave3 = plot_derivatives(x_grid,results_normal_t3 %>% filter(t==3) %>% .$uxt,title = "t = 3")
wave3
ggsave("t=3.png",wave3)

# Approximated wave at t=4
wave4 = plot_derivatives(x_grid,results_normal_t3 %>% filter(t==4) %>% .$uxt,title = "t = 4")
wave4
ggsave("t=4.png",wave4)

# gif
plot_wave(results_normal_t3,"/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/normal_wave_D=1_no_reaction_t4.gif")

# NEED TO MAKE D SMALLER to account for discretizing time
D=0.01
x_grid = seq(-10,10,by=0.1)
u0 = dnorm(x_grid)
time_steps = 1000
REACTION_FUNCTION = fisher_reaction # no reaction
k = 0
results_normal_D_small = simulate_u_x_t(u=u0,
                                   x_grid=x_grid,
                                   time_steps=time_steps,
                                   D=D,
                                   REACTION_FUNCTION = fisher_reaction,
                                   additional_reaction_arguments = c(k))
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-wave-output/std-normal-D=0.01-no-reaction/"
plot_wave(results_normal_D_small,paste0(dir,"wave_t1000.gif"))


# FISHER REACTION TERM. Keeping D at 0.01 and u(x) as the standard normal.
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-wave-output/std-normal-D=0.01-Fisher-reaction/" # save output here
D = 0.01
x_grid = seq(-10,10,by=0.1)
u0 = dnorm(x_grid)
time_steps = 1000
REACTION_FUNCTION = fisher_reaction

k = 0.9 # 0.9,0.5,0.1,0.01
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_k0.9.gif")) # Wave spreads to flatten out at 100% very quickly (before t=200)

k = 0.5
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_k0.5.gif")) # Same as before but fixes slightly more slowly 

k=0.1
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_k0.1.gif")) # Slow and gets wider before fixing

k = 0.01
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_k0.01.gif")) # The best one. Just barely fixes before t=1000.

# Weird reaction function: multiply by a factor f
REACTION_FUNCTION = multiply_reaction
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-wave-output/std-normal-D=0.01-multiply-reaction/" 
f = 0.5
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(f))
plot_wave(results,paste0(dir,"wave_f0.5.gif"))

plot_derivatives(x_grid,results %>% filter(t==1) %>% .$uxt,title = "t = 1")
plot_derivatives(x_grid,results %>% filter(t==20) %>% .$uxt,title = "t = 20")
plot_derivatives(x_grid,results %>% filter(t==30) %>% .$uxt,title = "t = 30")
plot_derivatives(x_grid,results %>% filter(t==100) %>% .$uxt,title = "t = 100")
plot_derivatives(x_grid,results %>% filter(t==1000) %>% .$uxt,title = "t = 1000")


f = 0.1
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(f))
plot_wave(results,paste0(dir,"wave_f0.1.gif"))

# Back to Fisher wave but change the diffusion term
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-wave-output/std-normal-D_varies-Fisher-reaction/"
x_grid = seq(-10,10,by=0.1)
u0 = dnorm(x_grid)
time_steps = 1000
REACTION_FUNCTION = fisher_reaction
k = 0.05 # fixes slowly

D = 0.01 # our default value to start
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_D0.01.gif"))

D = 0.1 # increase by a factor of 10
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_D0.1.gif")) # D is now way too high. Simulation no longer makes sense.

D = 0.001 # scale down by 10
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k))
plot_wave(results,paste0(dir,"wave_D0.001.gif")) # Beautiful

# Bistable wave
dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/numerical-wave-output/std-normal-D=0.01-bistable-wave/"
k = 0.05
alpha = 0.7
u_hat = (1-alpha)/2 # 15% invasion frequency - low to start
D = 0.01 # standard
x_grid = seq(-10,10,by=0.1)
u0 = dnorm(x_grid)
time_steps = 100
REACTION_FUNCTION = bistable_reaction
u0[which(x_grid==0)] # initial frequency of 0.398
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results, add_hline = u_hat)

# Set a high invasion frequency
# p_hat = 49% but p_0 = 0.398
u_hat = 0.49
alpha = 1-(2*u_hat) # 0.02
# bring down the number of time steps so the video is shorter
time_steps = 200
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results,paste0(dir,"wave_k0.05_alpha0.02.gif"))

# Invasion frequency exactly equal to the introduction frequency
u_hat = u0[which(x_grid==0)]
alpha = 1-(2*u_hat) # 0.202
time_steps = 500
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results,paste0(dir,"wave_k0.05_alpha0.202.gif")) # collapses

# Invasion frequency just slightly below the introduction
u_hat = u0[which(x_grid==0)] - 0.01 # 0.3889
alpha = 1-(2*u_hat) # 0.222
time_steps = 500
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results,paste0(dir,"wave_k0.05_alpha0.222.gif")) # collapses again. DK why?

# Subtract more from u_hat
u_hat = u0[which(x_grid==0)] - 0.02 # 0.3789
alpha = 1-(2*u_hat) # 0.242
time_steps = 500
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results,paste0(dir,"wave_k0.05_alpha0.242.gif")) # still fails

u_hat = u0[which(x_grid==0)] - 0.1 # 0.2989
alpha = 1-(2*u_hat) # 0.402
time_steps = 500
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results,paste0(dir,"wave_k0.05_alpha0.402.gif")) # still fails

###### examining the critical bubble/propagule


x_grid = seq(-10,10,by=0.01)
REACTION_FUNCTION = bistable_reaction
D = 0.01
k = 0.05
u0 = dnorm(x_grid)

u_0 - u_alpha(0.02) 
u_0 - 0.49

# u0 > u_hat but u0 < u(alpha), so the wave is not predicted to spread
alpha = 0.02
time_steps = 300
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results) # wave retreats

####
u0 = dnorm(x_grid,sd=0.4)
u_0 = u0[x0_pos]
u_0 - 0.49
u_0 - u_alpha(0.02)

# u0 > u(alpha) > u_hat, so the wave should already exceed the critical bubble frequency and be able to spread.
# here, u0 - u_alpha = 0.086 and u0 - uhat = 0.51
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results) # doesn't spread

#########

u0 = dnorm(x_grid)
u_hat = u0[which(x_grid==0)] - 0.2 # u_hat = 0.1989; u_0 = 0.3989
alpha = 1-(2*u_hat) # 0.602
u_a = u_alpha(alpha) # 0.308
u_0 = u0[which(x_grid==0)]
u_0 - u_a
u_0-u_hat

# here, u_0 > u(alpha) by 0.09 (0.01 more than last time) and u_0 > u_hat by 0.2
time_steps = 300
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results)

### Make sure that the graph looks like a line when there's no diffusion
D = 0
x_grid = seq(-10,10,by=0.1)
u0 = rep(0.3,length(x_grid)) # starts with just a 30% frequency everywhere
time_steps = 100
REACTION_FUNCTION = fisher_reaction
k = 0.01
results_normal = simulate_u_x_t(u=u0,x_grid=x_grid,time_steps=time_steps,D=D,
                                   REACTION_FUNCTION = fisher_reaction,
                                   additional_reaction_arguments = c(k))
plot_wave(results_normal) 

# Now transition to a bistable wave and make sure this line goes up when p0 > p_hat and goes down when p0 < p_hat
REACTION_FUNCTION = bistable_reaction
p0 = u0[1] # 0.3
p_hat = 0.29 # p0 > p_hat by 0.01.
alpha = 1-(2*p_hat) # 0.42
k = 0.3
time_steps = 300
u_a = u_alpha(alpha) # 0.4605003 -- the frequency needed for the critical propagule when diffusion is present
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results, add_hline = p_hat) # good - this spreads

# now make p_hat slightly more than p0
p_hat = 0.31
alpha = 1-(2*p_hat) # 0.38
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results, add_hline = p_hat) # good - wave retreats


# Bistable wave with Gaussian initial function
u0 = dnorm(x_grid)
p0 = u0[which(x_grid==0)]
p0 #  0.3989423
p_hat = 0.31
alpha = 1-(2*p_hat) # 0.38
p_alpha = u_alpha(alpha)
p_alpha # 0.4955
D = 0.01
REACTION_FUNCTION = bistable_reaction
k = 0.3
time_steps = 400
results = simulate_u_x_t(u=u0,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results, add_hline = p_hat) 

# u(x)
x_grid = seq(-10,10,by=0.01)

# Integration by trapezoidal approximation
# x = -5 to x = 5
AUC = trapz(-5:5, dnorm(-5:5))
AUC

# See how close this is to the true integral
pnorm(q=5,mean=0,sd=1,lower.tail = TRUE) - pnorm(q=-5,mean=0,sd=1, lower.tail = TRUE)
# Very close

u_hat = 0.3
# Figure out where u(x) == 0.3
plot(grid, dnorm(grid), col="red",type="b")
abline(h=u_hat)

grid = seq(-5,5,by=0.01)
df1 = data.frame(x = grid, y = dnorm(grid))
df2 = data.frame (x= grid, y = rep(u_hat,length(grid)))

# Get the intersection of the two lines 
# From stack exchange:
# Find points where x1 is above x2.
x1 = df1$y
x2 = df2$y
above = x1 > x2

# Points always intersect when above=TRUE, then FALSE or reverse
intersect.points = which(diff(above) != 0)
intersect.points
abline(v=grid[intersect.points[1]]) # GOOD
abline(v=grid[intersect.points[2]])

x_lower = grid[intersect.points[1]]
x_upper = grid[intersect.points[2]]
critical_area = trapz(grid[intersect.points[1]:intersect.points[2]],
                      x1[intersect.points[1]:intersect.points[2]]) - rectangle_area


critical_area = function(x_grid, u_x, u_hat, plot = TRUE){
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
    plot(x = x_grid, y = u_x, col="red", xlab = "x", ylab = "u(x)")
    abline(h=u_hat)
    abline(v=x1)
    abline(v=x2)
  }
  
  return(crit_area)
}

x_grid = seq(-10,10,by=0.01)
u_x = dnorm(x_grid)
u_x_0 = u_x[which(x_grid==0)]
u_hat = 0.2
critical_area(x_grid,u_x,u_hat)

# Keep u_hat at 0.3
# Plot different normal curves with mu=0 and sigma varying
sigma = 0.5
x_grid = seq(-10,10,by=0.01)
u_x = dnorm(x_grid,sd=sigma)
u_x_0 = u_x[which(x_grid==0)]
u_x_0 # 0.8
u_hat = 0.3
critical_area(x_grid,u_x,u_hat) # 0.418

sigma = 0.6
u_x = dnorm(x_grid,sd=sigma)
u_x_0 = u_x[which(x_grid==0)]
u_x_0 # 0.665
critical_area(x_grid,u_x,u_hat) # 0.338

# smaller sd --> greater height of u(x) at x=0 --> greater critical area for the same u_hat value

# Find a bistable wave equation that just barely invades
sigma = 0.6 # u(0) = 0.665
u_hat = 0.49 # just slightly below 
alpha = alpha_for_u_hat(u_hat) # 0.02
x_grid = seq(-10,10,by=0.01)
u_x = dnorm(x_grid,sd=sigma)

# First plot / calculate the critical area
ca = critical_area(x_grid, u_x, u_hat)
print(paste0("For sd = ",sigma," and u_hat = ",u_hat,", the critical area is ",round(ca,4)))

REACTION_FUNCTION = bistable_reaction
D = 0.01
k = 0.3
time_steps = 10
results = simulate_u_x_t(u=u_x,
                         x_grid=x_grid,
                         time_steps=time_steps,
                         D=D,
                         REACTION_FUNCTION = REACTION_FUNCTION,
                         additional_reaction_arguments = c(k,alpha))
plot_wave(results)


# Fine tune x-grid
# Solve for u
# Eventually will be scaling k
