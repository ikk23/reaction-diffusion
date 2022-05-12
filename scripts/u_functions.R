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

u1_minus_uhat = function(x_raw,a,b,sigma,k,uhat){
  x = x_raw - 0.5
  u1 = u_t1_sub1(x,a,b,sigma,k,uhat)
  diff = u1 - uhat
  return(diff)
}

u2_minus_uhat = function(x_raw, a, b, sigma, k, uhat){
  x = x_raw - 0.5
  u2 = u_t1_sub2(x,a,b,sigma,k,uhat)
  diff = u2 - uhat
  return(diff)
}

u3_minus_uhat = function(x_raw, a, b, sigma, k, uhat){
  x = x_raw - 0.5
  u3 = u_t1_sub3(x,a,b,sigma,k,uhat)
  diff = u3 - uhat
  return(diff)
}

u_minus_uhat = function(x_raw,a,b,sigma,k,uhat){
  x = x_raw - 0.5
  if (x < -a/2){
    diff = u1_minus_uhat(x_raw,a,b,sigma,k,uhat)
  } else if ((x >= -a/2) & (x <= a/2)){
    diff = u2_minus_uhat(x_raw,a,b,sigma,k,uhat)
  } else if (x > a/2){
    diff = u3_minus_uhat(x_raw, a,b,sigma,k,uhat)
  } else {
    print("NA -- error")
  }
  return(diff)
}


# Find the width of the wave after 1 round of dispersal and reaction
find_wave_width = function(a,b,sigma,k,uhat, n = 5000, plot = TRUE){
  x_raw_vector = seq(0,1.0,length.out = n)
  diff_vector = rep(-1,n)
  for (i in 1:n){
    diff_vector[i] = u_minus_uhat(x_raw_vector[i],a,b,sigma,k,uhat) 
  }
  indices_in_order = order(abs(diff_vector))
  two_x_intercept_indices = sort(indices_in_order[1:2])
  x_left = x_raw_vector[two_x_intercept_indices[1]]
  x_right = x_raw_vector[two_x_intercept_indices[2]]
  wave_width = x_right - x_left
  
  if (plot){
    plot(x_raw_vector, diff_vector, xlab = "x", ylab="u(x,t=1) - uhat")
    abline(v = x_left)
    abline(v = x_right)
    abline(h = uhat)
  }
  
  change_in_wave_width = wave_width - a
  
  return(list(x_left = x_left, x_right = x_right, wave_width=wave_width, change_in_wave_width = change_in_wave_width))
}


