my_theta = function(a,b,k,uhat,sigma){
  term1 = a*b*((2*k*(b-uhat))*(1-b)+1)
  
  term2 = sigma*(b^2)*k*( (25*b/6) - (3*(1+uhat)) )
  
  term3 = exp(-a/sigma)*(b^2)*k*((a*(uhat-(3*b)+1)) + sigma*((3*(1+uhat)) - (9*b/2)))
  
  term4 = exp(-2*a/sigma)*((5*sigma*(b^3)*k)/2)
  
  term5 = exp(-3*a/sigma)*((sigma*(b^3)*k)/3)
  
  term6 = exp(-a/(2*sigma))*((sigma*(b^3)*k)/2)
  
  theta = term1+term2+term3+term4+term5+term6
  
  return(theta)
}

auc_mathematica = function(a, b, sigma, k, uhat){
  # Multiply this all by 2
  
  term1_start = (1/12)*b*exp(-3*a/sigma)*(-1+exp(a/sigma))*sigma
  term1_blue = -((b^2)*k) + (exp(2*a/sigma)*( 6 + (3*b*k) - ((b^2)*k) + (3*k*uhat*(-4+b)))) + (b*k*exp(a/sigma)*((2*b) - (3*(1+uhat))))
  term1 = term1_start*term1_blue
  
  term2_start = (1/12)*b*exp(-3*a/sigma)
  
  term2_pink_one = (-6*a*exp(2*a/sigma))*((exp(a/sigma)*(-1 + (2*k*(-1+b)*(b-uhat)))) + (b*k*(-1 + (3*b)-uhat)))
  term2_pink_two = sigma*(-1 + exp(a/sigma))*(  ((b^2)*k) + (b*exp(a/sigma)*k*(3+b+(3*uhat))) + ( exp(2*a/sigma)*(-6 + (12*k*uhat) + ((7*b*k)*((4*b) - (3*(1+uhat)))))))
  
  term2 = term2_start*(term2_pink_one + term2_pink_two)
  
  inner = term1 + term2
  
  auc = 2*inner
  
  return(auc)
  
}

delta = function(a,b,sigma,k,uhat){
  orig = a*b
  auc1 = auc_mathematica(a,b,sigma,k,uhat)
  diff = auc1-orig
  return(diff)
}


factored_auc = function(a, b, sigma, k, uhat){
  orange = (((3*sigma*(b^2)*k)/2)*((3*b) - (2*uhat) - 2)) - (2*a*b*k*(b-1)*(b-uhat)) + (a*b)
  pink_inner = (sigma*b*((3*uhat) - (4*b) + 3)) - (a*((3*b) - uhat - 1))
  pink = (b*k*pink_inner)*exp(-a/sigma)
  blue = (-sigma*(b^3)*k/2)*exp(-2*a/sigma)
  
  auc_factored = orange + pink + blue
  return(auc_factored)
}

factored_delta = function(a,b,sigma,k,uhat){
  orange = (((3*sigma*(b^2)*k)/2)*((3*b) - (2*uhat) - 2)) - (2*a*b*k*(b-1)*(b-uhat))
  pink_inner = (sigma*b*((3*uhat) - (4*b) + 3)) - (a*((3*b) - uhat - 1))
  pink = (b*k*pink_inner)*exp(-a/sigma)
  blue = (-sigma*(b^3)*k/2)*exp(-2*a/sigma)

  delta_factored = orange+pink+blue
  return(delta_factored)
}


# Checking when factoring
a = 0.1
b = 1
sigma = 0.001
uhat = 0.4

unfactored = auc_mathematica(a,b,sigma,k,uhat)
factored = factored_auc(a,b,sigma,k,uhat)
print("THETA")
print(paste("Initial:",unfactored,"--> factored:",factored))

print("DELTA")
delta_un = delta(a,b,sigma,k,uhat)
delta_factored = factored_delta(a,b,sigma,k,uhat)
print(paste("Initial:",delta_un,"--> factored:",delta_factored))

factored_auc_b_is_1 = function(a, b, sigma, k, uhat){
  orange = ((3*sigma*k/2)*(1 - (2*uhat))) + a
  
  pink = k*((sigma*((3*uhat) - 1)) - (a*(2-uhat)))*exp(-a/sigma)
  
  blue = (-sigma*k/2)*exp(-2*a/sigma)
  
  auc_b_1 = orange + pink + blue
  return(auc_b_1)
}

factored_delta_b_is_1 = function(a,b,sigma,k,uhat){
  orange = (3*sigma*k/2)*(1-(2*uhat))
  
  pink = k*((sigma*((3*uhat)-1)) - (a*(2-uhat)))*exp(-a/sigma)
  
  blue = (-sigma*k/2)*exp(-2*a/sigma)
  
  delta = orange+pink+blue
  return(delta)
}


a = 0.5
b = 1
sigma = 0.1
uhat = 0.3

auc_orig = auc_mathematica(a,b,sigma,k,uhat)
auc_factored = factored_auc(a,b,sigma,k,uhat)
auc_factored_b_is_1 = factored_auc_b_is_1(a,b,sigma,k,uhat)
print(paste("Orig:",auc_orig,"factored:",auc_factored,"factored and b=1:",auc_factored_b_is_1))

delta_orig = delta(a,b,sigma,k,uhat)
delta_factored = factored_delta(a,b,sigma,k,uhat)
delta_factored_b_is_1 = factored_delta_b_is_1(a,b,sigma,k,uhat)
print(paste("Orig:",delta_orig,"factored:",delta_factored,"factored and b=1:",delta_factored_b_is_1))





