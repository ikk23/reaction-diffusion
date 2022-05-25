sigma = 0.01
a = 0.08
print(paste("Between zone:",-a/2,"to",a/2))
x = 0.02
k = 0.2


u2_e_term = exp((-1/sigma)*(x + (a/2))) + exp((-1/sigma)*((a/2)-x))

u2_e_term_squared = u2_e_term^2
u2_e_term_cubed = u2_e_term^3

u2_e_term_written_out = exp((-2/sigma)*(x + (a/2))) + exp((-2/sigma)*((a/2)-x)) + (2*exp(-a/sigma))

u2_e_term_cubed_written_out = exp((-1/sigma)*((3*x) + (3*a/2))) + exp((-1/sigma)*((3*a/2) - x)) + exp((-1/sigma)*((3*a/2) - (3*x))) + (2*exp((-1/sigma)*(x + (3*a/2)))) + (2*exp((-1/sigma)*((3*a/2) - x))) + exp((-1/sigma)*((3*a/2) + x))
u2_e_term_cubed_written_out
u2_e_term_cubed

# x between -a/2 and a/2
u2_full = function(x,a,b,k,uhat,sigma){
  if (x < -a/2 | x > a/2){
    print("NOT THE RIGHT FUNCTION")
    return(NULL)
  }
  u2_e_term = exp((-1/sigma)*(x + (a/2))) + exp((-1/sigma)*((a/2)-x))
  
  term1 = b*((2*k*(b-uhat)*(1-b))+1)
  
  term2 = b*((((b*((3*b)-2)) + (uhat*(1 - (2*b))))*k) - 0.5)*u2_e_term
  
  term3 = -(((k*b^2)/2)*((3*b)-uhat-1))*(u2_e_term^2)
  
  term4 = ((k*(b^3))/4)*u2_e_term^3
  
  return(term1 + term2 + term3 + term4)
}

x = 0.06
u3_e_term = exp((-1/sigma)*(x - (a/2))) - exp((-1/sigma)*(x + (a/2)))
u3_e_term_squared = u3_e_term^2
u3_e_term_cubed = u3_e_term^3

another_u2 = exp((-2/sigma)*(x - (a/2))) + exp((-2/sigma)*(x + (a/2))) - (2*exp(-2*x/sigma))
another_u3 = exp((-1/sigma)*((3*x) - (3*a/2))) - exp((-1/sigma)*((3*x) + (3*a/2))) + (3*exp((-1/sigma)*((3*x) + (a/2)))) - (3*exp((-1/sigma)*((3*x) - (a/2))))



factored_auc = function(a, b, sigma, k, uhat){
  orange = (((3*sigma*(b^2)*k)/2)*((3*b) - (2*uhat) - 2)) - (2*a*b*k*(b-1)*(b-uhat)) + (a*b)
  pink_inner = (sigma*b*((3*uhat) - (4*b) + 3)) - (a*((3*b) - uhat - 1))
  pink = (b*k*pink_inner)*exp(-a/sigma)
  blue = (-sigma*(b^3)*k/2)*exp(-2*a/sigma)
  
  auc_factored = orange + pink + blue
  return(auc_factored)
}

written_out_math_auc = function(a, b, sigma, k, uhat){
  term1 = a*b*( (2*k*(b-uhat)*(1-b)) + 1 )
  
  term2_inner = (k*( (b*((3*b) - 2)) + (uhat*(1-(2*b))))) - 0.5
  term2 = 2*sigma*b*term2_inner*(1 - exp(-a/sigma))
  
  term3_factor1 = -k*(b^2)*((3*b) - uhat - 1)
  term3_factor2 = (a*exp(-a/sigma)) + ((sigma/2)*(1 - exp(-2*a/sigma)))
  term3 = term3_factor1*term3_factor2
  
  term4_coefficient = sigma*k*(b^3)/6
  term4_inner= (9*exp(-a/sigma)) - (9*exp(-2*a/sigma)) - exp(-3*a/sigma) + 1
  term4 = term4_coefficient*term4_inner
  
  term5 = 2*sigma*b*(0.5 - (k*uhat))*(1 - exp(-a/sigma))
  
  term6 = (sigma*k*(b^2)/2)*(1 + uhat)*(1 + exp(-2*a/sigma) - (2*exp(-a/sigma)))
  
  term7_coefficient = -sigma*k*(b^3)/6
  term7_inner = 1 - exp(-3*a/sigma) + (3*exp(-2*a/sigma)) - (3*exp(-a/sigma))
  term7 = term7_coefficient*term7_inner
  
  auc = term1+term2+term3+term4+term5+term6+term7
  return(auc)
    
}


a = 0.08
b = 1
sigma = 0.01
k = 0.2
uhat = 0.4
factored_auc(a,b,sigma,k,uhat)
written_out_math_auc(a,b,sigma,k,uhat)