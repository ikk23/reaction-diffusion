# m = the drop size of d/d
# x = position
# D = diffusion coefficient = 0.5*sigma^2
# rho = wild-type density
# alpha = used in fitness
# k = invasion threshold

################### AFTER 1 ROUND OF DISPERSAL ONLY ################### 

# The expected number of d/ds after 1 round of dispersal = nAA'(x,t=0)
n_AA_x_t_prime = function(m,x,D){
  numerator = m*exp((-x^2)/(4*D))
  denominator = sqrt(4*pi*D)
  return(numerator/denominator)
}

# The expected number of wt/wts after 1 round of dispersal = naa'(x,t=0)
n_aa_x_t_prime = function(rho){
  return(rho)
}

# The expected count after 1 round of dispersal = N'(x,t=0) = nAA'(x,t=0) + naa'(x,t=0)
N_x_t_prime = function(m,x,D,rho){
  numerator_term1 = m*exp((-x^2)/(4*D))
  numerator_term2 = rho*sqrt(4*pi*D)
  denominator = sqrt(4*pi*D)
  sol = (numerator_term1 + numerator_term2)/denominator
  return(sol)
}

drive_rate_x_t_prime = function(m,x,D,rho){
  numerator = m*exp((-x^2)/(4*D))
  denominator_term1 = m*exp((-x^2)/(4*D))
  denominator_term2 = rho*sqrt(4*pi*D)
  sol = numerator/(denominator_term1+denominator_term2)
  return(sol)
}

m = 2030
x = 0.1
D = 0.001
rho = 1/10000
nAA = n_AA_x_t_prime(m,x,D)
naa = n_aa_x_t_prime(rho)
expected_tot = nAA + naa
calc_tot = N_x_t_prime(m,x,D,rho) # check
total_in_gen0 = N_x_t_prime(m,x,D,rho) 

################### AFTER REPRODUCTION, BEFORE VIABILITY ################### 

p = drive_rate_x_t_prime(m,x,D,rho)
expected_AA_freq_prime_prime = p^2
expected_num_AA_prime_prime = expected_AA_freq_prime_prime*total_in_gen0

expected_Aa_freq_prime_prime = 2*p*(1-p)
expected_num_Aa_prime_prime = expected_Aa_freq_prime_prime*total_in_gen0

expected_aa_freq_prime_prime = (1-p)^2
expected_num_aa_prime_prime = expected_aa_freq_prime_prime*total_in_gen0

# p^2 = [uA'(x,t=0)]^2
freq_AA_x_t_prime_prime = function(m,x,D,rho){
  numerator = (m^2)*exp((-x^2)/(2*D))
  denominator_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator = denominator_inner^2
  sol = numerator/denominator
  return(sol)
}

# 2*p*(1-p) = 2*[uA'(x,t=0)]*[1 - uA'(x,t=0)]
freq_Aa_x_t_prime_prime = function(m,x,D,rho){
  numerator = 2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D)
  denominator_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator = denominator_inner^2
  sol = numerator/denominator
  return(sol)
}

# (1-p)^2 = [1 - uA'(x,t=0)]^2
freq_aa_x_t_prime_prime = function(m,x,D,rho){
  numerator = 4*pi*D*(rho^2)
  denominator_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator = denominator_inner^2
  sol = numerator/denominator
  return(sol)
}

# N x p^2 = N'(x,t=0) x [uA'(x,t=0)]^2
embryo_count_AA_x_t_prime_prime = function(m,x,D,rho){
  factor1_numerator = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  factor2_numerator = (m^2)*exp((-x^2)/(2*D))
  num = factor1_numerator*factor2_numerator
  
  denominator_term1_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  sol = (num/denom)
  return(sol)
}

# N x 2*p*(1-p) = N'(x,t=0) x 2[uA'(x,t=0)][1-uA'(x,t=0)]
embryo_count_Aa_x_t_prime_prime = function(m,x,D,rho){
  denominator_term1_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  numerator_factor1 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  numerator_factor2 = 2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D)
  numerator = numerator_factor1*numerator_factor2
  
  sol = numerator/denom
  return(sol)
}

# N x (1-p)^2 = N'(x,t=0) x [1-uA'(x,t=0)]^2
embryo_count_aa_x_t_prime_prime = function(m,x,D,rho){
  denominator_term1_inner = m*exp((-x^2)/(4*D)) + (rho*sqrt(4*pi*D))
  denominator_term1 = denominator_term1_inner^2
  denominator_term2 = sqrt(4*pi*D)
  denom = denominator_term1*denominator_term2
  
  term1_num = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  term2_num = 4*pi*D*(rho^2)
  num = term1_num*term2_num
  
  sol = num/denom
  return(sol)
}

################### AFTER REPRODUCTION AND AFTER VIABILITY ################### 

mean_fitness = function(m,x,D,rho,alpha,k){
  # numerator
  t1 = (1 + (2*alpha*k))*((m^2)*exp((-x^2)/(2*D)))
  t2 = (1 + ((alpha-1)*k))*(2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D))
  t3 = 4*pi*D*(rho^2)
  numerator = t1 + t2 + t3
  
  denom_t1 = m*exp((-x^2)/(4*D))
  denom_t2 = rho*sqrt(4*pi*D)
  denom = (denom_t1+denom_t2)^2
  sol = numerator/denom
  return(sol)
}

# wAA/mean(W)
fitness_ratio_AA = function(m,x,D,rho,alpha,k){
  numerator_term1 = 1 + (2*alpha*k)
  numerator_term2_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  numerator_term2 = numerator_term2_inner^2
  numerator = numerator_term1*numerator_term2
  
  denom_t1 = (1 + (2*alpha*k))*((m^2)*exp((-x^2)/(2*D)))
  denom_t2 = (1 + ((alpha-1)*k))*(2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D))
  denom_t3 = 4*pi*D*(rho^2)
  denom = denom_t1+denom_t2+denom_t3
  
  sol = numerator/denom
  return(sol)
}

# wAa/mean(W)
fitness_ratio_Aa = function(m,x,D,rho,alpha,k){
  denom_t1 = (1 + (2*alpha*k))*((m^2)*exp((-x^2)/(2*D)))
  denom_t2 = (1 + ((alpha-1)*k))*(2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D))
  denom_t3 = 4*pi*D*(rho^2)
  denom = denom_t1+denom_t2+denom_t3
  
  
  num_t1 = 1 + ((alpha-1)*k)
  num_t2_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  num_t2 = num_t2_inner^2
  numerator = num_t1*num_t2
  
  sol = numerator/denom
  return(sol)
}

# waa/mean(W)
fitness_ratio_aa = function(m,x,D,rho,alpha,k){
  denom_t1 = (1 + (2*alpha*k))*((m^2)*exp((-x^2)/(2*D)))
  denom_t2 = (1 + ((alpha-1)*k))*(2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D))
  denom_t3 = 4*pi*D*(rho^2)
  denom = denom_t1+denom_t2+denom_t3
  
  num_inner = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  num = num_inner^2
  sol = num/denom
  return(sol)
}

# nAA(x,t=1)
juvenile_count_AA_post_viability = function(m,x,D,rho,alpha,k){
  f1_numerator = (1+(2*alpha*k))
  f2 = (m^2)*exp((-x^2)/(2*D))
  f3 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  numerator = f1_numerator*f2*f3
  
  f1_denom = sqrt(4*pi*D)*(1 + (2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  f2_denom = 8*pi*D*rho*m*exp((-x^2)/(4*D))*(1 + ((alpha-1)*k))
  f3_denom = 4*pi*D*(rho^2)*sqrt(4*pi*D)
  denom = f1_denom+f2_denom+f3_denom
  
  sol = numerator/denom
  return(sol)
}

# nAa(x,t=1)
juvenile_count_Aa_post_viability = function(m,x,D,rho,alpha,k){
  f1_num = 1 + ((alpha-1)*k)
  f2_num = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  f3_num = 2*m*rho*exp((-x^2)/(4*D))
  num = f1_num*f2_num*f3_num
  
  denom_t1 = (1+(2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  denom_t2 = (1 + ((alpha-1)*k))*2*m*rho*exp((-x^2)/(4*D))*sqrt(4*pi*D)
  denom_t3 = 4*pi*D*(rho^2)
  denom = denom_t1+denom_t2+denom_t3
  
  sol = num/denom
  return(sol)
}

# naa(x,t=1)
juvenile_count_aa_post_viability = function(m,x,D,rho,alpha,k){
  f1_denom = sqrt(4*pi*D)*(1 + (2*alpha*k))*(m^2)*exp((-x^2)/(2*D))
  f2_denom = 8*pi*D*rho*m*exp((-x^2)/(4*D))*(1 + ((alpha-1)*k))
  f3_denom = 4*pi*D*(rho^2)*sqrt(4*pi*D)
  denom = f1_denom+f2_denom+f3_denom
  
  num_f1 = 4*pi*D*(rho^2)
  num_f2 = (m*exp((-x^2)/(4*D))) + (rho*sqrt(4*pi*D))
  num = num_f1*num_f2
  sol = num/denom
  
  return(sol)
}
