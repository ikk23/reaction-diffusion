u0 = function(x,a,b=1){
  if (x >= -a/2 & x <= a/2){
    u = b
  } else {
    u = 0
  }
  return(u)
}

dispersal_kernel = function(x1,x2,sigma){
  coeff = 1/(2*sigma)
  exponent = (-1/sigma)*abs(x2-x1)
  sol = coeff*exp(exponent)
  return(sol)
}

uprime1 = function(x,a,b,sigma){
  # x < -a/2
  if (x >= -a/2){
    print("Not applicable")
    return(NULL)
  }
  # x < -a/2
  coeff = -b/2
  e1 = exp((-1/sigma) * ((a/2)-x))
  e2 = exp((-1/sigma)*((-a/2) - x))
  sol = coeff*(e1 - e2)
  return(sol)
}

uprime2 = function(x,a,b,sigma){
  # -a/2 <= x <= a/2
  if (x < -a/2 || x > a/2){
    print("Not applicable")
    return(NULL)
  }
  # -a/2 <= x <= a/2
  coeff = b/2
  e1 = exp((-1/sigma)*(x + (a/2)))
  e2 = exp((-1/sigma)*((a/2) - x))
  t2 = 2 - e1 - e2
  sol = coeff*t2
  return(sol)
}

uprime3 = function(x,a,b,sigma){
  # x > a/2
  if (x <= a/2){
    print("Not applicable")
    return(NULL)
  }
  coeff = b/2
  e1 = exp((-1/sigma)*(x - (a/2)))
  e2 = exp((-1/sigma)*(x + (a/2)))
  sol = coeff*(e1 - e2)
  return(sol)
}

u_t1_sub1 = function(x,a,b,sigma,k,uhat){
  # x < -a/2
  if (x >= -a/2){
    print("Not applicable")
    return(NULL)
  }
  
  # TERM1
  coeff = b*((k*uhat) - 0.5)
  e1 = exp((-1/sigma)*((a/2) - x))
  e2 = exp((-1/sigma)*((-a/2)-x))
  term1 = coeff*(e1 - e2)
  
  # TERM2
  coeff = ((k*(b^2))/2)*(1 + uhat)
  e1 = exp((-1/sigma)*((a/2) - x))
  e2 = exp((-1/sigma)*((-a/2) - x))
  inner = e1 - e2
  term2 = coeff*(inner^2)
  
  # TERM3
  coeff = (k*(b^3))/4
  e1 = exp((-1/sigma)*((a/2) - x))
  e2 = exp((-1/sigma)*((-a/2) - x))
  term3 = coeff*((e1 - e2)^3)
  
  sol = term1 + term2 + term3
  return(sol)
}

u_t1_sub2 = function(x,a,b,sigma,k,uhat){
  # -a/2 <= x <= a/2
  if (x < -a/2 || x > a/2){
    print("Not applicable")
    return(NULL)
  }
  
  # TERM1
  term1 = b*((2*k*(b-uhat)*(1-b)) + 1)
  
  # TERM2
  k_inner = b*((3*b) - 2) + (uhat*(1 - (2*b)))
  coeff = b*((k*k_inner) - 0.5)
  e1 = exp((-1/sigma)*(x + (a/2)))
  e2 = exp((-1/sigma)*((a/2)-x))
  term2 = coeff*(e1 + e2)
  
  # TERM3
  coeff = -1*( ((k*(b^2))/2) * ((3*b) - uhat - 1))
  e1 = exp((-1/sigma)*(x + (a/2)))
  e2 = exp((-1/sigma)*((a/2) - x))
  e_term = (e1 + e2)^2
  term3 = coeff*e_term # add
  
  # TERM4 
  coeff = (k*(b^3))/4
  e1 = exp((-1/sigma)*(x + (a/2)))
  e2 = exp((-1/sigma)*((a/2) - x))
  e_inner = (e1 + e2)^3
  term4 = coeff*e_inner
  
  sol = term1 + term2 + term3 + term4
  return(sol)
}

u_t1_sub3 = function(x,a,b,sigma,k,uhat){
  # x > a/2
  if (x <= a/2){
    print("Not applicable")
    return(NULL)
  }
  
  # TERM1
  coeff = b*(0.5 - (k*uhat))
  e1 = exp((-1/sigma)*(x - (a/2)))
  e2 = exp((-1/sigma)*(x + (a/2)))
  term1 = coeff*(e1 - e2)
  
  # TERM2
  coeff = ((k*(b^2))/2)*(1 + uhat)
  e1 = exp((-1/sigma)*(x - (a/2)))
  e2 = exp((-1/sigma)*(x + (a/2)))
  e_term = e1 - e2
  term2 = coeff*((e1 - e2)^2)
  
  # TERM3
  coeff = -((k*(b^3))/4)
  e1 = exp((-1/sigma)*(x - (a/2)))
  e2 = exp((-1/sigma)*(x + (a/2)))
  e_term = (e1 - e2)^3
  term3 = coeff*e_term
  
  sol = term1+term2+term3
  return(sol)
}

given_x_get_uprime_and_u_t1 = function(x_raw,a,b,sigma,k,uhat){
  x = x_raw - 0.5 # adjust
  if (x < -a/2){
    # x < -a/2
    uprime = uprime1(x,a,b,sigma) # u1'(x,t=1)
    u_t1 = u_t1_sub1(x,a,b,sigma,k,uhat) # u1(x,t=1) formula
    res = list(uprime = uprime, u_t1 = u_t1)
  } else if (x >= -a/2 & x <= a/2){
    # -a/2 <= x <= a/2
    uprime = uprime2(x,a,b,sigma) # u2'(x,t=1)
    u_t1 = u_t1_sub2(x,a,b,sigma,k,uhat) # u2(x,t=1) formula
    res = list(uprime = uprime, u_t1 = u_t1)
  } else if (x > a/2) {
    # x > a/2
    uprime = uprime3(x,a,b,sigma) # u3'(x,t=1)
    u_t1 = u_t1_sub3(x,a,b,sigma,k,uhat) # u3(x,t=1) formula
    res = list(uprime = uprime, u_t1 = u_t1)
  } else {
    print("error?")
    return(NULL)
  }
  return(res)
}

a = 0.02
print(paste0("Drive is between ",0.5-(a/2)," and ",0.5+(a/2)))
sigma = 0.01
uhat = 0.4
b = 1
k=0.2 
alpha =  1 - (2*uhat) # 0.2
d_d_fitness = 	1 + (2*alpha*k)
d_wt_fitness = 1 + ((alpha-1)*k)
wt_wt_fitness = 1
print(paste("d/d fitness:", d_d_fitness, "d/wt fitness:", d_wt_fitness, "wt/wt fitness:", wt_wt_fitness))

x = 0.04
x_raw = x + 0.5
given_x_get_uprime_and_u_t1(x_raw,a,b,sigma,k,uhat)
