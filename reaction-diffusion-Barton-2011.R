# Equation 13 - the solution to the scaled 1-dimensional reaction-diffusion equation

# Wa1a1 > Wa2a2 > Wa1a2
# (1+alpha*s) > (1) > (1+s(alpha-1)) where alpha is the strength of directional selection over underdominant selection, S/s
# alpha must be between (0,1)
# dp/dt = 0 when p=0,p=1, or p=(1-alpha)/2
# since alpha < 1, p is always less than 1/2

# Reaction term when the scaled T and X^2 are plugged in
fP_scaled = function(p, s, alpha){
  p_hat = (1-alpha)/2
  fP = 2*p*(1-p)*(p-p_hat) # if p > p_hat, the allele frequency will increase locally. If not, it will decrease.
  return(fP)
}

pXT = function(x,t,s,sigma_squared,alpha){
  T_scaled = s*t
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  solution_value = 1/(1 + exp(X-(alpha*T_scaled)))
  return(solution_value)
}


# First derivative of p(X,T) wrt X 
dPXT_dX = function(x,t,s,sigma_squared,alpha){
  X_sq_scaled = (2*s*(x^2))/(sigma_squared)
  X = sqrt(X_sq_scaled)
  T_scaled = s*t
  e_term = exp(X-(alpha*T_scaled))
  deriv = -(e_term)/((1+e_term)^2)
  return(deriv)
}

# Second derivative of p(X,T) wrt X 
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


# plot with hypothetical parameter values

alpha = 0.3
p_hat = (1-alpha)/2 # 0.35
s = 0.01
Wa1a1 = 1 + (alpha*s)
Wa2a2 = 1
Wa1a2 = 1 + s*(alpha-1)
print(paste("Unstable equilibrium frequency (p_hat) =",p_hat))
print(paste("Wa1a1 fitness:",Wa1a1, "Wa2a2 fitness:", Wa2a2, "Wa1a2 fitness:", Wa1a2)) # checks

# sigma_sq controls the shape of the dispersal kernel. If it's larger, the wave can spread wider(?)
sigma_sq = 1

# hold t constant
t = 1


# Use for-loop to first loop over x
last = 30 # last time step 
x_vec = 0:last
p_vec = rep(0, last+1)
dp_dt_vec = rep(0,last+1)
d2p_dt2_vec = rep(0,last+1)

# hold t constant, at 1
t = 1


for (x in x_vec){
  p_vec[x+1] = pXT(x,t,s,sigma_squared,alpha)
  dp_dt_vec[x+1] = dPXT_dX(x,t,s,sigma_squared,alpha)
  d2p_dt2_vec[x+1] = d2PXT_dX2(x,t,s,sigma_squared,alpha)
}


par(mfrow = c(3,1))
plot(x_vec,p_vec,xlab = "x", ylab = "p(X,T)", type = "l", col = "red", main = "p(X,T)", xlim = c(0,last), ylim = c(-0.3,max(p_vec)))
abline(h=0)


plot(x_vec,dp_dt_vec,xlab = "x", ylab = "dp(X,T)/dX", type = "l", col = "red", main = "dp(X,T)/dX", xlim = c(0,last), ylim = c(-0.3,max(dp_dt_vec)))
abline(h=0)

plot(x_vec,d2p_dt2_vec,xlab = "x", ylab = "d^2p(X,T)/dX^2", type = "l", col = "red", main = "d^2p(X,T)/dX^2", xlim = c(0,last), ylim = c(-0.3,max(d2p_dt2_vec)))
abline(h=0)
