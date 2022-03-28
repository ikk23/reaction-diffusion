source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-main-model.R")


# Check for a smooth function
sigma = 1
a = 1 # -a/2 = -5, a/2 = 5
b = 0.5
x_grid = seq(-10,10,by=0.1)
p = plot_migration_step(x_grid,a,b,sigma) # check

# Check that, as a-->infinity u'(x,t=1) --> b √
a = 1000
x_grid = seq(-1000,1000,by=0.1)
t = plot_migration_step(x_grid,a,b,sigma)

# CHECK math for migration of: x < -a/2 u(x,t=1) √ - math checks out
x = -10
sig_recip = -1/sigma
a_upper = a/2
a_lower = -a/2
e_term1 = exp(sig_recip*(a_upper-x))
e_term2 = exp(sig_recip*(a_lower-x))
e_full_term = e_term1 - e_term2
b_half_pos = b/2
b_half_neg = -b/2
initial_term1 = (2*k)*(b_half_neg*e_full_term)
initial_term2 = 1 + (b_half_pos*e_full_term)
initial_term3 = (b_half_neg*e_full_term) - u_hat
sol_initial = initial_term1*initial_term2*initial_term3
sol_initial
term1_fac = k*b*u_hat*e_full_term
term2_fac = (k*(b^2)/2)*(1 + u_hat)*(e_full_term^2)
term3_fac = (k*(b^3)/4)*(e_full_term^3)
sol_factored = term1_fac+term2_fac+term3_fac
sol_factored == sol_initial
print(paste("Initial:",sol_initial,"factored:",sol_factored))
# CHECK math for -a/2 <= x <= a/2 √
x = 0
# not simplified
sig_recip = -1/sigma
e_term1 = exp(sig_recip*(x + (a/2)))
e_term2 = exp(sig_recip*((a/2)-x))
inside_2_e_thing = 2 - e_term1 - e_term2
f1 = 2*k*(b/2)*inside_2_e_thing
f2 = 1 - ((b/2)*inside_2_e_thing)
f3 = ((b/2)*inside_2_e_thing)-u_hat
sol_initial = f1*f2*f3
sol_initial
# factored
inner_e = e_term1 + e_term2
constants = 2*k*b*(1-b)*(b-u_hat)
c1 = k*b*((b*((3*b) - (2*u_hat) - 2))+u_hat)
term_e_1 = c1*inner_e
c2 = (-k*(b^2)/2)*((3*b)-u_hat-1)
term_e_2 = c2*(inner_e^2)
c3 = k*(b^3)/4
term_e_3 = c3*(inner_e^3)
sol_factored = constants + term_e_1 + term_e_2 + term_e_3
sol_factored
print(paste("Initial:",sol_initial,"factored:",sol_factored))
# CHECK math for x > a/2 √
# initial
x = 10
sig_recip = -1/sigma
e_1 = exp(sig_recip*(x - (a/2)))
e_2 = exp(sig_recip*(x + (a/2)))
e_inner = e_1 - e_2
C = (b/2)*e_inner
initial_sol = 2*k*C*(1-C)*(C-u_hat)
initial_sol
# factored
e_term = e_1 - e_2
term1 = -k*b*u_hat*e_term
term2 = (k*(b^2)/2)*(1+u_hat)*(e_term^2)
term3 = ((-k*(b^3))/4)*(e_term^3)
sol_factored = term1 + term2 + term3
print(paste("Initial:",initial_sol,"factored:",sol_factored))

# examples:


# b = u_hat and a = 10
b = 0.3
u_hat = 0.3
a = 10
x_grid = seq(-20,20,by=0.1)
k = 0.1
sigma = 2
print(paste("ratio of sigma to a = ",sigma/a))
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat) # HERE, u(x,t=1) < 0 between -a/2 and a/2

dir = "/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/figures/"
ggsave(plot = res$plot, filename = paste0(dir, "b=u_hat=0.3_k=0.1.png"))

# Our parameters (3/16/2022)
sigma = 0.05
k = 0.2
u_hat = 0.2
a = 0.105
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.002


a = 0.1
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.00188

a  = 0.09
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.0016


a  = 0.05
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.002; increased from before, so the optimal a is between 0.05 and 0.09

a = 0.07
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.0013; new best

a = 0.06
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # 0.0016; optimal might be between 0.07 and 0.06

a = 0.068
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # not as good as 0.07

a = 0.069
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # not as good as 0.07

a = 0.072
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # less than 0.07's

a = 0.08
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # greater than 0.072's

a = 0.075
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # not as good

a = 0.073
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta)) # new best


a = 0.08
delta = check_for_delta_0_when_b_is_1(u_hat = 0.2, beta = a/sigma)
print(paste("When a =",a,"beta =",a/sigma,"and delta =",delta))

# a = 0.073 seems best here. beta = 1.48

# beta = a / sigma
# a = sigma*beta




# b < u_hat
b = 0.2
u_hat = 0.3
a = 10
x_grid = seq(-20,20,by=0.1)
k = 0.1
sigma = 2
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat) # u(x,t=1) dips even more below the x-axis between -5 and 5
View(res$results)

# b > u_hat
b = 0.4
u_hat = 0.3
a = 10
x_grid = seq(-20,20,by=0.1)
k = 0.1
sigma = 2
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat) # small bump at x = 0, but still mostly negative.

# b >> u_hat
b = 0.99
u_hat = 0.3
a = 10
x_grid = seq(-30,30,by=0.1)
k = 0.1
sigma = 2
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)

# only under best case scenarios does the u(x,t=1) wave stay positive.
b = 0.99
u_hat = 0.1
a = 10
x_grid = seq(-20,20,by=0.1)
k = 0.3
sigma = 3
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)

sig_n_recip = -1/sigma
e1 = exp(sig_n_recip*(x - (a/2)))
e2 = exp(sig_n_recip*(x + (a/2)))
e_term = e1 - e2

e_term_sq = e_term^2

e1_t = exp((-2/sigma)*(x - (a/2)))
e2_t = exp((-2/sigma)*(x + (a/2)))
e3_t = -2*exp((-1/sigma)*(2*x))
e1_t+e2_t+e3_t

e_term_cubed = e_term^3
e1_t = exp((-3/sigma)*(x - (a/2)))
e2_t = -1*exp((-3/sigma)*(x + (a/2)))
e3_t = 3*exp((-1/sigma)*((3*x) + (a/2)))
e4_t = -3*exp((-1/sigma)*((3*x) - (a/2)))
e1_t + e2_t + e3_t + e4_t

# Low u_hat and moderate b - GOOD
b = 0.5
u_hat = 0.1
a = 10
sigma = 2
k = 0.3
x_grid = seq(-20,20,by=0.1)
o = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)


# Check: if b=1, does anything happen? 
b = 1
u_hat = 0.1
a = 10
sigma = 2
k = 0.3
x_grid = seq(-20,20,by=0.1)
ok = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat) # migration lowers the curve; reaction pushes it down a lot.

# Check: when b = u_hat = 0.1  - NEGATIVES
b = u_hat
o_equal = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
# Problems again with negative values.


# Examine what occurs at x=1
results = o_equal$results
a_range = results %>% filter(x >= -a/2 & x <= a/2)
View(a_range)
i = which(a_range$x == 0)
u0 = a_range$u_x_t0[i]
u0 # = b, 0.1

# u'(x,t=1) always results in a positive value.
u_prime = a_range$u_x_prime_t1[i] # 0.0917915

# separate the factors in the reaction term
two_k_u = 2*k*results$u_x_prime_t1
one_minus_u = 1 - results$u_x_prime_t1
u_minus_u_hat = results$u_x_prime_t1 - u_hat

results_reaction = results %>% dplyr::select(x,u_x_t0,u_x_prime_t1,u_x_t1_full_sol) %>%
  add_column(two_k_u,one_minus_u,u_minus_u_hat)
View(results_reaction) # It's always u' - u_hat < 0.

b = 0.4
u_hat = 0.3
a = 10
sigma = 2
k = 0.3
x_grid = seq(-20,20,by=0.1)
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
real_reaction = res$results$u_x_prime_t1 + res$results$u_x_t1_two_step
res$plot + geom_point(aes(y = real_reaction), color = "purple")

# b > u_hat - WEIRD AT BOUNDARIES
b = 0.6
u_hat = 0.3
a = 25
sigma = 2
k = 0.5
x_grid = seq(-50,50,by=0.1)
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)


theta1 = function(a,b,k,u_hat,sigma){
  t1 = a*b*((2*k*(b-u_hat)*(1-b)) + 1)
  
  t2 = ((sigma*(b^2)*k)* (((25*b)/6) - (3*(1 + u_hat))) )
  
  t3 = exp(-a/sigma)*((b^2)*k)*((a*(u_hat - (3*b) + 1)) + (sigma*((3*(1+u_hat)) - ((9/2)*b))))
  
  t4 = exp((-2*a)/sigma)*((5*sigma*(b^3)*k)/2)
  
  t5 = exp((-3*a)/sigma)*((sigma*(b^3)*k)/3)
  
  t6 = exp(-a/(2*sigma))*((sigma*(b^3)*k)/2)
  
  sol = t1+t2+t3+t4+t5+t6
  
  return(sol)
}

theta1_before_simplification = function(a,b,k,u_hat,sigma){
  # Get int1
  term1 = ((a*b)/2)*((2*k*(b-u_hat)*(1-b))+1)
  
  term2_k_inside = (b*((3*b)-2)) + (u_hat*(1 - (2*b)))
  term2_sigma_b_inside = (k*term2_k_inside) - 0.5
  term2_factor = sigma*b*term2_sigma_b_inside
  term2_e = 1 - exp((-a)/sigma)
  term2 = term2_factor*term2_e
  
  term3_factor = ((-k*(b^2))/2)*((3*b) - u_hat - 1)
  term3_e = (a*exp(-a/sigma)) + ((sigma/2)*(1 - exp((-2*a)/sigma)))
  term3 = term3_factor*term3_e
  
  term4_factor = ((-sigma)*k*(b^3))/4
  term4_inside1 = (1/3)*(1 - exp((-3*a)/sigma))
  term4_inside2 = 3*(exp(-a/sigma) - exp((-2*a)/sigma))
  term4_inside = term4_inside1 + term4_inside2
  term4 = term4_factor*term4_inside
  
  int1 = term1+term2+term3+term4
  
  # Get int2
  
  term1_factor = sigma*b*(0.5 - (k*u_hat))
  term1_inside = 1 - exp(-a/sigma)
  term1 = term1_factor*term1_inside
  
  term2_factor = ((sigma*k*(b^2))/2)*(1 + u_hat)
  term2_inside = (0.5*(1 + exp((-2*a)/sigma))) - exp(-a/sigma)
  term2 = term2_factor*term2_inside
  
  term3_factor = (-sigma*k*(b^3))/4
  term3_inside = (1/3)*(1 - exp((-3*a)/sigma)) + exp((-2*a)/sigma) - exp(-a/(2*sigma))
  term3 = term3_factor*term3_inside
  
  int2 = term1 + term2 + term3
  
  # Sum int1 and int2
  sum_ints = int1+int2
  
  # Multiply by 2
  sol = 2*sum_ints
  
  return(sol)
}


# CHECKS

# ex:
a = 10
b = 0.3
u_hat = 0.3
sigma = 1
k = 0.1


x_grid = seq(-500,500,by=0.1)
length(x_grid)
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
theta1_approx = res$theta1
theta0 = a*b

theta1_no_factor = theta1_before_simplification(a,b,k,u_hat,sigma) 
theta1_factored = theta1(a,b,k,u_hat,sigma) 
print(paste("Before factored:",theta1_no_factor, "after factored:",theta1_factored,
            "trapz approx:",theta1_approx))


a = 30
b = 0.32
u_hat = 0.3
sigma = 1
k = 0.1
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
theta1_approx = res$theta1
theta0 = a*b

theta1_no_factor = theta1_before_simplification(a,b,k,u_hat,sigma) 
theta1_factored = theta1(a,b,k,u_hat,sigma) 
print(paste("Before factored:",theta1_no_factor, "after factored:",theta1_factored,
            "trapz approx:",theta1_approx, " -- theta0 was", res$theta0))

################################## 
# Very wide x-grid to approximate -infinity to +infinity

x_grid = seq(-500,500,by=0.1)
length(x_grid) # 10001
a = 25
k = 0.1
sigma = 1
u_hat = 0.2

# b = u_hat
b = u_hat

res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
print(paste0("a*b = ",res$theta0,".      theta1 by trapz approx: ",res$theta1_trapz, ", theta1 by factored formula: ",res$theta1_factored,", theta1 by unsimplified formula: ",res$theta1_unsimplified,".    error of trapz approx - factored formula = ",res$theta1_trapz-res$theta1_factored)) 
# AUC slightly decreases from 5 to 4.99; the formula values are essentially equal; the trapezoidal approximation is very close to the formula values (error of 2.7e-4)

# b > u_hat by 0.1
b = 0.3
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
print(paste0("a*b = ",res$theta0,".      theta1 by trapz approx: ",res$theta1_trapz, ", theta1 by factored formula: ",res$theta1_factored,", theta1 by unsimplified formula: ",res$theta1_unsimplified,".    error of trapz approx - factored formula = ",res$theta1_trapz-res$theta1_factored)) 
# AUC increases from 7.5 to 7.58. Formula values are almost exactly the same. The trapezoidal approximation is only 9e-4 off.

# b < u_hat by a lot
b = 0.05
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
print(paste0("a*b = ",res$theta0,".      theta1 by trapz approx: ",res$theta1_trapz, ", theta1 by factored formula: ",res$theta1_factored,", theta1 by unsimplified formula: ",res$theta1_unsimplified,".    error of trapz approx - factored formula = ",res$theta1_trapz-res$theta1_factored)) 
# AUC decreases from 1.25 to 1.21; formulas give the same value; error for trapz approximation is even smaller: 4.17e-6.

# Check that as a--> infinity and b = u_hat, AUC stays around the same
a = 1000
b = u_hat
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
print(paste0("a*b = ",res$theta0,".      theta1 by trapz approx: ",res$theta1_trapz, ", theta1 by factored formula: ",res$theta1_factored,", theta1 by unsimplified formula: ",res$theta1_unsimplified,".    error of trapz approx - factored formula = ",res$theta1_trapz-res$theta1_factored)) 
# AUC is initially at 200. The formulas both approximate a theta1 of 199.98893 (about 200); trapezoidal approximation is slightly lower (error or -0.194).


# March 24, 2022
# what a* is going to lead to that "critical propagule" when we have default parameters
sigma = 0.05
m = 0.005
k = 0.2
u_hat = 0.2
alpha = 1-(2*u_hat)
get_fitness_values(alpha,k) # d/d fitness = 1.24; d/wt fitness = 0.92; wt/wt fitness = 1.0

a = 0.05

# Try to get delta as close to 0 as possible
epsilon = check_for_delta_0_when_b_is_1(u_hat, beta = a/sigma)
paste0("a = ",a," --> beta = ", a/sigma, " --> delta = ",epsilon)

a = 0.04 # increase a from 0.05
paste0("a = ",a," --> beta = ", a/sigma, " --> delta = ",check_for_delta_0_when_b_is_1(u_hat, beta = a/sigma))

a = 0.073241
paste0("a = ",a," --> beta = ", a/sigma, " --> delta = ",check_for_delta_0_when_b_is_1(u_hat, beta = a/sigma))

seq_of_a = seq(0.04, 0.09, length.out=20)
epsilon_vector = rep(-1,20)
for (i in 1:20){
  a = seq_of_a[i]
  epsilon_vector[i] = check_for_delta_0_when_b_is_1(u_hat, beta = a/sigma)
}
tib = tibble(a = seq_of_a, delta = epsilon_vector)
View(tib)
ind = which.min(epsilon_vector)
a_min = seq_of_a[ind]
delta_min = epsilon_vector[ind]
# sweet spot for a is between 0.07157895 and 0.07684211

a_min_vec = seq(0.07157895, 0.07684211, length.out = 20)
epsilon_min_vec = rep(-1,20)
for (i in 1:20){
  a = a_min_vec[i]
  epsilon_min_vec[i] = check_for_delta_0_when_b_is_1(u_hat, beta = a/sigma)
}
tib_min = tibble(a = a_min_vec, delta = epsilon_min_vec)
View(tib_min)
min(tib_min$delta) # 0.001273019
a_value = tib_min$a[which.min(tib_min$delta)] # a = 0.073241
beta = a_value / sigma # 1.46482
