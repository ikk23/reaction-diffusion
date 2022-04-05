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


