source("/Users/isabelkim/Desktop/year2/underdominance/reaction-diffusion/scripts/functions-piecewise-discrete-time-continuous-space.R")


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
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat) # HERE, u(x,t=1) < 0 between -a/2 and a/2?

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


real_reaction = res$results$u_x_prime_t1 + res$results$u_x_t1_two_step
res$plot + geom_point(aes(y = real_reaction), color = "purple")

left = res$results %>% filter(x < -a/2)
diff = abs(left$u_x_t1_full_sol - (left$u_x_prime_t1 + bistable_reaction(left$u_x_prime_t1, k, u_hat))) 

i=1
(left$u_x_prime_t1[1] + bistable_reaction(left$u_x_prime_t1[1], k, u_hat))
left$u_x_t1_full_sol[1]



results = res$results
View(results)
left = results %>% filter(x >= -10 & x <= -5)
right = results %>% filter(x >= 5 & x <= 10)
weird = rbind(left,right)




# Checking math for expansion of e -- works for e_term^2
a = 10
x = -10
sigma = 2
sig_recip = -1/sigma
inner_e1 = (a/2)-x
e1 = exp(sig_recip*inner_e1)

inner_e2 = (-a/2)-x
e2 = exp(sig_recip*inner_e2)
e_term = e1 - e2

e_term_sq = e_term^2

e1_f = exp((-2/sigma)*((a/2)-x))
e2_f = 2*exp((1/sigma)*2*x)
e3_f = exp((-2/sigma)*((-a/2)-x))
e1_f - e2_f + e3_f


e_term_cubed = e_term^3
a_half_pos = a/2
a_half_neg = -a/2

e1 = exp((-3/sigma)*(a_half_pos-x))
e2 = exp((-3/sigma)*(a_half_neg - x))
e3 = 2*exp((1/sigma)*((3*x) + a_half_pos))
e4 = 2*exp((1/sigma)*((3*x) - a_half_pos))
e5 = exp((-1/sigma)*(a_half_neg - (3*x)))
e6 = exp((-1/sigma)*(a_half_pos - (3*x)))

sol = e1 - e2 + e3 - e4 + e5 - e6
sol
e_term_cubed


# Checking u(x,t=1) for x in [-a/2, a/2]
a = 10
b = 0.5
u_hat = 0.4
k = 0.1
sigma = 1

# x in range
x = 1

# 1. C = prime of u; u(x,t=1) = C + f(C)
C = u_prime_x1(x,a,b,sigma)
u_x_two_step = C + bistable_reaction(C,k,u_hat)

# 2. full formula
sig_n_recip = -1/sigma
e_1_inner = x + (a/2)
e_1 = exp(sig_n_recip*e_1_inner)
e_2_inner = (a/2) - x
e_2 = exp(sig_n_recip*e_2_inner)
e_term = e_1 + e_2

constants = (2*k*b*(1-b)*(b-u_hat)) + b

c_e1_inner = (b*((3*b)-(2*u_hat)-2)) + u_hat
c_e1 = (k*b*c_e1_inner) - (b/2)
e1_term = c_e1*e_term

c_e2 = ((-k*(b^2))/2)*((3*b) - u_hat - 1)
e2_term = c_e2*(e_term^2)

c_e3 = ((k*(b^3))/4)
e3_term = c_e3*(e_term^3)

sol = constants + e1_term + e2_term + e3_term
sol == u_x_two_step # CHECK, good


# Checking u(x,t=1) for x < -a/2
a = 10
b = 0.5
u_hat = 0.4
k = 0.1
sigma = 1

# x < -a/2
x = -6

# 1. C = prime of u; u(x,t=1) = C + f(C)
C = u_prime_x1(x,a,b,sigma)
u_x_two_step = C + bistable_reaction(C,k,u_hat)

# 2. full formula
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

sol == u_x_two_step # TRUE

# x > a/2
x = 10
# 1. C = prime of u; u(x,t=1) = C + f(C)
C = u_prime_x1(x,a,b,sigma)
u_x_two_step = C + bistable_reaction(C,k,u_hat)

# 2. full formula
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
sol == u_x_two_step # CHECK

# ex:
a = 10
b = 0.5
u_hat = 0.3
sigma = 1
k = 0.1

x_grid = seq(-100,100,by=0.1)
res = u_t0_to_t1(x_grid,a,b,sigma,k,u_hat)
theta1_approx = res$theta1 # 5.05875
a*b

theta1_e1 = theta1(a,b,k,u_hat,sigma)
print(paste("Trapz approx:",theta1_approx, "equation solution:",theta1_e1))
# These are not equal

theta1 = function(a,b,k,u_hat,sigma){
  term1 = a*b*((2*k*(b-u_hat)*(1-b)) + 1)
  
  term2_inner = ((b^2)/3) - (b*((6*k)+(u_hat/2))) + (4*k*(1+u_hat))
  term2_factor2 = 2 -(b*term2_inner)
  term2 = sigma*b*term2_factor2
  
  e_term1 = exp(-a/sigma)
  term3_sigma = sigma*((3*(1+u_hat)) - (7*b))
  term3_inside = (a*(1 + u_hat)) - (3*b) + term3_sigma
  term3 = e_term1*(b^2)*k*term3_inside
  
  e_term2 = exp((-2*a)/sigma)
  term4_f1 = sigma*(b^2)*k
  term4_f2 = b + 1 + (u_hat/2)
  term4 = e_term2*term4_f1*term4_f2
  
  e_term3 = exp((-3*a)/sigma)
  term5_f1 = (sigma*(b^3)*k)/3
  term5 = e_term3*term5_f1
  
  sol = term1 + term2 + term3+ term4 + term5
  
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


theta1_no_factor = theta1_before_simplification(a,b,k,u_hat,sigma)
theta1_factored = theta1(a,b,k,u_hat,sigma)
print(paste("Before factored:",theta1_no_factor, "after factored:",theta1_factored,
            "trapz approx:",theta1_approx))

# The "before factored" is closer to the trapezoidal approximation than the factored form, so there must be a mistake in the algebra somewhere -- look for it.